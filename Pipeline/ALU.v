/***************
module:ALU
**************/
`include "define.v"

module ALU(
        input       [3:0]   Aluc,
        input       [31:0]  a,//op1
        input       [31:0]  b,//op2
        output  reg [31:0]  out
        //output  reg         zero,
        //output  reg         sign
);

    always @(*) begin
        case (Aluc)
            `ALUAdd: out = a + b;
            `ALUSub: out = a - b;
            `ALUAnd: out = a & b;
            `ALUOr: out = a | b;
            `ALUCmpu: out = (a < b) ? 1: 0;// 不带符号比较
            `ALUCmps: begin //带符号比较
                if (a < b &&((a[31] == 0 && b[31]==0) ||
                    (a[31] == 1 && b[31]==1))) out = 1;
                else if (a[31] == 0 && b[31]==1) out = 0;
                else if (a[31] == 1 && b[31]==0) out = 1;
                else out = 0;
            end
            `ALUSll: out = b << a;
            `ALUXor: out = a ^ b;
            `ALUSra: out = b >>> a;
            `ALUSrl: out = b >> a;
            `ALUJoint: out = {b,16'd0};//LUI instruction
            `ALUSubZero: out = a - 32'd0;
            //`ALUZero: out = a - b;
            default: out = a + b;
        endcase

        //if (out == 0) zero = 1;
        //else zero = 0;
        
        //sign = out[31];
    end

    


endmodule
