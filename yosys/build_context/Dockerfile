ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/yosys'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS yosys-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/yosys'
ARG SOURCE_REPO='https://github.com/yosyshq/yosys'

LABEL description "Yosys open synthesis suite (development/build)"

# Add ca-certificates and git to access sources from https://github.com
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    git \
    ca-certificates \
    bison \
    build-essential \
    clang \
    flex \
    gawk \
    graphviz \
    iverilog \
    libboost-filesystem-dev \
    libboost-python-dev \
    libboost-system-dev \
    libffi-dev \
    libreadline-dev \
    pkg-config \
    python3 \
    tcl-dev \
    xdot \
    zlib1g-dev
# No need to clean-up here since build results are copied to a clean image

RUN git clone --recursive --depth 1 ${SOURCE_REPO} ${SOURCE_PATH}

RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && export PREFIX=${INSTALL_PATH} \
    && make config-clang \
    && make -j$(nproc) \
    && make install

# Tests take a long time, comment out while not stable
#RUN cd ${SOURCE_PATH} && make test

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS yosys-app

ARG INSTALL_PATH

LABEL description "Yosys open synthesis suite (application/runtime)"

# Copy installation files from dev image.
COPY --from=yosys-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/yosys /usr/bin/yosys

# Install runtime dependencies.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    iverilog \
    python3 \
    tcl \
    && apt clean \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Set default command.
CMD [ "/usr/bin/bash", "-c", "yosys" ]
