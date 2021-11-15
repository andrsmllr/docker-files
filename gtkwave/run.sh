#!/bin/bash
USER_ID=$(id -u ${USER})
SYSTEM_RUN_FOLDER="/run/user/${USER_ID}"

docker run \
  --rm \
  -ti \
  -v ${SYSTEM_RUN_FOLDER}:${SYSTEM_RUN_FOLDER} \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v ${HOME}/.Xauthority:/work/.Xauthority:ro \
  -e XAUTHORITY=/work/.Xauthority \
  -e DISPLAY=$DISPLAY \
  -v $(pwd):/work \
  -w /work \
  -e LOCAL_USER_ID=${USER_ID} \
  andrsmllr/gtkwave \
  "$@"
