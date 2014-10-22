module fetch_test;
	reg clk;
	reg rst;
	reg [3:0] state;
	wire [15:0] pc, npc;
	reg [15:0] taddr;
	reg br_taken;
	
	
	initial 
		begin
			clk = 0;
			
			#5 rst = 1'b0;
				state = 4'h8;
				br_taken = 0;
			#15 rst = 1'b1;
			#50 br_taken = 1'b1;
			    taddr = 16'h1234;
			#10 taddr = 16'h1235;
			#10 taddr = 16'h1236;
			#20 br_taken = 1'b0;
			#40 state = 4'h1;
			#40 state = 4'h5;
			#100 $finish;
		
		end
		
	always #5 clk = ~clk;
	fetch u1( .clk(clk), .rst(rst), .state(state), .pc(pc), .npc(npc), .rd(rd), .taddr(taddr), .br_taken(br_taken));
	
endmodule
