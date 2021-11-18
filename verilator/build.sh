#!/bin/bash

DOCKER_BUILD_TARGET="verilator-app"
DOCKER_IMAGE="andrsmllr/verilator"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
