ARG BASE_IMAGE=andrsmllr/base
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/bsc'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS bluespec-compiler-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/bsc'
ARG SOURCE_REPO='https://github.com/B-Lang-org/bsc'

LABEL description 'BlueSpec compiler (BSC) (development/build)'

# Install build dependencies.
# git and ca-certificates is needed to clone from https://github.com
# The texlive packages and asciidoctor are needed to build the BlueSpec documentation.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -qq -y \
    autoconf \
    bison \
    build-essential \
    ca-certificates \
    flex \
    git \
    ghc \
    gperf \
    iverilog \
    libghc-regex-compat-dev \
    libghc-syb-dev \
    libghc-old-time-dev \
    libghc-split-dev \
    make \
    perl \
    pkg-config \
    tcl-dev
# The libs below are needed to build bsc documentation.
#    asciidoctor \
#    texlive-latex-base \
#    texlive-latex-recommended \
#    texlive-latex-extra \
#    texlive-font-utils \
#    texlive-fonts-extra
# The libs below are needed to build bsc with profiling.
#    ghc-prof \
#    libghc-regex-compat-prof \
#    libghc-syb-prof \
#    libghc-old-time-prof \
#    libghc-split-prof
# No need to clean-up here since build results are copied to a clean image

RUN git clone --recursive --depth 1 ${SOURCE_REPO} ${SOURCE_PATH}

# Running make release is equivalent to running
# make install-src && make check-smoke && make install-doc
RUN cd ${SOURCE_PATH} \
    && mkdir -p ${INSTALL_PATH} \
    && export PATH=$PATH:${INSTALL_PATH}/bin \
    && make -j$(nproc) GHCJOBS=$(nproc) PREFIX=${INSTALL_PATH} install-src

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS bluespec-compiler-app

LABEL description 'BlueSpec compiler (BSC) (application/runtime)'

ARG INSTALL_PATH

# Copy installation files from dev image.
COPY --from=bluespec-compiler-dev ${INSTALL_PATH} ${INSTALL_PATH}
ENV PATH ${PATH}:${INSTALL_PATH}/bin

# Install runtime dependencies.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    libatomic1 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "bsc"]
