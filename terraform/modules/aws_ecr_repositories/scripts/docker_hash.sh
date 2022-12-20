#!/usr/bin/env bash

set -e

function parse_input() {
  eval "$(jq -r '@sh "export IMAGE=\(.image)"')"
  if [[ -z "${IMAGE}" ]]; then export IMAGE=none; fi
}

function get_hash() {
  HASH=$(docker inspect --format='{{index .RepoDigests 0}}' ${IMAGE})
  SHORT_HASH=$(echo $HASH | cut -d'@' -f2)
  TAG_HASH=$(echo $SHORT_HASH | cut -d':' -f2)
  jq -n \
    --arg hash "${SHORT_HASH}" \
    --arg short_hash "${TAG_HASH}" \
    '{"image_hash": $hash, "short_hash", $short_hash}'
}

parse_input
get_hash
