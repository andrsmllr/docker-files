ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/iverilog'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS iverilog-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/iverilog'
ARG SOURCE_REPO='https://github.com/steveicarus/iverilog'

LABEL description 'Icarus Verilog simulator (development/build)'

# git and ca-certificates is needed to clone from https://github.com
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -qq -y \
    autoconf \
    bison \
    ca-certificates \
    flex \
    g++ \
    git \
    gperf \
    libreadline-dev \
    make

# No need to clean-up here since build results are copied to a clean image

RUN git clone ${SOURCE_REPO} ${SOURCE_PATH}

RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && autoconf \
    && ./configure --prefix=${INSTALL_PATH} \
    && make -j$(nproc) \
    && make install

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS iverilog-app

ARG INSTALL_PATH

LABEL description 'Icarus Verilog simulator (application/runtime)'

# Copy installation files from dev image.
COPY --from=iverilog-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/iverilog /usr/bin/iverilog

# Install runtime dependencies.
#RUN apt update -qq \
#    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
#    g++ \
#    && apt clean \
#    && rm -rf /var/lib/apt/lists/*

# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "iverilog"]
