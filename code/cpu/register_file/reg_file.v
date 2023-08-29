/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Register file                  // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale  1ns/100ps

// Module for Register file
module reg_file(IN, OUT1, OUT2, INADDRESS, OUTADDRESS1, OUTADDRESS2, WRITE, CLK, RESET);
    // Define the ports
    input [31:0] IN;                                    // 32bit input
    output [31:0] OUT1, OUT2;                           // 32bit outputs
    input [4:0] INADDRESS, OUTADDRESS1, OUTADDRESS2;    // 5 bit addresses
	input WRITE, CLK, RESET;                            // Input signals

    reg [31:0] REGISTERS  [0:31];     //32 element array of 32 bit registers	             
    integer i;                      //Counter variable 
	
    //Register read

    //Assign statements are executed asynchrnously    
	assign #2 OUT1 = REGISTERS [OUTADDRESS1];
	assign #2 OUT2 = REGISTERS [OUTADDRESS2];

    //The always block triggeres (synchronously) only for the negative edge of the clock pulse
	always @(negedge CLK) 
    begin    
        //Write data to the register when write signal is high
        if (WRITE && !RESET) 
            REGISTERS [INADDRESS] <= #1 IN;
        else
            if (RESET)
                for (i = 0; i < 32; i = i + 1)
                    REGISTERS[i] <= #1 0;       // Set zero to all the registers
	end
   
endmodule


        