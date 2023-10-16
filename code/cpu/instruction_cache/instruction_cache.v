`include "../instruction_memory/instruction_memory.v"

module i_cache(
    ADDR,
    CLK,
    RESET,
    INSTRUCTION,
    BUSYWAIT
);

    input RESET,CLK;
    input [31:0] ADDR;

    output reg BUSYWAIT;
    output reg [31:0] INSTRUCTION;

    wire VALID, MEM_BUSYWAIT;
    wire [1:0] OFFSET;
    wire [2:0] INDEX;
    wire [127:0] READ_DATA;
    wire [24:0] TAG;

    reg hit, MEM_READ, WRITE_FROM_MEM;
    reg VALID_BITS [0:7];
    reg [24:0] TAGS [0:7];
    reg [31:0] WORD [0:7][0:3];
    reg [27:0] MEM_ADDR;

    i_mem I_MEM(
        MEM_READ,
        MEM_ADDR,
        CLK,
        RESET,
        READ_DATA,
        MEM_BUSYWAIT
    );

    assign VALID = VALID_BITS[ADDR[6:4]];
    assign TAG = TAGS[ADDR[6:4]];
    assign INDEX = ADDR[6:4];
    assign OFFSET = ADDR[3:2];

    always @(*) begin // Extract the data from word
        INSTRUCTION <= WORD[INDEX][OFFSET];
    end

    always @(*) begin // Check whather hit or miss
        if((TAG == ADDR[31:7]) && VALID) begin
            hit <= 1'b1;
        end
        else begin
            hit <= 1'b0;
        end
    end

    always @(negedge CLK,posedge RESET) begin
        if(RESET)begin
			for (integer i =0 ;i<8 ;i = i+1 ) begin
                VALID_BITS[i] <= 1'b0;
            end
		  end
        else if (WRITE_FROM_MEM) begin //write data get from instruction memory
            VALID_BITS[INDEX] <= 1;
            TAGS[INDEX] <= ADDR[31:7];
            {WORD[INDEX][3],WORD[INDEX][2],WORD[INDEX][1],WORD[INDEX][0]} <= READ_DATA;
        end
    end

    parameter IDLE_STATE = 3'b000, MEM_READ_STATE = 3'b001, CACHE_WRITE_STATE=3'b011;
    reg [2:0] state, next_state;
    // Combinational next state logic
    always @(*)
    begin
        case (state)
            // Normal state
            IDLE_STATE:
                if (!hit)  
                    next_state <= MEM_READ_STATE;
                else
                    next_state <= IDLE_STATE;
            // Memory read state
            MEM_READ_STATE:
                if (!MEM_BUSYWAIT)
                    next_state <= CACHE_WRITE_STATE;
                else    
                    next_state <= MEM_READ_STATE;
            // Chache write state
            CACHE_WRITE_STATE:
                    next_state <= IDLE_STATE;
        endcase
    end

    // Combinational output logic
    always @(*)
    begin
        case(state)
            IDLE_STATE:
            begin
                MEM_READ <= 0;
                BUSYWAIT <= 0;
                WRITE_FROM_MEM <= 0;  
            end
         
            MEM_READ_STATE: 
            begin
                MEM_READ <= 1;
                MEM_ADDR <= ADDR[31:4];
                BUSYWAIT <= 1;
                WRITE_FROM_MEM <= 0;
            end
            CACHE_WRITE_STATE:
            begin
                MEM_READ <= 0;
                BUSYWAIT <= 1;
                WRITE_FROM_MEM <= 1;// This signal assert when data block is come from memoey in this state
            end
        endcase
    end

    // Sequential logic for state transitioning
    always @(negedge CLK, posedge RESET)
    begin
        if(RESET)begin
            state <= IDLE_STATE;
        end
        else
            state <= next_state;
    end 

endmodule