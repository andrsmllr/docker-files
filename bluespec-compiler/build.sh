#!/bin/bash

DOCKER_BUILD_TARGET="bluespec-compiler-app"
DOCKER_IMAGE="andrsmllr/bluespec-compiler"
DOCKER_TAG="latest"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${DOCKER_TAG} ${BUILD_VERSION}
