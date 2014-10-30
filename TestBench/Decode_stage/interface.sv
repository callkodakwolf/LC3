interface lc3_if;
	
	bit 		clk;
	bit			rst;
	wire		enable_decode;
	wire [15:0]	npc_in;
	wire [5:0] 	e_control;
	wire [1:0] 	w_control;
	wire [15:0] 	npc_out;
	wire 			mem_control;
	wire [2:0]		psr;
	wire [15:0] instr_mem_dout;
	wire [15:0] ir;
	
	modport tester(
					input clk,
					output rst,
					clocking cb);
					
	modport	DUT	(
					input clk,
					input rst,
					input npc_in,
					input enable_decode,
					input instr_mem_dout,
					input psr,
					output ir,
					output e_control,
					output w_control,
					output mem_control,
					output npc_out);
					
	modport scoreboard(
					input clk,
					input rst,
	//				clocking cb_score,	
		input e_control,
		input w_control,
		input mem_control,
		input npc_out,
		input npc_in,
		input ir,
		input instr_mem_dout,
		input enable_decode
		);
						
	clocking cb @(posedge clk);
		output npc_in;
		output enable_decode;
		output instr_mem_dout;
		output psr;
	endclocking
/*	
	clocking cb_score @(posedge clk);
		input w_control;

	endclocking : cb_score
*/		
	initial begin
		$monitor ("enable_decode: %1h", enable_decode);
		clk = 0;
		forever begin 
			#10;
			clk = ~clk;
		end
	end
	
	

endinterface : lc3_if