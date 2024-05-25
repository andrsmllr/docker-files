#!/bin/bash

USER_ID=$(id -u ${USER})
SYSTEM_RUN_FOLDER="/run/user/${USER_ID}"

source ../dockerutils.sh

docker run \
  --rm \
  ${DOCKER_RUN_ARGS_FOR_INTERACTIVE_SESSION} \
  ${DOCKER_RUN_ARGS_FOR_ENTRYPOINT} \
  ${DOCKER_RUN_ARGS_MOUNT_CURRENT_WORKDIR} \
  andrsmllr/opentitan-env \
  /usr/bin/bash \
  "$@"
