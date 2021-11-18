#!/bin/bash

DOCKER_BUILD_TARGET="symbiyosys-app"
DOCKER_IMAGE="andrsmllr/symbiyosys"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
