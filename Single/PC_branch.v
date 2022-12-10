//module PC Branch

module PC_branch(
    input   [31:0] immd_pc,
    input   [31:0] pc_add4,
    output  [31:0] pc_branch
);
    assign pc_branch = immd_pc + pc_add4;

endmodule