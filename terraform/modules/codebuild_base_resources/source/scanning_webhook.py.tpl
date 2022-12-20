#!/usr/bin/python3.8
import urllib3
import json
import datetime
import os

http = urllib3.PoolManager()
os.environ["TZ"] = "UTC"

def parse_message(json_message):
    content = json.loads(json_message)
    bucket = ""
    child_account_id = content["account"]
    child_account_name = ""
    workspace = None
    job_name = "ScoutSuite"
    folder = "scoutsuite"

    build_start_time = content["detail"]["additional-information"]["build-start-time"]

    for phase in content["detail"]["additional-information"]["phases"]:
        if phase["phase-type"] == "BUILD":
            build_start_time = phase["start-time"]

    start_time = datetime.datetime.strptime(build_start_time, "%b %d, %Y %I:%M:%S %p")

    for env_var in content["detail"]["additional-information"]["environment"]["environment-variables"]:
        if env_var["name"] == "S3_BUCKET":
            bucket = env_var["value"]
        if env_var["name"] == "CHILD_ACCOUNT_ID":
            child_account_id = env_var["value"]
        if env_var["name"] == "WORKSPACE":
            job_name = "ZAP OWASP Scanner"
            folder = "owasp-data"
            workspace = env_var["value"]
        if env_var["name"] == "JOB_NAME":
            if env_var["value"] == "TRIVY":
              job_name = "Trivy Vulnerability Scanner"
              folder = "trivy"
        if env_var["name"] == "ACCOUNT_ALIAS":
            if workspace:
              child_account_name = workspace
            else:
              child_account_name = "bichard7-{}".format(env_var["value"].replace("_", "-"))

    environment_name = child_account_id if not child_account_name else child_account_name
    parsed_message = \
        ":{}: {} has run successfully against account *{}*\n\n" \
        "Login <https://{}.signin.aws.amazon.com/console|here>\n" \
        "\nReports avaible via S3 <s3://{}/{}/{}/{}/| available here>".format(
          "aws",
          job_name,
          environment_name if not workspace else workspace,
          content["account"],
          bucket,
          folder,
          child_account_id,
          "{}".format(start_time.strftime("%d%m%Y"))
)

    return parsed_message, job_name


def lambda_handler(event, context):
    url = "${webhook_url}"
    message, job_name = parse_message(event['Records'][0]['Sns']['Message'])
    msg = {
        "channel": "${channel_name}",
        "username": "{} CI".format(job_name),
        "text": message,
        "icon_emoji": ":closed_lock_with_key:"
    }

    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST', url, body=encoded_msg)
    print({
        "message": event['Records'][0]['Sns']['Message'],
        "status_code": resp.status,
        "response": resp.data
    })
