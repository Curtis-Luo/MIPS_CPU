//mux:4 to 1
module mux2(
    input   [31:0] pc_add4,
    input   [31:0] zero,
    input   [31:0] branch,
    input   [31:0] pc_jump,
    input   [1:0]  sel,
    output  reg [31:0] result
);
    always @(*) begin
        case (sel)
            2'b00: result = pc_add4;
            2'b01: result = zero;
            2'b10: result = branch;
            2'b11: result = pc_jump;
            default: result = pc_add4;
        endcase
    end
endmodule