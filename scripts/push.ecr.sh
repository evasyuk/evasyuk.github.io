#!/bin/bash

#
# NOTE:
#
# aws cli required
#

set -e
set -o pipefail

echo
echo "DEPLOY SCRIPT STARTED"
echo

#CI_COMMIT_REF_NAME=master

if [[ "$CI_COMMIT_REF_NAME" = "master" ]]
then
    # set all ENV variables from .env file
    #source .env

    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $MY_DOCKER_HUB

    echo
    echo "=========================================="
    echo $MY_DOCKER_HUB
    echo $MY_DOCKER_IMAGE
    echo $MY_TAG
    echo "=========================================="
    echo

    docker build -t $MY_DOCKER_IMAGE:$MY_TAG -f Dockerfile --no-cache . || { echo 'script error: docker build' ; }
    docker tag $MY_DOCKER_IMAGE:$MY_TAG $MY_DOCKER_HUB/$MY_DOCKER_IMAGE:$MY_TAG

    docker push $MY_DOCKER_HUB/$MY_DOCKER_IMAGE:$MY_TAG || { echo 'script error: missing aws auth info?!' ; exit 1; }

    #docker run -p 0.0.0.0:${PORT_SYSTEM}:${80} -d ${MY_DOCKER_HUB}/${MY_DOCKER_IMAGE}:${MY_TAG}
    #docker run -p 5599:80 -d evasyuk/land

    # unset all ENV variables from .env file
    #unset $(grep -v '^#' .env | sed -E 's/(.*)=.*/\1/' | xargs)

else
  echo "skipping upload step as non-master branch detected: $CI_COMMIT_REF_NAME"
  exit 1;
fi
