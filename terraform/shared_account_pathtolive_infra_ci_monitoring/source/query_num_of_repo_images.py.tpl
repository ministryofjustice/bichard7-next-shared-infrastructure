# periodically (every hour) get the number of images in each ecr repo

import boto3

client = boto3.client('ecr')

def recurisive_paginate_images(repo, image_array, next_token=''):
    repsonse = {}
    if next_token == '':
        response = client.list_images(
            repositoryName=repo,
            registryId="497078235711"
        )
    else:
        response = client.list_images(
            repositoryName=repo,
            registryId="497078235711",
            nextToken=next_token
        )

    if "nextToken" in response:
        recurisive_paginate_images(repo, image_array +
                            response["imageIds"], response["nextToken"])

    return image_array + response["imageIds"]

def get_repos():
    response = client.describe_repositories(
                registryId="497078235711"
            )

    return [repo["repositoryName"] for repo in response["repositories"]]

def lambda_handler(event, context):
    repo_names = get_repos()
    for repo in repo_names:
        images = recurisive_paginate_images(repo, [])

        if len(images) == 0:
            raise Exception(
                "There are no images in the: "+repo+" repository")
