/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Branch control unit            // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale 1ns/100ps

module branch_control_unit (
    input [31:0] DATA1, DATA2,       // Input data ports
    input [3:0] SELECT,             // Input selection control
    output reg PC_MUX_OUT           // Output result
);

    // Define Wires for intermediate calculations
    wire BEQ, BNE, BLT, BGE, BLTU, BGEU;

    // Calculations for comparisons
    assign BEQ = DATA1 == DATA2;     // Check if DATA1 is equal to DATA2
    assign BNE = DATA1 != DATA2;     // Check if DATA1 is not equal to DATA2
    assign BLT = $signed(DATA1) < $signed(DATA2);  // Check if DATA1 is less than DATA2 (signed comparison)
    assign BGE = $signed(DATA1) >= $signed(DATA2); // Check if DATA1 is greater than or equal to DATA2 (signed comparison)
    assign BLTU = $unsigned(DATA1) < $unsigned(DATA2);  // Check if DATA1 is less than DATA2 (unsigned comparison)
    assign BGEU = $unsigned(DATA1) >= $unsigned(DATA2); // Check if DATA1 is greater than or equal to DATA2 (unsigned comparison)

    always @(*)
    begin
        if (SELECT[3]) // Check if the most significant bit of SELECT is set (for branch/jump instruction)
        begin
            case (SELECT[2:0])
                3'b010: PC_MUX_OUT <= #1 1'b1;   // Set PC_MUX_OUT to 1 for JAL and JALR
                3'b000: PC_MUX_OUT <= #1 BEQ;     // Set PC_MUX_OUT based on BEQ result for BEQ
                3'b001: PC_MUX_OUT <= #1 BNE;     // Set PC_MUX_OUT based on BNE result for BNE
                3'b100: PC_MUX_OUT <= #1 BLT;     // Set PC_MUX_OUT based on BLT result for BLT
                3'b101: PC_MUX_OUT <= #1 BGE;     // Set PC_MUX_OUT based on BGE result for BGE
                3'b110: PC_MUX_OUT <= #1 BLTU;    // Set PC_MUX_OUT based on BLTU result for BLTU
                3'b111: PC_MUX_OUT <= #1 BGEU;    // Set PC_MUX_OUT based on BGEU result for BGEU
                default: PC_MUX_OUT <= #1 1'b0;   // Default case, set PC_MUX_OUT to 0
            endcase
        end
        else
        begin
            PC_MUX_OUT <= #1 1'b0; // If SELECT[3] is not set, set PC_MUX_OUT to 0 (no branch/jump)
        end
    end
endmodule
