//module: Memory -> WriteBack
//MEM_WB

module MEM_WB(
    input           clk,
    input           rst_n,
    input           regWr_MEM,
    input           Wrback_MEM,

    input [31:0]    ReadMemData_MEM,
    input [31:0]    AluResult_MEM,
    input [4:0]     WriteReg_MEM,

    output reg      regWr_WB,
    output reg      Wrback_WB,

    output reg [31:0] ReadMemData_WB,
    output reg [31:0] AluResult_WB,
    output reg [4:0]  WriteReg_WB
);
    
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)begin
            regWr_WB            <=   0;
            Wrback_WB           <=   0;
            ReadMemData_WB      <=   0;
            AluResult_WB        <=   0;
            WriteReg_WB         <=   0;
        end
        else begin
            regWr_WB            <=   regWr_MEM;
            Wrback_WB           <=   Wrback_MEM;
            ReadMemData_WB      <=   ReadMemData_MEM;
            AluResult_WB        <=   AluResult_MEM;
            WriteReg_WB         <=   WriteReg_MEM;
        end
    end
    
endmodule