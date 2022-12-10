//Zero extend
module ZeroExt(
    input   [15:0] im,
    output  [31:0]extend
);
    assign extend = {{16{1'b0}},im};
endmodule