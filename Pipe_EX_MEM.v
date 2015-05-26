module Pipe_EX_MEM(
	rst_i,
	clk_i,
	WB_RegWrite_i,	WB_RegWrite_o,
	WB_MemtoReg_i,	WB_MemtoReg_o,
	M_branch_i,		M_branch_o,
	M_MemRead_i,	M_MemRead_o,
	M_MemWrite_i,	M_MemWrite_o,
	Adder2_i,		Adder2_o,
	zero_i,			zero_o,
	ALU_result_i,	ALU_result_o,
	Write_data_i,	Write_data_o,
	MUX2_i,			MUX2_o,
	
);
	input rst_i;
	input clk_i;		  
	input WB_RegWrite_i;
	input WB_MemtoReg_i;
	input M_branch_i;
	input M_MemRead_i;
	input M_MemWrite_i;
	input [32-1:0] Adder2_i;
	input zero_i;
	input [32-1:0] ALU_result_i;
	input [32-1:0] Write_data_i;
	input [5-1:0] MUX2_i;

	output reg WB_RegWrite_o;
	output reg WB_MemtoReg_o;
	output reg M_branch_o;
	output reg M_MemRead_o;
	output reg M_MemWrite_o;
	output reg [32-1:0] Adder2_o;
	output reg zero_o;
	output reg [32-1:0] ALU_result_o;
	output reg [32-1:0] Write_data_o;
	output reg [5-1:0] MUX2_o;



	always @(posedge clk_i or negedge  rst_i) begin
		if(rst_i == 0) begin
			WB_RegWrite_o <= 0;
			WB_MemtoReg_o <= 0;
			M_branch_o <= 0;
			M_MemRead_o <= 0;
			M_MemWrite_o <= 0;
			Adder2_o <= 0;
			zero_o <= 0;
			ALU_result_o <= 0;
			Write_data_o <= 0;
			MUX2_o <= 0;
		end
		else begin
			WB_RegWrite_o <= WB_RegWrite_i;
			WB_MemtoReg_o <= WB_MemtoReg_i;
			M_branch_o <= M_branch_i;
			M_MemRead_o <= M_MemRead_i;
			M_MemWrite_o <= M_MemWrite_i;
			Adder2_o <= Adder2_i;
			zero_o <= zero_i;
			ALU_result_o <= ALU_result_i;
			Write_data_o <= Write_data_i;
			MUX2_o <= MUX2_i;
		end
	end

endmodule
