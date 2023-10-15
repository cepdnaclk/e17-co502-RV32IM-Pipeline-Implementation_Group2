module immediate_unit (INSTRUCTION, IMMEDIATE_SEL, IMMEDIATE);
    input [31:0] INSTRUCTION;
    input [2:0] IMMEDIATE_SEL;
    output [31:0] IMMEDIATE;

    always @ (*)
    begin
        case (IMMEDIATE_SEL)
            3'b000:
                IMMEDIATE <= #1 {INSTRUCTION[31:12], 12'b0}; //U-type
            3'b001:
                IMMEDIATE <= #1 {{12{INSTRUCTION[31]}}, INSTRUCTION[19:12], INSTRUCTION[20], INSTRUCTION[30:21], 1'b0}; //J-type
            3'b010:
                IMMEDIATE <= #1 {{21{INSTRUCTION[31]}}, INSTRUCTION[30:20]};  //I-type
            3'b011:
                IMMEDIATE <= #1 {{20{INSTRUCTION[31]}}, INSTRUCTION[7], INSTRUCTION[30:25], INSTRUCTION[11:8], 1'b0}; //B-type
            3'b100:
                IMMEDIATE <= #1 {{21{INSTRUCTION[31]}}, INSTRUCTION[30:25], INSTRUCTION[11:7]};   //S-type  
            default:
                IMMEDIATE <= #1 32'd0;
        endcase
    end
endmodule