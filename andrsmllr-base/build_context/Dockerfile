# syntax=docker/dockerfile:1
ARG BASE_IMAGE=ubuntu
ARG BASE_TAG=22.04

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS andrsmllr-base

LABEL maintainers 'andrsmllr <andrsmllr@bananatronics.org>'
LABEL description 'Common base image for my other EDA images'


RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -q -y \
        # Add dumb-init and gosu to provide a clean entrypoint
        # https://github.com/Yelp/dumb-init
        # https://github.com/tianon/gosu
        dumb-init \
        gosu \
        # Many commands complain if there are no system locales
        # thus add locales package to define some defaults.
        locales \
        # Add a compact text editor
        nano \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


# Set up time zone, language and locales.
ENV TZ=Europe/Berlin
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US
ENV LC_ALL=en_US.UTF-8
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && /usr/sbin/locale-gen ${LANG}


# Set up default terminal and default work directory.
ENV TERM=xterm-256color
WORKDIR /work


# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux; gosu nobody true
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/bin/bash" ]


# Set up a simple default healthcheck.
HEALTHCHECK --interval=30s --retries=2 --start-interval=5s --start-period=5s --timeout=10s CMD [ "/bin/true" ]
