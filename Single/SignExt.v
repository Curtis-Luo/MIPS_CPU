//sign extend
module signExt(
    input   [15:0] im,
    output  [31:0] extend
);
    assign extend = {{16{im[15]}},im};
endmodule