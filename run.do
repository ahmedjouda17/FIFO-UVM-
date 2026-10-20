vlib work
vlog +cover -f src_files.list

vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all -sv_seed random -l sim.log

add wave /top/FIFOif/*

run 0

add wave -position insertpoint \
sim:/uvm_root/uvm_test_top/env/sb/data_out_ref

run -all