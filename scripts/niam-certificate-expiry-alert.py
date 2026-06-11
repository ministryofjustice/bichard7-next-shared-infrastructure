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

def build_payload(days_left, expiry_date, environment):
    payload = {
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f":alerts: *NIAM certificate expires in {days_left} days*\nAction required — renew before the expiry date to avoid service disruption."
                }
            },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": "*Certificate*\nNIAM"
                    },
                    {
                        "type": "mrkdwn",
                        "text": f"*Expiry date*\n{expiry_date}"
                    },
                    {
                        "type": "mrkdwn",
                        "text": f"*Environment*\n`{environment}`"
                    }
                ]
            },
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

    describe_response = ssm.describe_parameters(
        ParameterFilters=[
            {"Key": "Name", "Option": "Contains", "Values": ["leds/niam/certificate.pem"]}
        ]
    )

    param_names = [p["Name"] for p in describe_response.get("Parameters", [])]

    if not param_names:
        print("No matching SSM parameters found. Double check your parameter name suffix!")
        return

    print(f"Found parameters: {', '.join(param_names)}")

    get_response = ssm.get_parameters(Names=param_names, WithDecryption=True)
    now = datetime.datetime.now(datetime.timezone.utc)

    for param in get_response.get("Parameters", []):
        cert = x509.load_pem_x509_certificate(param["Value"].encode("utf-8"), default_backend())
        expiry_date = cert.not_valid_after_utc
        expiry_date_formatted = expiry_date.strftime('%d %B %Y')
        days_remaining = (expiry_date - now).days
        environment = get_environment_name(param["Name"])

        print(f"\n📋 Parameter: {param['Name']}")
        print(f"📅 Expires on: {expiry_date_formatted}")
        print(f"⏳ Days remaining: {days_remaining}")

        if days_remaining <= WARNING_DAYS:
            print("🚨 Alert condition met! Sending Slack Notification...")
            send_slack_alert(param["Name"], days_remaining, expiry_date_formatted, environment)
        else:
            print("✅ Certificate is safe. No alert needed.")


def send_slack_alert(param_name, days_left, expiry_date, environment):
    if not SLACK_WEBHOOK:
        print("⚠️ Slack URL missing from environment variables. Skipping webhook call.")
        return

    emoji = ":alerts:"
    try:
      headers = {"Content-Type": "application/json"}
      payload = build_payload(days_left, expiry_date, environment)
      response = requests.post(SLACK_WEBHOOK, data = json.dumps(payload), headers = headers)
      print(f"NIAM Certificate expiry alert sent to slack. Status: {response.status_code}")

    except Exception as e:
      print(f"Could not send NIAM certificate expiry alert to slack. Error: {e}")


if __name__ == "__main__":
    main()