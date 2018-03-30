module execute(instruction, data_aluinA, data_aluinB, pc, clock, reset, 
        data_aluOut, data_multdiv, nextPC, exception_ALU, 
		  exception_MultDiv, ctrl_md_start, ctrl_md_ready, 
		  branch_taken, ctrl_branch);

    input [31:0] instruction, data_aluinA, data_aluinB, pc;
    input clock, reset;
    output [31:0] data_aluOut, data_multdiv, nextPC, exception_ALU, exception_MultDiv;
    output ctrl_md_start, ctrl_md_ready, branch_taken, ctrl_branch;

    wire [4:0] ctrl_ALUop, ctrl_shamt, ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
    wire [31:0] branch_target, exception_immed;
    wire ctrl_immed, ctrl_jump, ctrl_store, ctrl_jr, ctrl_mult, ctrl_div, ctrl_er, ctrl_ew;
	 wire ctrl_load, ctrl_bne, ctrl_blt, ctrl_link;
    controller ctrl(.instruction_in(instruction), .ctrl_ALUop(ctrl_ALUop), .ctrl_shamt(ctrl_shamt),
        .ctrl_regReadA(ctrl_readRegA), .ctrl_regReadB(ctrl_readRegB), .ctrl_regWrite(ctrl_writeReg), 
        .data_immediate(branch_target), .data_target(exception_immed), .ctrl_immed(ctrl_immed), 
		  .ctrl_mult(ctrl_mult), .ctrl_div(ctrl_div), .ctrl_load(ctrl_load), .ctrl_store(ctrl_store), 
		.ctrl_jump(ctrl_jump), .ctrl_jr(ctrl_jr), .ctrl_bne(ctrl_bne), 
		.ctrl_blt(ctrl_blt), .ctrl_link(ctrl_link), .ctrl_excep_read(ctrl_er), .ctrl_excep_write(ctrl_ew));
	 or branch_ctrl_or(ctrl_branch, ctrl_blt, ctrl_bne);

	 
    // ALU
    wire neq, lt, alu_exception;
    alu alu(.data_operandA(data_aluinA), .data_operandB(data_aluinB), .ctrl_ALUopcode(ctrl_ALUop), 
        .ctrl_shiftamt(ctrl_shamt), .data_result(data_aluOut), 
        .isNotEqual(neq), .isLessThan(lt), .overflow(alu_exception));

    // ALU Exceptions
    wire ctrl_add, ctrl_sub;
    wire [31:0] excep_inter1, excep_inter2, excep_inter3;
    and add_and(ctrl_add, ~ctrl_ALUop[0], ~ctrl_ALUop[1], ~ctrl_ALUop[2], ~ctrl_ALUop[3], ~ctrl_ALUop[4]);
    and sub_and(ctrl_sub, ~ctrl_ALUop[0], ctrl_ALUop[1], ~ctrl_ALUop[2], ~ctrl_ALUop[3], ~ctrl_ALUop[4]);
    mux_2 excep1(.sel(ctrl_add), .in0(exception_immed), .in1(32'h00000001), .out(excep_inter1));
    mux_2 excep2(.sel(ctrl_sub), .in0(excep_inter1), .in1(32'h00000003), .out(excep_inter2));
    mux_2 excep3(.sel(ctrl_immed), .in0(excep_inter2), .in1(32'h00000002), .out(excep_inter3));
    mux_2 excep4(.sel(alu_exception & ctrl_ew), .in0(32'h0), .in1(excep_inter3), .out(exception_ALU));

    // Next PC calculations
    wire blt_val, bne_val, un1, un2;
	 wire [31:0] shifted_branch;
	 assign shifted_branch[31:2] = branch_target[29:0];
	 assign shifted_branch[1:0] = 2'b0;
    adder_32 pc_adder(.inA(pc), .inB(shifted_branch), .cin(1'b0), .sum(nextPC), .cout(un1), .ovf(un2));
    and branch_and1(bne_val, ctrl_bne, neq);
    and branch_and2(blt_val, ctrl_blt, lt);
    or branch_or(branch_taken, bne_val, blt_val);

    // Mult Div
    wire md_exception;
    multdiv md(.data_operandA(data_aluinA), .data_operandB(data_aluinB), .ctrl_MULT(ctrl_mult), 
        .ctrl_DIV(ctrl_div), .clock(clock), .reset(reset), .data_result(data_multdiv), 
        .data_exception(md_exception), .data_resultRDY(ctrl_md_ready));
	 or md_start(ctrl_md_start, ctrl_mult, ctrl_div);

    // Mult Div Exceptions
    wire [31:0] excep_inter4, excep_inter5;
    mux_2 excep5(.sel(ctrl_mult), .in0(32'h0), .in1(32'h00000004), .out(excep_inter4));
    mux_2 excep6(.sel(ctrl_div), .in0(excep_inter4), .in1(32'h00000005), .out(excep_inter5));
    mux_2 excep7(.sel(md_exception), .in0(32'h0), .in1(excep_inter5), .out(exception_MultDiv));



endmodule