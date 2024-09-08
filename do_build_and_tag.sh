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

TAG="2024-09-08"

IMAGE_PREFIX="andrsmllr/"

IMAGES_TO_BUILD=" \
    bitbake \
    buildroot \
    ghdl \
    gtkwave \
    iverilog \
    magic \
    opentitan \
    verilator \
    xschem \
    yosys \
    klayout"
# klayout is last, because it takes longest to build
# bluespec-compiler is removed, because it fails to compile
# symbiyosys is removed, because it can no longer be build from sources on it's own apparently, TODO: replace with oss-cad-suite

IMAGES_TO_TAG=${IMAGES_TO_BUILD}
IMAGES_TO_PUSH=${IMAGES_TO_BUILD}

BASE_IMAGE=ubuntu
BASE_TAG=24.04
DOCKER_ADDITIONAL_ARGS="--build-arg BASE_IMAGE=${BASE_IMAGE} --build-arg BASE_TAG=${BASE_TAG}"


# The base image is special and always gets build. Do not include it in IMAGES_TO_BUILD
echo "[do_build_and_tag.sh] INFO: Building 'andrsmllr/base' ..."
cd ${root_dir}/andrsmllr-base && docker_build andrsmllr-base andrsmllr/base latest ./build_context "${DOCKER_ADDITIONAL_ARGS}"
docker_create_tag andrsmllr/base ${TAG} latest
docker_create_tag andrsmllr/base ${BASE_IMAGE}-${BASE_TAG} latest


# ------------------------------------------------------------------------------
# Build images

DOCKER_ADDITIONAL_ARGS=""

if [ "${DO_BUILD}" ]; then
    # Build images locally and create new latest tag
    for image in ${IMAGES_TO_BUILD}; do
        echo "[do_build_and_tag.sh] INFO: Building '${image}' ..."
        cd ${root_dir}/${image} && docker_build ${image}-app ${IMAGE_PREFIX}${image} latest ./build_context "${DOCKER_ADDITIONAL_ARGS}"
    done
fi

# ------------------------------------------------------------------------------
# Create tags

if [ "${DO_TAG}" ]; then
    for image in ${IMAGES_TO_TAG}; do
        echo "[do_build_and_tag.sh] INFO: Tagging '${image}' ..."
        docker_create_tag ${IMAGE_PREFIX}${image} ${TAG} latest
    done
fi

# ------------------------------------------------------------------------------
# Push tags

if [ "${DO_PUSH}" ]; then
    echo "[do_build_and_tag.sh] INFO: Pushing 'andrsmllr/base' ..."
    docker_push_tag andrsmllr/base ${TAG}
    docker_push_tag andrsmllr/base latest

    for image in ${IMAGES_TO_PUSH}; do
        echo "[do_build_and_tag.sh] INFO: Pushing '${image}' ..."
        docker_push_tag ${IMAGE_PREFIX}${image} ${TAG}
        docker_push_tag ${IMAGE_PREFIX}${image} latest
    done
fi
