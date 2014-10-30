// @positive clk edge, output signals are created for consuming blocks
module decode( 					
	input 			clk,
	input 			rst,
	input [15:0] 	npc_in,
	input 			enable_decode,
	input [15:0]	instr_mem_dout,
	input [2:0]			psr,
	output reg [15:0] 	ir,
	output wire [5:0] 	e_control,
	output reg [1:0] 	w_control,
	output reg [15:0] 	npc_out,
	output reg 		mem_control
	);

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
	
	reg [1:0] 	alu_control;
	reg [1:0] 	pcselect1;
	reg 	 	pcselect2;
	reg 		op2select;
	
	assign e_control = { alu_control, pcselect1, pcselect2, op2select};
	
	
	always@(posedge clk)
		begin
			if(!rst) 
				begin
					ir <= 16'h0;
					npc_out <= 16'h0;
					alu_control <= 2'h0;
					pcselect1 <=2'h0;
					pcselect2 <=2'h0;
					op2select <=1'h0;
					w_control <= 2'h0;
					mem_control <= 1'h0;
					
				end
			else begin
				if(enable_decode == 1'b0) begin
					ir <= ir;
					npc_out <= npc_out;
					alu_control <= alu_control;
					pcselect1 <=pcselect1;
					pcselect2 <= pcselect2;
					op2select <= op2select;
					w_control <= w_control;
					mem_control <= mem_control;
				end
				else begin
					ir <= instr_mem_dout;
					npc_out <= npc_in;	
						
					casex(instr_mem_dout[15:12])
						BR:		begin 
									w_control <= 2'b00;
									pcselect1 <= 2'b01;
									pcselect2 <= 1'b1;
									mem_control <=  1'bx;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						ADD:	begin 
									w_control <= 2'b00;
									alu_control <= 2'b00;
									op2select <= instr_mem_dout[5]? 1'b0:1'b1;
									mem_control <=  1'bx;
									pcselect1 <= 2'bxx;
									pcselect2 <= 1'bx;
								end
						LD:		begin
									w_control <= 2'b01;
									mem_control <= 1'b0;
									pcselect1 <= 2'b01;
									pcselect2 <= 1'b1;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						ST: 	begin 
									w_control <= 2'b00;
									mem_control <= 1'b0;
									pcselect1 <= 2'b01;
									pcselect2 <= 1'b1;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						AND:	begin
									w_control <= 2'b00;
									alu_control <= 2'b01;
									op2select <= instr_mem_dout[5]? 1'b0:1'b1;
									mem_control <=  1'bx;
									pcselect1 <= 2'bxx;
									pcselect2 <= 1'bx;
								end
						LDR: 	begin
									w_control <= 2'b01;
									mem_control <= 1'b0;
									pcselect1 <= 2'b10;
									pcselect2 <= 1'b0;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						STR: 	begin
									w_control <= 2'b00;
									mem_control <= 1'b0;
									pcselect2 <= 1'b0;
									pcselect1 <= 2'b10;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						NOT:	begin
									w_control <= 2'b00;
									alu_control <= 2'b10;
									mem_control <=  1'bx;
									pcselect1 <= 2'bxx;
									pcselect2 <= 1'bx;
									op2select <= 1'bx;
								end									
						LDI: 	begin
									w_control <=  2'b01;
									mem_control <= 1'b1;
									pcselect1 <= 2'b01;
									pcselect2 <= 1'b1;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						STI: 	begin
									w_control <=  2'b00;
									mem_control <= 1'b1;
									pcselect1 <= 2'b01;
									pcselect2 <= 1'b1;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						JMP:	begin
									w_control <= 2'b00;
									pcselect1 <= 2'b11;
									pcselect2 <= 1'b0;
									mem_control <=  1'bx;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						LEA: 	begin
									w_control <= 2'b10;
									pcselect1 <= 2'b01;
									pcselect2 <= 1'b1;
									mem_control <=  1'bx;
									alu_control <= 2'bxx;
									op2select <= 1'bx;
								end
						default:	begin
										w_control <= 2'bxx;
										mem_control <= 1'bx;
										alu_control <= 2'bxx;
										op2select <= 1'bx;	
										pcselect1 <= 2'bxx;
										pcselect2 <= 1'bx;
									end	
					endcase
									
				end
			end
		end
		

endmodule