#!/bin/bash

DOCKER_BUILD_TARGET="gtkwave-app"
DOCKER_IMAGE="andrsmllr/gtkwave"
BUILD_VERSION="HEAD"

source ../dockerutils.sh
docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
