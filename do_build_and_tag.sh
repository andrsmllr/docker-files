#!/bin/bash
#
# Must be executed from the root dir of the docker-files repo.
#

# Exit when any command fails.
set -e

root_dir=$(pwd)
source ./dockerutils.sh

DO_BUILD=1
DO_TAG=1
DO_PUSH=1

TAG="2023-02-11"

IMAGES_TO_BUILD=" \
    andrsmllr/bluespec-compiler \
    andrsmllr/ghdl \
    andrsmllr/gtkwave \
    andrsmllr/iverilog \
    andrsmllr/magic \
    andrsmllr/symbiyosys \
    andrsmllr/verilator \
    andrsmllr/xschem \
    andrsmllr/yosys \
    andrsmllr/klayout"
# klayout is last, because it takes longest to build

IMAGES_TO_TAG=${IMAGES_TO_BUILD}
IMAGES_TO_PUSH=${IMAGES_TO_BUILD}

DOCKER_ADDITIONAL_ARGS="--no-cache"


# ------------------------------------------------------------------------------
# Build images

if [ "${DO_BUILD}" -eq "1" ]; then
    # The base image is special and always gets build. Do not include it in IMAGES_TO_BUILD
    cd ${root_dir}/andrsmllr-base && docker_build andrsmllr-base andrsmllr/base latest ./context "${DOCKER_ADDITIONAL_ARGS}"

    # Build images locally and create new latest tag
    for image in ${IMAGES_TO_BUILD}; do
        cd ${root_dir}/${image} && docker_build ${image}-app ${image} latest ./context "${DOCKER_ADDITIONAL_ARGS}"
    done
fi

# ------------------------------------------------------------------------------
# Create tags

if [ "${DO_TAG}" -eq "1" ]; then
    docker_create_tag andrsmllr/base:${TAG} andrsmllr/base:latest

    for image in ${IMAGES_TO_TAG}; do
        docker_create_tag ${image}:${TAG} ${image}:latest
    done
fi

# ------------------------------------------------------------------------------
# Push tags

if [ "${DO_PUSH}" -eq "1" ]; then
    docker_push_tag andrsmllr/base ${TAG}
    docker_push_tag andrsmllr/base latest

    for image in ${IMAGES_TO_PUSH}; do
        docker_push_tag ${image} ${TAG}
        docker_push_tag ${image} latest
    done
fi
