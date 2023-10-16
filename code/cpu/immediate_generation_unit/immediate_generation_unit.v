/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Immediate value module         // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale 1ns/100ps

module immediate_generation_unit (INSTRUCTION, SELECT, OUT);
    // Define input/output ports
    input [31:0] INSTRUCTION;  // 32-bit instruction input
    input [2:0] SELECT;       // Select control input
    output reg [31:0] OUT;    // Output for the selected immediate value

    // Extract relevant parts of the instruction
    wire [31:0] U_IMM = {INSTRUCTION[31:12], 12'b0};  // U-type immediate
    wire [31:0] J_IMM = {INSTRUCTION[31], INSTRUCTION[19:12], INSTRUCTION[20], INSTRUCTION[30:21], 1'b0};  // J-type immediate
    wire [31:0] I_IMM = {INSTRUCTION[31], INSTRUCTION[31:20]};  // I-type immediate
    wire [31:0] B_IMM = {INSTRUCTION[31], INSTRUCTION[7], INSTRUCTION[30:25], INSTRUCTION[11:8], 1'b0};  // B-type immediate
    wire [31:0] S_IMM = {INSTRUCTION[31], INSTRUCTION[30:25], INSTRUCTION[11:7]};  // S-type immediate

    // Assign to output based on the SELECT input
    always @ (*)
    begin
        case (SELECT)
            3'b000: OUT <= #1 U_IMM;  // Assign U-type immediate for SELECT = 000
            3'b001: OUT <= #1 J_IMM;  // Assign J-type immediate for SELECT = 001
            3'b010: OUT <= #1 I_IMM;  // Assign I-type immediate for SELECT = 010
            3'b011: OUT <= #1 B_IMM;  // Assign B-type immediate for SELECT = 011
            3'b100: OUT <= #1 S_IMM;  // Assign S-type immediate for SELECT = 100
            default: OUT <= #1 32'd0;  // Default: Set the output to 0
        endcase
    end

endmodule
