# syntax=docker/dockerfile:1
ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/xschem'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS xschem-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/xschem'
ARG SOURCE_REPO='https://github.com/StefanSchippers/xschem'

LABEL description "Xschem schematic editor (development/build)"

# Add ca-certificates and git to access sources from https://github.com
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    git \
    ca-certificates \
    bison \
    flex \
    gawk \
    gcc \
    libcairo2 \
    libcairo2-dev \
    libx11-6 \
    libx11-dev \
    libx11-xcb-dev \
    libxcb1 \
    libxpm-dev \
    libxpm4 \
    libxrender-dev \
    libxrender1 \
    make \
    tcl8.6 \
    tcl8.6-dev \
    tk8.6 \
    tk8.6-dev
# No need to clean-up here since build results are copied to a clean image

RUN git clone --recursive --depth 1 ${SOURCE_REPO} ${SOURCE_PATH}

RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && ./configure --prefix=${INSTALL_PATH} \
    && make -j$(nproc) \
    && make install

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS xschem-app

ARG INSTALL_PATH

LABEL description "Xschem schematic editor (application/runtime)"

# Copy installation files from dev image.
COPY --from=xschem-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/xschem /usr/bin/xschem

# Install runtime dependencies.
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    libcairo2 \
    libx11-6 \
    libx11-xcb-dev \
    libxcb1 \
    libxpm4 \
    libxrender1 \
    tcl8.6 \
    tk8.6 \
    && apt clean \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Set default command.
CMD [ "/usr/bin/bash", "-c", "xschem" ]
