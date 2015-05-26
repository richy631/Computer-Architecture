//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
		instr_op_i,//instruction opcode
		RegWrite_o,
		ALU_op_o,
		ALUSrc_o,
		RegDst_o,
		Branch_o,
		Jump_o,
		MemRead_o,
		MemWrite_o,
		MemtoReg_o
		);
     
//I/O ports
input  [6-1:0] instr_op_i;
output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output 			Jump_o;
output			MemRead_o;
output			MemWrite_o;
output 			MemtoReg_o ;



//Parameter of OPCODE (input)
parameter op_Rtype = 6'd0;
parameter op_JUMP = 6'd2;
parameter op_BEQ = 6'd4;
parameter op_ADDI = 6'd8;
parameter op_SLTI = 6'd10;
parameter op_LOAD = 6'd35;
parameter op_STORE = 6'd43;

//Parameter of ALU_Op (output)
parameter ADDI = 3'b 000;
parameter BEQ = 3'b 001;
parameter R_TYPE = 3'b 010;
parameter SLTI = 3'b 011;
parameter LOAD = 3'b 100;
parameter STORE = 3'b 101;
parameter NOFUN = 3'b 111;



//Main function
assign ALU_op_o = ( instr_op_i == op_Rtype )?R_TYPE:  
							( instr_op_i == op_ADDI )? ADDI:
								( instr_op_i == op_BEQ )? BEQ:
									( instr_op_i == op_SLTI )? SLTI: 
										( instr_op_i == op_LOAD )? LOAD:
											( instr_op_i == op_STORE )? STORE:	NOFUN;
assign ALUSrc_o = ( instr_op_i == op_ADDI || instr_op_i == op_SLTI || instr_op_i == op_LOAD || instr_op_i == op_STORE)? 1: 0;
assign RegDst_o = ( instr_op_i == op_Rtype )? 1: 0;
assign Branch_o = ( instr_op_i == op_BEQ )? 1: 0;
assign RegWrite_o = ( instr_op_i == op_BEQ || instr_op_i == op_JUMP || instr_op_i == op_STORE)? 0: 1;



//=====================================//
//--------------Lab3-------------------//
//=====================================//

assign Jump_o = ( instr_op_i == op_JUMP )? 1: 0;
assign MemRead_o = ( instr_op_i == op_LOAD )? 1: 0;
assign MemWrite_o = ( instr_op_i == op_STORE )? 1: 0;
assign MemtoReg_o = ( instr_op_i == op_LOAD )? 1: 0;


endmodule        