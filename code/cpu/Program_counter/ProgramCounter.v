/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Program Counter                // 
// Group  : 2                              //
/////////////////////////////////////////////

module ProgramCounter(
    input wire clk,               // Input: Clock signal
    input wire [31:0] pc_in,     // Input: New program counter value
    input wire reset,            // Input: Reset signal
    output wire [31:0] pc_out    // Output: Current program counter value
);

//32-bit register for the program counter
reg [31:0] pc_register;

// Always block for updating the program counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the program counter to an initial value
        pc_register <= 32'h0;
    end else begin
        // Update the program counter with the new value from pc_in
        pc_register <= pc_in;
    end
end

// Assign the current program counter value to the output
assign pc_out = pc_register;

endmodule
