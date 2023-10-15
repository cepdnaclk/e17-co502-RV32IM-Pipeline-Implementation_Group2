module load_use_hazard_unit (
    clk,
    reset,
    IsLoad,
    rd_mem,
    rs1_alu,
    rs2_alu,
    forward_from_wb_stage_to_rs1,
    forward_from_wb_stage_to_rs2,
    bubble_enable
);
    input IsLoad; //1-if load, 0-otherwise
    input clk, reset;
    input [4:0] rd_mem, rs1_alu, rs2_alu;
    //The‌ ‌data‌ ‌loaded‌ ‌from‌ ‌memory‌ ‌is‌ ‌needed‌ ‌to‌ ‌perform‌ ‌the‌ ‌add‌ ‌operation‌ ‌before‌ ‌the‌ ‌load‌‌ instruction‌ ‌writes‌ ‌back‌ ‌to‌ ‌the‌ ‌register‌ 
    //In‌‌ Load-Use‌‌ hazards,‌‌it‌‌ is‌‌ required‌‌ to‌‌ have‌‌ a‌‌ nop‌‌ because‌‌ the‌‌ data‌‌ is‌‌ready‌‌ in‌‌ the‌‌ mem‌‌ stage‌‌ at‌‌ the‌‌ end‌‌ of‌‌ the‌‌ clock‌‌ cycle‌‌ and‌‌ instruction‌‌ after‌‌ the‌‌ Load‌‌ instruction‌‌ needs‌‌ the‌‌ loaded‌‌ data‌‌ at‌ ‌the‌ ‌beginning‌ ‌of‌ ‌the‌ ‌clock‌ ‌cycle.

    //so a buble is introduced.
    output reg forward_from_wb_stage_to_rs1, forward_from_wb_stage_to_rs2, bubble_enable;

    //load use hazard detection
    wire comparing_with_rs1,comparing_with_rs2,buble;

    assign #1 rs1_xnor=(rd_mem~^rs1_alu);
    assign #1 rs2_xnor=(rd_mem~^rs2_alu);
    assign #1 comparing_with_rs1= (&rs1_xnor);
    assign #1 comparing_with_rs2= (&rs2_xnor);
    assign #1 buble = comparing_with_rs1 | comparing_with_rs2;

    always @(posedge clk) begin
        #1  //combinational logic delay
        //setting the signals
        if (IsLoad) begin  //check for a load instruction to introduce a buble
            forward_from_wb_stage_to_rs1=comparing_with_rs1;
            forward_from_wb_stage_to_rs2=comparing_with_rs1;
            bubble_enable=buble;
        end
        else begin //if it is not a load instruction, no buble is introduced
            forward_from_wb_stage_to_rs1=1'b0;
            forward_from_wb_stage_to_rs2=1'b0;
            bubble_enable=1'b0;    
        end
    end

    always @(reset) begin
        if (reset) begin
            //reset all signals to zero at the intialization stage
            forward_from_wb_stage_to_rs1=1'b0;
            forward_from_wb_stage_to_rs2=1'b0;
            bubble_enable=1'b0;
        end
    end
endmodule