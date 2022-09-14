//module: Instruction Decoder -> Execute
//ID_EX
module ID_EX(
    input clk,
    input rst_n,
    input Flush_ID,

    input [3:0] Aluc_ID,
    input       AluSrcA_ID,
    input       AluSrcB_ID,
    input       memWr_ID,
    input       Wrback_ID,
    input       RegDst_ID,
    input       regWr_ID,

    input [31:0] RD1_ID,
    input [31:0] RD2_ID,

    input [31:0] ImmSa_ID,
    input [31:0] Imm32_ID,

    input [4:0]  rs_ID,
    input [4:0]  rt_ID,
    input [4:0]  rd_ID,

    output reg [3:0] Aluc_EX,
    output reg       AluSrcA_EX,
    output reg       AluSrcB_EX,
    output reg       memWr_EX,
    output reg       regWr_EX,
    output reg       RegDst_EX,
    output reg       Wrback_EX,


    output reg [31:0] RD1_EX,
    output reg [31:0] RD2_EX,

    output reg [31:0] ImmSa_EX,
    output reg [31:0] Imm32_EX,

    output reg [4:0]  rs_EX,
    output reg [4:0]  rt_EX,
    output reg [4:0]  rd_EX
);


    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)begin
            AluSrcA_EX      <= 0;
            AluSrcB_EX      <= 0;
            Aluc_EX         <= 0;
            memWr_EX        <= 0;
            regWr_EX        <= 0;
            RegDst_EX       <= 0;
            Wrback_EX       <= 0;
            RD1_EX          <= 0;
            RD2_EX          <= 0;
            ImmSa_EX        <= 0;
            Imm32_EX        <= 0;
            rs_EX           <= 0;
            rt_EX           <= 0;
            rd_EX           <= 0;
        end
        else begin
            RD1_EX          <= RD1_ID;
            RD2_EX          <= RD2_ID;
            ImmSa_EX        <= ImmSa_ID;
            Imm32_EX        <= Imm32_ID;
            rs_EX           <= rs_ID;
            rt_EX           <= rt_ID;
            rd_EX           <= rd_ID;
            if(Flush_ID) begin
                AluSrcA_EX      <= 0;
                AluSrcB_EX      <= 0;
                Aluc_EX         <= 0;
                memWr_EX        <= 0;
                regWr_EX        <= 0;
                RegDst_EX       <= 0;
                Wrback_EX       <= 0;
            end else begin
                AluSrcA_EX      <=    AluSrcA_ID;
                AluSrcB_EX      <=    AluSrcB_ID;
                Aluc_EX         <=    Aluc_ID;
                memWr_EX        <=    memWr_ID;
                regWr_EX        <=    regWr_ID;
                RegDst_EX       <=    RegDst_ID;
                Wrback_EX       <=    Wrback_ID;
            end
        end
        
    end
    
endmodule