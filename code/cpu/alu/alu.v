/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : ALU Module                     // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale 1ns/100ps

// 32 bit ALU module
module alu(DATA1, DATA2, SELECT, RESULT);
    
    // Define inputs of ALU
    input [31:0] DATA1, DATA2;  // Input data
    input [4:0] SELECT;         // Select port
    
    // Define outputs of ALU
    output reg [31:0] RESULT;

    //Wire to hold intermediate calculations
    wire [31:0] ADD, 
                SUB,
                AND, 
                OR, 
                SLL, 
                SRL, 
                XOR, 
                SRA,
                SLT,
                SLTU,
                MUL, 
                MULH, 
                MULHSU, 
                MULHU, 
                DIV, 
                REM, 
                REMU,
                FWD;

    // Assigning the results to the relavant operations
    assign #1 FWD = DATA2;          // Forward operation
    assign #2 ADD = DATA1 + DATA2;  // Add operation
    assign #2 SUB = DATA1 - DATA2;  // Subtraction operation
    assign #1 AND = DATA1 & DATA2;  // Bitwise AND operation
    assign #1 OR = DATA1 | DATA2;   // Bitwise OR operation
    assign #1 XOR = DATA1 ^ DATA2;  // Bitwise XOR operation

    assign #2 SLL = DATA1 << DATA2; // Bitwise left shift logical
    assign #2 SRL = DATA1 >> DATA2; // Bitwise right shift logical
    assign #2 SRA = $signed(DATA1) >>> DATA2; // Arithmetic right shift arithmetic

    assign #1 SLT = ($signed(DATA1) < $signed(DATA2)) ? 1'b1 : 1'b0; // Set less than 
    assign #1 SLTU = DATA1 < DATA2 ? 1'b1 : 1'b0; // Set less than Unsigned

    assign #2 MUL = DATA1 * DATA2; // Multiplication
    assign #2 MULH = $signed(DATA1) * $signed(DATA2) >> 32;
    assign #2 MULHSU = ($signed(DATA1) * DATA2) >> 32; // Returns upper 32-bits of signed x unsigned
    assign #2 MULHU = (DATA1 * DATA2) >>> 32; // Returns upper 32-bits of unsigned x unsigned

    assign #3 DIV = $signed(DATA1) / $signed(DATA2); // Signed Integer division
    assign #3 REM = $signed(DATA1) % $signed(DATA2); // Signed remainder of integer division

    assign #3 REMU = $unsigned(DATA1) % $unsigned(DATA2); // Unsigned remainder of integer division

    always @(*) // This block runs if there is any change in DATA1, DATA2, or SELECT
    begin
        case (SELECT)
            5'b00000: RESULT = ADD; 
            5'b00001: RESULT = SLL; 
            5'b00010: RESULT = SLT; 
            5'b00011: RESULT = SLTU; 

            5'b00100: RESULT = XOR; 
            5'b00101: RESULT = SRL; 
            5'b00110: RESULT = OR; 
            5'b00111: RESULT = AND; 

            // Commands for mul unit
            5'b01000: RESULT = MUL; 
            5'b01001: RESULT = MULH; 
            5'b01010: RESULT = MULHSU; 
            5'b01011: RESULT = MULHU; 

            5'b01100: RESULT = DIV; 
            5'b01101: RESULT = REM; 
            5'b01111: RESULT = REMU; 
            
            // Additional commands
            5'b10001: RESULT = SRA; 
            5'b10000: RESULT = SUB; 
            5'b11xxx: RESULT = FWD; 
                
            default: RESULT = 0; // Result is 0 for other cases
        endcase
    end
endmodule
