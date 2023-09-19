module ID_EX_pipeline (
    clk,reset,
    pc_next_in, 
    reg_data1_in, reg_data2_in, immediate_in,
    branch_sel_in, alu_sel_in, 
    operand1_sel_in, operand2_sel_in, mem_write_in, mem_read_in, reg_write_en_in, reg_write_sel_in,
    
    pc_next_out, 
    reg_data1_out, reg_data2_out, immediate_out,
    branch_sel_out, alu_sel_out, 
    operand1_sel_out, operand2_sel_out, mem_write_out, mem_read_out, reg_write_en_out, reg_write_sel_out,
    
);

    input clk,reset;

    input [31:0] pc_next_in, reg_data1_in, reg_data2_in, immediate_in;
    input [4:0] alu_sel_in;
    input [2:0] branch_sel_in, reg_write_sel_in;
    input [1:0] mem_write_in, mem_read_in;
    input operand1_sel_in, operand2_sel_in, reg_write_en_in;

    output reg[31:0] pc_next_out, reg_data1_out, reg_data2_out, immediate_out;
    output reg[4:0] alu_sel_out;
    output reg[2:0] branch_sel_out, reg_write_sel_out;
    output reg[1:0] mem_write_out, mem_read_out;
    output reg operand1_sel_out, operand2_sel_out, reg_write_en_out;

    always @ (posedge CLK)
    begin
        if (reset)
        begin
            pc_next_out <=  32'd0;
            reg_data1_out <= 32'd0;
            reg_data2_out <= 32'd0;
            immediate_out <= 32'd0;
            branch_sel_out <= 3'd0;
            alu_sel_out <= 5'd0;
            operand1_sel_out <= 1'b0;
            operand2_sel_out <= 1'b0;
            mem_read_out  <= 2'd0;
            mem_write_out <= 2'd0;
            reg_write_en_out <= 1'b0;
            reg_write_sel_out <= 3'd0;
        end
        else
        begin
            pc_next_out <=  pc_next_in;
            reg_data1_out <= reg_data1_in;
            reg_data2_out <= reg_data2_in;
            immediate_out <= immediate_in;
            branch_sel_out <= branch_sel_in;
            alu_sel_out <= alu_sel_in;
            operand1_sel_out <= operand1_sel_in;
            operand2_sel_out <= operand2_sel_in;
            mem_read_out  <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_en_out <= reg_write_en_in;
            reg_write_sel_out <= reg_write_sel_in;
        end
    end