//module: Forward

`include "define.v"
module Forward(
    input  [4:0] rs_EX,
    input  [4:0] rt_EX,
    input  [4:0] rs_ID,
    input  [4:0] rt_ID,
    input  [4:0] WriteReg_MEM,
    input  [4:0] WriteReg_WB,
    input  regWr_MEM,
    input  regWr_WB,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output reg ForwardAD,
    output reg ForwardBD
);
    initial begin
        ForwardAE = `Not_Forward;
        ForwardBE = `Not_Forward;
        ForwardAD = `Not_Forward;
        ForwardBD = `Not_Forward;
    end

    always @(*) begin
        if((rs_EX != 0) && (rs_EX == WriteReg_MEM) && (regWr_MEM ==1))
            ForwardAE = `Forward_MEM;
        else if((rs_EX != 0) && (rs_EX == WriteReg_WB) && (regWr_WB ==1))
            ForwardAE = `Forward_WB;
        else ForwardAE = `Not_Forward;

        if ((rt_EX != 0) && (rt_EX == WriteReg_MEM) && (regWr_MEM ==1))
            ForwardBE = `Forward_MEM;
        else if ((rt_EX != 0) && (rt_EX == WriteReg_WB) && (regWr_WB ==1))
            ForwardBE = `Forward_WB;
        else ForwardBE = `Not_Forward;

        if ((rs_ID != 0) && (rs_ID== WriteReg_MEM) && (regWr_MEM ==1))
            ForwardAD = `Forward_ALU;
        else ForwardAD = `Not_Forward_ALU;

        if ((rt_ID != 0) && (rt_ID== WriteReg_MEM) && (regWr_MEM ==1))
            ForwardBD = `Forward_ALU;
        else ForwardBD = `Not_Forward_ALU;
    end


endmodule


