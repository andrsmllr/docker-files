#!/bin/bash

DOCKER_BUILD_TARGET="magic-app"
DOCKER_IMAGE="andrsmllr/magic"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
