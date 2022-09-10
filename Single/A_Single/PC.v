//pc module


module PC(
    input               clk,
    input               rst_n,
    input       [31:0]  next_pc,
    output  reg [31:0]  pc
);


    always @(posedge clk, negedge rst_n) begin
        if(~rst_n)
            pc <= 32'd0;
        else
            pc <= next_pc;
    end

endmodule