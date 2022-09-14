//instruction memory
//Read only memory(ROM)
//


module instMEM(
	input 	[31:0] 	pc,
	output 	[31:0]	inst
);

	reg [31:0] inst_mem [0:63];

	initial $readmemh("E:/MIPS_CPU/A_Single/machinecode.txt",inst_mem);

	//assign inst = inst_mem[pc[6:2]];
	//exist overflow,can only support 32 instructions
	//so enlarge the useful pc width.
	assign inst = inst_mem[pc[31:2]];
	
endmodule
