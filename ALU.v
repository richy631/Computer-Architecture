`timescale 1ns/1ps

module ALU(
           rst_n_i,         // negative reset            (input)
           src1_i,          // 32 bits source 1          (input)
           src2_i,          // 32 bits source 2          (input)
           ALU_control_i,   // 4 bits ALU control input  (input)
           result_o,        // 32 bits result            (output)
           zero_o          // 1 bit when the output is 0, zero must be set (output)
           );


input           rst_n_i;
input  [32-1:0] src1_i;
input  [32-1:0] src2_i;
input   [4-1:0] ALU_control_i;

output [32-1:0] result_o;
output          zero_o;



wire    [32-1:0] result_o;
wire             zero_o;
wire				  set_less;
wire    [32-1:0] inter_cout;
wire             ii_cin;
wire	signed  [32-1:0] slt_used;

//Parameter ALU control
parameter ADD=4'b0000; 
parameter SUB=4'b0110; 
parameter AND=4'b0010;
parameter OR= 4'b0001; 
parameter SLT=4'b0111; 

parameter 	MUL	= 4'b1000;
parameter 	LW		= 4'b1001; 
parameter	SW		= 4'b1010;
parameter 	LUI	= 4'b1011;

assign slt_used =  src1_i - src2_i;
assign ii_cin = (ALU_control_i==4'b0110 || ALU_control_i==4'b0111)? 1'b1 : 1'b0;
assign result_o = ( ALU_control_i== ADD )? src1_i & src2_i:
							( ALU_control_i== OR )? src1_i | src2_i:
								( ALU_control_i== AND )? src1_i + src2_i:
									( ALU_control_i== SUB )? src1_i - src2_i:
										( ALU_control_i== SLT )? ( slt_used[31] == 1'b1)? 1:0:
											( ALU_control_i== MUL )? src1_i * src2_i:
												( ALU_control_i== LW )? src1_i + {16'd0 , src2_i[15:0]}:
													( ALU_control_i== SW )?src1_i + {16'd0 , src2_i[15:0]}: 32'd0;
assign zero_o = ( result_o == 32'd0)? 1: 0;
		
endmodule
