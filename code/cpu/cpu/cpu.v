`include "../alu/alu.v"
`include "../register_file/reg_file.v"
`include "../immediate_generation_unit/immediate_generation_unit.v"
`include "../control_unit/control_unit.v"
`include "../branch_control_unit/branch_control_unit.v"
`include "../instruction_cache/instruction_cache.v"
`include "../data_cache_controller/cache_controller.v"
`include "../pipeline_registers/IF_ID_pipeline.v"
`include "../pipeline_registers/ID_EX_pipeline.v"
`include "../pipeline_registers/EX_MEM_pipeline.v"
`include "../pipeline_registers/MEM_WB_pipeline.v"
`include "../other_modules/adder_4.v"
`include "../other_modules/mux_4to1.v"
`include "../other_modules/mux_2to1.v"

`timescale 1ns/100ps

module cpu (CLK, RESET);

    input CLK, RESET;                               // Clock and reset pins

    // IF
    wire INSTR_MEM_BUSYWAIT;
    wire [31:0] INSTRUCTION;     // Instruction fetched from instruction memory
    reg [31:0] PC;               // Program Counter
    wire [31:0] PC_PLUS_4, PC_NEXT;

    // ID
    wire [31:0] ID_PC, ID_INSTRUCTION, ID_REG_DATA1, ID_REG_DATA2, ID_IMMEDIATE;
    wire [4:0] ID_ALU_SELECT;
    wire [3:0] ID_DATA_MEM_READ, ID_BRANCH_CTRL;
    wire [2:0] ID_DATA_MEM_WRITE, ID_IMMEDIATE_SELECT;
    wire [1:0] ID_WB_VALUE_SELECT;
    wire ID_REG_WRITE_EN, ID_OPERAND1_SELECT, ID_OPERAND2_SELECT;

    // EX
    wire [31:0] EX_PC, EX_IMMEDIATE, EX_REG_DATA1, EX_REG_DATA2,
                EX_ALU_DATA1, EX_ALU_DATA2, EX_ALU_OUT;
    wire [4:0] EX_ALU_SELECT;
    wire [4:0] EX_REG_WRITE_ADDR;
    wire [3:0] EX_DATA_MEM_READ, EX_BRANCH_CTRL;
    wire [2:0] EX_DATA_MEM_WRITE;
    wire [1:0] EX_WB_VALUE_SELECT;
    wire EX_REG_WRITE_EN, EX_OPERAND1_SELECT, EX_OPERAND2_SELECT, EX_BJ_SIG;

    // MEM
    wire [31:0] DATA_MEM_READ_DATA, WB_VALUE;    // Data fetched from data memory
    wire [31:0] MEM_PC, MEM_PC_PLUS_4, MEM_ALU_OUT, MEM_REG_DATA2;
    wire [4:0] MEM_REG_WRITE_ADDR;
    wire [3:0] MEM_DATA_MEM_READ;
    wire [2:0] MEM_DATA_MEM_WRITE;
    wire [1:0] MEM_WB_VALUE_SELECT;
    wire MEM_REG_WRITE_EN, MEM_WRITE_DATA_SEL;

    // WB
    wire [31:0] WB_PC, WB_ALU_OUT, WB_DATA_MEM_READ_DATA, WB_WRITEBACK_VALUE;
    wire [4:0] WB_REG_WRITE_ADDR; 
    wire [1:0] WB_WB_VALUE_SELECT;
    wire WB_REG_WRITE_EN;


    ////////////IF stage/////////////
    //Adder to calculate PC+4
    adder_4 IF_PC_PLUS_4_ADDER (CLK, BUSYWAIT, RESET, PC, PC_PLUS_4);

    //Mux to select between PC+4 and branch target
    mux_2to1 BRANCH_SELECT_MUX (PC_PLUS_4, EX_ALU_OUT, PC_NEXT, EX_BJ_SIG);

    // Instruction chache (Instruction memory is in Instruction Cache)
    i_cache INSTRUCTION_CACHE (PC_PLUS_4, CLK, RESET, INSTRUCTION, INSTR_MEM_BUSYWAIT);

    // IF / ID 
    IF_ID_pipeline PIPELINE_REG_IF_ID (CLK, RESET, PC, INSTRUCTION, ID_PC, ID_INSTRUCTION);

    ////////////ID stage/////////////
    // Control unit 
    control_unit ID_CONTROL_UNIT (ID_INSTRUCTION, ID_ALU_SELECT, ID_REG_WRITE_EN, ID_DATA_MEM_WRITE, ID_DATA_MEM_READ, ID_BRANCH_CTRL, ID_IMMEDIATE_SELECT, ID_OPERAND1_SELECT, ID_OPERAND2_SELECT, ID_WB_VALUE_SELECT);

    //Register file
    reg_file ID_REGISTER_FILE (WB_WRITEBACK_VALUE, ID_REG_DATA1, ID_REG_DATA2, WB_REG_WRITE_ADDR, ID_INSTRUCTION[19:15], ID_INSTRUCTION[24:20], WB_REG_WRITE_EN, CLK, RESET);

    //Immediate generation unit
    immediate_generation_unit ID_IMMEDIATE_GEN_UNIT (ID_INSTRUCTION, ID_IMMEDIATE_SELECT, ID_IMMEDIATE);

    //ID / EX
    ID_EX_pipeline PIPELINE_REG_ID_EX (CLK, RESET, ID_PC, ID_REG_DATA1, ID_REG_DATA2, ID_IMMEDIATE, ID_INSTRUCTION[11:7], ID_ALU_SELECT, ID_OPERAND1_SELECT, ID_OPERAND2_SELECT, ID_REG_WRITE_EN, ID_DATA_MEM_WRITE, ID_DATA_MEM_READ, ID_BRANCH_CTRL, ID_WB_VALUE_SELECT, EX_PC, EX_REG_DATA1, EX_REG_DATA2, EX_IMMEDIATE, EX_REG_WRITE_ADDR, EX_ALU_SELECT, EX_OPERAND1_SELECT, EX_OPERAND2_SELECT, EX_REG_WRITE_EN, EX_DATA_MEM_WRITE, EX_DATA_MEM_READ, EX_BRANCH_CTRL, EX_WB_VALUE_SELECT);


    ////////////EX stage/////////////
    //OP1 select mux
    mux_2to1 EX_OP1_SELECT_MUX (EX_REG_DATA1, EX_PC, EX_ALU_DATA1, EX_OPERAND1_SELECT);

    //OP2 select mux
    mux_2to1 EX_OP2_SELECT_MUX (EX_REG_DATA2, EX_IMMEDIATE, EX_ALU_DATA2, EX_OPERAND2_SELECT);

    //ALU 
    alu EX_ALU (EX_ALU_DATA1, EX_ALU_DATA2, EX_ALU_SELECT, EX_ALU_OUT);

    //Branch control unit
    branch_control_unit EX_BRANCH_CTRL_UNIT (EX_REG_DATA1, EX_REG_DATA2, EX_BRANCH_CTRL, EX_BJ_SIG);

    //EX / MEM 
    EX_MEM_pipeline PIPELINE_REG_EX_MEM( CLK, RESET, EX_PC, EX_ALU_OUT, EX_REG_DATA2, EX_REG_WRITE_ADDR, EX_REG_WRITE_EN, EX_DATA_MEM_WRITE, EX_DATA_MEM_READ, EX_WB_VALUE_SELECT, MEM_PC, MEM_ALU_OUT, MEM_REG_DATA2, MEM_REG_WRITE_ADDR, MEM_REG_WRITE_EN, MEM_DATA_MEM_WRITE, MEM_DATA_MEM_READ, MEM_WB_VALUE_SELECT);

    ////////////IMEMF stage/////////////
    adder_4 PC_ADD(CLK, BUSYWAIT, RESET, MEM_PC, MEM_PC_PLUS_4);

    cache_controller DATA_CACHE_CONTROLLER(CLK, RESET, MEM_DATA_MEM_READ[3], MEM_DATA_MEM_WRITE[2], MEM_ALU_OUT, MEM_REG_DATA2, INSTRUCTION[14:12], DATA_MEM_READ_DATA, DATA_MEM_BUSYWAIT);

    //MEM / WB

    MEM_WB_pipeline PIPELINE_REG_MEM_WB(CLK, RESET, MEM_PC, MEM_ALU_OUT, DATA_MEM_READ_DATA, MEM_REG_WRITE_ADDR, MEM_REG_WRITE_EN,  MEM_WB_VALUE_SELECT, WB_PC, WB_ALU_OUT, WB_DATA_MEM_READ_DATA, WB_REG_WRITE_ADDR, WB_REG_WRITE_EN, WB_WB_VALUE_SELECT);

    ////////////WB stage/////////////
    mux_4to1 WB_VALUE_SELECT(WB_PC, WB_ALU_OUT, WB_DATA_MEM_READ_DATA, 32'd0, WB_VALUE, WB_WB_VALUE_SELECT);

    // PC Update
    always @ (posedge CLK)
    begin
        if (RESET == 1'b1)      // Reset PC to zero if RESET is asserted
            PC <= #1 32'd0;
        else if (!INSTR_MEM_BUSYWAIT || !DATA_MEM_BUSYWAIT)     // Stall PC if BUSYWAIT is asserted
            PC <= #1 PC_NEXT;
    end

endmodule