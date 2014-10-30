module LC3_TestBench_top();
	lc3_if if_lc3();
	tester tst(if_lc3.tester);
	scoreboard sb(if_lc3.scoreboard);
	
	
	decode dut (
					.clk(if_lc3.DUT.clk),
					.rst(if_lc3.DUT.rst),
					.npc_in(if_lc3.DUT.npc_in),
					.enable_decode(if_lc3.DUT.enable_decode),
					.instr_mem_dout(if_lc3.DUT.instr_mem_dout),
					.psr(if_lc3.DUT.psr),
					.ir(if_lc3.DUT.ir),
					.e_control(if_lc3.DUT.e_control),
					.w_control(if_lc3.DUT.w_control),
					.mem_control(if_lc3.DUT.mem_control),
					.npc_out(if_lc3.DUT.npc_out)
					);
	

endmodule