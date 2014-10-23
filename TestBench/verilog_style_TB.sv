module TestBech_Top;
	
	bit clk;
	wire rst;
	wire br_taken;
//	bit	rd;
	wire enable_updatepc;
	wire enable_fetch;
	wire [15:0] pc;
	wire [15:0] npc;
	logic [15:0] taddr;
//	shortint unsighed pc;
//	shortint unsigned npc;
	logic [15:0] previous_npc;
	logic [15:0] predicted_pc;
	logic [15:0] predicted_npc;
	logic predicted_rd;
	wire rd;
	bit [3:0] control;
	
	assign rst = control[3];
	assign br_taken = control[2];
	assign enable_updatepc = control[1];
	assign enable_fetch = control[0];
	
	
	covergroup control_bundle;
		coverpoint control {
			bins reset = { [4'h8: $] };
			bins branch = { [4'h4: 4'h7]};
			bins updatepc = {4'h2,4'h3,4'h6,4'h7};
		}
	endgroup
	
	control_bundle ctl_cov;
	
	initial begin : coverage
		ctl_cov = new();
		
		forever begin
			@(negedge clk);
			ctl_cov.sample();
		end
	end : coverage
	
	initial begin 
		clk = 0;
		forever begin 
			#10;
			clk = ~clk;
		end
	end
	
	always@(negedge clk) begin : scoreboard

		
		casex ( control )
			4'b1x00:begin
						predicted_pc = 16'hz;
						predicted_npc = previous_npc;
						predicted_rd = 1'bz;
					end
			4'b1x01:begin
						predicted_pc = previous_npc-16'h1;
						predicted_npc = previous_npc;
						predicted_rd = 1'b1;
					end
			4'b1110:begin
						predicted_pc = 16'hz;
						predicted_npc = taddr+1'b1;
						predicted_rd = 1'bz;
					end
			4'b1011:begin
						predicted_pc = previous_npc;
						predicted_npc = previous_npc+16'h1;
						predicted_rd = 1'b1;
					end
			4'b1111:begin
						predicted_pc = taddr;
						predicted_npc = taddr+16'h1;
						predicted_rd = 1'b1;
					end
			4'b1010:begin
						predicted_pc = 16'hzzzz;
						predicted_npc = previous_npc+16'h1;
						predicted_rd = 1'bz;
					end		
			4'b0xx1:begin
						predicted_pc = 16'h3000;
						predicted_npc = 16'h3001;
						predicted_rd = 1'b1;
					end
			4'b0xx0:begin
						predicted_pc = 16'hzzzz;
						predicted_npc = 16'h3001;
						predicted_rd = 1'bz;
					end
		endcase
		
		if(( predicted_pc != pc)||(predicted_npc != npc)||( predicted_rd != rd))
			$error ( " Failed: pc: %0h predicted_pc: %0h      npc: 0%h  predicted_npc: 0%h    rd: 0%h   predicted_rd: 0%h", pc, predicted_pc, npc, predicted_npc, rd, predicted_rd);
//		else $display( "match");
		
		
		
	end : scoreboard	

	initial begin : tester
		control[3] = 1'b0;
		@(negedge clk);
		@(negedge clk);
		control[3] = 1'b1;
		repeat (100) begin
			@(posedge clk);
			#15;
			control[2:0] = $random;
			control[3] = 1'b1;
			taddr = $random;
			previous_npc = predicted_npc;
		end
		$stop;
	end:tester
	
	fetch DUT(.clk, .rst, .enable_updatepc, .enable_fetch, .pc, .npc, .rd, .taddr, .br_taken);
endmodule : TestBech_Top