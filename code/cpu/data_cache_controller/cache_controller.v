/////////////////////////////////////////////
// Advanced Computer Architecture (CO502)  //
// Design : Data cache controller          // 
// Group  : 2                              //
/////////////////////////////////////////////

`include "../data_cache/data_cache.v"
`include "../data_memory/data_memory.v"

module cache_controller (
    // inputs
    CLK,
    RESET,
    READ_EN, // read enable signal
    WRITE_EN, // write enable signal
    ADDRESS, // read or write ADDRESS ,alu result
    WRITEDATA, // write data
    FUNC3,
    // outputs
    READ_DATA, // read data
	BUSYWAIT
);
    input RESET,READ_EN,WRITE_EN,CLK;
    input [31:0] ADDRESS,WRITEDATA;
    
    output reg BUSYWAIT;
    output reg [31:0] READ_DATA;

    input [2:0] FUNC3;


    wire [31:0] cache_read_data;
    wire cache_BUSYWAIT,cache_read,cache_write;
    reg mem_read,mem_write;
    wire mem_BUSYWAIT;
    wire [127:0] mem_readdata;
    reg [127:0] mem_WRITEDATA;
    reg [27:0] mem_ADDRESS;
    reg [31:0] store_data;
    
    wire [127:0] cache_mem_WRITEDATA;
    wire [27:0] cache_mem_ADDRESS;
    wire cache_mem_read,cache_mem_write,cache_mem_BUSYWAIT;



    //DLC
    reg [31:0] readdata_from_mem;

    assign lb ={{24{readdata_from_mem[7]}},readdata_from_mem[7:0]}; // take last 8 bits and 24 of sign bit
    assign lbu ={{24{1'b0}},readdata_from_mem[7:0]}; // take last 8 bits and 24 of zero values and extend
    assign lh ={{16{readdata_from_mem[15]}},readdata_from_mem[15:0]}; // take last 16 bits and 16 of sign bit
    assign lhu ={{16{1'b0}},readdata_from_mem[15:0]}; // take last 16 bits and 16 of zero values end extend

    always @(*) begin
        case(FUNC3)
            3'b000:begin
                READ_DATA<=lb;
            end
            3'b001:begin
                READ_DATA<=lh;
            end
            3'b010:begin
                READ_DATA<=readdata_from_mem; // load the word 32 bit
            end
            3'b100:begin
                READ_DATA<=lbu;
            end
            default:begin
                READ_DATA<=lhu;
            end
        endcase
    end


    //DSC
    assign sb ={{24{1'b0}},WRITEDATA[7:0]};
    assign sh ={{16{1'b0}},WRITEDATA[15:0]};

    //block which check which data that should be stored in the cache memory
    always @(*)begin
        case(FUNC3)
            3'b000: begin    //store byte
                store_data <= sb;
            end
            3'b001: begin   //store half word
                store_data <= sh;
            end
            3'b010:begin       //store full word
                store_data <= WRITEDATA;
            end
            default:begin       //store full word
                store_data <= WRITEDATA;
            end
        endcase
    end



    // read or write enable for cache cores
    and(cache_read,READ_EN,1'b1);
    and(cache_write,WRITE_EN,1'b1);

    // generate busy wait signals for cache cores
    and(cache_mem_BUSYWAIT,1'b1,mem_BUSYWAIT);

    dcache data_cache(CLK,RESET,cache_read,cache_write,ADDRESS,store_data,cache_read_data,cache_BUSYWAIT,cache_mem_read,cache_mem_write,cache_mem_ADDRESS,cache_mem_WRITEDATA,mem_readdata,cache_mem_BUSYWAIT);

    data_memory my_data_memory(CLK,RESET,mem_read,mem_write,mem_ADDRESS,mem_WRITEDATA,mem_readdata,mem_BUSYWAIT);



    always @(*) begin
        READ_DATA <= cache_read_data;
        BUSYWAIT <= cache_BUSYWAIT;
        mem_read <= cache_mem_read;
        mem_write <= cache_mem_write;
        mem_ADDRESS <= cache_mem_ADDRESS;
        mem_WRITEDATA <= cache_mem_WRITEDATA;
    end

endmodule