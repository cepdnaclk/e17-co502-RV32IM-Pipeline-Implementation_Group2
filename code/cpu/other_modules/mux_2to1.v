/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Mux 2 to 1                     // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale 1ns/100ps

module mux_2to1 (INPUT1, INPUT2, RESULT, SELECT);

    input [31:0] INPUT1, INPUT2;
    input SELECT;
    output reg [31:0] RESULT;

    always @ (*)
    begin
        if (SELECT == 1'b0)
            RESULT = INPUT1;
        else
            RESULT = INPUT2;
    end

endmodule