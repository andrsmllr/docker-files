#!/bin/bash
# ------------------------------------------------------------------------------
# Build a docker image.
#
# Assumes the build targets ${DOCKER_BUILD_TARGET}-dev and ${DOCKER_BUILD_TARGET}-app
# exist in the Dockerfile.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
function docker_build()
{
    DOCKER_BUILD_TARGET=${1}
    DOCKER_IMAGE=${2}
    DOCKER_TAG=${3:-"latest"}
    BUILD_VERSION=${4:-"HEAD"}

    # Build docker image and create local tag.
    DOCKER_BUILDKIT=1 docker build \
        --target ${DOCKER_BUILD_TARGET} \
        --build-arg BUILD_VERSION=${BUILD_VERSION} \
        --compress \
        --no-cache \
        -t ${DOCKER_IMAGE}:${DOCKER_TAG} \
        $(pwd)
}

# ------------------------------------------------------------------------------
function docker_push_tag()
{
    DOCKER_IMAGE=${1}
    DOCKER_TAG=${2:-"latest"}
    DOCKER_REGISTRY=${3:-"docker.io"}

    docker login ${DOCKER_REGISTRY}
    docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
}
