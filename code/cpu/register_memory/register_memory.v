/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Register Memory                // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale  1ns/100ps

// Module for Register memory
module register_memory(IN_DATA, WRITE, READ, CLK, RESET, OUT_DATA, PC_IN, PC_OUT);
    // Define the ports
    input [1023:0] IN_DATA; // Input Register values
    input [31:0] PC_IN; // Input PC value  

	input WRITE, READ, CLK, RESET;  // Input signals
    output reg [31:0] PC_OUT; // Output PC value 
    output reg [1023:0] OUT_DATA; // Output Register values
    // output reg BUSYWAIT;

    reg [31:0] REGISTERS  [0:31];       // 32 element array of 32 bit registers       
	

always @(posedge CLK)
    begin
        if(WRITE && !RESET) begin
            // BUSYWAIT = 1;
            PC_OUT <= #2 PC_IN;
            REGISTERS[0] = #40 IN_DATA[31:0]; 
            REGISTERS[1] = #40 IN_DATA[63:32]; 
            REGISTERS[2] = #40 IN_DATA[95:64];
            REGISTERS[3] = #40 IN_DATA[127:96]; 
            REGISTERS[4] = #40 IN_DATA[159:128]; 
            REGISTERS[5] = #40 IN_DATA[191:160]; 
            REGISTERS[6] = #40 IN_DATA[221:192]; 
            REGISTERS[7] = #40 IN_DATA[255:224]; 
            REGISTERS[8] = #40 IN_DATA[287:256]; 
            REGISTERS[9] = #40 IN_DATA[319:288]; 
            REGISTERS[10] = #40 IN_DATA[351:320]; 
            REGISTERS[11] = #40 IN_DATA[383:352]; 
            REGISTERS[12] = #40 IN_DATA[415:384]; 
            REGISTERS[13] = #40 IN_DATA[447:416]; 
            REGISTERS[14] = #40 IN_DATA[479:448]; 
            REGISTERS[15] = #40 IN_DATA[511:480]; 
            REGISTERS[16] = #40 IN_DATA[543:512]; 
            REGISTERS[17] = #40 IN_DATA[575:544]; 
            REGISTERS[18] = #40 IN_DATA[607:576]; 
            REGISTERS[19] = #40 IN_DATA[639:608]; 
            REGISTERS[20] = #40 IN_DATA[671:640]; 
            REGISTERS[21] = #40 IN_DATA[703:672]; 
            REGISTERS[22] = #40 IN_DATA[735:704]; 
            REGISTERS[23] = #40 IN_DATA[767:736]; 
            REGISTERS[24] = #40 IN_DATA[799:768]; 
            REGISTERS[25] = #40 IN_DATA[831:800]; 
            REGISTERS[26] = #40 IN_DATA[863:832]; 
            REGISTERS[27] = #40 IN_DATA[895:864]; 
            REGISTERS[28] = #40 IN_DATA[927:896]; 
            REGISTERS[29] = #40 IN_DATA[959:928]; 
            REGISTERS[30] = #40 IN_DATA[991:960]; 
            REGISTERS[31] = #40 IN_DATA[1023:992]; 
        end
        else if (READ && !RESET) begin
            // BUSYWAIT = 1;

            OUT_DATA[31:0] = #40 REGISTERS[0]; 
            OUT_DATA[63:32] = #40 REGISTERS[1]; 
            OUT_DATA[95:64] = #40 REGISTERS[2];
            OUT_DATA[127:96] = #40 REGISTERS[3]; 
            OUT_DATA[159:128]  = #40 REGISTERS[4]; 
            OUT_DATA[191:160] = #40 REGISTERS[5]; 
            OUT_DATA[221:192] = #40 REGISTERS[6]; 
            OUT_DATA[255:224] = #40 REGISTERS[7]; 
            OUT_DATA[287:256] = #40 REGISTERS[8]; 
            OUT_DATA[319:288] = #40 REGISTERS[9]; 
            OUT_DATA[351:320] = #40 REGISTERS[10]; 
            OUT_DATA[383:352] = #40 REGISTERS[11]; 
            OUT_DATA[415:384] = #40 REGISTERS[12]; 
            OUT_DATA[447:416] = #40 REGISTERS[13]; 
            OUT_DATA[479:448] = #40 REGISTERS[14]; 
            OUT_DATA[511:480] = #40 REGISTERS[15]; 
            OUT_DATA[543:512] = #40 REGISTERS[16]; 
            OUT_DATA[575:544] = #40 REGISTERS[17]; 
            OUT_DATA[607:576] = #40 REGISTERS[18]; 
            OUT_DATA[639:608] = #40 REGISTERS[19]; 
            OUT_DATA[671:640] = #40 REGISTERS[20]; 
            OUT_DATA[703:672] = #40 REGISTERS[21]; 
            OUT_DATA[735:704] = #40 REGISTERS[22]; 
            OUT_DATA[767:736] = #40 REGISTERS[23]; 
            OUT_DATA[799:768] = #40 REGISTERS[24]; 
            OUT_DATA[831:800] = #40 REGISTERS[25]; 
            OUT_DATA[863:832] = #40 REGISTERS[26]; 
            OUT_DATA[895:864] = #40 REGISTERS[27]; 
            OUT_DATA[927:896] = #40 REGISTERS[28]; 
            OUT_DATA[959:928] = #40 REGISTERS[29]; 
            OUT_DATA[991:960] = #40 REGISTERS[30]; 
            OUT_DATA[1023:992] = #40 REGISTERS[31]; 
        end
        else begin      
            // BUSYWAIT = 0;
            if (RESET) begin
                for (integer i = 0; i < 32; i = i + 1) begin
                    REGISTERS[i] <= #2 0;       // Set zero to all the registers
                end
                PC_OUT <= #2 0;
            end
        end
    end
endmodule


        