ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/verilator'
ARG WITH_SYSTEMC=1

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS verilator-dev

ARG INSTALL_PATH
ARG WITH_SYSTEMC
ARG SOURCE_PATH='/usr/src/verilator'
ARG SOURCE_REPO='https://github.com/verilator/verilator'

LABEL description "Verilator Verilog simulator"

# Add ca-certificates and git to access sources from https://github.com
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -qq -y \
    git \
    ca-certificates \
    autoconf \
    bison \
    build-essential \
    ccache \
    flex \
    g++ \
    libfl-dev \
    libfl2 \
    libgoogle-perftools-dev \
    make \
    numactl \
    perl \
    perl-doc \
    python3 \
    wget \
    zlib1g \
    zlib1g-dev \
    zlibc
# No need to clean-up here since build results are copied to a clean image

COPY ./with_systemc.sh /tmp/with_systemc.sh
RUN if [[ $WITH_SYSTEMC == 1 ]]; then source /tmp/with_systemc.sh; fi

RUN git clone ${SOURCE_REPO} ${SOURCE_PATH}

# If SystemC sources are present, compile them
RUN /tmp/with_systemc.sh

RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && autoconf \
    && ./configure --prefix=${INSTALL_PATH} \
    && make -j$(nproc) \
    && make install

# Tests take a long time, comment out while not stable
#RUN cd ${SOURCE_PATH} && make check

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS verilator-app

ARG INSTALL_PATH
ARG WITH_SYSTEMC
ENV VERILATOR_ROOT ${INSTALL_PATH}

# Copy installation files from builder.
COPY --from=verilator-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/verilator /usr/bin/verilator

# Install runtime dependencies.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    libfl-dev \
    libfl2 \
    libgoogle-perftools-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Prepare gosu, a tool used by entrypoint.sh to install a local user with same UID as the docker user.
RUN set -eux; gosu nobody true
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "verilator"]
