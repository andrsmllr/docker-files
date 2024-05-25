ARG BASE_IMAGE=ubuntu
ARG BASE_TAG=20.04

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS opentitan-env

LABEL maintainers 'andrsmllr <andrsmllr@bananatronics.org>'
LABEL description 'Opentitan build environment'

ARG REPO_TOP=/opt/opentitan
ARG TOOLCHAIN_PATH=/opt/riscv-toolchain
ARG PYTHON_VENV_PATH=/opt/venv
ARG VERILATOR_VERSION=4.210
ARG VERILATOR_PATH=/opt/verilator
ARG VERILATOR_SRC_PATH=/usr/local/src/verilator

RUN if [ -z ${REPO_TOP} ]; then exit 1; fi
RUN if [ -z ${TOOLCHAIN_PATH} ]; then exit 1; fi


RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    # Add dumb-init and gosu to provide a clean entrypoint
    # https://github.com/Yelp/dumb-init
    # https://github.com/tianon/gosu
    dumb-init \
    gosu \
    # ca-certificates is needed to clone from https://github.com
    ca-certificates \
    # Git is required to fetch the opentitan source repo
    git \
    # Add a compact text editor
    nano \
    # Optional package for the opentitan environment
    # Clean up apt
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


# Fetch opentitan sources
RUN if [ ! -d "${REPO_TOP}" ]; then \
    git clone https://github.com/lowRISC/opentitan --recurse-submodules ${REPO_TOP} ; \
    fi


# Install required packages for opentitan
# See https://opentitan.org/book/doc/getting_started/index.html
WORKDIR ${REPO_TOP}
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && sed '/^#/d' ./apt-requirements.txt | xargs apt-get install -q -y \
    && apt-get install -q -y python3-venv \
    # Clean up apt
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


# Install python packages
WORKDIR ${REPO_TOP}
RUN python3 -m venv ${PYTHON_VENV_PATH} \
    && . ${PYTHON_VENV_PATH}/bin/activate \
    && pip3 install -U pip "setuptools<66.0.0" \
    && pip3 install -r python-requirements.txt --require-hashes


# Install the lowrisc riscv toolchain
WORKDIR ${REPO_TOP}
RUN if [ ! -d "${TOOLCHAIN_PATH}" ]; then \
    ./util/get-toolchain.py --install-dir ${TOOLCHAIN_PATH} ; \
    fi


# Install required packages for Verilator
WORKDIR ${REPO_TOP}
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install -q -y \
    gcc-10 \
    g++-10 \
    # Clean up apt
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Install Verilator.
# See https://opentitan.org/book/doc/getting_started/setup_verilator.html
RUN git clone https://github.com/verilator/verilator.git ${VERILATOR_SRC_PATH}
WORKDIR ${VERILATOR_SRC_PATH}
RUN git checkout v${VERILATOR_VERSION}
RUN autoconf
RUN CC=gcc-10 CXX=g++-10 ./configure --prefix=${VERILATOR_PATH}
RUN CC=gcc-10 CXX=g++-10 make -j$(nproc)
RUN CC=gcc-10 CXX=g++-10 make install
RUN export PATH=/opt/verilator/bin:$PATH


# Set up default terminal and default work directory.
ENV TERM=xterm-256color
WORKDIR ${REPO_TOP}


# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux; gosu nobody true
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/bin/bash" ]


# Set up a simple default healthcheck.
HEALTHCHECK --interval=30s --retries=2 --start-interval=5s --start-period=5s --timeout=10s CMD [ "/bin/true" ]
