//pc module


module PC(
    input               clk,
    input               rst_n,
    input               Stall_IF,//1: stall 0:not stall
    input       [31:0]  next_pc,
    output  reg [31:0]  pc
);

    always @(posedge clk, negedge rst_n) begin
        if(~rst_n)
            pc <= 32'd0;
        else if(Stall_IF != 1'b1)
            pc <= next_pc;
        else pc <= pc;
    end

endmodule