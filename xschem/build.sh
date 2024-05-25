#!/bin/bash

DOCKER_BUILD_TARGET="xschem-app"
DOCKER_IMAGE="andrsmllr/xschem"
DOCKER_TAG="latest"
DOCKER_BUILD_CONTEXT="./build_context"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${DOCKER_TAG} ${DOCKER_BUILD_CONTEXT}
