#!/bin/bash

DOCKER_BUILD_TARGET="xschem-app"
DOCKER_IMAGE="andrsmllr/xschem"
DOCKER_TAG="latest"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${DOCKER_TAG} ${BUILD_VERSION}
