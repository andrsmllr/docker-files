#!/bin/bash

DOCKER_BUILD_TARGET="magic-runner"
DOCKER_IMAGE="andrsmllr/magic"
BUILD_VERSION="HEAD"

docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
