ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/gtkwave'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS gtkwave-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/gtkwave'
ARG SOURCE_REPO='https://github.com/gtkwave/gtkwave'

LABEL description 'GTKWave waveform viewer (development/build)'

# git and ca-certificates is needed to clone from https://github.com
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -qq -y \
    git \
    ca-certificates \
    bison \
    desktop-file-utils \
    flex \
    gcc \
    g++ \
    gawk \
    gedit \
    gperf \
    gobject-introspection \
    liblz4-dev \
    libbz2-dev \
    liblzma-dev \
    libgirepository1.0-dev \
    libgtk-3-dev \
    libgtk-4-bin \
    ninja-build \
    python3-pip \
    tcl \
    tk \
    tk-dev
# No need to clean-up here since build results are copied to a clean image

# Install meson from pip, because ppa package is out-of-date
RUN pip3 install meson

RUN git clone --recursive --depth 1 ${SOURCE_REPO} ${SOURCE_PATH}

RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && meson setup build \
    && cd build \
    && meson install --destdir ${INSTALL_PATH}

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS gtkwave-app

ARG INSTALL_PATH

LABEL description 'GTKWave waveform viewer (application/runtime)'

# Copy installation files from dev image.
COPY --from=gtkwave-dev ${INSTALL_PATH}/usr/local/share/gtkwave3 ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/gtkwave /usr/bin/gtkwave

# Install runtime dependencies.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    libgtk-3-0 \
    tcl \
    tk \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Set default command.
CMD [ "/usr/bin/bash", "-c", "gtkwave" ]
