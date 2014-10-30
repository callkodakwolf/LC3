# Da Ke
# Compilation for all Verilog and SystemVerilog files 


# Compile Verilog Files
vlog ../Verilog/decode.v
#vlog *.vp

# Compile System Verilog Files
vlog -mfcu -sv  /Decode_stage/tester.sv /Decode_stage/scoreboard.sv /Decode_stage/interface.sv 
vlog -sv   /Decode_stage/TestBench.sv
# Simulate the Top module

vsim -coverage -novopt -sv_seed 129610023857 LC3_TestBench_top

log -r */
add wave sim:/LC3_TestBench_top/dut/ir
add wave sim:/LC3_TestBench_top/sb/ir_predict
add wave sim:/LC3_TestBench_top/dut/instr_mem_dout
#add wave sim:/LC3_TestBench_top/dut/w_control
#add wave sim:/LC3_TestBench_top/sb/if_sb/w_control
#add wave sim:/LC3_TestBench_top/sb/w_control_predict
add wave sim:/LC3_TestBench_top/dut/e_control
add wave sim:/LC3_TestBench_top/sb/e_control_predict
add wave sim:/LC3_TestBench_top/sb/if_sb/e_control
add wave sim:/LC3_TestBench_top/dut/mem_control
add wave sim:/LC3_TestBench_top/sb/mem_control_predict
add wave sim:/LC3_TestBench_top/sb/if_sb/mem_control
#add wave sim:/LC3_TestBench_top/dut/npc_out
add wave sim:/LC3_TestBench_top/sb/npc_out_predict
add wave sim:/LC3_TestBench_top/dut/clk
add wave sim:/LC3_TestBench_top/dut/rst
add wave sim:/LC3_TestBench_top/dut/enable_decode
#add wave sim:/LC3_TestBench_top/dut/*
#add wave sim:/LC3_TestBench_top/sb/*

run -all



