# MIPS_CPU
[MIPS](https://en.wikipedia.org/wiki/MIPS_architecture) (Microprocessor without Interlocked Pipelined Stages) is a family of reduced instruction set computer (RISC) instruction set architectures (ISA) developed by MIPS Computer Systems, now MIPS Technologies, based in the United States.  

In the course of Computer Processors, I implemented a 32-bit MIPS CPU supporting 36 instructions.  

Document Structure:  
--Single  
----test: testbench  
----RTL codes(*.v)  
----Arch,Instruction_Test(*.vsdx,*.pdf,*.xlsx)  
--Pipeline  
----test: testbench  
----RTL codes(*.v)  
----Arch,Instruction_Test(*.vsdx,*.pdf,*.xlsx)  

A MIPS CPU that supports 36 MIPS instructions. You can find the documentation for specific instructions test just clicking the link: https://github.com/Curtis-Luo/MIPS_CPU/blob/main/Pipeline/Instruction%20Test.pdf  
Firstly, I completed a single-cycle MIPS CPU that can work correctly.  
A single-cycle mips cpu: https://github.com/Curtis-Luo/MIPS_CPU/tree/main/Single.  
Then based on the single-cycle MIPS CPU, I completed the multi-cycle pipelined MIPS CPU.  
A classic 5-stage pipeline mips cpu: https://github.com/Curtis-Luo/MIPS_CPU/tree/main/Pipeline.  
