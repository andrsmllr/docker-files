ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/klayout'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS klayout-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/klayout'
ARG SOURCE_REPO='https://github.com/klayout/klayout'

LABEL description "Klayout GDSII viewer and editor (development/build)"

# Add ca-certificates and git to access sources from https://github.com
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -qq -y \
    git \
    ca-certificates \
    g++ \
    libqt5svg5-dev \
    libqt5xmlpatterns5-dev \
    make \
    python3 \
    python3-dev \
    qtmultimedia5-dev \
    qttools5-dev-tools \
    qttools5-dev
# No need to clean-up here since build results are copied to a clean image

RUN git clone ${SOURCE_REPO} ${SOURCE_PATH}

RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && mkdir -p build \
    && ./build.sh -build ./build -prefix ${INSTALL_PATH}

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS klayout-app

ARG INSTALL_PATH

LABEL description "Klayout GDSII viewer and editor (application/runtime)"

# Copy installation files from dev image.
COPY --from=klayout-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/klayout /usr/bin/klayout

# Install runtime dependencies.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    libqt5svg5-dev \
    libqt5xmlpatterns5-dev \
    python3 \
    python3-dev \
    qtmultimedia5-dev \
    qttools5-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "klayout"]
