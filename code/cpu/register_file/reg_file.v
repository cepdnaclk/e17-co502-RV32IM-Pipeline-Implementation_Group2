/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Register file                  // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale  1ns/100ps

// Module for Register file
module reg_file(IN, OUT1, OUT2, INADDRESS, OUTADDRESS1, OUTADDRESS2, WRITE, CLK, RESET, IN_DATA, OUT_DATA, READ_MEM, WRITE_MEM);
    // Define the ports
    input [31:0] IN;                                    // 32bit input to write data
    output [31:0] OUT1, OUT2;                           // 32bit outputs to read data
    input [4:0] INADDRESS, OUTADDRESS1, OUTADDRESS2;    // 5 bit addresses write address and 2 read addresses
	input WRITE, CLK, RESET, READ_MEM, WRITE_MEM;                            // Input signals
    input [1023:0] IN_DATA; // Input Register values

    output reg [1023:0] OUT_DATA;// Output Register values
    // output reg BUSYWAIT;

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
            // BUSYWAIT = 0;
            if (RESET)
                for (i = 0; i < 32; i = i + 1)
                    REGISTERS[i] <= #1 0;       // Set zero to all the registers
	end

    always @(posedge CLK)
    begin
        if(WRITE_MEM && !RESET) begin
            // BUSYWAIT = 1;

            REGISTERS[0] = #8 IN_DATA[31:0]; 
            REGISTERS[1] = #8 IN_DATA[63:32]; 
            REGISTERS[2] = #8 IN_DATA[95:64];
            REGISTERS[3] = #8 IN_DATA[127:96]; 
            REGISTERS[4] = #8 IN_DATA[159:128]; 
            REGISTERS[5] = #8 IN_DATA[191:160]; 
            REGISTERS[6] = #8 IN_DATA[221:192]; 
            REGISTERS[7] = #8 IN_DATA[255:224]; 
            REGISTERS[8] = #8 IN_DATA[287:256]; 
            REGISTERS[9] = #8 IN_DATA[319:288]; 
            REGISTERS[10] = #8 IN_DATA[351:320]; 
            REGISTERS[11] = #8 IN_DATA[383:352]; 
            REGISTERS[12] = #8 IN_DATA[415:384]; 
            REGISTERS[13] = #8 IN_DATA[447:416]; 
            REGISTERS[14] = #8 IN_DATA[479:448]; 
            REGISTERS[15] = #8 IN_DATA[511:480]; 
            REGISTERS[16] = #8 IN_DATA[543:512]; 
            REGISTERS[17] = #8 IN_DATA[575:544]; 
            REGISTERS[18] = #8 IN_DATA[607:576]; 
            REGISTERS[19] = #8 IN_DATA[639:608]; 
            REGISTERS[20] = #8 IN_DATA[671:68]; 
            REGISTERS[21] = #8 IN_DATA[703:672]; 
            REGISTERS[22] = #8 IN_DATA[735:704]; 
            REGISTERS[23] = #8 IN_DATA[767:736]; 
            REGISTERS[24] = #8 IN_DATA[799:768]; 
            REGISTERS[25] = #8 IN_DATA[831:800]; 
            REGISTERS[26] = #8 IN_DATA[863:832]; 
            REGISTERS[27] = #8 IN_DATA[895:864]; 
            REGISTERS[28] = #8 IN_DATA[927:896]; 
            REGISTERS[29] = #8 IN_DATA[959:928]; 
            REGISTERS[30] = #8 IN_DATA[991:960]; 
            REGISTERS[31] = #8 IN_DATA[1023:992]; 
        end
        else if (READ_MEM && !RESET) begin
            // BUSYWAIT = 1;

            OUT_DATA[31:0] = #8 REGISTERS[0]; 
            OUT_DATA[63:32] = #8 REGISTERS[1]; 
            OUT_DATA[95:64] = #8 REGISTERS[2];
            OUT_DATA[127:96] = #8 REGISTERS[3]; 
            OUT_DATA[159:128]  = #8 REGISTERS[4]; 
            OUT_DATA[191:160] = #8 REGISTERS[5]; 
            OUT_DATA[221:192] = #8 REGISTERS[6]; 
            OUT_DATA[255:224] = #8 REGISTERS[7]; 
            OUT_DATA[287:256] = #8 REGISTERS[8]; 
            OUT_DATA[319:288] = #8 REGISTERS[9]; 
            OUT_DATA[351:320] = #8 REGISTERS[10]; 
            OUT_DATA[383:352] = #8 REGISTERS[11]; 
            OUT_DATA[415:384] = #8 REGISTERS[12]; 
            OUT_DATA[447:416] = #8 REGISTERS[13]; 
            OUT_DATA[479:448] = #8 REGISTERS[14]; 
            OUT_DATA[511:480] = #8 REGISTERS[15]; 
            OUT_DATA[543:512] = #8 REGISTERS[16]; 
            OUT_DATA[575:544] = #8 REGISTERS[17]; 
            OUT_DATA[607:576] = #8 REGISTERS[18]; 
            OUT_DATA[639:608] = #8 REGISTERS[19]; 
            OUT_DATA[671:68] = #8 REGISTERS[20]; 
            OUT_DATA[703:672] = #8 REGISTERS[21]; 
            OUT_DATA[735:704] = #8 REGISTERS[22]; 
            OUT_DATA[767:736] = #8 REGISTERS[23]; 
            OUT_DATA[799:768] = #8 REGISTERS[24]; 
            OUT_DATA[831:800] = #8 REGISTERS[25]; 
            OUT_DATA[863:832] = #8 REGISTERS[26]; 
            OUT_DATA[895:864] = #8 REGISTERS[27]; 
            OUT_DATA[927:896] = #8 REGISTERS[28]; 
            OUT_DATA[959:928] = #8 REGISTERS[29]; 
            OUT_DATA[991:960] = #8 REGISTERS[30]; 
            OUT_DATA[1023:992] = #8 REGISTERS[31]; 
        end
    end
   
endmodule


        