module memory(instruction, data_aluOut, data_readRegB, q_dmem, wren_dmem, address_dmem, write_dmem, data_memOut);
    input [31:0] instruction, data_aluOut, data_readRegB, q_dmem;
    output wren_dmem;
    output [12:0] address_dmem;
    output [31:0] write_dmem, data_memOut;

    wire [4:0] ctrl_ALUop, ctrl_shamt, ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
    wire [31:0] branch_target, jump_immed;
    wire ctrl_jump, ctrl_immed, ctrl_jr, ctrl_mult, ctrl_div, ctrl_er, ctrl_ew;
	 wire ctrl_load, ctrl_bne, ctrl_blt, ctrl_link;
    controller ctrl(.instruction_in(instruction), .ctrl_ALUop(ctrl_ALUop), .ctrl_shamt(ctrl_shamt),
        .ctrl_regReadA(ctrl_readRegA), .ctrl_regReadB(ctrl_readRegB), .ctrl_regWrite(ctrl_writeReg), 
        .data_immediate(branch_target), .data_target(jump_immed), .ctrl_immed(ctrl_immed), 
		  .ctrl_mult(ctrl_mult), .ctrl_div(ctrl_div), .ctrl_load(ctrl_load), .ctrl_store(wren_dmem), 
		.ctrl_jump(ctrl_jump), .ctrl_jr(ctrl_jr), .ctrl_bne(ctrl_bne), 
		.ctrl_blt(ctrl_blt), .ctrl_link(ctrl_link), .ctrl_excep_read(ctrl_er), .ctrl_excep_write(ctrl_ew));

    assign address_dmem = data_aluOut[12:0];
    assign write_dmem = data_readRegB;
    mux_2 ctrl_mem(.sel(ctrl_load), .in0(data_aluOut), .in1(q_dmem), .out(data_memOut));

endmodule