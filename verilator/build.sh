#!/bin/bash

DOCKER_BUILD_TARGET="verilator-runner"
DOCKER_IMAGE="andrsmllr/verilator"
BUILD_VERSION="HEAD"

docker_build ${DOCKER_BUILD_TARGET} ${DOCKER_IMAGE} ${BUILD_VERSION}
