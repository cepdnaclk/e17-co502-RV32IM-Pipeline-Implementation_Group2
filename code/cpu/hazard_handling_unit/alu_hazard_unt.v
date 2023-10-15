module Alu_hazard_unit (
    input clk,
    input reset,
    Dest_MEM,
    Dest_ALU,
    ID_rs1, 
    ID_rs2, 
    forward_from_MEM_stage_to_rs1_signal,
    forward_from_MEM_stage_to_rs2_signal,
    forward_from_WB_stage_to_rs1_signal,
    forward_from_WB_stage_to_rs2_signal
);
input clk,reset;
input [4:0] Dest_ALU, Dest_MEM, ID_rs1, ID_rs2;
output reg forward_from_MEM_stage_to_rs1_signal, forward_from_MEM_stage_to_rs2_signal, forward_from_WB_stage_to_rs1_signal, forward_from_WB_stage_to_rs2_signal;
wire [4:0] xnor_EX_rs1,xnor_EX_rs2,xnor_MEM_rs1,xnor_MEM_rs2;
wire comparing_with_EX_rs1,comparing_with_EX_rs2,comparing_with_MEM_rs1,comparing_with_MEM_rs2;

assign #1 xnor_EX_rs1=(Dest_ALU~^ID_rs1);
assign #1 xnor_EX_rs2=(Dest_ALU~^ID_rs2);

assign #1 xnor_MEM_rs1=(Dest_MEM~^ID_rs1);
assign #1 xnor_MEM_rs2=(Dest_MEM~^ID_rs2);

assign #1 comparing_with_EX_rs1= (&xnor_EX_rs1);
assign #1 comparing_with_EX_rs2= (&xnor_EX_rs2);

assign #1 comparing_with_MEM_rs1= (&xnor_MEM_rs1);
assign #1 comparing_with_MEM_rs2= (&xnor_MEM_rs2);


always @(posedge clk) begin
    #1
    forward_from_MEM_stage_to_rs1_signal=comparing_with_EX_rs1;
    forward_from_MEM_stage_to_rs2_signal=comparing_with_EX_rs2;

    forward_from_WB_stage_to_rs1_signal=comparing_with_MEM_rs1;
    forward_from_WB_stage_to_rs2_signal=comparing_with_MEM_rs2;
end

always @(reset) begin
	if(reset==1'b1) begin
        #1
        forward_from_MEM_stage_to_rs1_signal=1'b0;
        forward_from_MEM_stage_to_rs2_signal=1'b0;
        forward_from_WB_stage_to_rs1_signal=1'b0;
        forward_from_WB_stage_to_rs2_signal=1'b0;	                        
	end
end

    
endmodule