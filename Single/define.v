// ALUopcode
`define ALUAdd 4'd0
`define ALUSub 4'd1
`define ALUAnd 4'd2
`define ALUOr 4'd3
`define ALUCmpu 4'd4
`define ALUCmps 4'd5
`define ALUSll 4'd6
`define ALUXor 4'd7
`define ALUSra 4'd8
`define ALUSrl 4'd9
`define ALUJoint 4'd10
`define ALUSubZero 4'd11
//`define ALUZero 4'd11;

// ALUSrcA, ALUSrcB
`define FromData 1'b0
`define FromSA 1'b1
`define FromImmd 1'b1

// DBDataSrc
`define FromALU 1'b0
`define FromDM 1'b1

// RegDst
`define FromRt 1'b0
`define FromRd 1'b1

// ExtSel
`define ZeroExd 1'b0
`define SignExd 1'b1

// PCSrc
`define NextIns 2'b00
`define Jump 2'b01 
`define Branch 2'b10 
`define Zero 2'b11 

// for instruction
// op code
`define opRFormat 6'b000000
`define opADD 6'b000000
`define opADDU 6'b000000
//`define opNOOP 6'b000000
`define opSUB 6'b000000
`define opSUBU 6'b000000
`define opAND 6'b000000
`define opOR 6'b000000
`define opXOR 6'b000000
`define opSLL 6'b000000
`define opSLLV 6'b000000
`define opSLT 6'b000000
`define opSLTU 6'b000000
`define opSRLV 6'b000000
`define opSRA 6'b000000
`define opSRL 6'b000000

`define opADDI 6'b001000
`define opADDIU 6'b001001
`define opANDI 6'b001100
`define opLUI 6'b001111
`define opORI 6'b001101
`define opSLTI 6'b001010
`define opSLTIU 6'b001011
`define opXORI 6'b001110
`define opLUI 6'b001111

`define opSW 6'b101011
`define opLW 6'b100011
`define opSB 6'b101000
`define opLB 6'b100000

`define opBEQ 6'b000100
`define opBNE 6'b000101
`define opBGEZ 6'b000001
`define opBGTZ 6'b000111
`define opBLEZ 6'b000110
`define opBLTZ 6'b000001

`define opJ 6'b000010
`define opJAL 6'b000011
`define opJR 6'b000000
//`define opJALR 6'b000000

//`define opHALT 6'b111111

// func code
`define funcADD 6'b100000
`define funcADDU 6'b100001
`define funcSUB 6'b100010
`define funcSUBU 6'b100011
`define funcAND 6'b100100
`define funcXOR 6'b100110
`define funcOR 6'b100101
`define funcSLL 6'b000000
`define funcSLLV 6'b000100
`define funcSLT 6'b101010
`define funcSLTU 6'b101011
`define funcSRLV 6'b000110
`define funcSRA 6'b000011
`define funcSRAV 6'b000111
`define funcSRL 6'b000010
`define funcJR 6'b001000
//`define funcJAR 6'b001001
