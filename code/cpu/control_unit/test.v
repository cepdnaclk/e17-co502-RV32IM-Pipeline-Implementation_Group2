module control_unit_tb;

    // Define test signals
    reg [31:0] Instruction;
    wire [4:0] ALU_sel;
    wire [3:0] mem_read;
    wire [2:0] mem_write;
    wire [3:0] branch_sel;
    wire [2:0] immeadiate_sel;
    wire [1:0] reg_write_sel;
    wire reg_write_EN;
    wire operand1_sel;
    wire operand2_sel;

    // Instantiate the control_unit module
    control_unit cu (
        .Instruction(Instruction),
        .ALU_sel(ALU_sel),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch_sel(branch_sel),
        .immeadiate_sel(immeadiate_sel),
        .reg_write_sel(reg_write_sel),
        .reg_write_EN(reg_write_EN),
        .operand1_sel(operand1_sel),
        .operand2_sel(operand2_sel)
    );

    // Test stimulus
    initial begin
        // Test case 1: A sample instruction
        Instruction = 32'h01234567; // You can replace this with your own instruction
        #10; // Allow some time for the module to process the input
        // Display the output signals
        $display("ALU_sel = %b", ALU_sel);
        $display("mem_read = %b", mem_read);
        $display("mem_write = %b", mem_write);
        $display("branch_sel = %b", branch_sel);
        $display("immeadiate_sel = %b", immeadiate_sel);
        $display("reg_write_sel = %b", reg_write_sel);
        $display("reg_write_EN = %b", reg_write_EN);
        $display("operand1_sel = %b", operand1_sel);
        $display("operand2_sel = %b", operand2_sel);
        $finish;
    end

endmodule

