# Da Ke
# Compilation for all Verilog and SystemVerilog files 


# Compile Verilog Files
vlog *.v
#vlog *.vp

# Compile System Verilog Files
vlog -mfcu -sv *.sv

# Simulate the Top module

vsim -coverage -novopt -sv_seed 129610023857 TestBech_Top

log -r */

run -all


