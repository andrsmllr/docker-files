#!/bin/bash
# ------------------------------------------------------------------------------
# Build a docker image.
#
# Assumes the build targets ${DOCKER_BUILD_TARGET}-dev and ${DOCKER_BUILD_TARGET}-app
# exist in the Dockerfile.
# ------------------------------------------------------------------------------

DOCKER_RUN_ARGS_ENABLE_DISPLAY="-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v ${HOME}/.Xauthority:/tmp/.Xauthority:ro \
  -e XAUTHORITY=/tmp/.Xauthority \
  -e DISPLAY=${DISPLAY}"

DOCKER_RUN_ARGS_FOR_ENTRYPOINT="-e LOCAL_USER_ID=${USER_ID}"

DOCKER_RUN_ARGS_FOR_INTERACTIVE_SESSION="--tty --interactive"

DOCKER_RUN_ARGS_MOUNT_CURRENT_WORKDIR="-v $(pwd):/$(pwd) \
  -w $(pwd)"

# ------------------------------------------------------------------------------
function docker_build()
{
    if [ $# -lt 2 ]; then
        echo "Not enough arguments"
        return -1
    fi

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
        --tag ${DOCKER_IMAGE}:${DOCKER_TAG} \
        ${DOCKER_BUILD_CONTEXT} \
        ${DOCKER_BUILD_ARGS}

    return $?
}


# ------------------------------------------------------------------------------
function docker_create_tag()
{
    if [ $# -lt 2 ]; then
        echo "Not enough arguments"
        return -1
    fi

    DOCKER_IMAGE=${1}
    DOCKER_TAG_TO=${2}
    DOCKER_TAG_FROM=${3:-"latest"}

    echo "Creating new tag for ${DOCKER_IMAGE}: ${DOCKER_TAG_FROM} -> ${DOCKER_TAG_TO}"
    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG_FROM} ${DOCKER_IMAGE}:${DOCKER_TAG_TO}

    return $?
}


# ------------------------------------------------------------------------------
function docker_push_tag()
{
    if [ $# -lt 1 ]; then
        echo "Not enough arguments"
        return -1
    fi

    DOCKER_IMAGE=${1}
    DOCKER_TAG=${2:-"latest"}
    DOCKER_REGISTRY=${3:-"docker.io"}

    echo "Pushing tag ${DOCKER_IMAGE}:${DOCKER_TAG} to ${DOCKER_REGISTRY}"
    docker login ${DOCKER_REGISTRY}
    docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}

    return $?
}
