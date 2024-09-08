# syntax=docker/dockerfile:1
ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS buildroot-env

LABEL description 'Buildroot build environment'

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    # ca-certificates is needed to clone from https://github.com
    ca-certificates \
    # Add a compact text editor
    nano \
    # Mandatory packages for buildroot
    # See https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
    gnu-which \
    sed \
    make \
    binutils \
    build-essential \
    diffutils \
    gcc \
    g++ \
    bash \
    patch \
    gzip \
    bzip2 \
    perl \
    tar \
    cpio \
    unzip \
    rsync \
    file \
    bc \
    findutils \
    wget \
    # Optional packages for buildroot
    # For some features and utilities Python is used
    python3 \
    # For configuration interface/menu
    #ncurses5 \
    #qt5 \
    #libglib2.0-0 \
    #libgtk2 \
    #libglade2-0 \
    # For fetching source code
    cvs \
    git \
    mercurial \
    # For scp \
    openssh-client \
    #sftp \
    subversion \
    # For java support
    #javac \
    #jar \
    # For documentation generation
    #asciidoc \
    #w3m \
    #dblatex \
    # For graph generation
    graphviz \
    #python-matplotlib \
    # For buildroot util scripts
    expect \
    # Clean up apt
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


FROM buildroot-env as buildroot-app
