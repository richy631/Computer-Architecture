module Pipe_MEM_WB(
	rst_i,
	clk_i,
	WB_RegWrite_i,	WB_RegWrite_o,
	WB_MemtoReg_i,	WB_MemtoReg_o,
	DM_i,				DM_o,
	ALU_result_i,	ALU_result_o,
	MUX2_i,			MUX2_o
);
	input rst_i;
	input clk_i;
	input WB_RegWrite_i;
	input WB_MemtoReg_i;
	input [32-1:0] DM_i;
	input [32-1:0] ALU_result_i;
	input [5-1:0] MUX2_i;

	output reg WB_RegWrite_o;
	output reg WB_MemtoReg_o;
	output reg [32-1:0] DM_o;
	output reg [32-1:0] ALU_result_o;
	output reg [5-1:0] MUX2_o;

	always @(posedge clk_i or negedge  rst_i) begin
		if(rst_i == 0) begin
			WB_RegWrite_o <= 0;
			WB_MemtoReg_o <= 0;
			DM_o <= 0;
			ALU_result_o <= 0;
			MUX2_o <= 0;
		end
		else begin
			WB_RegWrite_o <= WB_RegWrite_i;
			WB_MemtoReg_o <= WB_MemtoReg_i;
			DM_o <= DM_i;
			ALU_result_o <= ALU_result_i;
			MUX2_o <= MUX2_i;
		end
	end

endmodule
