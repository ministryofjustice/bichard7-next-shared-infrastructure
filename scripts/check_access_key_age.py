#!/usr/bin/env python3

import os
from datetime import datetime, timezone

import boto3
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

ACCESS_KEY_WARN_AGE_DAYS = int(os.getenv("ACCESS_KEY_WARN_AGE_DAYS"))
ACCESS_KEY_EXPIRY_AGE_DAYS = int(os.getenv("ACCESS_KEY_EXPIRY_AGE_DAYS"))
SLACK_BOT_TOKEN = os.getenv("SLACK_BOT_TOKEN")
SLACK_CHANNEL_NAME = os.getenv("SLACK_CHANNEL_NAME")
client = WebClient(token=SLACK_BOT_TOKEN)


def check_access_key_age(
    max_age_days=ACCESS_KEY_EXPIRY_AGE_DAYS, threshold=ACCESS_KEY_WARN_AGE_DAYS
):
    iam = boto3.client("iam")
    paginator = iam.get_paginator("list_users")
    users_with_expiring_access_keys = {}

    print(f"{'User':<40} {'Key ID':<25} {'Age (Days)':<12} {'Status'}")
    print("-" * 90)

    for page in paginator.paginate():
        for user in page["Users"]:
            username = user["UserName"]

            if "@madetech.com" not in username:
                continue

            try:
                keys = iam.list_access_keys(UserName=username)

                for key in keys["AccessKeyMetadata"]:
                    if key["Status"] != "Active":
                        continue

                    create_date = key["CreateDate"]
                    age_days = (datetime.now(timezone.utc) - create_date).days

                    if age_days >= threshold:
                        status_flag = (
                            "!! EXPIRED !!" if age_days > max_age_days else "⚠️ WARNING"
                        )

                        if username not in users_with_expiring_access_keys:
                            users_with_expiring_access_keys[username] = []

                        users_with_expiring_access_keys[username].append(
                            {
                                "key_id": key["AccessKeyId"],
                                "age_days": age_days,
                                "days_till_limit": max_age_days - age_days,
                                "status": status_flag,
                            }
                        )

                        print(
                            f"{username:<40} {key['AccessKeyId']:<25} {age_days:<12} {status_flag}"
                        )

            except Exception as e:
                print(f"Error checking keys for {username}: {e}")

    print(
        f"\nFound {len(users_with_expiring_access_keys)} users with keys needing attention"
    )
    return users_with_expiring_access_keys


def get_slack_id_by_email(users_dict, slack_client):
    for email in users_dict.keys():
        try:
            response = slack_client.users_lookupByEmail(email=email)
            user_id = response["user"]["id"]

            users_dict[email].append({"slack_id": user_id})
            print(f"✓ Slack lookup success: {email} -> {user_id}")

        except SlackApiError as e:
            print(f"✗ Slack lookup failed for {email}: {e.response['error']}")
            users_dict[email].append({"slack_id": None})
        except Exception as e:
            print(f"✗ Unexpected error looking up {email}: {e}")
            users_dict[email].append({"slack_id": None})

    return users_dict


def build_channel_summary_payload(users_dict):
    blocks = [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": ":alerts: AWS Access Key Rotation Summary",
            },
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": f"Found *{len(users_dict)} users* with access keys requiring rotation:",
            },
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "Run this command:\n`aws-vault rotate bichard7-shared` and follow the on-screen prompt",
            },
        },
        {"type": "divider"},
    ]

    for username, key_info_list in users_dict.items():
        slack_id = None
        key_count = 0
        oldest_age = 0

        for item in key_info_list:
            if "slack_id" in item:
                slack_id = item["slack_id"]
            if "age_days" in item:
                key_count += 1
                oldest_age = max(oldest_age, item["age_days"])

        user_mention = f"<@{slack_id}>" if slack_id else f"`{username}`"

        warning = (
            " :warning: *Action Required* Access key older than 90 days"
            if oldest_age > 90
            else ""
        )

        blocks.append(
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"• {user_mention} - {key_count} key(s), oldest is *{oldest_age} days*{warning}",
                },
            }
        )

    blocks.append({"type": "divider"})

    return blocks


def send_channel_summary(slack_client, channel, blocks):
    try:
        response = slack_client.chat_postMessage(
            channel=channel, text="AWS IAM Access Key Rotation Summary", blocks=blocks
        )
        return response["ok"]
    except SlackApiError as e:
        print(f"Error sending channel message: {e.response['error']}")
        return False
    except Exception as e:
        print(f"Unexpected error sending channel message: {e}")
        return False


def main():
    slack_token = client.token

    if not slack_token:
        print("ERROR: SLACK_BOT_TOKEN environment variable not set!")
        return

    slack_client = WebClient(token=slack_token)

    print("=" * 90)
    print("STEP 1: Checking IAM access key ages...")
    print("=" * 90)
    expired_access_users = check_access_key_age()

    if not expired_access_users:
        print("\n✓ No users found with expiring access keys. Exiting.")
        return

    print("\n" + "=" * 90)
    print("STEP 2: Looking up Slack user IDs...")
    print("=" * 90)
    users_with_slack_ids = get_slack_id_by_email(expired_access_users, slack_client)

    print("\n" + "=" * 90)
    print("STEP 3: Sending channel summary...")
    print("=" * 90)
    summary_blocks = build_channel_summary_payload(users_with_slack_ids)
    channel_success = send_channel_summary(
        slack_client, channel=SLACK_CHANNEL_NAME, blocks=summary_blocks
    )

    if channel_success:
        print("✓ Channel summary posted successfully")
    else:
        print("✗ Failed to post channel summary")

    # Print final summary
    print("\n" + "=" * 90)
    print("EXECUTION SUMMARY")
    print("=" * 90)
    print(f"Users with old keys: {len(expired_access_users)}")
    print(f"Channel summary: {'✓ Posted' if channel_success else '✗ Failed'}")
    print("=" * 90)


if __name__ == "__main__":
    main()
