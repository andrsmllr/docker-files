#!/bin/bash

DOCKER_BUILD_TARGET="andrsmllr-base"
DOCKER_IMAGE="andrsmllr/base"
BUILD_VERSION="HEAD"

docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
