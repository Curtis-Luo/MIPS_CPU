//shift combination
module Jshift(
    input   [25:0] inst,
    input   [31:0] pc_add4,
    output  [31:0] sh
    ); 
    parameter z = 2'b00;
    assign sh = {pc_add4[31:28],inst[25:0],z};
endmodule