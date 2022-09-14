//control unit
`include "define.v"

module Conunit(
    input   wire  [5:0] Func,
    input   wire  [5:0] Op,
    input   wire  [4:0] rt,//distinguish the BGEZ and BLTZ
    input   wire        Zero,//zero signal,
    input   wire        Sign,//
    output  reg   [3:0] Aluc,//control the type of ALU data
    output  reg          AluSrcA,//control the data_in of ALU
    output  reg          AluSrcB,//control the data_in of ALU
    output  reg    [1:0] PcSrc,//control next_pc address
    output  reg          Wrback,//control the write back signal of reg file
    output  reg          RegDst,//control the update of reg file I-type or R-type
    output  reg          ExtSe,//control the extend module
    output  reg          memWr,//control the data memory write enable
    output  reg          regWr//control the reg file write enable
);
    //Aluc[3:0]**************
    always @(*) begin
        case (Op)
            `opRFormat: begin
                case(Func)
                    `funcADD: Aluc =`ALUAdd;
                    `funcADDU: Aluc =`ALUAdd;
                    `funcSUB: Aluc =`ALUSub;
                    `funcSUBU: Aluc =`ALUSub;
                    `funcAND: Aluc =`ALUAnd;
                    `funcXOR: Aluc =`ALUXor;
                    `funcOR: Aluc =`ALUOr;
                    `funcSLL: Aluc =`ALUSll;
                    `funcSLLV: Aluc =`ALUSll;
                    `funcSLT: Aluc =`ALUCmps;
                    `funcSLTU: Aluc =`ALUCmpu;
                    `funcSRLV: Aluc =`ALUSrl;
                    `funcSRA,`funcSRAV: Aluc =`ALUSra;
                    `funcSRL: Aluc =`ALUSrl;
                    //`funcJR: 
                    //`funcJAR 6'b001001
                    default: Aluc = `ALUAdd;
                endcase
            end
            `opADDI: Aluc = `ALUAdd;
            `opADDIU: Aluc = `ALUAdd;
            `opANDI: Aluc = `ALUAnd;
            //`opLUI 6'b001111
            `opORI: Aluc = `ALUOr;
            `opSLTI: Aluc = `ALUCmps;
            `opSLTIU: Aluc = `ALUCmpu;
            `opXORI: Aluc = `ALUXor;////////
            `opSW: Aluc = `ALUAdd;
            `opLW: Aluc = `ALUAdd;
            `opSB: Aluc = `ALUAdd;
            `opLB: Aluc = `ALUAdd;////////
            `opBEQ: Aluc =`ALUSub;
            `opBNE: Aluc =`ALUSub;
            `opBGEZ: Aluc =`ALUSubZero;
            `opBGTZ: Aluc =`ALUSubZero;
            `opBLEZ: Aluc =`ALUSubZero;
            `opBLTZ: Aluc =`ALUSubZero;///
            `opLUI: Aluc = `ALUJoint;
            //`opBGEZ: Aluc = `ALUSubZero;
            //`opJ
            //`opJAL
            //`opJR
            `opNOOP: Aluc = `ALUAdd;
            default: Aluc = `ALUAdd;
        endcase
    end

    //AluSrcA
    always @(*) begin
        case({Op,Func})
            {`opSLL,`funcSLL},{`opSRA,`funcSRA},{`opSRL,`funcSRL}: AluSrcA = `FromSA;
            default: AluSrcA = `FromData;
        endcase
    end

    //AluSrcB
    always @(*) begin
        case(Op)
            `opADDI,`opADDIU,`opSLTI,`opSLTIU: AluSrcB = `FromImmd;
            `opORI,`opLUI,`opXORI: AluSrcB = `FromImmd;
            `opSW,`opLW,`opSB,`opLB: AluSrcB = `FromImmd;
            `opNOOP: AluSrcB = `FromImmd;
            default: AluSrcB = `FromData;
        endcase
    end

    //PcSrc
    always @(*) begin
        case(Op)
            `opJAL,`opJ: PcSrc = `Jump;
            `opJR: begin
                case (Func)
                    `funcJR: PcSrc = `Jump; 
                    default: PcSrc = `NextIns;
                endcase
            end
            `opBEQ: PcSrc = (Zero == 1) ? `Branch : `NextIns;
            `opBNE: PcSrc = (Zero == 0) ? `Branch : `NextIns;
            `opBGTZ: PcSrc = (Sign == 0 && Zero == 0) ? `Branch : `NextIns;
            `opBLTZ: begin//or `opBGEZ
                case (rt)
                    5'd1: PcSrc = (Sign == 0) ? `Branch : `NextIns;//BGEZ
                    default: PcSrc = (Sign == 1) ? `Branch : `NextIns;//BLTZ   
                endcase
            end
            //`opBLTZ: PcSrc = (Sign == 1) ? `Branch : `NextIns;   
            //`opBGEZ: PcSrc = (Sign == 0) ? `Branch : `NextIns;
            `opBLEZ: PcSrc = (Sign == 1 || Zero == 0) ? `Branch : `NextIns;
            `opNOOP: PcSrc = `NOOP;
            default:PcSrc = `NextIns;
        endcase
    end

    //Wrback
    always @(*) begin
        case(Op)
            `opLW,`opLB: Wrback = `FromDM;
            default: Wrback = `FromALU;
        endcase
    end
    
    //RegDst
    always @(*) begin
        case(Op)
            `opADDIU,`opSLTI,`opSLTIU: RegDst = `FromRt;
            `opNOOP: RegDst = `FromRt;
            `opLW,`opLB: RegDst = `FromRt;
            `opADDI,`opORI,`opANDI,`opXORI,`opLUI: RegDst = `FromRt;
            default: RegDst = `FromRd;
        endcase
    end

    //ExtSe
    always @(*) begin
        case(Op)
            `opORI,`opANDI,`opXORI: ExtSe = `ZeroExd;
            default: ExtSe = `SignExd;
        endcase
    end

    //memWr
    always @(*) begin
        case(Op)
            `opSW,`opSB: memWr = 1;
            default: memWr = 0;
        endcase
    end

    //regWr
    always @(*) begin
        case(Op)
            `opSW,`opSB,`opBEQ,`opBNE,`opBGTZ,`opBGEZ,`opBLTZ,`opBLEZ: regWr = 0;
            `opJ,`opJAL: regWr = 0;
            `opJR: begin
                case (Func)
                    `funcJR: regWr = 0;
                    default: regWr = 1;
                endcase
            end
            default regWr = 1;
        endcase
    end
    

endmodule