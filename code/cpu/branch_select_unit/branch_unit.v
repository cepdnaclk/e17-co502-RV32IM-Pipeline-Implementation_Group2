module Branch_unit(branch_sel, input1, input2, branch_output);
    input [3:0] branch_sel;
    input [31:0] input1, input2;    //DATA1, DATA2 respectively, after comparing them, output will be decided
    output reg branch_output;
    //according to logic of control unit branch_sel[3] will decide whether it is a regular instruction or a branch/jump instruction
    //if branch_output == 1 -> pc will be updated with new pc value (not pc + 4)
    //else pc -> pc + 4
    //if given condition is true, branch_output will be 1
    always @ (*)
    begin
        if (SELECT[3])    //not a regular instruction
        begin
            case (SELECT[2:0]) // base on the other 3 bits type of the branch/jump instruction will be selected
            
                3'b000: //func3 = 000 -> BEQ
                    branch_output <= #1 (input1 == input2);
                
                3'b001: //func3 = 001 -> BNE
                    branch_output <= #1 (input1 != input2);
                
                3'b100:  //func3 = 100 -> BLT
                    branch_output <= #1 ($signed(input1) < $signed(input2));
                
                3'b101:  //func3 = 101 -> BGE
                    branch_output <= #1 ($signed(input1) >= $signed(input2));
                
                3'b110:  //func3 = 110 -> BLTU
                    branch_output <= #1 ($unsigned(input1) < $unsigned(input2)); 
                
                3'b111:  //func3 = 111 -> BGEU
                    branch_output <= #1 ($unsigned(input1) >= $unsigned(input2)); 
                
                // for JAL and JALR
                3'b010: //genetared from control unit (not from instruction)
                    branch_output <= #1 1'b1; 

                //for any other combination    
                default:
                    branch_output <= #1 1'b0;
            endcase
        end
        else    //regular instruction
        begin
            branch_output <= #1 1'b0;
        end
    end
endmodule