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
	output reg 			mem_control
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
	reg [1:0] 	pcselect2;
	reg 		op2select;
	
	assign e_control = { alu_control, pcselect1, pcselect2, op2select};
	
	
	always@(posedge clk or negedge rst)
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
			else
				begin
					if( enable_decode == 1'h0)
						begin
							ir <= ir;
							npc_out <= npc_out;
							alu_control <= alu_control;
							pcselect1 <=pcselect1;
							pcselect2 <= pcselect2;
							op2select <= op2select;
							w_control <= w_control;
							mem_control <= mem_control;
						end
					else 
						begin
							ir <= instr_mem_dout;
							npc_out <= npc_in;	
							
							case(ir[15:12])
								BR:		w_control <= 2'b00;
								ADD:	w_control <= 2'b00;
								LD:		w_control <= 2'b01;
								ST: 	w_control <= 2'b00;
								AND:	w_control <= 2'b00;
								LDR: 	w_control <= 2'b01;
								STR: 	w_control <= 2'b00;
								NOT:	w_control <= 2'b00;
								LDI: 	w_control <= 2'b01;
								STI: 	w_control <= 2'b00;
								JMP:	w_control <= 2'b00;
								LEA: 	w_control <= 2'b10;
								default:	w_control <= 2'bxx;
							endcase
							case(ir[15:12])
								LD:	mem_control <= 1'b0;
								ST: 	mem_control <= 1'b0;
								LDR: 	mem_control <= 1'b0;
								STR: 	mem_control <= 1'b0;
								LDI: 	mem_control <= 1'b1;
								STI: 	mem_control <= 1'b1;
								default:	mem_control <= 1'bx;
							endcase
							
							case(ir[15:12])
								ADD:	alu_control <= 2'b00;
								AND:	alu_control <= 2'b01;
								NOT:	alu_control <= 2'b10;
								default:	alu_control <= 2'bxx;
							endcase
							
							case(ir[15:12])
								ADD:	begin
											op2select <= ir[5]? 1'b0:1'b1;
										end
								AND:	begin
											op2select <= ir[5]? 1'b0:1'b1;
										end
								default:    op2select <= 1'bx;		
							endcase
							
							case(ir[15:12])
								BR:	pcselect1 <= 2'b01;
								LD:	pcselect1 <= 2'b01;
								ST: 	pcselect1 <= 2'b01;
								LDR: 	pcselect1 <= 2'b10;
								STR: 	pcselect1 <= 2'b10;
								LDI: 	pcselect1 <= 2'b01;
								STI: 	pcselect1 <= 2'b01;
								JMP:	pcselect1 <= 2'b11;
								LEA: 	pcselect1 <= 2'b01;
								default:	pcselect1 <= 2'bxx;
							endcase
							
							case(ir[15:12])
								BR:	pcselect2 <= 1'b1;
								LD:	pcselect2 <= 1'b1;
								ST: 	pcselect2 <= 1'b1;
								LDR: 	pcselect2 <= 1'b0;
								STR: 	pcselect2 <= 1'b0;
								LDI: 	pcselect2 <= 1'b1;
								STI: 	pcselect2 <= 1'b1;
								JMP:	pcselect2 <= 1'b0;
								LEA: 	pcselect2 <= 1'b1;
								default:	pcselect2 <= 1'bx;
							endcase
						end
				end
		end
		

endmodule