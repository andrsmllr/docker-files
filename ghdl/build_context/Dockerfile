# syntax=docker/dockerfile:1
ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/ghdl'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS ghdl-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/ghdl'
ARG SOURCE_REPO='https://github.com/ghdl/ghdl'

LABEL description 'GHDL open source VHDL simulator (development/build)'

# git and ca-certificates is needed to clone from https://github.com
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    git \
    ca-certificates \
    bison \
    clang \
    flex \
    gnat \
    libz-dev \
    llvm \
    llvm-dev \
    make
# No need to clean-up here since build results are copied to a clean image

RUN git clone --recursive --depth 1 ${SOURCE_REPO} ${SOURCE_PATH}

RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && ./configure --prefix=${INSTALL_PATH} --with-llvm-config \
    && make -j$(nproc) \
    && make install

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS ghdl-app

ARG INSTALL_PATH

LABEL description 'GHDL open source VHDL simulator (application/runtime)'

# Copy installation files from dev image.
COPY --from=ghdl-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/ghdl /usr/bin/ghdl

# Install runtime dependencies.
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    gnat \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Set default command.
CMD [ "/usr/bin/bash", "-c", "ghdl" ]
