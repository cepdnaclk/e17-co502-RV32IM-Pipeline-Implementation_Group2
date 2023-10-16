module adder_4 (CLK, BUSYWAIT, RESET, PCin, PCout);

    input CLK, RESET, BUSYWAIT;
    input [31:0] PCin;
    output reg [31:0] PCout;

    always @ (posedge CLK) begin
        #1
        if(!RESET) // & !BUSYWAIT)  
			#2 PCout <= PCin + 4;
    end

    //reset the register to -4 whenever the reset signal changes from low to high
    always @ (posedge CLK) begin
		#1
        if(RESET)  
			#2 PCout = -32'd4;
    end

endmodule