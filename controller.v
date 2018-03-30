module controller(instruction_in, 

	// ALU Control Signals
		ctrl_ALUop, ctrl_shamt, 

	// Registers
		ctrl_regReadA, ctrl_regReadB, ctrl_regWrite, 

	// Immediates
		data_immediate, data_target,

	// Control Signals (ALU)
		ctrl_immed, ctrl_mult, ctrl_div,

	// Control Signals (Mem)
		ctrl_load, ctrl_store, 

	// Control Signals (Jump/Branch)
		ctrl_bne, ctrl_blt, ctrl_jump, ctrl_jr, ctrl_link,
		
	// Control Signals (Exception)
		ctrl_excep_read, ctrl_excep_write);

	input [31:0] instruction_in;

	output [31:0] data_immediate, data_target;
	output [4:0] ctrl_ALUop, ctrl_shamt, ctrl_regReadA, ctrl_regReadB, ctrl_regWrite;
	output ctrl_immed, ctrl_mult, ctrl_div, ctrl_load, ctrl_store;
	output ctrl_bne, ctrl_blt, ctrl_jump, ctrl_jr, ctrl_link;
	output ctrl_excep_read, ctrl_excep_write;

	wire [4:0] opcode, init_ALUop, rd, rs, rt;

	// Instruction Components
	assign opcode = instruction_in[31:27];
	assign rd = instruction_in[26:22];
	assign rs = instruction_in[21:17];
	assign rt = instruction_in[16:12];
	assign ctrl_shamt = instruction_in[11:7];
	assign init_ALUop = instruction_in[6:2];
	assign data_target[26:0] = instruction_in[26:0];
	assign data_target[31:27] = 5'b0;
	assign data_immediate[16:0] = instruction_in[16:0];
	genvar i;
	generate
		for(i = 17; i < 32; i = i + 1) begin: immediate_loop
			assign data_immediate[i] = instruction_in[16];
		end
	endgenerate

	// Control Signals
	wire[31:0] opdecode;
	decoder_32 decd(.in(opcode), .out(opdecode));
	or immed_or(ctrl_immed, opdecode[5], opdecode[7], opdecode[8]);
	and mult_and(ctrl_mult, opdecode[0], ~init_ALUop[0], init_ALUop[1], init_ALUop[2], ~init_ALUop[3], ~init_ALUop[4]);
	and div_and(ctrl_div, opdecode[0], init_ALUop[0], init_ALUop[1], init_ALUop[2], ~init_ALUop[3], ~init_ALUop[4]);
	assign ctrl_load = opdecode[8];
	assign ctrl_store = opdecode[7];
	assign ctrl_bne = opdecode[2];
	assign ctrl_blt = opdecode[6];
	or jump_or(ctrl_jump, opdecode[1], opdecode[3], opdecode[4]);
	assign ctrl_jr = opdecode[4];
	assign ctrl_link = opdecode[3];
	assign ctrl_excep_read = opdecode[22];
	wire add_sub_exc, noop_elim;
	or noop_or(noop_elim, rs[0], rs[1], rs[2], rs[3], rs[4]);
	and ex_alu(add_sub_exc, opdecode[0], ~init_ALUop[1], ~init_ALUop[2], noop_elim);
	or excw_or(ctrl_excep_write, opdecode[5], add_sub_exc, opdecode[21], ctrl_mult, ctrl_div);

	// Register selection
	wire readRDA, readRDB, readRSB, noWrite, noReadA, noReadB;
	wire [4:0] regA, regA_2, regB, regB_2, regWrite;
	or readRDA_or(readRDA, ctrl_bne, ctrl_blt, ctrl_jr);
	assign readRDB = ctrl_store;
	or readRSB_or(readRSB, ctrl_bne, ctrl_blt);
	or noReadA_or(noReadA, opdecode[1], opdecode[3], opdecode[21], opdecode[22]);
	or noReadB_or(noReadB, opdecode[5], ctrl_load, opdecode[1], opdecode[3], ctrl_jr, opdecode[21], opdecode[22]);
	or noWrite_or(noWrite, ctrl_store, ctrl_jump, ctrl_bne, ctrl_blt, opdecode[21], opdecode[22]);
	mux_2_5bit ctrl_regA(.sel(readRDA), .in0(rs), .in1(rd), .out(regA));
	mux_2_5bit ctrl_rg2A(.sel(noReadA), .in0(regA), .in1(5'b0), .out(regA_2));
	mux_2_5bit ctrl_rg3A(.sel(ctrl_excep_read), .in0(regA_2), .in1(5'b11110), .out(ctrl_regReadA));
	mux_2_5bit ctrl_regB(.sel(readRDB), .in0(rt), .in1(rd), .out(regB));
	mux_2_5bit ctrl_rg2B(.sel(readRSB), .in0(regB), .in1(rs), .out(regB_2));
	mux_2_5bit ctrl_rg3B(.sel(noReadB), .in0(regB_2), .in1(5'b0), .out(ctrl_regReadB));
	mux_2_5bit ctrl_regW(.sel(noWrite), .in0(rd), .in1(5'b0), .out(regWrite));
	mux_2_5bit ctrl_rg2W(.sel(ctrl_link), .in0(regWrite), .in1(5'b11111), .out(ctrl_regWrite));

	// ALU Op Determination
	wire [4:0] inter_alu;
	assign inter_alu = opdecode[0] ? init_ALUop : 5'b00000;
	assign ctrl_ALUop = (ctrl_bne | ctrl_blt) ? 5'b00001 : inter_alu;


endmodule