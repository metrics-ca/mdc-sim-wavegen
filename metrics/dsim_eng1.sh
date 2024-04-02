#!/bin/bash
# dsim_eng1.sh
# Bash script to simulate design with Metrics DSim on eng-1

# Set up environment
export VIVADO_HOME=/tools/Xilinx/Vivado/2022.1
cd work
WAVE_FILE=waves.mxd
set -e

# Compile standard libraries
dlib map -lib ieee ${STD_LIBS}/ieee93
dvhcom -vhdl93 -lib xpm -F ../common/xpm_filelist.txt
dvhcom -vhdl93 -lib unisim -F ../common/unisim_filelist.txt
dvlcom -lib xpm -F ../common/xpm_ver_filelist.txt
dvlcom -lib unisims_ver -F ../common/unisims_ver_filelist.txt

# Compile design libraries
dvlcom -lib fifo_generator_v13_2_7 +incdir+../../../../../wavegen.srcs/sources_1/imports/Sources +incdir+../../../../../wavegen.gen/sources_1/ip/clk_core ../../../../../wavegen.ip_user_files/ipstatic/simulation/fifo_generator_vlog_beh.v
dvhcom -vhdl93 -lib fifo_generator_v13_2_7  ../../../../../wavegen.ip_user_files/ipstatic/hdl/fifo_generator_v13_2_rfs.vhd
dvlcom -lib fifo_generator_v13_2_7 +incdir+../../../../../wavegen.srcs/sources_1/imports/Sources +incdir+../../../../../wavegen.gen/sources_1/ip/clk_core ../../../../../wavegen.ip_user_files/ipstatic/hdl/fifo_generator_v13_2_rfs.v
dvlcom -lib xil_defaultlib +incdir+../../../../../wavegen.srcs/sources_1/imports/Sources +incdir+../../../../../wavegen.gen/sources_1/ip/clk_core -F ../common/xil_defaultlib_filelist.txt

# Compile glbl module
dvlcom -lib xil_defaultlib ../../xsim/glbl.v

# Elaborate and Simulate design, and dump waveform
dsim -top xil_defaultlib.tb_wave_gen -top xil_defaultlib.glbl -run-until 1000us +acc+b -waves $WAVE_FILE -L xil_defaultlib -L xpm -L unisims_ver -L fifo_generator_v13_2_7 -lib xil_defaultlib
