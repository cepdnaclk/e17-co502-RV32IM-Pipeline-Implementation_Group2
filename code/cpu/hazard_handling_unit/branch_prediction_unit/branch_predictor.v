module Branch_Predictor(reset,ID_PC,EX_PC, flush); //in the IF stage

    input reset, Branch_Signal,ID_STAGE_BRANCH,Branch_Signal,Branch_Signal_OUT;
    input [2:0] ID_PC,EX_PC; // last 3 bits of PC value in IF-ID pipeline, ID-EX pipeline
    
    reg [1:0] prediction[0:7]; //8 registers (2-bits) to store recent predictions (branch target buffer)
    output reg flush,signal_to_take,EARLY_PREDICTION;

    //initialization at reset
    parameter BRANCH_TAKEN_STRONG = 2'b00, BRANCH_TAKEN_WEAK =2'b01, BRANCH_NOTTAKEN_WEAK =2'b10, BRANCH_NOTTAKEN_STRONG =2'b11;
    integer i;
    always @(reset) begin
        flush=1'b0; //no flush
        for (i = 0; i < 8; i++ ) begin
            prediction[i]=2'b00;
        end
    end
    

    //prediction, this will decide based on BTF, to take the branch or not
    //when this signal is set to 0, no problem regular instruction happens
    always @(*) begin
        if (ID_STAGE_BRANCH) begin
            case (prediction[ID_PC])
                BRANCH_TAKEN_STRONG:
                    signal_to_take=1'b1;
                BRANCH_TAKEN_WEAK:
                    signal_to_take=1'b1;
                BRANCH_NOTTAKEN_WEAK:
                    signal_to_take=1'b0;
                BRANCH_NOTTAKEN_STRONG:
                    signal_to_take=1'b0;
            endcase   
        end
        else begin
            signal_to_take=1'b0;
        end
    end

    //EX_PC is the value corresponding to previous instruction
    //ID_PC is the value coressponding to the next instruction
    //this section updates BTB based on result of branch_control_unit
    always @(*) begin
    if (Branch_Signal) begin    //"Branch_Signal_OUT" getting from branch control unit to check whether our prediction is correct
        case (prediction[EX_PC])
            BRANCH_TAKEN_STRONG:
                if (Branch_Signal_OUT) begin                //prediction is correct
                    prediction[EX_PC]=2'b00;
                    flush=1'b0;                             //no need to flush pipeline
                end
                else begin                                       //prediction is incorrect
                    prediction[EX_PC]=2'b01;
                    flush=1'b1;                                   //pipelines should be flushed 
                    EARLY_PREDICTION=1'b1;                       // PC should be given PC+4 value that got from alu stage
                end
            BRANCH_TAKEN_WEAK:
                if (Branch_Signal_OUT) begin               //prediction is correct
                    prediction[EX_PC]=2'b00;
                    flush=1'b0;
                end
                else begin                                       //prediction is incorrect
                    prediction[EX_PC]=2'b10;
                    flush=1'b1;
                    EARLY_PREDICTION=1'b1;
                end
            BRANCH_NOTTAKEN_WEAK:
                if (Branch_Signal_OUT) begin               //prediction is incorrect
                    prediction[EX_PC]=2'b01;
                    flush=1'b1;
                    EARLY_PREDICTION=1'b0;      // PC should be given the (b_imm + PC) from ALU stage(ALU stage should have the calculaed value from the dedicated adder)
                end
                else begin                                       //prediction is correct
                    prediction[EX_PC]=2'b11;
                    flush=1'b0;
                end
            BRANCH_NOTTAKEN_STRONG:
                if (Branch_Signal_OUT) begin               //prediction is incorrect
                    prediction[EX_PC]=2'b10;
                    flush=1'b1;
                    EARLY_PREDICTION=1'b0;
                end
                else begin                                        //prediction is incorrect
                    prediction[EX_PC]=2'b11;
                    flush=1'b0;
                end
        endcase   
    end
    else begin
        flush = 1'b0;
    end

    
end
endmodule