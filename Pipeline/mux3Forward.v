//module: mux3Forward
`include "define.v"

module mux3Forward(
    input  [31:0] RD,
    input  [31:0] forward_MEM,
    input  [31:0] forward_WB,
    input  [1:0]  selet,
    output reg [31:0] data_out
);
    always @(*) begin
        case(selet)
            `Not_Forward: data_out = RD;
            `Forward_MEM: data_out = forward_MEM;
            `Forward_WB:  data_out = forward_WB;
            default: data_out = RD;
        endcase
    end

endmodule