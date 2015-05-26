module Pipe_IF_ID(
	rst_i,
	clk_i,
	instr_i,
	pc_i,
	instr_o,
	pc_o
);

input rst_i;
input clk_i;
input [32-1:0] instr_i;
input [32-1:0] pc_i;
output reg[32-1:0] instr_o;
output reg [32-1:0] pc_o;

always @(posedge clk_i or negedge  rst_i) begin
	if(rst_i == 0) begin
		instr_o <= 0;
		pc_o <= 0;
	end
	else begin
		instr_o <= instr_i;
		pc_o <= pc_i;
	end
end

endmodule	