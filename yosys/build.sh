#!/bin/bash

DOCKER_BUILD_TARGET="yosys-app"
DOCKER_IMAGE="andrsmllr/yosys"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
