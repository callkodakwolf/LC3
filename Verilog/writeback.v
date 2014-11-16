// @ 
module writeback(
					input clk,
					input rst,
					input [15:0] aluout,
					input [1:0] w_control,
					input [15:0] pcout,
					input [15:0] memout,
					input enable_writeback,
					input [2:0] sr1,sr2,
					input [2:0] dr,
					output [15:0] VSR1, VSR2,
					output [2:0] psr
				);
				
	wire [15:0] dr_in;	 // output from 3 to 1 mux for dest Reg Data path
	wire [7:0]  Asy_reg_select;	// For 3 to 8 decoder to select regs
	wire [15:0] r0_out,r1_out,r2_out,r3_out,r4_out,r5_out,r6_out,r7_out;
	
	Mux_3_16 		Des_reg_data_mux(	
									.Mux_input_16_0(aluout), 
									.Mux_input_16_1(memout),
									.Mux_input_16_3(pcout),
									.select(w_control),
									.Mux_out_16(dr_in)
									);

	Decoder_3_to_8 	Asy_reg_select_decoder(	
											.code(dr),
											.data(Asy_reg_select)
											);
	
	Mux_8_16	Mux_vsr1(	.select(sr1),
							.input_16_0(r0_out),
							.input_16_1(r1_out),
							.input_16_2(r2_out),
							.input_16_3(r3_out),
							.input_16_4(r4_out),
							.input_16_5(r5_out),
							.input_16_6(r6_out),
							.input_16_7(r7_out),
							.output_16(VSR1)
						);
	Mux_8_16	Mux_vsr2(	.select(sr2),
							.input_16_0(r0_out),
							.input_16_1(r1_out),
							.input_16_2(r2_out),
							.input_16_3(r3_out),
							.input_16_4(r4_out),
							.input_16_5(r5_out),
							.input_16_6(r6_out),
							.input_16_7(r7_out),
							.output_16(VSR2)
						);
										
	Asyn_reg_16 r0(.clk(Asy_reg_select[0]),.rst(rst),.enable(enable_writeback),.data_in_16(dr_in),.data_out_16(r0_out) );
	Asyn_reg_16 r1(.clk(Asy_reg_select[1]),.rst(rst),.enable(enable_writeback),.data_in_16(dr_in),.data_out_16(r1_out) );
	Asyn_reg_16 r2(.clk(Asy_reg_select[2]),.rst(rst),.enable(enable_writeback),.data_in_16(dr_in),.data_out_16(r2_out) );
	Asyn_reg_16 r3(.clk(Asy_reg_select[3]),.rst(rst),.enable(enable_writeback),.data_in_16(dr_in),.data_out_16(r3_out) );
	Asyn_reg_16 r4(.clk(Asy_reg_select[4]),.rst(rst),.enable(enable_writeback),.data_in_16(dr_in),.data_out_16(r4_out) );
	Asyn_reg_16 r5(.clk(Asy_reg_select[5]),.rst(rst),.enable(enable_writeback),.data_in_16(dr_in),.data_out_16(r5_out) );
	Asyn_reg_16 r6(.clk(Asy_reg_select[6]),.rst(rst),.enable(enable_writeback),.data_in_16(dr_in),.data_out_16(r6_out) );
	Asyn_reg_16 r7(.clk(Asy_reg_select[7]),.rst(rst),.enable(enable_writeback),.data_in_16(dr_in),.data_out_16(r7_out) );
	
	PSR_NZP_Reg NZP_Reg(
						.clk(clk),
						.rst(rst),
						.enable(enable_writeback),
						.Exec_stage_result(dr_in),
						.psr(psr)
						);
	
	
endmodule
		