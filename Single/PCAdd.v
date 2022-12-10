//module:add pc


module PCAdd(
    input       [31:0]  pc,
    output      [31:0]  pc_add4
);
    assign pc_add4 = pc + 32'd4;
endmodule
