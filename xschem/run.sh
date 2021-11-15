#!/bin/bash
USER_ID=$(id -u ${USER})
SYSTEM_RUN_FOLDER="/run/user/${USER_ID}"
# Use default xschem library path if XSCHEM_LIB_PATH is not defined.
XSCHEM_LIB_PATH=${XSCHEM_LIB_PATH:-"${HOME}/.xschem/lib"}

#-v ${HOME}/.Xauthority:/work/.Xauthority \
#-e XAUTHORITY=/work/.Xauthority \

docker run \
  --rm \
  -ti \
  -v ${XSCHEM_LIB_PATH}:/work/xschem_lib \
  -v ${SYSTEM_RUN_FOLDER}:${SYSTEM_RUN_FOLDER} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  -v $(pwd):/work \
  -w /work \
  -e LOCAL_USER_ID=${USER_ID} \
  andrsmllr/xschem:latest \
  "$@"
