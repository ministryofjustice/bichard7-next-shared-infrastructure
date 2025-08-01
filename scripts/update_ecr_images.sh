#!/usr/bin/env bash

set -e

AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=eu-west-2

function update_ecr_image {
    local docker_image=$1
    local image_name=$2
    local ecr_repo_url="${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/${image_name}"
    local docker_image_without_tag=$(echo "${docker_image}" | cut -d ":" -f1)

    printf "\nPulling ${docker_image}\n"

    docker pull -q --platform linux/amd64 $docker_image 1>/dev/null
    local short_hash=$(docker image inspect $(docker images -q "${docker_image}") | \
                jq -r '.[] | select(.Architecture=="amd64").RepoDigests[]' | \
                grep "${docker_image_without_tag}" | cut -d ":" -f2)
    if [ -z "${short_hash}" ]; then
        # If this fails, it's possible that the manifest could be a different structure
        echo "Getting the image hash from the manifest"
        short_hash=$(docker manifest inspect "${docker_image}" | jq -r '.manifests[] | select(.platform.architecture=="amd64").digest' | cut -d ":" -f2)
    fi

    if [ -z "${short_hash}" ]; then
        echo "Couldn't find image hash for ${docker_image}"
        exit 1
    fi

    local image_tag="${ecr_repo_url}:${short_hash}"

    docker tag $docker_image $image_tag
    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ecr_repo_url};
    echo "Pushing ${image_tag}"
    docker push -q $image_tag 1>/dev/null
}

update_ecr_image amazonlinux:2 amazon-linux2
update_ecr_image amazonlinux:2023 amazon-linux-2023
update_ecr_image liquibase/liquibase liquibase
update_ecr_image gradle:6.7-jdk11 gradle-jdk11
update_ecr_image open-liberty:kernel-slim-java11-openj9 open-liberty
update_ecr_image rossja/ncc-scoutsuite:aws-latest scoutsuite
update_ecr_image zaproxy/zap-stable zap-owasp-scanner
update_ecr_image ghcr.io/puppeteer/puppeteer puppeteer
