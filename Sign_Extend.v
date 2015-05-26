
module Sign_Extend(
    data_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
//reg     [32-1:0] data_o;

//Sign extended
          assign data_o[15:0] = data_i[15:0];
			 assign data_o[31:16] = ( data_i[15] == 1'b0 )? 16'd0: 16'hffff;
endmodule      
     