#!/bin/bash

DOCKER_BUILD_TARGET="yosys-app"
DOCKER_IMAGE="andrsmllr/yosys"
DOCKER_TAG="latest"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${DOCKER_TAG} ${BUILD_VERSION}
