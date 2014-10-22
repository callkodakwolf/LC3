
module LC3_top(clk, rst, rd, addr, din ,dout, complete);
	input clk;
	input rst;
	output rd;
	output complete;
	output [15:0] addr,din,dout;
	
	
	wire [3:0] state_wire;
	wire [5:0] C_Control_wire;
	
	
	fetch stage_fetch(.clk(clk), .rst(rst), .state(), .pc(), .npc() , .rd(), .taddr(), .br_taken() );
	
	controller u_controller(.clk(clk), .rst(rst), .state(state_wire), .C_Control(C_Control_wire), .complete(complete));
	
endmodule 