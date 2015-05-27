
module Pipe_CPU(
	clk_i,
	rst_n
);

/****************************************
*            I/O ports                  *
****************************************/
input clk_i;
input rst_n;

/****************************************
*          Internal signal              *
****************************************/

/**** IF stage ****/
wire [32-1:0] pc_in;
wire [32-1:0] pc_out;
wire [32-1:0] pc_sum;
wire [32-1:0] instr_o;
wire [32-1:0] IF_ID_instr_o;
wire [32-1:0] IF_ID_pc_o;
//control signal ...
wire PCSrc;

/**** ID stage ****/
//RF
wire [32-1:0]	RSdata;
wire [32-1:0]	RTdata;

//decoder
wire RegWrite;
wire [3-1:0] ALU_op;
wire [4-1:0] ALUSrc;
wire RegDst;
wire branch;
wire Jump;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire [32-1:0] Sign_o;


wire [32-1:0] ID_EX_pc_o;
wire [32-1:0] ID_EX_RSdata_o;
wire [32-1:0] ID_EX_RTdata_o;
wire [32-1:0] ID_EX_Sign_o;
wire [5-1:0] ID_EX_instr20_16_o;
wire [5-1:0] ID_EX_instr15_11_o;

//control signal ...
wire ID_EX_RegWrite_o;
wire [3-1:0] ID_EX_ALU_op_o;
wire [4-1:0] ID_EX_ALUSrc_o;
wire ID_EX_RegDst_o;
wire ID_EX_branch_o;
//wire ID_EX_Jump_o;
wire ID_EX_MemRead_o;
wire ID_EX_MemWrite_o;
wire ID_EX_MemtoReg_o;


/**** EX stage ****/
wire [4-1:0]	ALUctrl;
wire [32-1:0] MUX1_o;
wire [5-1:0] MUX2_o;
wire [32-1:0] ALU_result_o;
wire zero_o;
wire [32-1:0] Shift_o;
wire [32-1:0] Adder2_branch_o;


wire [32-1:0] EX_M_Adder2_branch_o;
wire EX_M_zero_o;
wire [32-1:0] EX_M_ALU_result_o;
wire [32-1:0] EX_M_RTdata_o;
wire [5-1:0] EX_M_MUX2_o;

//control signal ...
wire EX_M_WB_RegWrite_o;
wire EX_M_WB_MemtoReg_o;
wire EX_M_branch_o;
wire EX_M_MemRead_o;
wire EX_M_MemWrite_o;

/**** MEM stage ****/
wire [32-1:0] DM_o;
//control signal ...


/**** WB stage ****/
wire M_WB_RegWrite_o;
wire M_WB_MemtoReg_o;
wire [32-1:0] M_WB_DM_o;
wire [32-1:0] M_WB_ALU_result_o;
wire [5-1:0] M_WB_MUX2_o;
wire [32-1:0] MUXWB_o;
//control signal ...

/**** Data hazard ****/


//control signal ...

/****************************************
*       Instantiate modules             *
****************************************/
//Instantiate the components in IF stage
ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i(rst_n),
	.pc_in_i(pc_in),
	.pc_out_o(pc_out)
);

Adder Add_pc(
	.src1_i(32'd4),
	.src2_i(pc_out),
	.sum_o(pc_sum)
);

MUX_2to1 #(.size(32)) PCMUX(
	.data0_i(pc_sum),
	.data1_i(),
	.select_i(PCSrc),
	.data_o(pc_in)
);

Instr_Memory IM(
	.pc_addr_i(pc_sum),
	.instr_o(instr_o)
);
			

Pipe_IF_ID IF_ID(
	.rst_i(rst_n),
	.clk_i(clk_i),
	.instr_i(instr_o),	.instr_o(IF_ID_instr_o),
	.pc_i(pc_out),			.pc_o(IF_ID_pc_o)
);
		
//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),
	.rst_i(rst_n),
	.RSaddr_i(IF_ID_instr_o[25:21]),	//rs
	.RTaddr_i(IF_ID_instr_o[20:16]),	//rt
	.RDaddr_i(M_WB_MUX2_o),
	.RDdata_i(MUXWB_o),
	.RegWrite_i(RegWrite),
	.RSdata_o(RSdata),
	.RTdata_o(RTdata)
);

Decoder Control(
	.instr_op_i(IF_ID_instr_o[31:26]),//instruction opcode
	.RegWrite_o(RegWrite),
	.ALU_op_o(ALUop),
	.ALUSrc_o(ALUsrc),
	.RegDst_o(RegDst),
	.Branch_o(branch) ,
	.Jump_o(Jump),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.MemtoReg_o(MemtoReg)
);

Sign_Extend Sign_Extend(
	.data_i(IF_ID_instr_o[16-1:0]),
	.data_o(Sign_o)
);	

Pipe_ID_EX ID_EX(
	.rst_i(rst_n),
	.clk_i(clk_i),
	.WB_RegWrite_i(RegWrite),	.WB_RegWrite_o(ID_EX_WB_RegWrite_o),
	.WB_MemtoReg_i(MemtoReg),	.WB_MemtoReg_o(ID_EX_WB_MemtoReg_o),
	.M_branch_i(branch),			.M_branch_o(ID_EX_M_branch_o),
	.M_MemRead_i(MemRead),		.M_MemRead_o(ID_EX_M_MemRead_o),
	.M_MemWrite_i(MemWrite),	.M_MemWrite_o(ID_EX_M_MemWrite_o),
	.EX_ALUop_i(ALUop),			.EX_ALUop_o(ID_EX_ALUop_o),
	.EX_ALUsrc_i(ALUsrc),		.EX_ALUsrc_o(ID_EX_ALUsrc_o),
	.EX_RegDst_i(RegDst),		.EX_RegDst_o(ID_EX_RegDst_o),
	.pc_i(pc_sum),					.pc_o(ID_EX_pc_o),
	.RSdata_i(RSdata),			.RSdata_o(ID_EX_RSdata_o),
	.RTdata_i(RTdata),			.RTdata_o(ID_EX_RTdata_o),
	.Sign_i(Sign_o),				.Sign_o(ID_EX_Sign_o),
	.instr20_16_i(IF_ID_instr_o[20:16]),	.instr20_16_o(ID_EX_instr20_16_o),
	.instr15_11_i(IF_ID_instr_o[15:11]),	.instr15_11_o(ID_EX_instr15_11_o)
);
		
//Instantiate the components in EX stage	   
ALU ALU(
	.rst_n_i(rst_n),	// negative reset            (input)
	.src1_i(ID_EX_RSdata_o),			// 32 bits source 1          (input)
	.src2_i(MUX1_o),			// 32 bits source 2          (input)
	.ALU_control_i(ALUCtrl),	// 4 bits ALU control input  (input)
	.result_o(ALU_result_o),		// 32 bits result            (output)
	.zero_o(zero_o)			// 1 bit when the output is 0, zero must be set (output)
);
		
ALU_Ctrl ALU_Control(
	.funct_i(ID_EX_Sign_o[6-1:0]),
	.ALUOp_i(ID_EX_ALUop_o),
	.ALUCtrl_o(ALUCtrl)
);

MUX_2to1 #(.size(32)) Mux1(
	.data0_i(ID_EX_RTdata_o),
	.data1_i(ID_EX_Sign_o),
	.select_i(ID_EX_ALUSrc_o),
	.data_o(MUX1_o)
);
		
MUX_2to1 #(.size(5)) Mux2(
	.data0_i(ID_EX_instr20_16_o),
	.data1_i(ID_EX_instr15_11_o),
	.select_i(ID_EX_RegDst_o),
	.data_o(MUX2_o)
);
Shift_Left_Two_32 Shifter(
	.data_i(ID_EX_Sign_o),
	.data_o(Shift_o)
);

Adder Adder2_branch(
	.src1_i(ID_EX_pc_o),
	.src2_i(Shift_o),
	.sum_o(Adder2_branch_o)
);

Pipe_EX_MEM EX_M(
	.rst_i(rst_n),
	.clk_i(clk_i),
	.WB_RegWrite_i(ID_EX_WB_RegWrite_o),	.WB_RegWrite_o(EX_M_WB_RegWrite_o),
	.WB_MemtoReg_i(ID_EX_WB_MemtoReg_o),	.WB_MemtoReg_o(EX_M_WB_MemtoReg_o),
	.M_branch_i(ID_EX_M_branch_o),			.M_branch_o(EX_M_branch_o),
	.M_MemRead_i(ID_EX_M_MemRead_o),			.M_MemRead_o(EX_M_MemRead_o),
	.M_MemWrite_i(ID_EX_M_MemWrite_o),		.M_MemWrite_o(EX_M_MemWrite_o),
	.Adder2_i(Adder2_branch_o),		.Adder2_o(EX_M_Adder2_branch_o),
	.zero_i(zero_o),						.zero_o(EX_M_zero_o),
	.ALU_result_i(ALU_result_o),		.ALU_result_o(EX_M_ALU_result_o),
	.Write_data_i(ID_EX_RTdata_o),	.Write_data_o(EX_M_RTdata_o),
	.MUX2_i(MUX2_o),						.MUX2_o(EX_M_MUX2_o)
);

	
//Instantiate the components in MEM stage

assign PCSrc = EX_M_branch_o & EX_M_zero_o;

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(EX_M_ALU_result_o),
	.data_i(EX_M_RTdata_o),
	.MemRead_i(EX_M_MemRead_o),
	.MemWrite_i(EX_M_MemWrite_o),
	.data_o(DM_o)
);

Pipe_MEM_WB M_WB(
	.rst_i(rst_n),
	.clk_i(clk_i),
	.WB_RegWrite_i(EX_M_WB_RegWrite_o),	.WB_RegWrite_o(M_WB_RegWrite_o),
	.WB_MemtoReg_i(EX_M_MemtoReg_o),		.WB_MemtoReg_o(M_WB_MemtoReg_o),
	.DM_i(DM_o),								.DM_o(M_WB_DM_o),
	.ALU_result_i(EX_M_ALU_result_o),	.ALU_result_o(M_WB_ALU_result_o),
	.MUX2_i(EX_M_MUX2_o),					.MUX2_o(M_WB_MUX2_o)
);


MUX_2to1 #(.size(5)) MUXWB(
	.data0_i(M_WB_DM_o),
	.data1_i(M_WB_ALU_result_o),
	.select_i(M_WB_MemtoReg_o),
	.data_o(MUXWB_o)
);

//Instantiate the components in WB stage
/****************************************
*         Signal assignment             *
****************************************/
	
endmodule

