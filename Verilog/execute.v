// @positive edge, output signals are created for consuming blocks except for output SR1 and SR2 which is a function of input ir
module execute(
				input clk,
				input rst,
				input enable_execute,
				input [5:0] e_control,
				input [1:0] w_control_in,
				input mem_control_in,
				input bypass_alu_1,
				input bypass_alu_2,
				input bypass_mem_1,
				input bypass_mem_2,
				input [15:0] VSR1,
				input [15:0] VSR2,
				input [15:0] ir,
				input [15:0] npc_in,
				input [15:0] mem_bypass_val,
				output reg [1:0] w_control_out,
				output reg mem_control_out,
				output reg [15:0] aluout,	
				output reg [15:0] pcout,	
				output reg [2:0] dr,
				output [2:0] sr1,			// Asynchronously created
				output [2:0] sr2,			// Asynchronously created
				output [15:0] ir_exec,		
				output [2:0] nzp,			
				output [15:0] m_data
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
	parameter offset9 = 2'b01;
	parameter offset6 = 2'b10;
	parameter offset0 = 2'b11;
	
	wire [15:0] new_pc;
	wire [15:0] pc_adder_input1, pc_adder_input2;
	wire [15:0] aluin1, aluin2;
	wire [15:0] sxt_offset9, sxt_offset6;
	wire [1:0] alu_control, pcselect1;
	wire pcselect2, op2select;
	
	assign alu_control = e_control[5:4];
	assign pcselect1 = e_control[3:2];
	assign pcselect2 = e_control[1];
	assign op2select = e_control[0];
	assign aluin1 = VSR1;
	assign aluin2 = (op2select)? VSR2: ir[4:0];
	assign sxt_offset9 = {{7{ir[8]}},ir[8:0]};
	assign sxt_offset6 = {{10{ir[5]}},ir[5:0]};
	
	assign sr2 = ir[2:0];
	assign sr1 = ir[8:6];
	assign pc_adder_input2 = (pcselect2)? npc_in: VSR1;
	
	
	always@(posedge clk) begin
		if(!rst) begin
			dr <= 3'b000;
			w_control_out <= 2'b00;
			pcout <= 16'h0000;
			aluout <= 16'h0000;
		end
		else begin
			if(!enable_execute)begin
				dr <= dr;
				w_control_out <= w_control_out;
				pcout <= pcout;
				aluout <= aluout;
				
			end
			else begin
				dr <= ir[11:9];
				w_control_out <= w_control_in;
				casex(pcselect1) 
					offset9: begin
								pcout <= sxt_offset9 + pc_adder_input2;
							 end
					offset6: begin
								pcout = sxt_offset6 + pc_adder_input2;
							 end
					offset0: begin
								pcout = 16'h0000 + pc_adder_input2;
							 end
					default: begin 						// update for offset11 situation
								pcout = 16'hxxxx + pc_adder_input2;
							 end			
				endcase
				casex(alu_control)
					2'b00: 	begin
								aluout <= aluin1+aluin2;
							end
					2'b01:  begin
								aluout <= aluin1 & aluin1;
							end
					2'b10: 	begin
								aluout <= ~aluin1;
							end
					default begin
								aluout <= aluout;
							end
				endcase
			end
			
		end
	end
endmodule
