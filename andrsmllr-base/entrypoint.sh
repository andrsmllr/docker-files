#!/bin/bash
# Add new user and run command as that user.
# Use $LOCAL_USER_ID from environment or use default Docker user ID.
# Use $LOCAL_USER_NAME from environment or use default Docker user name.

USER_ID=${LOCAL_USER_ID:-9001}
USER_NAME=${LOCAL_USER_NAME:-dockeruser}
USER_SHELL=/bin/bash

echo "Running as user : '${USER_NAME}' with UID : '${USER_ID}'"
useradd --shell ${USER_SHELL} -u ${USER_ID} -o -c "" -m ${USER_NAME}
export HOME=/home/${USER_NAME}

exec /usr/bin/dumb-init /usr/sbin/gosu ${USER_NAME} "$@"
