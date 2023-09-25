module IF_ID_pipeline(
    pc_next_in, // 32 bits (PC + 4)
    if, // 32 bits instruction (instruction fetch)
    reset, //reset signal for this pipeline module
    clk, //clk signal

    pc_next_out, // 32 bits (PC + 4)
    id, //32 bits  (instruction decode)
); //Instruction Fetching and decoding pipeline

    input clk, reset;
    input [31:0] if, pc_next_in;
    output reg [31:0] id, pc_next_out;

    always @(posedge clk)
    begin
        if(reset)
        //assign zero for all registers
        begin
            pc_next_out <= 32'd0;
            id <= 32'd0;    
        end 
        else
        begin
	    pc_next_out <= pc_next_in;
            id <= if;
	
        end 
        
    end
    
endmodule