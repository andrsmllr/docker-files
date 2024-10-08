#!/bin/bash

DOCKER_BUILD_TARGET="buildroot-env"
DOCKER_IMAGE="andrsmllr/buildroot-env"
DOCKER_TAG="latest"
DOCKER_BUILD_CONTEXT="./build_context"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${DOCKER_TAG} ${DOCKER_BUILD_CONTEXT}
