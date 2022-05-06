#!/bin/bash
# Add local user.
# Use LOCAL_USER_ID if passed at runtime or fall back to default Docker user ID.

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

export XSCHEM_PATH=/opt/xschem

exec /usr/sbin/gosu user "$@"
