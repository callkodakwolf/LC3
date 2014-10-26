
module LC3_top(	input 	clk, 
				input 	rst, 
				output 	instr_mem_rd, 
				output 	[15:0] instr_mem_pc,
				input  	[15:0] instr_mem_dout,
				input 	instr_mem_complete,
				input 	data_mem_complete,
				input  	[15:0] data_mem_dout,
				output	[15:0] data_mem_din,
				output	data_mem_rd,
				output 	data_mem_addr,
				);
	
	wire [15:0] npc_if_dec;
	wire [15:0] pc_out_fetch;
	wire enable_decode;
	wire enable_updatepc;
	wire enable_fetch;
	wire rd_fetch;
	
	
	
	
	fetch stage_fetch(.clk(clk), .rst(rst), .enable_updatepc(enable_updatepc), .enable_fetch(enable_fetch), .pc(pc_out_fetch), .npc( npc_if_dec ) , .rd(rd_fetch), .taddr(), .br_taken() );
	
	decode stage_decode(.clk(clk), .rst(rst), .npc_in(npc_if_dec), .enable_decode(enable_decode), .instr_mem_dout(instr_mem_dout), .psr(), ir(), .e_control(), .w_control(), .npc_out, mem)_control() );
	
	controller u_controller(.clk(clk), .rst(rst), .state(state_wire), .C_Control(C_Control_wire), .complete(complete));
	
endmodule 