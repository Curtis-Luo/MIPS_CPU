//moculinput  [4:0] e Hazard Unit

module HazardUnit(
    input  [4:0] rs_EX,
    input  [4:0] rt_EX,
    input  [4:0] rs_ID,
    input  [4:0] rt_ID,
    input  [4:0] WriteReg_MEM,
    input  [4:0] WriteReg_WB,
    input  regWr_MEM,
    input  regWr_WB,
    input  [4:0] WriteReg_EX,
    input  Branch_ID,
    input  regWr_EX,
    input  Wrback_EX,
    output [1:0] ForwardAE,
    output [1:0] ForwardBE,
    output ForwardAD,
    output ForwardBD,
    output Stall_IF,
    output Stall_ID,
    output Flush_EX
);

    Forward Forward_instance(
        .rs_EX(rs_EX),
        .rt_EX(rt_EX),
        .rs_ID(rs_ID),
        .rt_ID(rt_ID),
        .WriteReg_MEM(WriteReg_MEM),
        .WriteReg_WB(WriteReg_WB),
        .regWr_MEM(regWr_MEM),
        .regWr_WB(regWr_WB),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD)
    );

    Stall Stall_instance(
        .rs_ID(rs_ID),
        .rt_ID(rt_ID),
        .rt_EX(rt_EX),
        .WriteReg_EX(WriteReg_EX),
        .WriteReg_MEM(WriteReg_MEM),
        .Branch_ID(Branch_ID),
        .regWr_EX(regWr_EX),
        .regWr_MEM(regWr_MEM),
        .Wrback_EX(Wrback_EX),
        .Stall_IF(Stall_IF),
        .Stall_ID(Stall_ID),
        .Flush_EX(Flush_EX)
    );

endmodule