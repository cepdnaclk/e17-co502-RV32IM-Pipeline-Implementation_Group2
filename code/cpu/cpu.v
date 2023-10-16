`include "../alu/alu.v"
`include "../register_file/register_file.v"

`include "../immediate_generation_unit/immediate_generation_unit.v"
`include "../control_unit/control_unit.v"
`include "../branch_control_unit/branch_control_unit.v"

`include "../pipeline_registers/pr_if_id.v"
`include "../pipeline_registers/pr_id_ex.v"
`include "../pipeline_registers/pr_ex_mem.v"
`include "../pipeline_registers/pr_mem_wb.v"

`include "../support_modules/plus_4_adder.v"
`include "../support_modules/mux_4to1_32bit.v"
`include "../support_modules/mux_2to1_32bit.v"

`timescale 1ns/100ps

module cpu (
    CLK, RESET, PC, INSTRUCTION, DATA_MEM_READ, DATA_MEM_WRITE,
    DATA_MEM_ADDR, DATA_MEM_WRITE_DATA, DATA_MEM_READ_DATA,
    DATA_MEM_BUSYWAIT, INSTR_MEM_BUSYWAIT
);

    input CLK, RESET;                               // Clock and reset pins
    input DATA_MEM_BUSYWAIT, INSTR_MEM_BUSYWAIT;    // Busywait signals
    input [31:0] INSTRUCTION;           // Instruction fetched from instruction memory
    input [31:0] DATA_MEM_READ_DATA;    // Data fetched from data memory

    output [2:0] DATA_MEM_WRITE;    // Write control signal for data memory
    output [3:0] DATA_MEM_READ;     // Read control signal for data memory
    output [31:0] DATA_MEM_ADDR, DATA_MEM_WRITE_DATA;   // Address line and data out to data memory
    output reg [31:0] PC;               // Program Counter

    /******************* Connection wires *******************/
    // IF
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


    /****************************************** TODO: IF stage ******************************************/
    //Adder to calculate PC+4
    plus_4_adder IF_PC_PLUS_4_ADDER (PC, PC_PLUS_4);

    //Mux to select between PC+4 and branch target
    mux_2to1_32bit BRANCH_SELECT_MUX (PC_PLUS_4, EX_ALU_OUT, PC_NEXT, EX_BJ_SIG);

    /****************************************** TODO: IF / ID ******************************************/
    pr_if_id PIPELINE_REG_IF_ID (CLK, RESET, PC, INSTRUCTION, ID_PC, ID_INSTRUCTION);

    /****************************************** TODO: ID stage ******************************************/
    // Control unit 
    control_unit ID_CONTROL_UNIT (ID_INSTRUCTION, ID_ALU_SELECT, ID_REG_WRITE_EN, ID_DATA_MEM_WRITE, ID_DATA_MEM_READ, ID_BRANCH_CTRL, ID_IMMEDIATE_SELECT, ID_OPERAND1_SELECT, ID_OPERAND2_SELECT, ID_WB_VALUE_SELECT);

    //Register file
    reg_file ID_REGISTER_FILE (WB_WRITEBACK_VALUE, ID_REG_DATA1, ID_REG_DATA2, WB_REG_WRITE_ADDR, ID_INSTRUCTION[19:15], ID_INSTRUCTION[24:20], WB_REG_WRITE_EN, CLK, RESET);

    //Immediate generation unit
    immediate_generation_unit ID_IMMEDIATE_GEN_UNIT (ID_INSTRUCTION, ID_IMMEDIATE_SELECT, ID_IMMEDIATE);

    /****************************************** TODO: ID / EX ******************************************/
    pr_id_ex PIPELINE_REG_ID_EX (CLK, RESET, ID_PC, ID_REG_DATA1, ID_REG_DATA2, ID_IMMEDIATE, ID_INSTRUCTION[11:7], ID_ALU_SELECT, ID_OPERAND1_SELECT, ID_OPERAND2_SELECT, ID_REG_WRITE_EN, ID_DATA_MEM_WRITE, ID_DATA_MEM_READ, ID_BRANCH_CTRL, ID_WB_VALUE_SELECT, EX_PC, EX_REG_DATA1, EX_REG_DATA2, EX_IMMEDIATE, EX_REG_WRITE_ADDR, EX_ALU_SELECT, EX_OPERAND1_SELECT, EX_OPERAND2_SELECT, EX_REG_WRITE_EN, EX_DATA_MEM_WRITE, EX_DATA_MEM_READ, EX_BRANCH_CTRL, EX_WB_VALUE_SELECT);


    /****************************************** TODO: EX stage ******************************************/
    //OP1 select mux
    mux_2to1_32bit EX_OP1_SELECT_MUX (EX_REG_DATA1, EX_PC, EX_ALU_DATA1, EX_OPERAND1_SELECT);

    //OP2 select mux
    mux_2to1_32bit EX_OP2_SELECT_MUX (EX_REG_DATA2, EX_IMMEDIATE, EX_ALU_DATA2, EX_OPERAND2_SELECT);

    //ALU 
    alu EX_ALU (EX_ALU_DATA1, EX_ALU_DATA2, EX_ALU_OUT, EX_ALU_SELECT);

    //Branch control unit
    branch_control_unit EX_BRANCH_CTRL_UNIT (EX_REG_DATA1, EX_REG_DATA2, EX_BRANCH_CTRL, EX_BJ_SIG);

    /****************************************** TODO: EX / MEM ******************************************/
    pr_ex_mem PIPELINE_REG_EX_MEM( CLK, RESET, EX_PC, EX_ALU_OUT, EX_REG_DATA2, EX_REG_WRITE_ADDR, EX_REG_WRITE_EN, EX_DATA_MEM_WRITE, EX_DATA_MEM_READ, EX_WB_VALUE_SELECT, MEM_PC, MEM_ALU_OUT, MEM_REG_DATA2, MEM_REG_WRITE_ADDR, MEM_REG_WRITE_EN, MEM_DATA_MEM_WRITE, MEM_DATA_MEM_READ, MEM_WB_VALUE_SELECT);


    /****************************************** TODO: MEM stage ******************************************/

    plus_4_adder PC_ADD(MEM_PC, MEM_PC_PLUS_4);

    assign DATA_MEM_ADDR =  MEM_ALU_OUT;
    assign DATA_MEM_WRITE_DATA =  MEM_REG_DATA2;
    assign DATA_MEM_READ =  MEM_DATA_MEM_READ;
    assign DATA_MEM_WRITE =  MEM_DATA_MEM_WRITE;


    /****************************************** TODO: MEM / WB ******************************************/

    pr_mem_wb PIPELINE_REG_MEM_WB(CLK, RESET, MEM_PC, MEM_ALU_OUT, DATA_MEM_READ_DATA, MEM_REG_WRITE_ADDR, MEM_REG_WRITE_EN,  MEM_WB_VALUE_SELECT, WB_PC, WB_ALU_OUT, WB_DATA_MEM_READ_DATA, WB_REG_WRITE_ADDR, WB_REG_WRITE_EN, WB_WB_VALUE_SELECT);

    /****************************************** TODO: WB stage ******************************************/

    mux_4to1_32bit WB_VALUE_SELECT(WB_PC, WB_ALU_OUT, WB_DATA_MEM_READ_DATA, 32'd0, WB_VALUE, WB_WB_VALUE_SELECT);


    // PC Update
    always @ (posedge CLK)
    begin
        if (RESET == 1'b1)      // Reset PC to zero if RESET is asserted
            PC <= #1 32'd0;
        else if (!INSTR_MEM_BUSYWAIT || !DATA_MEM_BUSYWAIT)     // Stall PC if BUSYWAIT is asserted
            PC <= #1 PC_NEXT;
    end

endmodule



























/*
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
`include "other_modules/adder_4.v"

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
   
    wire [31:0] PC_4, PC_next; //in the case of jump or branch instructions, PC is not PC_4

    wire [31:0] ID_PC, ID_INSTRUCTION, ID_REG_DATA1, ID_REG_DATA2, ID_IMMEDIATE; //stores in IF_ID_pipeline
    
    //outputs of control unit
    wire [4:0] ALU_sel;
    wire [3:0] mem_read;
    wire [2:0] mem_write;
    wire [3:0] branch_sel;
    wire [2:0] immediate_sel;
    wire [1:0] reg_write_sel;
    wire reg_write_EN, operand1_sel, operand2_sel;

    wire Branch_Jump_Signal; //output of branch target unit

    //output of immediate unit
    wire [31:0] IMMEDIATE_ID;
    //inputs to regFile
    wire WRITE_REG_EN;
    wire [4:0] REG_WRITE_ADDRESS, REG_READ_ADDRESS1, REG_READ_ADDRESS2;
    wire [31:0] WRITE_REG;
    
    //outputs of regFile
    wire [31:0] REG_OUT1, REG_OUT2; 

    //outputs of ID_EX pipeline
    wire [31:0] EX_PC, EX_REG_OUT1, EX_REG_OUT2, IMMEDIATE_EX, EX_REG_WRITE_ADDR;
    wire [3:0] branch_sel_EX, mem_read_EX;
    wire [4:0] ALU_sel_EX; 
    wire [2:0] mem_write_EX;
    wire [1:0] reg_write_sel_EX;
    wire operand1_sel_EX, operand2_sel_EX, reg_write_EN_EX;

    //outputs of 2to1 muxes and alu
    wire [31:0] MUX1_OUT, MUX2_OUT, ALU_OUT;

    //output of Branch_Unit
    wire Branch_Jump_Signal;

    //outputs of EX_MEM pipeline
    wire [31:0] MEM_PC, MEM_REG_OUT2, MEM_ALU_OUT, MEM_REG_WRITE_ADDR, MEM_PC_4;
    wire [3:0] mem_read_MEM;
    wire [2:0] mem_write_MEM;
    wire [1:0] reg_write_sel_MEM;
    wire reg_write_EN_MEM;

    //outputs of data mem
    wire [31:0] DATA_MEM_OUT;

    //outputs of MEM_WB pipeline
    wire [31:0] WB_PC, DATA_MEM_OUT_WB, WB_ALU_OUT, WB_REG_WRITE_ADDR;
    wire [1:0] reg_write_sel_WB;
    wire reg_write_EN_WB;

    wire [31:0] WB_result;
    
    //IF stage
    adder_4 PC_PLUS_4_ADDER (PC, PC_4);
    mux_2to1 Branch_select_mux(PC_4, ALU_OUT, PC_next, Branch_Jump_Signal);

    //pipeline IF_ID 
    IF_ID_pipeline IF_ID_pipeline(PC, INSTRUCTION, RESET, CLK,  ID_PC, ID_INSTRUCTION);

    //ID stage
    //first necessary control signals should be generated
    control_unit Control_Unit(ID_INSTRUCTION, ALU_sel, reg_write_EN, mem_write, mem_read, branch_sel, immediate_sel, operand1_sel, operand2_sel, reg_write_sel);

    immediate_unit Immediate_Unit(ID_INSTRUCTION, immediate_sel, IMMEDIATE_ID);

    //use reister file to get DATA1, DATA2
    reg_file RegFile(WRITE_REG, REG_OUT1, REG_OUT2, REG_WRITE_ADDRESS, REG_READ_ADDRESS1, REG_READ_ADDRESS2, WRITE_REG_EN, CLK, RESET);

    //pipeline ID_EX
    ID_EX_pipeline ID_EX_Pipeline(CLK,RESET,ID_PC, 
    REG_OUT1, REG_OUT2, IMMEDIATE_ID, branch_sel, ALU_sel, 
    operand1_sel, operand2_sel, mem_write, mem_read, reg_write_EN, reg_write_sel,
    EX_PC, EX_REG_OUT1, EX_REG_OUT2, IMMEDIATE_EX, branch_sel_EX, ALU_sel_EX, 
    operand1_sel_EX, operand2_sel_EX, mem_write_EX, mem_read_EX, reg_write_EN_EX, reg_write_sel_EX);

    //EX stage
    mux_2to1 Mux_2to1(EX_REG_OUT1, EX_PC, MUX1_OUT, operand1_sel_EX);
    mux_2to1 Mux_2to1(EX_REG_OUT2, IMMEDIATE_EX, MUX2_OUT, operand2_sel_EX);
    alu ALU(MUX1_OUT, MUX2_OUT, ALU_sel_EX, ALU_OUT);

    //Branch control unit
    Branch_unit Branch_Unit(branch_sel, EX_REG_OUT1, EX_REG_OUT2, Branch_Jump_Signal);

    //EX_MEM pipeline
    EX_MEM_pipeline EX_MEM_Pipeline(CLK, RESET, 
    EX_PC, ALU_OUT, EX_REG_OUT2,
    EX_REG_WRITE_ADDR, 
    reg_write_EN_EX, mem_write_EX, mem_read_EX, reg_write_sel_EX,

    MEM_PC, MEM_ALU_OUT, MEM_REG_OUT2,
    MEM_REG_WRITE_ADDR,  
    reg_write_EN_MEM, mem_write_MEM, mem_read_MEM, reg_write_sel_MEM);

    //mem stage
    adder_4 Adder_4(MEM_PC, MEM_PC_4);

    //MEM_WB pipeline
    MEM_WB_pipeline MEM_WB_Pipeline(CLK, RESET, 
    MEM_PC, MEM_ALU_OUT,
    DATA_MEM_OUT,
    MEM_REG_WRITE_ADDR, reg_write_EN_MEM, reg_write_sel_MEM,

    WB_PC, WB_ALU_OUT, 
    DATA_MEM_OUT_WB,
    WB_REG_WRITE_ADDR, reg_write_EN_WB, reg_write_sel_WB);

    mux_4to1 Mux_4to1(WB_PC, WB_ALU_OUT, DATA_MEM_OUT_WB, 32'd0, WB_result, reg_write_sel_WB);

    always@(posedge CLK)
    begin
        if (RESET == 1'b1)      // Reset PC to zero if RESET is asserted
            PC <= #1 32'd0;
        else if (!INSTR_MEM_BUSYWAIT || !DATA_MEM_BUSYWAIT)     // Stall PC if BUSYWAIT is asserted
            PC <= #1 PC_next;
    end

endmodule
*/