//mux 2 to 1 for ALU

module mux2x32(
    input   wire [31:0] Qb,//R-type
    input   wire [31:0] im,//I-type
    input   wire        sel,
    output  reg [31:0]  result
);
    always @(*) begin
        case (sel)
            1'b0: result = Qb;
            1'b1: result = im;
            default: result = Qb;
        endcase
    end

endmodule