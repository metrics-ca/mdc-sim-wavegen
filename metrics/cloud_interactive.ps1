# cloud_interactive.ps1
# PowerShell script to simulate design with Metrics DSim Cloud

# Set up environment
cd work
$WAVE_FILE = "waves.mxd"

# Compile design libraries
mdc dvlcom -a '-lib fifo_generator_v13_2_7 +incdir+../../../../../wavegen.srcs/sources_1/imports/Sources +incdir+../../../../../wavegen.gen/sources_1/ip/clk_core ../../../../../wavegen.ip_user_files/ipstatic/simulation/fifo_generator_vlog_beh.v'
mdc dvhcom -a '-vhdl93 -lib fifo_generator_v13_2_7  ../../../../../wavegen.ip_user_files/ipstatic/hdl/fifo_generator_v13_2_rfs.vhd'
mdc dvlcom -a '-lib fifo_generator_v13_2_7 +incdir+../../../../../wavegen.srcs/sources_1/imports/Sources +incdir+../../../../../wavegen.gen/sources_1/ip/clk_core ../../../../../wavegen.ip_user_files/ipstatic/hdl/fifo_generator_v13_2_rfs.v'
mdc dvlcom -a '-lib xil_defaultlib +incdir+../../../../../wavegen.srcs/sources_1/imports/Sources +incdir+../../../../../wavegen.gen/sources_1/ip/clk_core -F ../common/xil_defaultlib_filelist.txt'

# Compile glbl module
mdc dvlcom -a '-lib xil_defaultlib ../../xsim/glbl.v'

# Elaborate and Simulate design, and dump waveform
mdc dsim -a "-top xil_defaultlib.tb_wave_gen -top xil_defaultlib.glbl -run-until 1000us +acc+b -waves $WAVE_FILE -L xil_defaultlib -L xpm -L unisims_ver -L fifo_generator_v13_2_7 -lib xil_defaultlib"
