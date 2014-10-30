module scoreboard(lc3_if.scoreboard if_sb);

	
	logic [1:0] w_control_predict;
	logic mem_control_predict;
	logic [5:0] e_control_predict;
	logic [15:0] npc_out_predict;
	logic [15:0] ir_predict;	

	covergroup decode_stage;
//		coverpoint if_sb.cb_score.instr_mem_dout[15:12]{
		Intru_type:coverpoint if_sb.instr_mem_dout[15:12]{
			bins add = 	{ ADD };
			bins jmp = 	{ JMP };
			bins br =  	{ BR };
			bins And = 	{ AND };
			bins Not = 	{	NOT };
			bins ld = {	LD };
			bins ldr  = {LDR};
			bins ldi  = {LDI};
			bins lea  = {LEA};
			bins st  = {ST};
			bins str  = {STR};
			bins sti  = {STI};	
			bins dont_care = {4'b0100, 4'b1000, 4'b1101, 4'b1111};
		}
		
		Intru_type_specify: coverpoint {if_sb.instr_mem_dout[15:12], if_sb.instr_mem_dout[5]}{
			bins add_0 = { {ADD, 1'b0}};
			bins add_1 = { {ADD, 1'b1}};
			bins and_0 = { {AND, 1'b0}};
			bins and_1 = { {AND, 1'b1}};
						
		}
		
		E_control : coverpoint if_sb.e_control {
			bins add_0 = { 6'b00xxx1};
			bins add_1 = { 6'b00xxx0};
			bins and_0 = { 6'b01xxx1};
			bins and_1 = { 6'b01xxx0};
			bins NOT = { 6'b10xxxx };
			bins BR = { 6'bxx011x };
			bins JMP = { 6'bxx110x};
			bins LD = { 6'bxx011x };
			bins LDR  = { 6'bxx100x };
			bins LDI  = { 6'bxx011x };
			bins LEA  = { 6'bxx011x };
			bins ST = { 6'bxx011x };
			bins STR  = { 6'bxx100x };
			bins STI  = { 6'bxx011x };
			
		}
		
		
		
//		coverpoint if_sb.cb_score.enable_decode;
		enable_status:coverpoint if_sb.enable_decode;
	endgroup : decode_stage
	
	decode_stage instr_cov;
	
	initial begin : coverage
		instr_cov = new();
		
		forever begin
			@(negedge if_sb.clk);
			instr_cov.sample();
			
		end
	end : coverage
		
	always@(posedge if_sb.clk) begin
		
		
		if(!if_sb.rst) begin
			ir_predict <= 16'h0;
			npc_out_predict <= 16'h0;
			e_control_predict <= 6'h0;
			mem_control_predict <= 1'b0;
			w_control_predict <= 2'b00;			
		end
		else begin
//			if(if_sb.cb_score.enable_decode == 1'b1) begin
//				
//				ir_predict = if_sb.cb_score.instr_mem_dout;
//				npc_out_predict = if_sb.cb_score.npc_in;
			if(if_sb.enable_decode == 1'b1) begin
				
				ir_predict = if_sb.instr_mem_dout;
				npc_out_predict = if_sb.npc_in;
				
				//应该使用模块的输入计算响应
	
//				casex(if_sb.cb_score.instr_mem_dout[15:12])
				casex(if_sb.instr_mem_dout[15:12])
								BR:		begin 
											w_control_predict = 2'b00;
											e_control_predict = 6'bxx011x;
											mem_control_predict = 1'bx;
										end
								ADD:	begin 
											w_control_predict = 2'b00;
//											if( if_sb.cb_score.instr_mem_dout[5] ==1'b0)
											if( if_sb.instr_mem_dout[5] ==1'b0)
												e_control_predict = 6'b00xxx1;
											else 
												e_control_predict = 6'b00xxx0;
											mem_control_predict = 1'bx;
											//$display("@0dns",$time);
										end
								LD:		begin 
											w_control_predict = 2'b01;
											e_control_predict = 6'bxx011x;
											mem_control_predict = 1'b0;
										end
								ST: 	begin 
											w_control_predict = 2'b00;
											e_control_predict = 6'bxx011x;
											mem_control_predict = 1'b0;
										end
								AND:	begin 
											w_control_predict = 2'b00;	
//											if( if_sb.cb_score.instr_mem_dout[5] ==1'b0)
											if( if_sb.instr_mem_dout[5] ==1'b0)
												e_control_predict = 6'b01xxx1;
											else 
												e_control_predict = 6'b01xxx0;
											mem_control_predict = 1'bx;
										end
								LDR: 	begin 
											w_control_predict = 2'b01;
											e_control_predict = 6'bxx100x;
											mem_control_predict = 1'b0;
										end
								STR: 	begin 
											w_control_predict = 2'b00;
											e_control_predict = 6'bxx100x;
											mem_control_predict = 1'b0;
										end
								NOT:	begin  
											w_control_predict = 2'b00;
											e_control_predict = 6'b10xxxx;
											mem_control_predict = 1'bx;
										end
								LDI: 	begin  
											w_control_predict = 2'b01;
											e_control_predict = 6'bxx011x;
											mem_control_predict = 1'b1;
										end
								STI: 	begin  
											w_control_predict = 2'b00;
											e_control_predict = 6'bxx011x;
											mem_control_predict = 1'b1;
										end
								JMP:	begin  
											w_control_predict = 2'b00;
											e_control_predict = 6'bxx110x;
											mem_control_predict = 1'bx;
										end
								LEA: 	begin  
											w_control_predict = 2'b10;
											e_control_predict = 6'bxx011x;
											mem_control_predict = 1'bx;
										end
								default:	begin 
												w_control_predict = 2'bxx;
												e_control_predict = 6'bxxxxxx;
												mem_control_predict = 1'bx;
											end
								
				endcase
			end
			
		end
		
		
		@(negedge if_sb.clk)
		assert(w_control_predict === if_sb.w_control)
			else $error("$w_control is %h while w_control_predict is %h", if_sb.w_control, w_control_predict);
		assert(e_control_predict === if_sb.e_control)
			else $error("$e_control wrong");
		assert(mem_control_predict === if_sb.mem_control)
			else $error("$mem_control wrong");
		assert(ir_predict === if_sb.ir)
			else $error("ir wrong");
		assert(npc_out_predict === if_sb.npc_out) 
			else $error("npc_out wrong");
			
		
	end
endmodule