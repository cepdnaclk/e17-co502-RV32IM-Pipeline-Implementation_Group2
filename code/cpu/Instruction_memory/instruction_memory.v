/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Instruction Memory             // 
// Group  : 2                              //
/////////////////////////////////////////////

module i_mem(
    READ_EN,
    READ_ADDR,
    CLK,
    RESET,
    READ_DATA,
    BUSYWAIT
);

    input READ_EN, CLK, RESET;
    input [27:0] READ_ADDR;

    output reg BUSYWAIT;
    output reg [127:0] READ_DATA;

    reg [3:0] COUNTER;
    reg READ_ACCESS;

    reg [7:0] MEM_ARRAY [0:1023];

    initial 
    begin
    $readmemh("instructions.mem", MEM_ARRAY);
    end

    always @(*)
    begin
        BUSYWAIT <= (READ_EN && COUNTER!=4'b1111)? 1 : 0;
        READ_ACCESS <= (READ_EN)? 1'b1 : 1'b0;
    end

    always @(posedge CLK,posedge RESET)
    begin
        case (COUNTER)
            4'b0000:begin
                READ_DATA[7:0]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b0001:begin
                READ_DATA[15:8]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b0010:begin
                READ_DATA[23:16]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b0011:begin
                READ_DATA[31:24]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b0100:begin
                READ_DATA[39:32]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b0101:begin
                READ_DATA[47:40]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b0110:begin
                READ_DATA[55:48]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b0111:begin
                READ_DATA[63:56]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b1000:begin
                READ_DATA[71:64]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b1001:begin
                READ_DATA[79:72]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b1010:begin
                READ_DATA[87:80]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b1011:begin
                READ_DATA[95:88]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b1100:begin
                READ_DATA[103:96]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b1101:begin
                READ_DATA[111:104]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b1110:begin
                READ_DATA[119:112]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end
            4'b1111:begin
                READ_DATA[127:120]=MEM_ARRAY[{READ_ADDR[27:0],COUNTER}];
            end 
        endcase
    end
endmodule