//module mux: 2 to 1
module mux2(
    input   [4:0] rd,//R-type
    input   [4:0] rt,//I-type
    input         sel,
    output  reg [4:0] result
);
    always @(*) begin
        case (sel)
            1'b0: result = rd;
            1'b1: result = rt; 
            default: result = rd;
        endcase
    end

endmodule