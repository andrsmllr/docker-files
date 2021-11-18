ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/gtkwave'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS gtkwave-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/gtkwave'
ARG SOURCE_REPO='https://github.com/gtkwave/gtkwave'

LABEL description 'Common base image for other EDA images'

# git and ca-certificates is needed to clone from https://github.com
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -qq -y \
    git \
    ca-certificates \
    autotools-dev \
    automake \
    bison \
    flex \
    gcc \
    g++ \
    gawk \
    gedit \
    gperf \
    liblz4-dev \
    libbz2-dev \
    liblzma-dev \
    libgtk-3-dev \
    tcl \
    tk \
    tk-dev
# No need to clean-up here since build results are copied to a clean image

RUN git clone ${SOURCE_REPO} ${SOURCE_PATH}

RUN cd ${SOURCE_PATH}/gtkwave3-gtk3 \
    && mkdir -p ${INSTALL_PATH} \
    && ./autogen.sh \
    && ./configure --prefix=${INSTALL_PATH} --enable-gtk3 \
    && make -j$(nproc) \
    && make install

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS gtkwave-app

ARG INSTALL_PATH

# Copy installation files from dev image.
COPY --from=gtkwave-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/gtkwave /usr/bin/gtkwave

# Install runtime dependencies.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    libgtk-3-0 \
    tcl \
    tk \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "klayout"]
