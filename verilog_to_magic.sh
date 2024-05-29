#!/usr/bin/env bash

set -ex

# required:
# export PDK=sky130A
# export PDK_ROOT=~/asic/pdk
# export PDKPATH="$PDK_ROOT/$PDK"
# export OPENLANE_ROOT=~/asic/openlane

# optional: avoid reinstalling stuff by setting paths:
# export PRECHECK_ROOT=~/asic/precheck
# export CARAVEL_ROOT=~/asic/caravel
# export MCW_ROOT=~/asic/mgmt_core_wrapper
# export TIMING_ROOT=~/asic/timing-scripts

export OPENLANE_IMAGE_NAME="efabless/openlane:2023.07.19-1"

export PROJECT_NAME=lfsr

docker run -it --rm \
	-v $OPENLANE_ROOT:/openlane \
	-v $PDK_ROOT:$PDK_ROOT \
	-v $(pwd):/work \
	-e PDK_ROOT=$PDK_ROOT \
	-e PDK=$PDK \
	-u $(id -u $USER):$(id -g $USER) \
	$OPENLANE_IMAGE_NAME \
	bash -c "./flow.tcl -overwrite -design /work/openlane/$PROJECT_NAME -run_path /work/openlane/$PROJECT_NAME/runs -tag $PROJECT_NAME"

# copy the files out:

mkdir mag || true 2> /dev/null
mkdir verilog/gl || true 2> /dev/null

cp openlane/$PROJECT_NAME/runs/lfsr/results/final/mag/$PROJECT_NAME.mag mag/
cp openlane/$PROJECT_NAME/runs/lfsr/results/final/verilog/gl/$PROJECT_NAME.v verilog/gl/

# open the file

magic -d OGL -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc  mag/$PROJECT_NAME.mag
