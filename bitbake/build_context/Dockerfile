ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS bitbake-env

LABEL description 'Bitbake/Yocto build environment'

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    # ca-certificates is needed to clone from https://github.com
    ca-certificates \
    # Add a compact text editor
    nano \
    # Mandatory packages bitbake
    build-essential \
    python3 \
    g++ \
    gcc \
    git \
    make \
    chrpath \
    cpio \
    diffstat \
    file \
    gawk \
    wget \
    zstd \
    lz4 \
    patch \
    #pzstd \
    #ranlib \
    #rpcgen \
    #strings \
    #unzstd \
    # Clean up apt
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
