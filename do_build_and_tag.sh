#!/bin/bash
#
# Must be executed from the root dir of the docker-files repo.
#

# Exit when any command fails.
set -e

root_dir=$(pwd)
source ./dockerutils.sh

DOCKER_ADDITIONAL_ARGS="--no-cache"

# Build images locally
cd ${root_dir}/andrsmllr-base && docker_build andrsmllr-base andrsmllr/base latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/bluespec-compiler && docker_build bluespec-compiler-app andrsmllr/bluespec-compiler latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/ghdl && docker_build ghdl-app andrsmllr/ghdl latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/gtkwave && docker_build gtkwave-app andrsmllr/gtkwave latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/iverilog && docker_build iverilog-app andrsmllr/iverilog latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/klayout && docker_build klayout-app andrsmllr/klayout latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/magic && docker_build magic-app andrsmllr/magic latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/symbiyosys && docker_build symbiyosys-app andrsmllr/symbiyosys latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/verilator && docker_build verilator-app andrsmllr/verilator latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/xschem && docker_build xschem-app andrsmllr/xschem latest ./context "${DOCKER_ADDITIONAL_ARGS}"
cd ${root_dir}/yosys && docker_build yosys-app andrsmllr/yosys latest ./context "${DOCKER_ADDITIONAL_ARGS}"

# Push tags
docker_push_tag andrsmllr/base latest
docker_push_tag andrsmllr/bluespec-compiler latest
docker_push_tag andrsmllr/ghdl latest
docker_push_tag andrsmllr/gtkwave latest
docker_push_tag andrsmllr/iverilog latest
docker_push_tag andrsmllr/klayout latest
docker_push_tag andrsmllr/magic latest
docker_push_tag andrsmllr/symbiyosys latest
docker_push_tag andrsmllr/verilator latest
docker_push_tag andrsmllr/xschem latest
docker_push_tag andrsmllr/yosys latest
