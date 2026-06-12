import os
import json
import datetime
import urllib.request
import boto3
import requests
from cryptography import x509
from cryptography.hazmat.backends import default_backend

ssm = boto3.client("ssm")
SLACK_WEBHOOK = ssm.get_parameter(
        Name="/monitoring/slack/niam_webhook")["Parameter"]["Value"]
WARNING_DAYS = 30
ROLE_ARNS=[]

def assume_role(role_arn, session_name="NIAM_EXPIRY_ALERT"):
    sts_client = boto3.client('sts')

    response = sts_client.assume_role(
        RoleArn=role_arn,
        RoleSessionName=session_name,
    )

    credentials = response['Credentials']

    assumed_session = boto3.Session(
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken']
    )

    return assumed_session

def get_day_suffix(days_remaining):
    return "day" if days_remaining == 1 else "days"

def build_expiry_summary(environment, days_remaining, expiry_date):
    day_suffix = get_day_suffix(days_remaining)
    return [
                {
                    "type": "rich_text",
                    "elements": [
                        {
                            "type": "rich_text_section",
                            "elements": [
                                {
                                    "type": "text",
                                    "text": f"{environment}"
                                }
                            ]
                        }
                    ]
                },
                {
                    "type": "rich_text",
                    "elements": [
                        {
                            "type": "rich_text_section",
                            "elements": [
                                {
                                    "type": "text",
                                    "text": f"{days_remaining} {day_suffix}"
                                }
                            ]
                        }
                    ]
                },
                {
                    "type": "rich_text",
                    "elements": [
                        {
                            "type": "rich_text_section",
                            "elements": [
                                {
                                    "type": "text",
                                    "text": f"{expiry_date}"
                                }
                            ]
                        }
                    ]
                }
            ]

def build_expiry_summary_payload(summary):
    return {
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": ":calendar: *NIAM Certificate — Weekly Expiry Summary*\nHere's a snapshot of how many days remain on each environment's NIAM certificate as of today. Review and plan renewals accordingly."
                }
            },
            {
                "type": "divider"
            },
            {
                "type": "table",
                "rows": [
                    [
                        {
                            "type": "rich_text",
                            "elements": [
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "text",
                                            "text": "Environment"
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "type": "rich_text",
                            "elements": [
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "text",
                                            "text": "Days Left"
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "type": "rich_text",
                            "elements": [
                                {
                                    "type": "rich_text_section",
                                    "elements": [
                                        {
                                            "type": "text",
                                            "text": "Expires On"
                                        }
                                    ]
                                }
                            ]
                        }
                    ],
                    *summary
                ]
            },
            {
                "type": "context",
                "elements": [
                    {
                        "type": "mrkdwn",
                        "text": ":information_source: This summary is sent every Monday at 09:00"
                    }
                ]
            }
        ]
    }

def build_expiry_alert(environment, days_remaining, expiry_date):
    day_suffix = get_day_suffix(days_remaining)
    status_emoji = ":red_circle " if days_remaining < 14 else ""
    return {
        "type": "section",
        "fields": [
            {
                "type": "mrkdwn",
                "text": f"*Environment*\n`{environment}`"
            },
            {
                "type": "mrkdwn",
                "text": f"*Expires in*\n{status_emoji}*{days_remaining} {day_suffix}* ({expiry_date})"
            }
        ]
    }

def build_payload(expiry_details):
    payload = {
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f":alerts: *Action required* — renew NIAM certificate before the expiry date to avoid service disruption."
                }
            },
            *expiry_details,
            {
                "type": "divider"
            },
            {
                "type": "actions",
                "elements": [
                    {
                        "type": "button",
                        "text": {
                            "type": "plain_text",
                            "text": "View renewal guide"
                        },
                        "style": "primary",
                        "url": "https://dsdmoj.atlassian.net/wiki/spaces/KB/pages/6099698378/NIAM+Certificate+Renewal"
                    }
                ]
            },
            {
                "type": "context",
                "elements": [
                    {
                        "type": "mrkdwn",
                        "text": ":information_source: This alert runs daily until renewed."
                    }
                ]
            }
        ]
    }

    return payload

def get_environment_name(param_name):
    return param_name.split("/")[1].split("-")[1]

def main():
    print("🔍 Scanning Parameter Store...")
    expiry_summaries = []
    expiry_alerts = []

    for role_arn in ROLE_ARNS:
        child_account_role_session = assume_role(role_arn)
        child_account_ssm = child_account_role_session.client('ssm')

        describe_response = child_account_ssm.describe_parameters(
            ParameterFilters=[
                {"Key": "Name", "Option": "Contains", "Values": ["leds/niam/certificate.pem"]}
            ]
        )

        param_names = [p["Name"] for p in describe_response.get("Parameters", [])]

        if not param_names:
            print("No matching SSM parameters found. Double check your parameter name suffix!")
            return

        print(f"Found parameters: {', '.join(param_names)}")

        get_response = child_account_ssm.get_parameters(Names=param_names, WithDecryption=True)
        now = datetime.datetime.now(datetime.timezone.utc)

        for param in get_response.get("Parameters", []):
            cert = x509.load_pem_x509_certificate(param["Value"].encode("utf-8"), default_backend())
            expiry_date = cert.not_valid_after_utc
            formatted_expiry_date = expiry_date.strftime('%d %B %Y')
            days_remaining = (expiry_date - now).days
            environment = get_environment_name(param["Name"])

            print(f"\n📋 Parameter: {param['Name']}")
            print(f"📅 Expires on: {formatted_expiry_date}")
            print(f"⏳ Days remaining: {days_remaining}")
            print(f"☁️ Environment: {environment}")

            expiry_summary = build_expiry_summary(environment, days_remaining, formatted_expiry_date)
            expiry_summaries.append(expiry_summary)

            if days_remaining <= WARNING_DAYS:
                expiry_alert = build_expiry_alert(environment, days_remaining, formatted_expiry_date)
                expiry_alerts.append(expiry_alert)

    if now.weekday() == 0:
        if not expiry_summaries:
            print("No NIAM certificate expiry data found.")
            return
        payload = build_expiry_summary_payload(expiry_summaries)
        send_slack_alert(payload)

    if expiry_alerts:
        print("\n🚨 Alert condition met! Sending slack notification...")
        payload = build_payload(expiry_alerts)
        send_slack_alert(payload)
    else:
        print("\n✅ Certificates are safe. No alert needed.")


def send_slack_alert(payload):
    if not SLACK_WEBHOOK:
        print("⚠️ Slack URL missing from environment variables. Skipping webhook call.")
        return

    try:
      headers = {"Content-Type": "application/json"}
      response = requests.post(SLACK_WEBHOOK, data = json.dumps(payload), headers = headers)
      print(f"NIAM Certificate expiry alert sent to slack. Status: {response.status_code}")

    except Exception as e:
      print(f"Could not send NIAM certificate expiry alert to slack. Error: {e}")


if __name__ == "__main__":
    main()
