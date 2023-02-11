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
    DOCKER_BUILD_CONTEXT=${4:-$(pwd)}
    DOCKER_BUILD_ARGS=${5}

    # Build docker image and create local tag.
    # docker buildx build \
    DOCKER_BUILDKIT=1 docker build \
        --target ${DOCKER_BUILD_TARGET} \
        --compress \
        -t ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_BUILD_CONTEXT} \
        ${DOCKER_BUILD_ARGS}
}


# ------------------------------------------------------------------------------
function docker_create_tag()
{
    DOCKER_IMAGE=${1}
    DOCKER_TAG_A=${2:-"latest"}
    DOCKER_TAG_B=${3:-"latest"}

    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG_A} ${DOCKER_IMAGE}:${DOCKER_TAG_B}
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
