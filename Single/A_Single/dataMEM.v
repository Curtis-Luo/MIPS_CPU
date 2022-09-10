//data memory
module dataMEM(
    input           clk,
    input           w_en,//1:sw 0:lw
    input  [31:0]   wdata,
    input  [31:0]   address,
    output [31:0]   data_out
);
    reg [31:0] data_mem [0:255];

    //initial $readmemh("./data_mem.txt",data_mem);

    assign data_out = data_mem[address[6:2]];

    always @(posedge clk) begin
        if(w_en)
            data_mem[address[6:2]] <= wdata;
        else data_mem[address[6:2]] <= data_mem[address[6:2]];
    end


endmodule