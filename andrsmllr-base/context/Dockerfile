ARG BASE_IMAGE=ubuntu
ARG BASE_TAG=20.04

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS andrsmllr-base

LABEL maintainers 'andrsmllr <andrsmllr@bananatronics.org>'
LABEL description 'Common base image for my other EDA images'

# Add dumb-init and gosu to provide a clean entrypoint
# https://github.com/Yelp/dumb-init
# https://github.com/tianon/gosu
# Add sudo and nano to ease development of builder images
ENV TZ=Europe/Berlin
ENV LANG=en_US.UTF-8
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    /usr/sbin/locale-gen ${LANG} \
    && apt update -qq \
    && apt dist-upgrade -q -y \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
        dumb-init \
        gosu \
        nano \
    && apt clean \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux; gosu nobody true
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
