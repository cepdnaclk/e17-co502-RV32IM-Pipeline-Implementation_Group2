module adder_4 (PCin, PCout);

    input [31:0] PCin;
    output [31:0] PCout;

    assign #2 PCout = PCin + 4;

endmodule