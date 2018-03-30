module decode(instruction, data_readRegA, data_readRegB, 
				ctrl_er, ctrl_ew,
			   ctrl_load, ctrl_store, ctrl_mult, ctrl_div, ctrl_link,
            ctrl_readRegA, ctrl_readRegB, ctrl_writeReg, 
            data_aluinA, data_aluinB, jump_target, ctrl_jump);

    input [31:0] instruction, data_readRegA, data_readRegB;
    output [4:0] ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
    output [31:0] data_aluinA, data_aluinB, jump_target;
    output ctrl_jump, ctrl_er, ctrl_ew, ctrl_load, ctrl_store, ctrl_mult, ctrl_div, ctrl_link;

	 wire [4:0] ctrl_ALUop, ctrl_shamt;
    wire [31:0] immediate, jump_immed;
    wire ctrl_immed, std_jump, ctrl_jr, ctrl_bne, ctrl_blt;
    controller ctrl(.instruction_in(instruction), .ctrl_ALUop(ctrl_ALUop), .ctrl_shamt(ctrl_shamt),
        .ctrl_regReadA(ctrl_readRegA), .ctrl_regReadB(ctrl_readRegB), .ctrl_regWrite(ctrl_writeReg), 
        .data_immediate(immediate), .data_target(jump_immed), .ctrl_immed(ctrl_immed), 
		  .ctrl_mult(ctrl_mult), .ctrl_div(ctrl_div), .ctrl_load(ctrl_load), .ctrl_store(ctrl_store), 
		.ctrl_jump(std_jump), .ctrl_jr(ctrl_jr), .ctrl_bne(ctrl_bne), 
		.ctrl_blt(ctrl_blt), .ctrl_link(ctrl_link), .ctrl_excep_read(ctrl_er), .ctrl_excep_write(ctrl_ew));

    mux_2 alu_immed(.sel(ctrl_immed), .out(data_aluinB), .in0(data_readRegB), .in1(immediate));
    assign data_aluinA = data_readRegA;
	 
	 mux_2 jr_select(.sel(ctrl_jr), .out(jump_target), .in0(jump_immed), .in1(data_readRegA));
	 
	 wire exc_jump, exc_nz;
	 or exc_or(exc_nz, data_readRegA[0], data_readRegA[1], data_readRegA[2], data_readRegA[3]);
	 and exc_and(exc_jump, exc_nz, ctrl_er);
	 
	 or jump_or(ctrl_jump, exc_jump, std_jump);



endmodule