//module: noop_reg

module noop_reg(
    input clk,
    input [31:0] noop_in,
    output reg [31:0] noop_out
);
    always @(posedge clk) begin
        noop_out <= noop_in;
    end

endmodule