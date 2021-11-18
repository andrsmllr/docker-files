#!/bin/bash

DOCKER_BUILD_TARGET="klayout-app"
DOCKER_IMAGE="andrsmllr/klayout"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
