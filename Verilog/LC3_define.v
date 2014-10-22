
module globaldefine();
/*`define*/ parameter Fetch=4'h0;
/*`define*/ parameter Decode= 4'h1;
/*`define*/ parameter ExecALU= 4'h2;
/*`define*/ parameter ExecNPC= 4'h3;
/*`define*/ parameter ExecMemAddr= 4'h4;
/*`define*/ parameter RMem= 4'h5;
/*`define*/ parameter IRMem= 4'h6;
/*`define*/ parameter WMem= 4'h7;
/*`define*/ parameter UpdatePC= 4'h8;
/*`define*/ parameter UpdateReg= 4'h9;
/*`define*/ parameter Invalid= 4'hA;
endmodule