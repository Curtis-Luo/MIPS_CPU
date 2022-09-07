//Single Cycle MIPS CPU
`include "define.v"

module SingleCycleCPU(
    input wire clk,
    input wire rst_n
);
    //pc signal
    wire [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] pc_add4;
    wire [31:0] pc_branch;
    wire [31:0] pc_jump;

    //instruction decoder signal
    wire [31:0] inst;
    wire [5:0] op;
    wire [5:0] func;
    wire [4:0] sa;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] immd16;
    wire [25:0] immd26;

    //regfile signal
    wire regWr;
    wire [4:0] WriteReg;
    //assign WriteReg = (RegDst == `FromRt) ? rt : rd;
    wire [31:0] WriteData;
    wire [31:0] ALUResult;
    wire [31:0] RAMOut;
    //assign WriteData = (Wrback == `FromALU) ? ALUResult : RAMOut;
    wire [31:0] RD1;
    wire [31:0] RD2;

    //control unit signal
    //wire  [5:0] Func;
    //wire  [5:0] Op;
    wire  Zero;//zero signal,
    wire        Sign;//
    wire  [3:0] Aluc;//control the type of ALU data
    wire  AluSrcA;//control the data_in of ALU
    wire  AluSrcB;//control the data_in of ALU
    wire  [1:0] PcSrc;//control next_pc address
    wire  Wrback;//control the write back signal of reg file
    wire  RegDst;//control the update of reg file I-type or R-type
    wire  ExtSe;//control the extend module
    wire  memWr;//control the data memory write enable
    //wire  regWr;

    wire  [31:0] Extendimmd;
    wire  [31:0] immd_pc;
    wire  [31:0] alu_in_a;
    wire  [31:0] alu_in_b;
    wire  [31:0] alu_out;
    wire  [31:0] data_mem_out;
    wire  [31:0] sa_immd;
   
    PC pc_instance(
        .clk(clk),
        .rst_n(clk),
        .next_pc(next_pc),
        .pc(pc)
    );

    PCAdd pc_add4_instance(
        .pc(pc),
        .pc_add4(pc_add4)
    );

    instMEM instMEM_instance(
        .pc(pc),
	    .inst(inst)
    );

    decoder decoder_instance(
        .ins(inst),
        .op(op),
        .func(func),
        .sa(sa),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .immd16(immd16),
        .immd26(immd26)
    );

    RegFile RegFile_instance(
        .clk(clk),
        .rst_n(rst_n),
        .regWr(regWr),
        .RdReg1(rs),
        .RdReg2(rt),
        .WrReg(WriteReg),
        .WriteData(WriteData),//Write Back
        .RD1(RD1),
        .RD2(RD2)
    );

    mux2 mux2_instance(
        .rd(rd),//R-type
        .rt(rt),//I-type
        .sel(RegDst),
        .result(WriteReg)
    );

    Extend Extend_instance(
        .ExtSe(Extse),
        .immd16(immd16),
        .Extout(Extendimmd)
    );

    Lshift Lshift_instance(
        .in(Extendimmd),
        .shift(immd_pc)
    );

    PC_branch PC_branch_instance(
        .immd_pc(immd_pc),
        .pc_add4(pc_add4),
        .pc_branch(pc_branch)
    );

    mux2x32 mux2x32_instance_1(
        .Qb(RD2),//R-type
        .im(Extendimmd),//I-type
        .sel(AluSrcB),
        .result(alu_in_b)
    );

    Jshift Jshift_instance(
        .inst(immd26),
        .pc_add4(pc_add4),
        .sh(pc_jump)
    );

    ALU ALU_instance(
        .Aluc(Aluc),
        .a(alu_in_a),//op1
        .b(alu_in_b),//op2
        .out(alu_out),
        .zero(zero),
        .sign(Sign)
    );

    dataMEM dataMEM_instance(
        .clk(clk),
        .w_en(memWr),//1:sw 0:lw
        .wdata(RD2),
        .address(alu_out),
        .data_out(data_mem_out)
    );

    //write back
    mux2x32 mux2x32_instance_2(
        .Qb(alu_out),
        .im(data_mem_out),
        .sel(Wrback),
        .result(WriteData)
    );

    //selet srcA
    wire [15:0] SA;
    assign SA = {{11{1'b0}},sa};
    ZeroExt Zeroext_instance_1(
        .im(SA),
        .extend(sa_immd)
    );
    mux2x32 mux2x32_instance_3(
        .Qb(RD1),
        .im(sa_immd),
        .sel(AluSrcA),
        .result(alu_in_a)
    );

    Conunit Conunit_instance(
    .Func(func),
    .Op(op),
    .Zero(Zero),//zero signal,
    .Sign(Sign),//
    .Aluc(Aluc),//control the type of ALU data
    .AluSrcA(AluSrcA),//control the data_in of ALU
    .AluSrcB(AluSrcB),//control the data_in of ALU
    .PcSrc(PcSrc),//control next_pc address
    .Wrback(Wrback),//control the write back signal of reg file
    .RegDst(RegDst),//control the update of reg file I-type or R-type
    .ExtSe(Extse),//control the extend module
    .memWr(memWr),//control the data memory write enable
    .regWr(regWr)//control the reg file write enable
);

    mux4 mux4(
    .pc_add4(pc_add4),
    .zero(Zero),
    .branch(pc_branch),
    .pc_jump(pc_jump),
    .sel(PcSrc),
    .result(next_pc)
);


endmodule
