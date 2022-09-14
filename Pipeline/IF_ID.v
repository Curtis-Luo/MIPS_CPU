//module: Instruction Fetch-> Instruction Decoder
//IF_ID
module IF_ID(
    input clk,
    input rst_n,
    input Flush_IF,
    input Stall_ID,//1:stall 0: not stall
    input [31:0] PC_IF,
    input [31:0] Instruction_IF,

    output reg[31:0] PC_ID,
    output reg[31:0] Instruction_ID
);
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n) begin
            Instruction_ID <= 32'd0;
            PC_ID <= 32'd0;
        end 
        else if(Flush_IF == 1'b1) begin
            Instruction_ID <= 32'hFC00_0000;//NOOP
            //PC_ID <= PC_IF;
        end
        else if(Stall_ID == 1'b0) begin
            Instruction_ID <= Instruction_IF;
            PC_ID <= PC_IF;
            $display(" CurrentPC :0x%x ", PC_IF);
        end

    end

endmodule