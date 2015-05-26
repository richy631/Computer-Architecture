
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
//reg        [4-1:0] ALUCtrl_o;

//Parameter of ALU_Op (input)
parameter addi = 3'b 000;
parameter beq_in = 3'b 001;
parameter R_type = 3'b 010;
parameter slti = 3'b 011;
parameter load = 3'b 100;
parameter store = 3'b 101;
parameter nofunc_in = 3'b 111;

//Parameter ALU control (output)
parameter 	LW_SW  = 4'b 0010;
parameter	BEQ_out   = 4'b 0110;
parameter	AND   = 4'b 0000;
parameter	OR    = 4'b 0001;
parameter	ADD   = 4'b 0010;
parameter	SUB   = 4'b 0110;
parameter	SLT   = 4'b 0111;   
parameter	NOFUN_out = 4'b 1111; 
//LAB3
parameter 	MUL	= 4'b1000;
parameter 	LW		= 4'b1001; 
parameter	SW		= 4'b1010;
parameter 	LUI	= 4'b1011;


//Select exact operation
assign ALUCtrl_o = ( ALUOp_i == addi )? ADD :
							( ALUOp_i == beq_in )? BEQ_out : 
								( ALUOp_i == slti )? SLT:
									( ALUOp_i == load )? LW:
										( ALUOp_i == store )? SW:
											( ALUOp_i == R_type )? (funct_i == 6'b 100000)? ADD:
																				(funct_i == 6'b 100010)? SUB:
																					(funct_i == 6'b 100100)? AND:
																						(funct_i == 6'b 100101)? OR:
																							(funct_i == 6'b 011000)? MUL:
																								(funct_i == 6'b 101010)? SLT: NOFUN_out: NOFUN_out ;
									
endmodule     





                    
                    