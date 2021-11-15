#!/bin/bash

DOCKER_BUILD_TARGET="gtkwave-runner"
DOCKER_IMAGE="andrsmllr/gtkwave"
BUILD_VERSION="HEAD"

docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
