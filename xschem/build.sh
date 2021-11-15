#!/bin/bash

source ../dockerutils.sh

DOCKER_BUILD_TARGET="xschem-runner"
DOCKER_IMAGE="andrsmllr/xschem"
BUILD_VERSION="HEAD"

docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
