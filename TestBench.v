//Subject:     CO final project  - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns / 1ps
`define CYCLE_TIME 10			

module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;
integer     i;
integer     handle;


//Greate tested modle  

Pipe_CPU cpu(
       .clk_i(CLK),
	    .rst_n(RST)
		);

//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial  begin
	$readmemb("Pipeline_test.txt", cpu.IM.Instr_Mem);
    //  
	CLK = 0; 
	RST = 0;
	count = 0;
    
    #(`CYCLE_TIME)      RST = 1;
    #(`CYCLE_TIME*30)      $stop;

end




always@(posedge CLK) begin
		 count = count + 1;
		 $display("Cycle %d   PC=%d  instr=%b\n",count-1,cpu.PC.pc_out_o,cpu.instr_o);
		 
		 /*$display("\n----------------IF------------------\n");
		 $display("instr = %b\n", cpu.instr_mem_out);
		 
		 $display("\n----------------ID------------------\n");
		 $display("RTdata = %d  MemWrite = %b\n", cpu.RTdata,cpu.MemWrite);
		 
		 $display("\n----------------EXE------------------\n");
		 $display("ID_EXE_RTdata_out=%d Mux_ALUSrc_out=%d  ID_EXE_MemWrite = %b\n",
			 cpu.ID_EXE_RTdata_out,
			 cpu.Mux_ALUSrc_out,
			 cpu.ID_EXE_MemWrite);
		 
		 $display("\n----------------MEM------------------\n");
		 $display("EXE_MEM_RTdata_out(DM_i)=%d MemWrite_i(DM_i)=%b  EX_MEM_MemWrite=%b\n",
			 cpu.DM.data_i,
			 cpu.DM.MemWrite_i,
			 cpu.EX_MEM_MemWrite);
		 
		 $display("\n----------------WB------------------\n");
		 $display("\nr[%d](RF_i)=%d          RegWrite_i(RF_i)==%b\n",
			cpu.RF.RDaddr_i,
			cpu.RF.RDdata_i,
			cpu.RF.RegWrite_i);
			
		 $display("r[%d](cpu_ii)=%d          MEM_WB_RegWrite(cpu_ii)=%b\n",
			cpu.MEM_WB_Mux_Write_Reg_out,
			cpu.Mem2Reg_data,
			cpu.MEM_WB_RegWrite);
		 $display("--------------------------------------\n");
		
		 $display("\nr0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d\n",
			cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], 
			cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], 
			cpu.RF.Reg_File[4], cpu.RF.Reg_File[5], 
			cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
			);
		 $display("======================================================\n");
		 $display("======================================================\n");
		 */
		//if( count == 12 ) begin 
			//print result to transcript 
			//$display("\n==========================================================================================\n");
			$display("---------------------------------Register-------------------------------------------------\n");
			$display("r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d\n",
			cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], 
			cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], 
			cpu.RF.Reg_File[4], cpu.RF.Reg_File[5], 
			cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
			);
			$display("r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d, r15=%d\n",
			cpu.RF.Reg_File[8], cpu.RF.Reg_File[9],
			cpu.RF.Reg_File[10], cpu.RF.Reg_File[11],
			cpu.RF.Reg_File[12], cpu.RF.Reg_File[13],
			cpu.RF.Reg_File[14], cpu.RF.Reg_File[15],
			);
			$display("\n-------------------------------Memory----------------------------------------------------\n");
			$display("m0=%d, m1=%d, m2=%d, m3=%d, m4=%d, m5=%d, m6=%d, m7=%d\n\nm8=%d, m9=%d, m10=%d, m11=%d, m12=%d, m13=%d, m14=%d, m15=%d\n\n",							 
						 cpu.DM.memory[0], cpu.DM.memory[1], cpu.DM.memory[2], cpu.DM.memory[3],
						 cpu.DM.memory[4], cpu.DM.memory[5], cpu.DM.memory[6], cpu.DM.memory[7],
						 cpu.DM.memory[8], cpu.DM.memory[9], cpu.DM.memory[10], cpu.DM.memory[11],
						 cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
					  );
			//$display("\n==========================================================================================\n");


		//end

		if( count == 15 ) begin 
			//print result to transcript 
			//$display("\n==========================================================================================\n");
			$display("---------------------------------Register-------------------------------------------------\n");
			$display("r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d\n",
			cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], 
			cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], 
			cpu.RF.Reg_File[4], cpu.RF.Reg_File[5], 
			cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
			);
			$display("r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d, r15=%d\n",
			cpu.RF.Reg_File[8], cpu.RF.Reg_File[9],
			cpu.RF.Reg_File[10], cpu.RF.Reg_File[11],
			cpu.RF.Reg_File[12], cpu.RF.Reg_File[13],
			cpu.RF.Reg_File[14], cpu.RF.Reg_File[15],
			);
			$display("\n-------------------------------Memory----------------------------------------------------\n");
			$display("m0=%d, m1=%d, m2=%d, m3=%d, m4=%d, m5=%d, m6=%d, m7=%d\n\nm8=%d, m9=%d, m10=%d, m11=%d, m12=%d, m13=%d, m14=%d, m15=%d\n\n",							 
						 cpu.DM.memory[0], cpu.DM.memory[1], cpu.DM.memory[2], cpu.DM.memory[3],
						 cpu.DM.memory[4], cpu.DM.memory[5], cpu.DM.memory[6], cpu.DM.memory[7],
						 cpu.DM.memory[8], cpu.DM.memory[9], cpu.DM.memory[10], cpu.DM.memory[11],
						 cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
					  );
			//$display("\n==========================================================================================\n");


		end
		
end
  
endmodule

