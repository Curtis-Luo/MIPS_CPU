//module: Branch Predict

`include "define.v"
module BranchPredict(
    input  [3:0]  Aluc,
    input  [31:0] in_a,
    input  [31:0] in_b,
    output reg Zero,
    output reg Sign
);
    reg [31:0] out;

    always @(*) begin
        case (Aluc)
            `ALUSub: out = in_a - in_b;
            `ALUSubZero: out = in_a - 32'd0;
            default: out = 1'b1;
        endcase

        if (out == 0) Zero = 1;
        else Zero = 0;
        
        Sign = out[31];
    end

endmodule