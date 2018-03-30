module writeback(instruction, pc, data_memOut, data_multdiv, data_exception_alu, data_exception_multdiv, 
				ctrl_writeReg, data_writeReg);
    input [31:0] instruction, pc, data_memOut, data_multdiv, data_exception_alu, data_exception_multdiv;
    output [4:0] ctrl_writeReg;
    output [31:0] data_writeReg;

	 wire ctrl_writeExc;
	 wire [4:0] ctrl_ALUop, ctrl_shamt, ctrl_readRegA, ctrl_readRegB, ctrl_writeReg_good;
    wire [31:0] branch_target, jump_immed;
    wire ctrl_immed, ctrl_store, ctrl_jr, ctrl_mult, ctrl_div, ctrl_er;
	 wire ctrl_jump, ctrl_load, ctrl_bne, ctrl_blt, ctrl_link;
    controller ctrl(.instruction_in(instruction), .ctrl_ALUop(ctrl_ALUop), .ctrl_shamt(ctrl_shamt),
        .ctrl_regReadA(ctrl_readRegA), .ctrl_regReadB(ctrl_readRegB), .ctrl_regWrite(ctrl_writeReg_good), 
        .data_immediate(branch_target), .data_target(jump_immed), .ctrl_immed(ctrl_immed), 
		  .ctrl_mult(ctrl_mult), .ctrl_div(ctrl_div), .ctrl_load(ctrl_load), .ctrl_store(ctrl_store), 
		.ctrl_jump(ctrl_jump), .ctrl_jr(ctrl_jr), .ctrl_bne(ctrl_bne), 
		.ctrl_blt(ctrl_blt), .ctrl_link(ctrl_link), .ctrl_excep_read(ctrl_er), .ctrl_excep_write(ctrl_writeExc));

    wire multdiv;
    wire [31:0] data_write, data_exception, shifted_pc, data_writeReg_good;
    or multdiv_or(multdiv, ctrl_mult, ctrl_div);
    mux_2 multdiv_out(.sel(multdiv), .in0(data_memOut), .in1(data_multdiv), .out(data_write));
    mux_2 multdiv_exc(.sel(multdiv), .in0(data_exception_alu), .in1(data_exception_multdiv), .out(data_exception));
	 assign shifted_pc[29:0] = pc[31:2];
	 assign shifted_pc[31:30] = 2'b0;
    mux_2 link_out(.sel(ctrl_link), .in0(data_write), .in1(shifted_pc), .out(data_writeReg_good));
	 
	 wire excep_occurred, excep_wb;
	 or excep_or(excep_occurred, data_exception[0], data_exception[1], data_exception[2]);
	 and exc_wb(excep_wb, ctrl_writeExc, excep_occurred);
    mux_2 exc_out(.sel(excep_wb), .in0(data_writeReg_good), .in1(data_exception), .out(data_writeReg));
	 assign ctrl_writeReg = excep_wb ? 5'b11110 : ctrl_writeReg_good;
	     
endmodule