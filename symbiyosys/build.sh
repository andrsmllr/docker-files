#!/bin/bash

DOCKER_BUILD_TARGET="symbiyosys"
DOCKER_IMAGE="andrsmllr/symbiyosys"
BUILD_VERSION="HEAD"

docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
