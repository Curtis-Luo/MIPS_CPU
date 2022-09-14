//module mux: 2 to 1
`include "define.v"
module mux2(
    input   [4:0] rd,//R-type
    input   [4:0] rt,//I-type
    input         sel,
    output  reg [4:0] result
);
    always @(*) begin
        case (sel)
            `FromRt: result = rt;
            `FromRd: result = rd; 
            default: result = rd;
        endcase
    end

endmodule