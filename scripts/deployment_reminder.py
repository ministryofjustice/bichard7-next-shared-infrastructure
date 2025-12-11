from datetime import datetime, timezone
import json
import os
import requests
import boto3

pipeline_name = "cjse-bichard7-path-to-live-deploy-pipeline"
LIMIT_DAYS = int(os.getenv("LIMIT_DAYS", "3"))
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

def calculate_days_since_last_smoketest(smoketest_time):
    now = datetime.now(timezone.utc)
    deployment_age = (now - smoketest_time)
    return deployment_age.days

def check_days_overs_limit(days):
    return days >= LIMIT_DAYS

def send_alert_to_slack(deployment_age):
    try:
        headers = {"Content-Type": "application/json"}
        payload = {
        "text": f":mild-panic-intensifies: We have not deployed in the last {deployment_age} days :mild-panic-intensifies:"
        }
        response = requests.post(SLACK_WEBHOOK, data=json.dumps(payload), headers=headers)
        print(f"Deployment reminder sent to slack. Status: {response.status_code}", )

    except Exception as e:
        print(f"Could not send deployment slack reminder. Error: {e}")

def run_script():
    ps = get_pipeline_state(pipeline_name)
    last_time = get_last_smoketest_time(ps)
    deployment_age = calculate_days_since_last_smoketest(last_time)
    is_over_limit = check_days_overs_limit(deployment_age)
    if(is_over_limit):
        send_alert_to_slack(deployment_age)

if __name__ == '__main__':
    run_script()
