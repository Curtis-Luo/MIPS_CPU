//instruction memory
//Read only memory(ROM)


module instMEM(
	input 	[31:0] 	pc,
	output 	[31:0]	inst
);

	reg [31:0] inst_mem [0:31];

	initial $readmemh("./machinecode.txt",inst_mem);

	assign inst = inst_mem[pc[6:2]];
	
endmodule
