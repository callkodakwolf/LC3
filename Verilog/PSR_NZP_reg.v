module PSR_NZP_Reg(
					input clk,
					input rst,
					input enable,
					input [15:0] Exec_stage_result,
					output reg [2:0] psr
					);
					
		always@(posedge clk) begin
		if(!rst) begin
			psr <= 3'b000;
		end
		else begin
			if( !enable ) begin
				psr <= psr;
			end
			else begin
				casex( Exec_stage_result)
					16'b0000000000000000:
						begin 
							psr <= 3'b010;
						end
					16'b1xxxxxxxxxxxxxxx:
						begin
							psr <= 3'b100;
						end
					16'b0xxxxxxxxxxxxxxx:
						begin
							psr <= 3'b001;
						end	
					default:
						begin
							psr <= 3'bxxx;
						end
				endcase
			end
		end
	end
endmodule