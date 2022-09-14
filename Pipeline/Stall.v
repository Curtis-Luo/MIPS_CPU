//module: stall

`include "define.v"

module Stall(
    input  [4:0] rs_ID,
    input  [4:0] rt_ID,
    input  [4:0] rt_EX,
    input  [4:0] WriteReg_EX,
    input  [4:0] WriteReg_MEM,
    input  Branch_ID,
    input  regWr_EX,
    input  regWr_MEM,
    input  Wrback_EX,
    output reg Stall_IF,
    output reg Stall_ID,
    output reg Flush_EX
);
    wire lwstall;
    wire branchstall;

    initial begin
        Stall_IF = 1'b0;
        Stall_ID = 1'b0;
        Flush_EX = 1'b0;
    end

    /*always @(*) begin
        lwstall = ((rs_ID == rt_EX) | (rt_ID == rt_EX)) & ( Wrback_EX == 1);
        branchstall = ((Branch_ID ==1) & (regWr_EX == 1) & ((WriteReg_EX == rs_ID) | (WriteReg_EX == rt_ID)))
                        || ((Branch_ID ==1) & (regWr_MEM == 1) & ((WriteReg_MEM == rs_ID) | (WriteReg_MEM == rt_ID)));
    end*/

    assign lwstall = ((rs_ID == rt_EX) | (rt_ID == rt_EX)) & ( Wrback_EX == 1);
    assign branchstall = ((Branch_ID ==1) & (regWr_EX == 1) & ((WriteReg_EX == rs_ID) | (WriteReg_EX == rt_ID)))
                        || ((Branch_ID ==1) & (regWr_MEM == 1) & ((WriteReg_MEM == rs_ID) | (WriteReg_MEM == rt_ID)));

    always @(*) begin
        if((lwstall == 1'b1) | (branchstall == 1'b1))begin
            Stall_IF = 1'b1;
            Stall_ID = 1'b1;
            Flush_EX = 1'b1;
        end
        else begin
            Stall_IF = 1'b0;
            Stall_ID = 1'b0;
            Flush_EX = 1'b0;
        end
    end

endmodule

/***** There may be a problem.
Stall_IF = lwstall | branchstall;
Stall_ID = lwstall | branchstall;
Flush_EX = lwstall | branchstall;
*/