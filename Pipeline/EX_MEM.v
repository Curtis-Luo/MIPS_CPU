//module: Execute -> Memory
//EX_MEM
module EX_MEM(
    input       clk,
    input       rst_n,
    input       memWr_EX,
    input       regWr_EX,
    input       Wrback_EX,

    input [31:0] AluResult_EX,
    input [31:0] WriteMemData_EX,
    input [4:0]  WriteReg_EX,

    output reg        memWr_MEM,           
    output reg        regWr_MEM,
    output reg        Wrback_MEM,
 
    output reg [31:0] AluResult_MEM,
    output reg [31:0] WriteMemData_MEM,
    output reg [4:0]  WriteReg_MEM  
);
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)begin
            memWr_MEM           <= 0;        
            regWr_MEM           <= 0;
            Wrback_MEM          <= 0;
            AluResult_MEM       <= 0;
            WriteMemData_MEM    <= 0;
            WriteReg_MEM        <= 0;
        end
        else begin
            memWr_MEM           <= memWr_EX;        
            regWr_MEM           <= regWr_EX;
            Wrback_MEM          <= Wrback_EX;
            AluResult_MEM       <= AluResult_EX;
            WriteMemData_MEM    <= WriteMemData_EX;
            WriteReg_MEM        <= WriteReg_EX;
        end
    end

endmodule