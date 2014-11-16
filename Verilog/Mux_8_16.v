
module Mux_8_16( 
				input [2:0] select,
				input [15:0] input_16_0,
				input [15:0] input_16_1,
				input [15:0] input_16_2,
				input [15:0] input_16_3,
				input [15:0] input_16_4,
				input [15:0] input_16_5,
				input [15:0] input_16_6,
				input [15:0] input_16_7,
				output [15:0] output_16
				);
	reg [15:0] output_16_reg;
	assign output_16 = output_16_reg;
	
	always@(*) begin
		casex(select)
			3'h0: 	output_16_reg = input_16_0;
			3'h1:	output_16_reg = input_16_1;
			3'h2:	output_16_reg = input_16_2;
			3'h3:	output_16_reg = input_16_3;
			3'h4:	output_16_reg = input_16_4;
			3'h5:	output_16_reg = input_16_5;
			3'h6:	output_16_reg = input_16_6;
			3'h7:	output_16_reg = input_16_7;
		endcase
	end
	
endmodule