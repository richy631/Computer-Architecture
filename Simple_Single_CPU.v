
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0]	pc_in;
wire [32-1:0]	pc_out;
wire [32-1:0]	pc_sum;
wire [32-1:0]	branch_sum;

wire [32-1:0]	instr_mem_out;

wire [32-1:0]	RSdata;
wire [32-1:0]	RTdata;

wire [32-1:0]	ALU_result;
wire				ALU_zero;

wire [5-1:0]	Mux_Write_Reg_out;
wire [32-1:0]	Mux_ALUSrc_out;
wire [32-1:0]	Sign_Extend_out;
wire [32-1:0]	Shift_Left_Two_32_out;

//Control signal
wire 				ALUsrc;
wire				branch;
wire 				RegDst;
wire				RegWrite;
wire [3-1:0]	ALUop;

wire 				PCSrc;
wire [4-1:0]	ALUctrl;


//Control signal
wire 				Jump;
wire				MemRead;
wire				MemWrite;
wire 				MemtoReg ;
wire [32-1:0]	Mem2Reg_data;

//Internal signal
wire [32-1:0]	jump_pc;
wire [32-1:0]	mid_jump_pc;
wire [32-1:0]	pc_source_out;
wire [32-1:0]	sft_lef_2_jump_pc_out;
wire [32-1:0]	read_mem_data;

//Create componentes
ProgramCounter PC(
       .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1_pc(
       .src1_i(32'd4),     
	    .src2_i(pc_out),     
	    .sum_o(pc_sum)    
	    );
	
Instr_Memory IM(
       .pc_addr_i(pc_out),  
	    .instr_o(instr_mem_out)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_mem_out[20:16]),//rt
        .data1_i(instr_mem_out[15:11]),//rd
        .select_i(RegDst),
        .data_o(Mux_Write_Reg_out)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
		  .rst_i(rst_i) ,     
        .RSaddr_i(instr_mem_out[25:21]) , //rs
        .RTaddr_i(instr_mem_out[20:16]) , //rt
        .RDaddr_i(Mux_Write_Reg_out) ,  
        .RDdata_i(Mem2Reg_data)  ,
        .RegWrite_i (RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Controller(
       .instr_op_i(instr_mem_out[31:26]), 
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

ALU_Ctrl AC(
        .funct_i(instr_mem_out[5:0]),   
        .ALUOp_i(ALUop),   
        .ALUCtrl_o(ALUctrl) 
        );
	
Sign_Extend SE(
        .data_i(instr_mem_out[15:0]),
        .data_o(Sign_Extend_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(Sign_Extend_out),
        .select_i(ALUsrc),
        .data_o(Mux_ALUSrc_out)
        );	


ALU ALU(
		 .rst_n_i(rst_n), 
       .src1_i(RSdata),
	    .src2_i(Mux_ALUSrc_out),
	    .ALU_control_i(ALUctrl),
	    .result_o(ALU_result),
		 .zero_o(ALU_zero)
	    );

Shift_Left_Two_32 Shifter(
        .data_i(Sign_Extend_out),
        .data_o(Shift_Left_Two_32_out)
        ); 
		  
Adder Adder2_branch(
        .src1_i(pc_sum),     
	    .src2_i(Shift_Left_Two_32_out),     
	    .sum_o(branch_sum)      
	    );		

assign PCSrc = branch & ALU_zero;

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_sum),
        .data1_i(branch_sum),
        .select_i(PCSrc),
        .data_o(pc_source_out)
        );	
		  

assign jump_pc = { pc_sum[31:28] , sft_lef_2_jump_pc_out };
assign mid_jump_pc = { 6'b000000 , instr_mem_out[25:0] };	

MUX_2to1 #(.size(32)) Mux_Jump_Source(
        .data0_i(pc_source_out),
        .data1_i(jump_pc),
        .select_i(Jump),
        .data_o(pc_in)
        );	

Shift_Left_Two_32 Shifter_Jump_PC(
        .data_i(  mid_jump_pc ),
        .data_o( sft_lef_2_jump_pc_out)
        );
	
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(ALU_result),
		.data_i(RTdata),
		.MemRead_i(MemRead),
		.MemWrite_i(MemWrite),
		.data_o(read_mem_data)
		);

MUX_2to1 #(.size(32)) Mux_Mem2Reg(
		.data0_i(ALU_result),
		.data1_i(read_mem_data),
		.select_i(MemtoReg),
		.data_o(Mem2Reg_data)
		);

endmodule
		  


