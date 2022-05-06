#!/bin/bash

DOCKER_BUILD_TARGET="verilator-app"
DOCKER_IMAGE="andrsmllr/verilator"
DOCKER_TAG="latest"
DOCKER_BUILD_CONTEXT="./context"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${DOCKER_TAG} ${DOCKER_BUILD_CONTEXT}
