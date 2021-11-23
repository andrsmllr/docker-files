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
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -qq -y \
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

RUN git clone ${SOURCE_REPO} ${SOURCE_PATH}

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
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    gnat \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "ghdl"]
