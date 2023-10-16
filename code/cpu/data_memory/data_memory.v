/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Data memory                    // 
// Group  : 2                              //
/////////////////////////////////////////////

`timescale 1ns/100ps

module data_memory(CLK, RESET, READ_EN, WRITE_EN, ADDRESS, WRITE_DATA, READ_DATA, BUSYWAIT);
input CLK;
input RESET;
input READ_EN;
input WRITE_EN;
input[27:0] ADDRESS;
input[127:0] WRITE_DATA;
output reg [127:0] READ_DATA;
output reg BUSYWAIT;


// Declare memory array 1024x8-bits 
reg [7:0] memory_array [63:0];


// Detecting an incoming memory access
reg [3:0]counter;
reg readaccess, writeaccess;


always @(*)
begin
	BUSYWAIT <= ((READ_EN || WRITE_EN)&& counter!=4'b1111)? 1 : 0;
	readaccess <= (READ_EN && !WRITE_EN)? 1'b1 : 1'b0;
	writeaccess <= (!READ_EN && WRITE_EN)? 1'b1 : 1'b0;
end



always @(posedge CLK,posedge RESET) begin
    if (RESET) begin
        counter <= 4'b0000;
    end
    else if(readaccess || writeaccess)
    begin
        counter <= counter + 4'b0001;
    end
end

//Reading & writing
always @(posedge CLK, posedge RESET)
begin
        
        case (counter)
            4'b0000:begin
                READ_DATA[7:0]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b0001:begin
                READ_DATA[15:8]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b0010:begin
                READ_DATA[23:16]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b0011:begin
                READ_DATA[31:24]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b0100:begin
                READ_DATA[39:32]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b0101:begin
                READ_DATA[47:40]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b0110:begin
                READ_DATA[55:48]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b0111:begin
                READ_DATA[63:56]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b1000:begin
                READ_DATA[71:64]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b1001:begin
                READ_DATA[79:72]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b1010:begin
                READ_DATA[87:80]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b1011:begin
                READ_DATA[95:88]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b1100:begin
                READ_DATA[103:96]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b1101:begin
                READ_DATA[111:104]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b1110:begin
                READ_DATA[119:112]=memory_array[{ADDRESS[27:0],counter}];
            end
            4'b1111:begin
                READ_DATA[127:120]=memory_array[{ADDRESS[27:0],counter}];
            end 
        endcase

        case (counter)
            4'b0000:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[7:0];
            end
            4'b0001:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[15:8];
            end
            4'b0010:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[23:16];
            end
            4'b0011:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[31:24];
            end
            4'b0100:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[39:32];
            end
            4'b0101:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[47:40];
            end
            4'b0110:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[55:48];
            end
            4'b0111:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[63:56];
            end
            4'b1000:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[71:64];
            end
            4'b1001:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[79:72];
            end
            4'b1010:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[87:80];
            end
            4'b1011:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[95:88];
            end
            4'b1100:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[103:96];
            end
            4'b1101:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[111:104];
            end
            4'b1110:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[119:112];
            end
            4'b1111:begin
                memory_array[{ADDRESS[27:0],counter}]=WRITE_DATA[127:120];
            end
        endcase

end

endmodule