	
module memory_access(
						input clk,
						input rst,
						input [15:0] m_data,
						input [15:0] m_addr,
						input m_control,
						input [1:0] mem_state,
						input [15:0] dmem_dout,
						output reg [15:0] dmem_addr,
						output reg [15:0] dmem_din,
						output reg dmem_rd,
						output [15:0] memout
					);
	
	parameter mem_read = 1'b1;
	parameter mem_write = 1'b0;
	
	assign memout = dmem_din;
	
	always@(posedge clk) begin
		if(!rst) begin
			dmem_addr = 16'h0000;
			dmem_din = 16'h0000;
			dmem_rd = mem_read;			
		end
		else begin
			
		end
	
	end