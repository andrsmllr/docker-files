ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/magic'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS magic-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/magic'
ARG SOURCE_REPO='https://github.com/RTimothyEdwards/magic'

LABEL description 'Magic VLSI layout'

# Add ca-certificates and git to access sources from https://github.com
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -qq -y \
    git \
    ca-certificates \
    bison \
    build-essential \
    clang \
    csh \
    flex \
    libcairo2-dev \
    libglu1-mesa-dev \
    libx11-dev \
    m4 \
    mesa-common-dev \
    tcl-dev \
    tk-dev
# No need to clean-up here since build results are copied to a clean image

RUN git clone ${SOURCE_REPO} ${SOURCE_PATH}

RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && ./configure --prefix=${INSTALL_PATH} \
    && make -j$(nproc) \
    && make install

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS magic-app

ARG INSTALL_PATH

# Copy installation files from dev image.
COPY --from=magic-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/magic /usr/bin/magic

# Install runtime dependencies.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    libcairo2-dev \
    libglu1-mesa-dev \
    libx11-dev \
    tcl \
    tk \
    && apt clean \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux; gosu nobody true
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "magic"]
