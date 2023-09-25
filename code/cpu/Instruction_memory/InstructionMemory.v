/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Instruction Memory             // 
// Group  : 2                              //
/////////////////////////////////////////////

module InstructionMemory(
    input wire [31:0] address,      // Input address for instruction fetch
    output wire [31:0] instruction  // Output instruction
);

// Define an array of 32-bit instructions
reg [31:0] memory [0:1023]; // Change the size based on your memory requirements

// Initialize the memory with program instructions
initial begin
    // Load program instructions into the memory
    memory[0]  <= 32'h8C01006F; // RV32IM instruction: LUI x1, 0x6F
    memory[4]  <= 32'h00030313; // RV32IM instruction: ADDI x6, x6, 0x3
end

// Read operation: output the instruction based on the input address
assign instruction = memory[address];
endmodule
