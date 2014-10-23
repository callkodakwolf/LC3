
module fetch(clk, rst, enable_updatepc, enable_fetch, pc, npc, rd, taddr, br_taken);
	input clk;
	input rst;
	input enable_updatepc;
	input enable_fetch;
//	input [3:0] state;
	output [15:0] pc, npc;
	input [15:0] taddr;	//target address of control instruction
	input br_taken;		
	output rd;			//Memory read control 
	
	reg [15:0] pc_reg;
	wire [15:0] pc_input, target_pc ;
/**
 parameter Fetch=4'h0;
 parameter Decode= 4'h1;
 parameter ExecALU= 4'h2;
 parameter ExecNPC= 4'h3;
 parameter ExecMemAddr= 4'h4;
 parameter RMem= 4'h5;
 parameter IRMem= 4'h6;
 parameter WMem= 4'h7;
 parameter UpdatePC= 4'h8;
 parameter UpdateReg= 4'h9;
 parameter Invalid= 4'hA;
**/

	assign npc = pc_reg +16'h0001;
	assign target_pc = (br_taken ==1) ? taddr : npc;
	assign pc_input = ( enable_updatepc == 1'b1 ) ? target_pc : pc_reg; 
	assign pc = ( enable_fetch == 1'b1 ) ? pc_reg : 16'hzzzz;
	assign rd = ( enable_fetch == 1'b1 ) ? 1'b1 : 1'bz;
	
	
	always@(posedge clk or negedge rst)
		begin
			if(!rst) pc_reg <= 16'h3000;
			else pc_reg <= pc_input;			
		end
		

	
endmodule