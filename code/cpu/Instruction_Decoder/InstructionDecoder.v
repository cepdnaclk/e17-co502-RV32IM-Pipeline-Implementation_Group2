/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Instruction Decoder            // 
// Group  : 2                              //
/////////////////////////////////////////////

module InstructionDecoder(
    input wire [31:0] instruction, // Input: The 32-bit instruction
    output reg RegWrite,          // Output: Register Write Enable
    output reg MemtoReg,          // Output: Memory to Register
    output reg MemWrite,          // Output: Memory Write Enable
    output reg MemRead,           // Output: Memory Read Enable
    output reg [2:0] ALUOp,       // Output: ALU Operation Select
    output reg [2:0] ALUSrc,      // Output: ALU Source
    output reg [4:0] WriteRegDst,  // Output: Write Register Destination
    output wire [6:0] OpCode       // Output: Opcode
);

// Opcode extraction from the instruction
assign OpCode = instruction[6:0];

// Control signal generation based on opcode
always @(instruction) begin
    case(OpCode)
        // Add more cases for other instructions as needed
        7'b0110011: begin // R-type instructions
            RegWrite = 1'b1;
            ALUOp = 3'b010; // ALU operation: ADD
            WriteRegDst = instruction[11:7];
        end
        7'b0000011: begin // I-type load instructions
            RegWrite = 1'b1;
            MemtoReg = 1'b1;
            ALUOp = 3'b000; // ALU operation: ADD
            ALUSrc = 3'b010; // ALU source: Immediate
            WriteRegDst = instruction[11:7];
        end
        // Add more cases for other instruction types
        default: begin
            // Handle unknown/unsupported instructions
        end
    endcase
end

endmodule
