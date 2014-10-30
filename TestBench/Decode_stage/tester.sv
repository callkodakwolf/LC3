	parameter BR = 4'b0000;
	parameter JMP = 4'b1100;
	parameter ADD = 4'b0001;
	parameter AND = 4'b0101;
	parameter NOT = 4'b1001;
	parameter LD = 4'b0010;
	parameter LDR  = 4'b0110;
	parameter LDI  = 4'b1010;
	parameter LEA  = 4'b1110;
	parameter ST  = 4'b0011;
	parameter STR  = 4'b0111;
	parameter STI  = 4'b1011;	

module tester(lc3_if.tester t);

	logic enable_decode;
	logic [15:0] instr_mem_dout, npc_in;
	

	
	initial begin	// for clocking block, assignment should be unblocking
		t.rst = 1'b0;
		t.cb.enable_decode = 1'b0;
		#15;
		t.rst = 1'b1;
		@(posedge t.clk)
		t.cb.enable_decode <= 1'b1;
		
		repeat (2000) begin
			@(negedge t.clk) begin
				// t.cb.enable_decode <= $random;
				//instr = $random
				t.cb.instr_mem_dout <= $random;
				t.cb.npc_in <= $random;
			end
		end
		$stop;
	end
	
endmodule