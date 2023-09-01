/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Control Unit Module            // 
// Group  : 2                              //
/////////////////////////////////////////////


`timescale 1ns/100ps


module control_unit (
    Instruction, ALU_sel, reg_write_EN, 
    mem_write, mem_read, branch_sel, 
    immeadiate_sel, operand1_sel, operand2_sel, 
    reg_write_sel
);

    // Define input ports
    input [31:0] Instruction;
    
    // Define output ports
    output [4:0] ALU_sel;
    output [3:0] mem_read;
    output [2:0] mem_write;
    output [3:0] branch_sel;
    output [2:0] immeadiate_sel;
    output [1:0] reg_write_sel;
    output reg_write_EN, operand1_sel, operand2_sel;

    // Instruction control segments
    wire [6:0] opcode;
    wire [6:0] funct7;
    wire [2:0] funct3;

    // Extract the control segments
    assign opcode = Instruction[6:0];
    assign funct3 = Instruction[14:12];
    assign funct7 = Instruction[31:25];


    /**************************** Register write enable signal ****************************/
    // Set for all instructions other than BRANCH and STORE
    assign #1 reg_write_EN = ~(
        (opcode === 7'b1100011) |   // BRANCH
        (opcode === 7'b0100011)     // STORE
    );


    /**************************** Immediate select signal ****************************/
    assign #1 immeadiate_sel = 
        (opcode === 7'b0110111) ? 3'b000 :      // LUI (U-type)
        (opcode === 7'b0010111) ? 3'b000 :      // AUIPC (U-type)
        (opcode === 7'b1101111) ? 3'b001 :      // JAL (J-type)
        (opcode === 7'b1100111) ? 3'b010 :      // JALR (I-type)
        (opcode === 7'b0000011) ? 3'b010 :      // LOAD (I-type)
        (opcode === 7'b1100011) ? 3'b011 :      // BRANCH (B-type)
        (opcode === 7'b0100011) ? 3'b100 :      // STORE (S-type)
        (opcode === 7'b0010011) ? 3'b010 : 3'bxxx;     // All other I-type (ADDI, ANDI, ORI, etc...)


    /**************************** OPERAND MUX select signals ****************************/
    // Set operand1 to PC for these instructions
    assign #1 operand1_sel =
        (opcode === 7'b0010111) |   // AUIPC
        (opcode === 7'b1101111) |   // JAL
        (opcode === 7'b1100011);    // BRANCH

    // Set operand2 to Immeadiate for these instructions
    assign #1 operand2_sel = 
        (opcode === 7'b0110111) |   // LUI
        (opcode === 7'b0010111) |   // AUIPC
        (opcode === 7'b1101111) |   // JAL
        (opcode === 7'b1100111) |   // JALR
        (opcode === 7'b0000011) |   // LOAD
        (opcode === 7'b1100011) |   // BRANCH
        (opcode === 7'b0100011) |   // STORE
        (opcode === 7'b0010011);    // All other I-type (ADDI, ANDI, ORI, etc...) 

    /**************************** ALU function  select signal ****************************/
    assign #1 ALU_sel[2:0] = 
        (
            // Force selection of ADD function
            (opcode === 7'b0110111) |   // LUI
            (opcode === 7'b0010111) |   // AUIPC
            (opcode === 7'b1101111) |   // JAL
            (opcode === 7'b1100011) |   // BRANCH
            (opcode === 7'b0000011) |   // LOAD
            (opcode === 7'b0100011)     // STORE
        ) ? 3'b000 :
        (opcode === 7'b1100111) ? // JALR (Force selection of JTARGET function)
            3'b001 : funct3;    // All other instructions use funct3 as is

    assign #1 ALU_sel[3] =
        (opcode === 7'b0110111) |       // LUI
        ({opcode, funct7} === {7'b0110011, 7'b0000001});    // RV32M

    assign #1 ALU_sel[4] =
        (opcode === 7'b0110111) |       // LUI
        (opcode === 7'b1100111) |       // JALR
        ({opcode, funct3, funct7} === {7'b0110011, 3'b000, 7'b0100000}) |   // SUB
        ({opcode, funct3, funct7} === {7'b0110011, 3'b101, 7'b0100000}) |   // SRA
        ({opcode, funct3, funct7} === {7'b0010011, 3'b101, 7'b0100000});    // SRAI

    
    /**************************** Branch Control Unit select signal ****************************/
    // MSB of BRANCH_CTRL must be set for branch/jump instructions
    assign #1 branch_sel[3] = 
        (opcode === 7'b1101111) |   // JAL
        (opcode === 7'b1100111) |   // JALR
        (opcode === 7'b1100011);    // BRANCH

    // Lower bits are set to 010 for JUMP instructions
    // and FUNCT3 for other instructions
    assign #1 branch_sel[2:0] = 
        ((opcode === 7'b1101111) || (opcode === 7'b1100111)) ?      // JAL, JALR
            3'b010 : funct3;


    /**************************** Data memory control signals ****************************/
    // Data memory read signal
    assign #1 mem_write[2] = (opcode === 7'b0100011);   // Set MSB for STORE instructions
    assign #1 mem_write[1:0] = funct3[1:0];     // Lower bits are derived from FUNCT3

    // Data memory write signal
    assign #1 mem_read[3] = (opcode === 7'b0000011);    // Set MSB for LOAD instructions
    assign #1 mem_read[2:0] = funct3;   // Lower bits are derived from FUNCT3


    /**************************** Writeback value select signal ****************************/
    assign #1 reg_write_sel = 
        ((opcode == 7'b1101111) | (opcode == 7'b1100111)) ? 2'b00 :   // JAL, JALR (PC)
        (opcode == 7'b0000011) ? 2'b01 :        // LOAD (Mem output)
        2'b10;      // Everything else (ALU output)


endmodule
