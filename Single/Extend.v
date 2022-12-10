//module Extend

module Extend(
    input   ExtSe,
    input   [15:0] immd16,
    output  [31:0] Extout
);
    wire [31:0] signext;
    wire [31:0] zeroext;

    signExt signExt_instance(
    .im(immd16),
    .extend(signext)
);  
    ZeroExt Zeroext_instance(
    .im(immd16),
    .extend(zeroext)
); 
    assign Extout = (ExtSe) ? signext : zeroext;
    
endmodule