import os
import json
import datetime
import urllib.request
import boto3
import requests
from cryptography import x509
from cryptography.hazmat.backends import default_backend

ssm = boto3.client("ssm")
SLACK_WEBHOOK_URL = ""
WARNING_DAYS = 30

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
        days_remaining = (expiry_date - now).days

        print(f"\n📋 Parameter: {param['Name']}")
        print(f"📅 Expires on: {expiry_date.isoformat()}")
        print(f"⏳ Days remaining: {days_remaining}")

        if days_remaining <= WARNING_DAYS:
            print("🚨 Alert condition met! Sending Slack Notification...")
            send_slack_alert(param["Name"], days_remaining)
        else:
            print("✅ Certificate is safe. No alert needed.")


def send_slack_alert(param_name, days_left):
    if not SLACK_WEBHOOK_URL:
        print("⚠️ Slack URL missing from environment variables. Skipping webhook call.")
        return

    emoji = ":alerts:"
    try:
      headers = {"Content-Type": "application/json"}
      payload = {
        "text": f"{emoji} *NIAM certficate expires in {days_left} days!*"
      }
      response = requests.post(SLACK_WEBHOOK_URL, data = json.dumps(payload), headers = headers)
      print(f"NIAM Certificate expiry alert sent to slack. Status: {response.status_code}")

    except Exception as e:
      print(f"Could not send NIAM certificate expiry alert to slack. Error: {e}")


if __name__ == "__main__":
    main()