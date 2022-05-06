#!/bin/bash

DOCKER_BUILD_TARGET="ghdl-app"
DOCKER_IMAGE="andrsmllr/ghdl"
DOCKER_TAG="latest"
DOCKER_BUILD_CONTEXT="./context"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${DOCKER_TAG} ${DOCKER_BUILD_CONTEXT}
