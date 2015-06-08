module Pipe_ID_EX(
	rst_i,
	clk_i,
	WB_RegWrite_i,	WB_RegWrite_o,
	WB_MemtoReg_i,	WB_MemtoReg_o,
	M_branch_i,		M_branch_o,
	M_MemRead_i,	M_MemRead_o,
	M_MemWrite_i,	M_MemWrite_o,
	EX_ALUop_i,		EX_ALUop_o,
	EX_ALUSrc_i,	EX_ALUSrc_o,
	EX_RegDst_i,	EX_RegDst_o,
	pc_i,				pc_o,
	RSdata_i,		RSdata_o,
	RTdata_i,		RTdata_o,
	Sign_i,			Sign_o,
	instr20_16_i,	instr20_16_o,
	instr15_11_i,	instr15_11_o
);
	input rst_i;
	input clk_i;		  
	input WB_RegWrite_i;
	input WB_MemtoReg_i;
	input M_branch_i;
	input M_MemRead_i;
	input M_MemWrite_i;
	input [3-1:0] EX_ALUop_i;
	input EX_ALUSrc_i;
	input EX_RegDst_i;
	input [32-1:0] RSdata_i;
	input [32-1:0] RTdata_i;
	input [32-1:0] Sign_i;
	input [32-1:0] pc_i;
	input [5-1:0] instr20_16_i;
	input [5-1:0]instr15_11_i;

	output reg WB_RegWrite_o;
	output reg WB_MemtoReg_o;
	output reg M_branch_o;
	output reg M_MemRead_o;
	output reg M_MemWrite_o;
	output reg [3-1:0] EX_ALUop_o;
	output reg EX_ALUSrc_o;
	output reg EX_RegDst_o;
	output reg [32-1:0] RSdata_o;
	output reg [32-1:0] RTdata_o;
	output reg [32-1:0] Sign_o;
	output reg [32-1:0] pc_o;
	output reg [5-1:0] instr20_16_o;
	output reg [5-1:0] instr15_11_o;
		  
	always @(posedge clk_i or negedge  rst_i) begin
		if( rst_i == 0)begin
			WB_RegWrite_o <= 0;
			WB_MemtoReg_o <= 0;
			M_branch_o <= 0;
			M_MemRead_o <= 0;
			M_MemWrite_o <= 0;
			EX_ALUop_o <= 0;
			EX_ALUSrc_o <= 0;
			EX_RegDst_o <= 0;
			RSdata_o <= 0;
			RTdata_o <= 0;
			Sign_o <= 0;
			pc_o <= 0;
			instr20_16_o <= 0;
			instr15_11_o <= 0;
			
		end
		else begin
			WB_RegWrite_o <= WB_RegWrite_i;
			WB_MemtoReg_o <= WB_MemtoReg_i;
			M_branch_o <= M_branch_i;
			M_MemRead_o <= M_MemRead_i;
			M_MemWrite_o <= M_MemWrite_i;
			EX_ALUop_o <= EX_ALUop_i;
			EX_ALUSrc_o <= EX_ALUSrc_i;
			EX_RegDst_o <= EX_RegDst_i;
			RSdata_o <= RSdata_i;
			RTdata_o <= RTdata_i;
			Sign_o <= Sign_i;
			pc_o <= pc_i;
			instr20_16_o <= instr20_16_i;
			instr15_11_o <= instr15_11_i;
		end
	end
endmodule	