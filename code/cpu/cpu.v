`include "alu/alu.v"
`include "register_file/reg_file.v"
`include "Instruction_Decoder/InstructionDecoder.v"
`include "Instruction_memory/InstructionMemory.v"
`include "control_unit/control_unit.v"
`include "Program_counter/ProgramCounter.v"

`include "pipeline_registers/EX_MEM_pipeline.v"
`include "pipeline_registers/ID_EX_pipeline.v"
`include "pipeline_registers/IF_ID_pipeline.v"
`include "pipeline_registers/MEM_WB_pipeline.v"

`include "other_modules/mux_2to1.v"
`include "other_modules/mux_4to1.v"

module cpu (
    CLK, RESET, PC, INSTRUCTION, DATA_MEM_READ, DATA_MEM_WRITE,
    DATA_MEM_ADDR, DATA_MEM_WRITE_DATA, DATA_MEM_READ_DATA,
    DATA_MEM_BUSYWAIT, INSTR_MEM_BUSYWAIT
);
    input CLK, RESET;
    output reg [31:0] PC;   
    input DATA_MEM_BUSYWAIT, INSTR_MEM_BUSYWAIT; 

    output [2:0] DATA_MEM_WRITE;    // Write control signal for data memory
    output [3:0] DATA_MEM_READ;     // Read control signal for data memory
    output [31:0] DATA_MEM_ADDR, DATA_MEM_WRITE_DATA; 

    input [31:0] INSTRUCTION;           // Instruction fetched from instruction memory
    input [31:0] DATA_MEM_READ_DATA;    // Data fetched from data memory

endmodule
