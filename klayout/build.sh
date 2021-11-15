#!/bin/bash

DOCKER_BUILD_TARGET="klayout-runner"
DOCKER_IMAGE="andrsmllr/klayout"
BUILD_VERSION="HEAD"

docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
