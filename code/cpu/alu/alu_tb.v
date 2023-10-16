`timescale 1ns/100ps

module alu_tb;

    reg [31:0] DATA1, DATA2;
    reg [4:0] SELECT;
    wire [31:0] RESULT;

    // Instantiate the alu module
    alu uut (
        .DATA1(DATA1),
        .DATA2(DATA2),
        .SELECT(SELECT),
        .RESULT(RESULT)
    );

    // Define the VCD file and variables to dump
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // Rest of your testbench logic
        // ...
    end

    // Testbench logic
    initial begin
        // Test 1: ADD operation
        DATA1 = 32'b00000000000000000000000000000001;  // 1
        DATA2 = 32'b00000000000000000000000000000010;  // 2
        SELECT = 5'b00000;                           // ADD
        $display("Running ADD Test:");
        $display("Input DATA1: %h", DATA1);
        $display("Input DATA2: %h", DATA2);
        $display("Input SELECT: %b", SELECT);
        #10; // Add a delay
        $display("Result: %h", RESULT);
        $display(""); // Blank line for separation

        // Test 2: SUB operation
        DATA1 = 32'b00000000000000000000000000000101;  // 5
        DATA2 = 32'b00000000000000000000000000000011;  // 3
        SELECT = 5'b10000;   
        $display("Running SUB Test:");
        $display("Input DATA1: %h", DATA1);
        $display("Input DATA2: %h", DATA2);
        $display("Input SELECT: %b", SELECT);
        #10; // Add a delay
        $display("Result: %h", RESULT);
        $display(""); // Blank line for separation

        // Test 3: SLL operation
        DATA1 = 32'b00000000000000000000000000000100;  // 4
        DATA2 = 5'b00010;                            // Shift left by 2
        SELECT = 5'b00001; 
        $display("Running SLL Test:");
        $display("Input DATA1: %h", DATA1);
        $display("Input DATA2: %h", DATA2);
        $display("Input SELECT: %b", SELECT);
        #10; // Add a delay
        $display("Result: %h", RESULT);
        $display(""); // Blank line for separation

        // Test 4: AND operation
        DATA1 = 32'b00101010;                         // Some bit pattern
        DATA2 = 32'b01011101;                         // Another bit pattern
        SELECT = 5'b00100;                            // AND
        $display("Running AND Test:");
        $display("Input DATA1: %h", DATA1);
        $display("Input DATA2: %h", DATA2);
        $display("Input SELECT: %b", SELECT);
        #10; // Add a delay
        $display("Result: %h", RESULT);
        $display(""); // Blank line for separation

        // Test 5: OR operation
        DATA1 = 32'h00F0F0F0;                         // Some bit pattern
        DATA2 = 32'h0F0F0F0F;                         // Another bit pattern
        SELECT = 5'b00101;                            // OR
        $display("Running OR Test:");
        $display("Input DATA1: %h", DATA1);
        $display("Input DATA2: %h", DATA2);
        $display("Input SELECT: %b", SELECT);
        #10; // Add a delay
        $display("Result: %h", RESULT);
        $display(""); // Blank line for separation

        // Finish simulation
        $finish;
    end
endmodule
