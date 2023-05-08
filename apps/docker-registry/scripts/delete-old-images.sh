#!/bin/bash

set -e

LIVINGDAYS=${1-150}
DOCKER_REGISTRY="registry.docker.home.stackpwn.in:80/v2"
ACCEPT_HEADER="Accept: application/vnd.docker.distribution.manifest.v2+json"
MAX_LIST_LIMIT=50

PRESERVE_COUNT=${PRESERVE_COUNT:-5}

function get_repositories {
  curl -Ls "${DOCKER_REGISTRY}"/_catalog?n="${MAX_LIST_LIMIT}" | jq -r '."repositories"[]'
}


function get_repository_tags {
  curl -Ls "${DOCKER_REGISTRY}"/"$1"/tags/list?n="${MAX_LIST_LIMIT}" | jq -r '."tags"[]' | sort -r | tail -n +$((1 + PRESERVE_COUNT))
}


function get_tag_digest {
  REPOSITORY="$1"
  TAG="$2"
  curl -ILs --header "${ACCEPT_HEADER}" "${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${TAG}" | grep Docker-Content-Digest | awk '{print $2}' | tr -d '\r'
}


function get_tag_digest2 {
  REPOSITORY="$1"
  TAG="$2"
  curl -ILs --header "${ACCEPT_HEADER}" "${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${TAG}" | grep Docker-Content-Digest | awk '{print $2}' | tr -d '\r'
}

REPOSITORIES=$(get_repositories)
echo ALL REPOS: ${REPOSITORIES}
echo
for REPOSITORY in ${REPOSITORIES[@]}
do
#  ENVS=("home")
#  for env in ${ENVS[@]}
#  do
    TAGS=$(get_repository_tags "${REPOSITORY}" "$env")
    echo ${REPOSITORY}: ${TAGS}
    echo
    for TAG in ${TAGS[@]}
    do
      echo ${REPOSITORY}:${TAG}
      DIGEST=$(get_tag_digest "${REPOSITORY}" "${TAG}")
      echo "${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${DIGEST}"
      URL="${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${DIGEST}"
      echo "Will delete $URL"
      curl -v -s -X DELETE -i "$URL"
      echo -------------------------------------------------------------------------------------
      echo
    done
#  done
done
