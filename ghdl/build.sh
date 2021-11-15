#!/bin/bash

DOCKER_BUILD_TARGET="ghdl-runner"
DOCKER_IMAGE="andrsmllr/ghdl"
BUILD_VERSION="HEAD"

docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
