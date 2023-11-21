/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Register Memory Controller     // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale  1ns/100ps

// Module for Register memory
module reg_file(reg_mem_read, reg_mem_write, RF_write, RF_read, RM_write, RM_read, CLK, RESET, BUSYWAIT);
    // Define the ports
	input reg_mem_read, reg_mem_write, CLK, RESET;                  // Input signals
    output reg RF_write, RF_read, RM_write, RM_read, BUSYWAIT;      // Output signals

	always @(posedge CLK) 
    begin    
        if (reg_mem_read && !RESET) begin
            BUSYWAIT <= #1 1;
            RM_read <= #10 1;
            RF_write <= #50 1;
            BUSYWAIT <= #50 0;
        end
        else if (reg_mem_write && !RESET) begin
            BUSYWAIT <= #1 1;
            RF_read <= #10 1;
            RM_write <= #50 1;
            BUSYWAIT <= #50 0;
        end 
        else begin
            if(BUSYWAIT){
                RM_read <= #2 0;
                RF_write <= #2 0;
                RF_read <= #2 0;
                RM_write <= #2 0;
            }
        end  
	end
   
endmodule


        