
module Asyn_reg_16(
					input clk,
					input rst,
					input enable,
					input [15:0] data_in_16,
					output reg [15:0] data_out_16
					);
					
	always@( posedge clk) begin
		if(!rst)
			data_out_16 = 16'h0000;
		else begin
			if( !enable) begin
				data_out_16 = data_out_16;
			end
			else begin
				data_out_16 = data_in_16;
			end
		end
	
	
	end
endmodule