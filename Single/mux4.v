//mux:4 to 1
`include "define.v"

module mux4(
    input   [31:0] pc_add4,
    input   [31:0] zero,
    input   [31:0] branch,
    input   [31:0] pc_jump,
    input   [1:0]  sel,
    output  reg [31:0] result
);
    always @(*) begin
        case (sel)
            `NextIns: result = pc_add4;
            `Jump: result = pc_jump;
            `Branch: result = branch;
            `Zero: result = zero;
            default: result = pc_add4;
        endcase
    end
endmodule
