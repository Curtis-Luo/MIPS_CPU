//logic left shift: << 2
module Lshift(
    input   [31:0] in,
    output  [31:0] shift
);
    parameter  z = 2'b00;
    assign shift = {in[29:0], z};
endmodule