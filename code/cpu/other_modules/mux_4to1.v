/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Mux 4 to 1                     // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale 1ns/100ps

module mux_4to1 (INPUT1, INPUT2, INPUT3, INPUT4, RESULT, SELECT);

    input [31:0] INPUT1, INPUT2, INPUT3, INPUT4;
    input [1:0] SELECT;
    output reg [31:0] RESULT;

    always @ (*)
    begin
        if (SELECT == 2'b00)
            RESULT = INPUT1;
        else if (SELECT == 2'b01)
            RESULT = INPUT2;
        else if (SELECT == 2'b10)
            RESULT = INPUT3;
        else
            RESULT = INPUT4;
    end

endmodule