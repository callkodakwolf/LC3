// This module is a 2 to 1 mux
// Width: 16 bits
// Select signal: 1 bits

module Mux_4_16(
						input [15:0] Mux_input_16_0,
						input [15:0] Mux_input_16_1,
						input  select,
						output [15:0] Mux_out_16
				);
	
	reg [15:0] Mux_out;
	
	assign Mux_out_16 = Mux_out;
	
	always@(*) begin
		
		casex(select)
			1'b0:	begin
						Mux_out = Mux_input_16_0;
					end
			1'b1: 	begin 
						Mux_out = Mux_input_16_1;
					end

			default:	begin
							Mux_out = 16'hxxxx;
						end
						
		endcase
	end
	
endmodule
						