module fetch(jump, ctrl_jump, branchPC, ctrl_branch, reset, stall, clock, q_imem, insn_address, instruction, pc);
    input [31:0] q_imem, jump, branchPC;
    input ctrl_jump, ctrl_branch, clock, reset, stall;
    output [11:0] insn_address;
    output [31:0] instruction, pc;

    wire [31:0] currentPC, interPC, jump_val, jump_shift, nextPC;
    wire changePC;
    or pc_change(changePC, ctrl_jump, ctrl_branch);
    register pc_reg(.write(nextPC), .we(~stall), .clr(reset), .clk(clock), .read(currentPC));
	 wire un1, un2;
    adder_32 pc_incr(.inA(currentPC), .inB(32'h00000004), .cin(1'b0), .sum(interPC), .cout(un1), .ovf(un2));
    assign jump_shift[31:2] = jump[29:0];
	 assign jump_shift[1:0] = 2'b00;
	 mux_2 branch_select(.sel(ctrl_branch), .in0(jump_shift), .in1(branchPC), .out(jump_val));
    mux_2 jump_select(.sel(changePC), .in0(interPC), .in1(jump_val), .out(nextPC));
    assign insn_address = currentPC[13:2];
    assign instruction = q_imem;
    assign pc = interPC;

endmodule