#!/usr/bin/python3.8
import urllib3
import json

http = urllib3.PoolManager()


def parse_message(json_message):
    return json.loads(json_message)


def lambda_handler(event, context):
    url = "${webhook_url}"

    message = parse_message(event['Records'][0]['Sns']['Message'])
    alarm_state = "[RESOLVED] " if message["NewStateValue"] == "OK" else ""
    msg = {
        "channel": "${notifications_channel_name}",
        "username": "Cloudwatch Alarms",
        "text": alarm_state+message["AlarmDescription"]
    }

    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST', url, body=encoded_msg)
    print({
        "message": event['Records'][0]['Sns']['Message'],
        "status_code": resp.status,
        "response": resp.data
    })
