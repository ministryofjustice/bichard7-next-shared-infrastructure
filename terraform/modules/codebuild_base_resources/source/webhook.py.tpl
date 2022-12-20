#!/usr/bin/python3.8
import urllib3
import json

http = urllib3.PoolManager()


def parse_codepipeline_message(content):
    emoji = "information_source"
    parsed_message = ":{}: *{} {}* on account {}\n\n" \
                     "{} stage {} has changed to {} at {}\n\n" \
                     "Login <https://{}.signin.aws.amazon.com/console|here>\n".format(
                         emoji,
                         content["source"],
                         content["detail"]["pipeline"],
                         content["account"],
                         content["detailType"],
                         content["detail"]["stage"],
                         content["detail"]["state"],
                         content["time"],
                         content["account"]
                     )

    return parsed_message


def parse_codepipeline_approval(content):
    emoji = "approved"
    parsed_message = ":{}: *{} requires approval for stage {}*\n\n" \
                     "@channel {} requires manual approval \n\n" \
                     "Please review via <{}|this link> \n".format(
                         emoji,
                         content["approval"]["pipelineName"],
                         content["approval"]["stageName"],
                         content["approval"]["stageName"],
                         content["approval"]["approvalReviewLink"]
                     )

    return parsed_message


def parse_codebuild_message(content):
    emoji = "white_check_mark" if content["detail"]["build-status"] == "SUCCEEDED" else "x"
    if content["detail"]["build-status"] == "IN_PROGRESS":
        content["detail"]["build-status"] = "Started"
        emoji = "arrow_forward"
    parsed_message = ":{}: *{} {}* on account {}\n\n" \
                     "Building branch *{}* has {} on {}\n\n" \
                     "Login <https://{}.signin.aws.amazon.com/console|here>\n" \
                     "<{}|Cloudwatch Logs>".format(
                         emoji,
                         content["detail"]["build-status"].capitalize(),
                         content["detail"]["project-name"],
                         content["account"],
                         content["detail"]["additional-information"]["source-version"] if content["detail"]["additional-information"][
                             "source-version"] else "head",
                         content["detail"]["build-status"].capitalize(),
                         content["time"],
                         content["account"],
                         content["detail"]["additional-information"]["logs"]["deep-link"]
                     )

    return parsed_message


def parse_message(json_message, subject=None):
    content = json.loads(json_message)
    if subject:
        parsed_message = parse_codepipeline_approval(content)
    elif content['detailType'] and content['detailType'] == "CodePipeline Stage Execution State Change":
        parsed_message = parse_codepipeline_message(content)
    else:
        parsed_message = parse_codebuild_message(content)

    return parsed_message


def lambda_handler(event, context):
    url = "${webhook_url}"
    subject = None
    if event['Records'][0]['Sns']['Subject']:
        subject = event['Records'][0]['Sns']['Subject']

    message = parse_message(event['Records'][0]['Sns']['Message'], subject)
    msg = {
        "channel": "${channel_name}",
        "username": "CodeBuild CI",
        "text": message,
        "icon_emoji": ":shipit:"
    }

    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST', url, body=encoded_msg)
    print({
        "message": event['Records'][0]['Sns']['Message'],
        "status_code": resp.status,
        "response": resp.data
    })
