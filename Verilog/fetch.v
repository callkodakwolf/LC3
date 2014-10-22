
module fetch(clk, rst, state, pc, npc, rd, taddr, br_taken);
	input clk;
	input rst;
	input [3:0] state;
	output [15:0] pc, npc;
	input [15:0] taddr;	//target address of control instruction
	input br_taken;		
	output rd;			//Memory read control 
	
	reg [15:0] pc_reg;
	wire [15:0] pc_input, target_pc ;

/*`define*/ parameter Fetch=4'h0;
/*`define*/ parameter Decode= 4'h1;
/*`define*/ parameter ExecALU= 4'h2;
/*`define*/ parameter ExecNPC= 4'h3;
/*`define*/ parameter ExecMemAddr= 4'h4;
/*`define*/ parameter RMem= 4'h5;
/*`define*/ parameter IRMem= 4'h6;
/*`define*/ parameter WMem= 4'h7;
/*`define*/ parameter UpdatePC= 4'h8;
/*`define*/ parameter UpdateReg= 4'h9;
/*`define*/ parameter Invalid= 4'hA;


	assign npc = pc_reg +16'h0001;
	assign target_pc = (br_taken ==1) ? taddr : npc;
	assign pc_input = ( state == UpdatePC ) ? target_pc : pc_reg; 
	assign pc = ( state != RMem && state != WMem && state != IRMem) ? pc_reg : 16'hzzzz;
	assign rd = ( state != RMem && state != WMem && state != IRMem) ? 1'b1 : 1'bz;
	
	
	always@(posedge clk or negedge rst)
		begin
			if(!rst) pc_reg <= 16'h3000;
			else pc_reg <= pc_input;			
		end
		

	
endmodule