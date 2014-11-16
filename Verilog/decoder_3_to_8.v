

module Decoder_3_to_8(
						input [2:0] code,
						output [7:0] data
						);

	reg [7:0] data_reg;
	assign data = data_reg;
	always@(code) begin
		case(code)
			3'h0:	data_reg = 8'b00000001;				
			3'h1:	data_reg = 8'b00000010;	
			3'h2:	data_reg = 8'b00000100;		
			3'h3:   data_reg = 8'b00001000;		
			3'h4:   data_reg = 8'b00010000;		
			3'h5:   data_reg = 8'b00100000;		
			3'h6:   data_reg = 8'b01000000;		
			3'h7:   data_reg = 8'b10000000;	
			default:	data_reg = 8'hxx;
		endcase
	end
endmodule