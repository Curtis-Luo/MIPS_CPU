//module: mux2Forward
`include "define.v"

module mux2Forward(
    input  [31:0] RD,
    input  [31:0] forward_ALU,
    input    selet,
    output reg [31:0] data_out
);
    always @(*) begin
        case(selet)
            `Not_Forward_ALU: data_out = RD;
            `Forward_ALU: data_out = forward_ALU;
            default: data_out = RD;
        endcase
    end

endmodule