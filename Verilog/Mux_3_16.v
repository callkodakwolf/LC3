// This module is a 3 to 1 mux
// Width: 16 bits
// Select signal: 2 bits

module Mux_3_16(
						input [15:0] Mux_input_16_0,
						input [15:0] Mux_input_16_1,
						input [15:0] Mux_input_16_2,
						input [1:0] select,
						output [15:0] Mux_out_16);
	
	reg [15:0] Mux_out;
	
	assign Mux_out_16 = Mux_out;
	
	always@(select or Mux_input_16_0 or Mux_input_16_1 or Mux_input_16_2) begin
		
		casex(select)
			2'b00:	begin
						Mux_out = Mux_input_16_0;
					end
			2'b01: 	begin 
						Mux_out = Mux_input_16_1;
					end
			2'b10:	begin
						Mux_out = Mux_input_16_2;
					end
			default:	begin
							Mux_out = 16'hxxxx;
						end
						
		endcase
	end
	
endmodule
						