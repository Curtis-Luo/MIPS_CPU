//module RegFile

module RegFile(
    input clk,
    input rst_n,
    input regWr,
    input [4:0] RdReg1,
    input [4:0] RdReg2,
    input [4:0] WrReg,
    input [31:0] WriteData,//Write Back
    output [31:0] RD1,
    output [31:0] RD2
);
    reg [31:0] regfile [0:31];
    integer i;

    assign RD1 = (RdReg1 == 0) ? 0 : regfile[RdReg1];
    assign RD2 = (RdReg2 == 0) ? 0 : regfile[RdReg2];

    always @(posedge clk, negedge rst_n) begin
        if(~rst_n)
            for (i = 0; i<31; i=i+1) begin
                regfile[i] <= 32'd0;
            end
        else if(regWr == 1 && WrReg != 0)
            regfile[WrReg] <= WriteData;
    end

endmodule