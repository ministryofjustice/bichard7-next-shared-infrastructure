from datetime import datetime, timedelta
import json
import os
import requests
import boto3

pipeline_name = "cjse-bichard7-path-to-live-deploy-pipeline"
LIMIT_DAYS = int(os.getenv("LIMIT_DAYS", "5"))
ssm = boto3.client('ssm')
SLACK_WEBHOOK = ssm.get_parameter(
        Name="/slack/deployment_reminder")["Parameter"]["Value"]

def get_pipeline_state(pipeline_name):
    code_pipeline = boto3.client('codepipeline', region_name="eu-west-2")
    pipeline_state = code_pipeline.get_pipeline_state(
        name=pipeline_name
    )
    return pipeline_state

def get_last_smoketest_time(pipeline_state):
    smoketest_state = next(s for s in pipeline_state["stageStates"] if s["stageName"] == "run-production-smoketests")
    smoketest_action = next (a for a in smoketest_state["actionStates"] if a["actionName"] == "run-production-smoketests")
    lastSmoketestTime = smoketest_action["latestExecution"]["lastStatusChange"]
    return lastSmoketestTime

def count_workdays_since(last_time):
    last_time = last_time.date()
    today = datetime.today().date()
    workdays_since = 0
    current_date = last_time
    while current_date < today:
        if current_date.weekday() < 5:
            workdays_since += 1
        current_date += timedelta(days=1)
    return workdays_since

def check_days_overs_limit(days):
    return days > LIMIT_DAYS

def send_alert_to_slack(deployment_age):
    emoji = ":mild-panic-intensifies:"
    overdue_days = deployment_age-LIMIT_DAYS
    try:
        headers = {"Content-Type": "application/json"}
        payload = {
        "text": f"We have not deployed in {deployment_age} working days {emoji*overdue_days}"
        }
        response = requests.post(SLACK_WEBHOOK, data=json.dumps(payload), headers=headers)
        print(f"Deployment reminder sent to slack. Status: {response.status_code}")

    except Exception as e:
        print(f"Could not send deployment reminder to slack. Error: {e}")

def run_script():
    pipeline_state = get_pipeline_state(pipeline_name)
    last_time = get_last_smoketest_time(pipeline_state)
    workdays_since = count_workdays_since(last_time)
    is_over_limit = check_days_overs_limit(workdays_since)
    if(is_over_limit):
        send_alert_to_slack(workdays_since)

if __name__ == '__main__':
    run_script()
