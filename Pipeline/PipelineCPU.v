//A 5-stage pipeline MIPS CPU
`include "define.v"

module PipelineCPU(
    input wire clk,
    input wire rst_n
);
    //pc signal
    wire [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] pc_branch;
    wire [31:0] pc_jump;
    wire [1:0]  PcSrc;

    wire Stall_IF;
    wire Flush_IF;
    assign Flush_IF = (PcSrc == `Jump || PcSrc == `Branch) ? 1'b1 : 1'b0;//assign command
    wire [31:0] PC_IF;
    wire [31:0] Instruction_IF;

    wire [31:0] PC_ID;
    wire [31:0] Instruction_ID;
    wire Stall_ID;
    wire Flush_ID;//?
    wire [3:0] Aluc_ID;
    wire AluSrcA_ID;
    wire AluSrcB_ID;
    wire memWr_ID;
    wire Wrback_ID;
    wire RegDst_ID;
    wire regWr_ID;
    wire [31:0] RD1_ID;
    wire [31:0] RD2_ID;
    wire [31:0] ImmSa_ID;
    wire  [31:0] Imm32_ID;
    wire Branch_ID;
    assign Branch_ID = (PcSrc == `Jump || PcSrc == `Branch) ? 1'b1 : 1'b0;//assign command
    wire ForwardAD;
    wire ForwardBD;
    
    wire [3:0] Aluc_EX;
    wire       AluSrcA_EX;
    wire       AluSrcB_EX;
    wire       memWr_EX;
    wire       regWr_EX;
    wire       RegDst_EX;
    wire       Wrback_EX;
    wire [31:0] RD1_EX;
    wire [31:0] RD2_EX;
    wire [31:0] ImmSa_EX;
    wire [31:0] Imm32_EX;
    wire [4:0]  rs_EX;
    wire [4:0]  rt_EX;
    wire [4:0]  rd_EX;
    wire [31:0] Alu_out_EX;
    wire [31:0] WriteMemData_EX;
    wire [4:0] WriteReg_EX;
    wire Flush_EX;
    assign Flush_ID = Flush_EX;// assign command
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;

    wire memWr_MEM;     
    wire regWr_MEM;
    wire Wrback_MEM;
    wire [31:0] Alu_out_MEM;
    wire [31:0] WriteMemData_MEM;
    wire  [4:0] WriteReg_MEM;
    wire  [31:0] data_mem_out_MEM;

    wire regWr_WB;
    wire Wrback_WB;
    wire  [31:0] data_mem_out_WB;
    wire [31:0] Alu_out_WB;
    wire [4:0] WriteReg_WB;
    wire [31:0] WriteData_WB;

    wire [5:0] op;
    wire [5:0] func;
    wire [4:0] sa;
    wire [4:0] rs_ID;
    wire [4:0] rt_ID;
    wire [4:0] rd_ID;
    wire [15:0] immd16;
    wire [25:0] immd26;

    wire  Zero;//zero signal,
    wire  Sign;//
    //wire  [3:0] Aluc;//control the type of ALU data
    //wire  AluSrcA;//control the data_in of ALU
    //wire  AluSrcB;//control the data_in of ALU
    //wire  [1:0] PcSrc;//control next_pc address
    //wire  Wrback;//control the write back signal of reg file
    //wire  RegDst;//control the update of reg file I-type or R-type
    wire  ExtSe;//control the extend module
    //wire  memWr;//control the data memory write enable
    //wire  regWr;

    wire  [31:0] immd_pc;
    wire  [31:0] alu_in_a;
    wire  [31:0] alu_in_b;
    //wire  [31:0] alu_out;
    //wire  [31:0] Alu_out_EX;
    //wire  [31:0] Alu_out_MEM;
    //wire  [31:0] data_mem_out_MEM;
    //wire  [31:0] sa_immd;
    
    //Instruction Fetch
    PC pc_instance(
        .clk(clk),
        .rst_n(rst_n),
        .Stall_IF(Stall_IF),
        .next_pc(next_pc),
        .pc(pc)
    );

    PCAdd pc_add4_instance(
        .pc(pc),
        .pc_add4(PC_IF)
    );

    instMEM instMEM_instance(
        .pc(pc),
	    .inst(Instruction_IF)
    );

    wire [31:0] NOOP;
    noop_reg noop_reg_instance(
        .clk(clk),
        .noop_in(next_pc),
        .noop_out(NOOP)
    );
    mux4 mux4(
        .pc_add4(PC_IF),
        .NOOP(NOOP),
        .branch(pc_branch),
        .pc_jump(pc_jump),
        .sel(PcSrc),
        .result(next_pc)
    );
    wire [31:0] pc_jr;
    wire [31:0] pc_j_jal;
    assign pc_jump = (func == `funcJR)? pc_jr : pc_j_jal;//assign command

    IF_ID IF_ID_instance(
        .clk(clk),
        .rst_n(rst_n),
        .Flush_IF(Flush_IF),
        .Stall_ID(Stall_ID),
        .PC_IF(PC_IF),
        .Instruction_IF(Instruction_IF),
        .PC_ID(PC_ID),
        .Instruction_ID(Instruction_ID)
    );

    //Instruction Decoder
    decoder decoder_instance(
        .ins(Instruction_ID),
        .op(op),
        .func(func),
        .sa(sa),
        .rs(rs_ID),
        .rt(rt_ID),
        .rd(rd_ID),
        .immd16(immd16),
        .immd26(immd26)
    );

    
    RegFile RegFile_instance(
        .clk(clk),
        .rst_n(rst_n),
        .regWr(regWr_WB),
        .RdReg1(rs_ID),
        .RdReg2(rt_ID),
        .WrReg(WriteReg_WB),
        .WriteData(WriteData_WB),//Write Back
        .RD1(RD1_ID),
        .RD2(RD2_ID)
    );
    
    assign pc_jr = RD1_ID;//assign command

    mux2 mux2_instance(
        .rd(rd_EX),//R-type
        .rt(rt_EX),//I-type
        .sel(RegDst_EX),
        .result(WriteReg_EX)
    );

    Extend Extend_instance(
        .ExtSe(ExtSe),
        .immd16(immd16),
        .Extout(Imm32_ID)
    );

    Lshift Lshift_instance(
        .in(Imm32_ID),
        .shift(immd_pc)
    );

    PC_branch PC_branch_instance(
        .immd_pc(immd_pc),
        .pc_add4(PC_ID),
        .pc_branch(pc_branch)
    );


    Jshift Jshift_instance(
        .inst(immd26),
        .pc_add4(PC_ID),
        .sh(pc_j_jal)
    );

    Conunit Conunit_instance(
        .Func(func),
        .Op(op),
        .rt(rt_ID),//distinguish the BGEZ and BLTZ
        .Zero(Zero),//zero signal,
        .Sign(Sign),//
        .Aluc(Aluc_ID),//control the type of ALU data
        .AluSrcA(AluSrcA_ID),//control the data_in of ALU
        .AluSrcB(AluSrcB_ID),//control the data_in of ALU
        .PcSrc(PcSrc),//control next_pc address
        .Wrback(Wrback_ID),//control the write back signal of reg file
        .RegDst(RegDst_ID),//control the update of reg file I-type or R-type
        .ExtSe(ExtSe),//control the extend module
        .memWr(memWr_ID),//control the data memory write enable
        .regWr(regWr_ID)//control the reg file write enable
    );

    //Branch Predict
    wire [31:0] branch_in_a;
    wire [31:0] branch_in_b;

    mux2Forward mux2Forward_instance_1(
        .RD(RD1_ID),
        .forward_ALU(Alu_out_MEM),
        .selet(ForwardAD),
        .data_out(branch_in_a)
    );

    mux2Forward mux2Forward_instance_2(
        .RD(RD2_ID),
        .forward_ALU(Alu_out_MEM),
        .selet(ForwardBD),
        .data_out(branch_in_b)
    );

    BranchPredict BranchPredict_instance(
        .Aluc(Aluc_ID),
        .in_a(branch_in_a),
        .in_b(branch_in_b),
        .Zero(Zero),
        .Sign(Sign)
    );

    ID_EX ID_EX_instance(
        .clk(clk),
        .rst_n(rst_n),
        .Flush_ID(Flush_ID),
        .Aluc_ID(Aluc_ID),
        .AluSrcA_ID(AluSrcA_ID),
        .AluSrcB_ID(AluSrcB_ID),
        .memWr_ID(memWr_ID),
        .Wrback_ID(Wrback_ID),
        .RegDst_ID(RegDst_ID),
        .regWr_ID(regWr_ID),
        .RD1_ID(RD1_ID),
        .RD2_ID(RD2_ID),
        .ImmSa_ID(ImmSa_ID),
        .Imm32_ID(Imm32_ID),
        .rs_ID(rs_ID),
        .rt_ID(rt_ID),
        .rd_ID(rd_ID),
        .Aluc_EX(Aluc_EX),
        .AluSrcA_EX(AluSrcA_EX),
        .AluSrcB_EX(AluSrcB_EX),
        .memWr_EX(memWr_EX),
        .regWr_EX(regWr_EX),
        .RegDst_EX(RegDst_EX),
        .Wrback_EX(Wrback_EX),
        .RD1_EX(RD1_EX),
        .RD2_EX(RD2_EX),
        .ImmSa_EX(ImmSa_EX),
        .Imm32_EX(Imm32_EX),
        .rs_EX(rs_EX),
        .rt_EX(rt_EX),
        .rd_EX(rd_EX)
    );

    //Execute

    assign WriteMemData_EX = RD2_EX;

    ALU ALU_instance(
        .Aluc(Aluc_EX),
        .a(alu_in_a),//op1
        .b(alu_in_b),//op2
        .out(Alu_out_EX)
        //.zero(Zero),
        //.sign(Sign)
    );

    wire [31:0] forward_MEM;
    wire [31:0] forward_WB;
    assign forward_MEM = Alu_out_MEM;
    assign forward_WB  = WriteData_WB;
    wire [31:0] mux_in_a;
    wire [31:0] mux_in_b;
    mux3Forward mux3Forward_instance_1(
        .RD(RD1_EX),
        .forward_MEM(forward_MEM),
        .forward_WB(forward_WB),
        .selet(ForwardAE),
        .data_out(mux_in_a)
    );

    //selet srcA
    wire [15:0] SA;
    assign SA = {{11{1'b0}},sa};
    ZeroExt Zeroext_instance_1(
        .im(SA),
        .extend(ImmSa_ID)
    );

    mux2x32 mux2x32_instance_1(
        .Qb(mux_in_a),
        .im(ImmSa_EX),
        .sel(AluSrcA_EX),
        .result(alu_in_a)
    );

    mux3Forward mux3Forward_instance_2(
        .RD(RD2_EX),
        .forward_MEM(forward_MEM),
        .forward_WB(forward_WB),
        .selet(ForwardBE),
        .data_out(mux_in_b)
    );

    mux2x32 mux2x32_instance_2(
        .Qb(mux_in_b),//R-type
        .im(Imm32_EX),//I-type
        .sel(AluSrcB_EX),
        .result(alu_in_b)
    );

    EX_MEM EX_MEM_instance(
        .clk(clk),
        .rst_n(rst_n),
        .memWr_EX(memWr_EX),
        .regWr_EX(regWr_EX),
        .Wrback_EX(Wrback_EX),
        .AluResult_EX(Alu_out_EX),
        .WriteMemData_EX(WriteMemData_EX),
        .WriteReg_EX(WriteReg_EX),
        .memWr_MEM(memWr_MEM),           
        .regWr_MEM(regWr_MEM),
        .Wrback_MEM(Wrback_MEM),
        .AluResult_MEM(Alu_out_MEM),
        .WriteMemData_MEM(WriteMemData_MEM),
        .WriteReg_MEM(WriteReg_MEM)
    );

    //Memory
    
    dataMEM dataMEM_instance(
        .clk(clk),
        .w_en(memWr_MEM),//1:sw 0:lw
        .wdata(WriteMemData_MEM),
        .address(Alu_out_MEM),
        .data_out(data_mem_out_MEM)
    );

    //Write Back

    MEM_WB MEM_WB_instance(
        .clk(clk),
        .rst_n(rst_n),
        .regWr_MEM(regWr_MEM),
        .Wrback_MEM(Wrback_MEM),
        .ReadMemData_MEM(data_mem_out_MEM),
        .AluResult_MEM(Alu_out_MEM),
        .WriteReg_MEM(WriteReg_MEM),
        .regWr_WB(regWr_WB),
        .Wrback_WB(Wrback_WB),
        .ReadMemData_WB(data_mem_out_WB),
        .AluResult_WB(Alu_out_WB),
        .WriteReg_WB(WriteReg_WB)
    );

    //write back
    mux2x32 mux2x32_instance_3(
        .Qb(Alu_out_WB),
        .im(data_mem_out_WB),
        .sel(Wrback_WB),
        .result(WriteData_WB)
    );


    //Data Hazard and Control Hazard
    HazardUnit HazardUnit_instance(
        .rs_EX(rs_EX),
        .rt_EX(rt_EX),
        .rs_ID(rs_ID),
        .rt_ID(rt_ID),
        .WriteReg_MEM(WriteReg_MEM),
        .WriteReg_WB(WriteReg_WB),
        .regWr_MEM(regWr_MEM),
        .regWr_WB(regWr_WB),
        .WriteReg_EX(WriteReg_EX),
        .Branch_ID(Branch_ID),//?
        .regWr_EX(regWr_EX),
        .Wrback_EX(Wrback_EX),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD),
        .Stall_IF(Stall_IF),//
        .Stall_ID(Stall_ID),
        .Flush_EX(Flush_EX)
    );

endmodule
