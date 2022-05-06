ARG BASE_IMAGE=andrsmllr/yosys
ARG BASE_TAG=latest
ARG INSTALL_PATH='/opt/symbiyosys'

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS symbiyosys-dev

ARG INSTALL_PATH
ARG SOURCE_PATH='/usr/src/symbiyosys'
ARG SOURCE_REPO='https://github.com/yosyshq/symbiyosys'

LABEL description "SymbiYosys open source formal verification suite (development/build)"

# Add ca-certificates and git to access sources from https://github.com
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -qq -y \
    autoconf \
    bison \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    curl \
    flex \
    g++ \
    gawk \
    git \
    gperf \
    graphviz \
    libboost-program-options-dev \
    libffi-dev \
    libftdi-dev \
    libgmp-dev \
    libpython2.7 \
    libreadline-dev \
    mercurial \
    ninja-build \
    pkg-config \
    python \
    python-dev \
    python3-pip \
    python-setuptools \
    python3 \
    tcl-dev \
    wget \
    xdot
# No need to clean-up here since build results are copied to a clean image

# SymbiYosys, needs patch to allow non-default install path (prefix)
# See https://yosyshq.readthedocs.io/projects/sby/en/latest/install.html
RUN git clone --recursive  ${SOURCE_REPO} ${SOURCE_PATH}
COPY ./symbiyosys.patch ${SOURCE_PATH}/symbiyosys.patch
WORKDIR ${SOURCE_PATH}
RUN git apply ./symbiyosys.patch \
    && mkdir -p ${INSTALL_PATH} \
    && make install

# Yices2
ENV YICES2_SOURCE_PATH /usr/src/yices2
ENV YICES2_INSTALL_PATH ${INSTALL_PATH}/solvers/yices2
RUN git clone --recursive  https://github.com/SRI-CSL/yices2 ${YICES2_SOURCE_PATH}
WORKDIR ${YICES2_SOURCE_PATH}
RUN autoconf \
    && ./configure --prefix=${YICES2_INSTALL_PATH} \
    && make -j$(nproc) \
    && mkdir -p ${YICES2_INSTALL_PATH} \
    && make install

# Z3
ENV Z3_SOURCE_PATH /usr/src/z3
ENV Z3_INSTALL_PATH ${INSTALL_PATH}/solvers/z3
RUN git clone --recursive https://github.com/Z3Prover/z3 ${Z3_SOURCE_PATH}
WORKDIR ${Z3_SOURCE_PATH}
RUN mkdir -p ${Z3_INSTALL_PATH} \
    && ./configure --prefix=${Z3_INSTALL_PATH} \
    && cd ./build \
    && make -j$(nproc) \
    && make install

# SuperProve
ENV SUPERPROVE_SOURCE_PATH /usr/src/super_prove
ENV SUPERPROVE_INSTALL_PATH ${INSTALL_PATH}/solvers
RUN git clone --recursive https://github.com/sterin/super-prove-build ${SUPERPROVE_SOURCE_PATH}
WORKDIR ${SUPERPROVE_SOURCE_PATH}
RUN mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -G Ninja .. \
    && ninja \
    && ninja package \
    && mkdir -p ${SUPERPROVE_INSTALL_PATH} \
    && SUPERPROVE_RELEASE_TAR=$(find . -maxdepth 1 -name super_prove-*-Release.tar.gz) \
    && tar -C ${SUPERPROVE_INSTALL_PATH} -xf ${SUPERPROVE_RELEASE_TAR}
ENV SUPERPROVE_WRAPPER ${SUPERPROVE_INSTALL_PATH}/super_prove/bin/suprove
RUN echo '#!/bin/bash' > ${SUPERPROVE_WRAPPER}
RUN echo 'tool=super_prove; if [ "$1" != "${1#+}" ]; then tool="${1#+}"; shift; fi' >> ${SUPERPROVE_WRAPPER}
RUN echo "exec ${SUPERPROVE_INSTALL_PATH}/super_prove/bin/\${tool}.sh \$@" >> ${SUPERPROVE_WRAPPER}
RUN chmod +x ${SUPERPROVE_WRAPPER}

# Avy, needs patch to fix issue with boost
ENV AVY_SOURCE_PATH /usr/src/avy
ENV AVY_INSTALL_PATH ${INSTALL_PATH}/solvers/avy
RUN git clone --recursive https://bitbucket.org/arieg/extavy ${AVY_SOURCE_PATH}
COPY ./avy.patch ${AVY_SOURCE_PATH}/avy/avy.patch
RUN cd ${AVY_SOURCE_PATH}/avy && git apply ./avy.patch
WORKDIR ${AVY_SOURCE_PATH}
RUN mkdir -p ${AVY_SOURCE_PATH}/build \
    && cd ${AVY_SOURCE_PATH}/build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make -j$(nproc) \
    && mkdir -p ${AVY_INSTALL_PATH}/bin \
    && cp ${AVY_SOURCE_PATH}/build/avy/src/avy ${AVY_INSTALL_PATH}/bin/avy \
    && cp ${AVY_SOURCE_PATH}/build/avy/src/avybmc ${AVY_INSTALL_PATH}/bin/avybmc \
    && cp ${AVY_SOURCE_PATH}/build/avy/src/avypdr ${AVY_INSTALL_PATH}/bin/avypdr

# Boolector
# Open issue https://github.com/YosysHQ/SymbiYosys/issues/112
ENV BTOR_SOURCE_PATH /usr/src/boolector
ENV BTOR_INSTALL_PATH ${INSTALL_PATH}/solvers/boolector
RUN git clone --recursive https://github.com/boolector/boolector ${BTOR_SOURCE_PATH}
WORKDIR ${BTOR_SOURCE_PATH}
RUN ./contrib/setup-btor2tools.sh \
    && ./contrib/setup-lingeling.sh \
    && ./configure.sh \
    && make -C build -j$(nproc) \
    && mkdir -p ${BTOR_INSTALL_PATH}/bin \
    && cp build/bin/boolector ${BTOR_INSTALL_PATH}/bin/boolector \
    && cp build/bin/btor* ${BTOR_INSTALL_PATH}/bin/ \
    && cp deps/btor2tools/bin/btorsim ${BTOR_INSTALL_PATH}/bin/btorsim

################################################################################
FROM ${BASE_IMAGE}:${BASE_TAG} AS symbiyosys-app

ARG INSTALL_PATH

LABEL description "SymbiYosys open source formal verification suite (application/runtime)"

# Copy installation files from dev image.
COPY --from=symbiyosys-dev ${INSTALL_PATH} ${INSTALL_PATH}
RUN ln -s ${INSTALL_PATH}/bin/sby /usr/bin/sby \
    && export PATH=$PATH:${INSTALL_PATH}/solvers/yices2/bin:${INSTALL_PATH}/solvers/z3/bin:${INSTALL_PATH}/solvers/super_prove/bin:${INSTALL_PATH}/solvers/avy/bin:${INSTALL_PATH}/solvers/boolector/bin

# Install runtime dependencies.
RUN apt update -qq \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    iverilog \
    python3 \
    tcl \
    && apt clean \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Prepare entrypoint.sh, which installs a local user with same UID as the docker user.
ENV TERM=xterm-256color
WORKDIR /work
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && set -eux
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "sby"]
