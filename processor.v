/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [12:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 assign ctrl_writeEnable = 1'b1;
	 
    // Jump Controls
    wire[31:0] jump_target;
    wire ctrl_jump;
	 
    // Stall, Bypass Controls
	 wire ctrl_load, ctrl_store, ctrl_mult, ctrl_div, ctrl_link; // Bypass Control Inputs
	 wire [1:0] bypass_aluinA, bypass_aluinB, bypass_readRegB; // Bypass Control Outputs
    wire multdiv_start, multdiv_ready; 	 // Multdiv Stall Inputs
	 wire ctrl_ew, ctrl_er;						 // Exception Stall Inputs
    wire [4:0] writeReg_decode; 				 // Data Bypass/Stall Input
    wire stall, multdiv_stall; 				 // Stall Control Signals
    stall stall_logic(.readRegA(ctrl_readRegA), .readRegB(ctrl_readRegB), .writeReg(writeReg_decode), 
        .multdiv_start(multdiv_start), .multdiv_ready(multdiv_ready), .ctrl_ew(ctrl_ew), .ctrl_er(ctrl_er),
		  .ctrl_load(ctrl_load), .ctrl_store(ctrl_store), .ctrl_mult(ctrl_mult), .ctrl_div(ctrl_div), .ctrl_link(ctrl_link),		  
		  .by_aluinA(bypass_aluinA), .by_aluinB(bypass_aluinB), .by_regB(bypass_readRegB),
		  .clock(clock), .reset(reset), .stall(stall), .multdiv_stall(multdiv_stall));

	 // Branch Predictor
    wire branch_actual, branch_prediction, branch_in, mispredict, ctrl_branch_e;
	 wire [31:0] branch_target_actual, branch_target_predict, branch_target_in, branch_target_corrected;
	 wire [31:0] pc_f, pc_e;
    branch_predictor pred(.pc_read(pc_f), .pc_write(pc_e), 
		  .branch_result(branch_actual), .branch_address(branch_target_actual), 
		  .reset(reset), .write(ctrl_branch_e), .clock(clock), 
		  .branch_prediction(branch_prediction), .branch_target(branch_target_predict), 
		  .mispredict(mispredict));  
	 or branch_or(branch_in, branch_prediction, mispredict);
	 mux_2 target_corrector(.sel(branch_actual), .in0(pc_e), .in1(branch_target_actual), 
		  .out(branch_target_corrected));
	 mux_2 predict_selector(.sel(mispredict), .in0(branch_target_predict), .in1(branch_target_corrected), 
		  .out(branch_target_in));
		  	 

    // Fetch
	 wire [31:0] instruction_f;
    fetch f(.jump(jump_target), .ctrl_jump(ctrl_jump), .branchPC(branch_target_in), .ctrl_branch(branch_in),
    	.reset(reset), .stall(stall), .clock(clock), .q_imem(q_imem), .insn_address(address_imem), 
        .instruction(instruction_f), .pc(pc_f));

    // Latch instruction, PC
	 wire [31:0] instruction_d, pc_d;
    wire noop_d;
    or noop_or_d(noop_d, reset, mispredict, ctrl_jump);
    register insn_fd_reg(.write(instruction_f), .we(~stall), .clr(noop_d), .clk(clock), .read(instruction_d));
    register pc_fd_reg(   .write(pc_f),         .we(~stall), .clr(noop_d), .clk(clock), .read(pc_d));

	 
    // Decode
	 wire [31:0] data_aluinA_d, data_aluinB_d;
    decode d(.instruction(instruction_d), .data_readRegA(data_readRegA), .data_readRegB(data_readRegB),
		  .ctrl_ew(ctrl_ew), .ctrl_er(ctrl_er),
		  .ctrl_load(ctrl_load), .ctrl_store(ctrl_store), .ctrl_mult(ctrl_mult), .ctrl_div(ctrl_div), .ctrl_link(ctrl_link),		  
        .ctrl_readRegA(ctrl_readRegA), .ctrl_readRegB(ctrl_readRegB), .ctrl_writeReg(writeReg_decode), 
        .data_aluinA(data_aluinA_d), .data_aluinB(data_aluinB_d), .jump_target(jump_target), .ctrl_jump(ctrl_jump));

    // Latch instruction, PC, data_aluinA, data_aluinB, data_readRegB
	 wire [31:0] instruction_e, data_aluinA_e, data_aluinB_e, data_readRegB_e, insn_noop_d;
	 mux_2 noop_insert(.sel(stall), .in0(instruction_d), .in1(32'b0), .out(insn_noop_d));
	 wire noop_e;
	 or noop_or_e(noop_e, reset, mispredict);
    register insn_de_reg(  .write(insn_noop_d),   .we(~multdiv_stall), .clr(noop_e), .clk(clock), .read(instruction_e));
    register pc_de_reg(    .write(pc_d),          .we(~multdiv_stall), .clr(noop_e), .clk(clock), .read(pc_e));
    register aluinA_de_reg(.write(data_aluinA_d), .we(~multdiv_stall), .clr(noop_e), .clk(clock), .read(data_aluinA_e));
    register aluinB_de_reg(.write(data_aluinB_d), .we(~multdiv_stall), .clr(noop_e), .clk(clock), .read(data_aluinB_e));
    register regB_de_reg(  .write(data_readRegB), .we(~multdiv_stall), .clr(noop_e), .clk(clock), .read(data_readRegB_e));
    
	 // Bypass In
	 wire [31:0] data_aluOut_m, data_memOut_w, data_multdiv_w; // Bypass Inputs
	 wire [31:0] data_aluinA_bp, data_aluinB_bp, data_readRegB_bp; // Bypass Outputs
	 mux_4 by_aluA(.sel(bypass_aluinA), .in0(data_aluinA_e), .in1(data_aluOut_m), 
		.in2(data_memOut_w), .in3(data_multdiv_w), .out(data_aluinA_bp));
	 mux_4 by_aluB(.sel(bypass_aluinB), .in0(data_aluinB_e), .in1(data_aluOut_m), 
		.in2(data_memOut_w), .in3(data_multdiv_w), .out(data_aluinB_bp));
	 mux_4 by_regB(.sel(bypass_readRegB), .in0(data_readRegB_e), .in1(data_aluOut_m), 
		.in2(data_memOut_w), .in3(data_multdiv_w), .out(data_readRegB_bp));
	 

    // Execute
	 wire [31:0] data_aluOut_e, exception_alu_e, data_multdiv_em, exception_multdiv_em;
    execute e(.instruction(instruction_e), .data_aluinA(data_aluinA_bp), .data_aluinB(data_aluinB_bp), 
    	.data_multdiv(data_multdiv_em), .ctrl_md_start(multdiv_start), .ctrl_md_ready(multdiv_ready), 
		.pc(pc_e), .clock(clock), .reset(reset), .data_aluOut(data_aluOut_e), .nextPC(branch_target_actual), 
		.branch_taken(branch_actual), .ctrl_branch(ctrl_branch_e), 
		.exception_ALU(exception_alu_e), .exception_MultDiv(exception_multdiv_em));

    // Latch instruction, PC, data_readRegB, data_aluOut, exception_alu
	 wire [31:0] instruction_m, pc_m, data_readRegB_m, exception_alu_m;
	 wire noop_m;
	 or noop_or_m(noop_m, reset, multdiv_ready);
    register insn_em_reg(  .write(instruction_e),   .we(1'b1), .clr(noop_m), .clk(clock), .read(instruction_m));
    register pc_em_reg(    .write(pc_e),            .we(1'b1), .clr(noop_m), .clk(clock), .read(pc_m));
    register regB_em_reg(  .write(data_readRegB_bp), .we(1'b1), .clr(noop_m), .clk(clock), .read(data_readRegB_m));
    register aluout_em_reg(.write(data_aluOut_e),   .we(1'b1), .clr(noop_m), .clk(clock), .read(data_aluOut_m));
    register excep_em_reg( .write(exception_alu_e), .we(1'b1), .clr(noop_m), .clk(clock), .read(exception_alu_m));
		
	 
    // Memory
	 wire [31:0] data_memOut_m;
    memory m(.instruction(instruction_m), .data_aluOut(data_aluOut_m), .data_readRegB(data_readRegB_m), 
        .q_dmem(q_dmem), .wren_dmem(wren), .address_dmem(address_dmem), .write_dmem(data), 
        .data_memOut(data_memOut_m));

    // Latch instruction, PC, data_memOut, data_multdiv, (exception_alu & exception_multdiv)
    wire [31:0] instruction_w, pc_w, insn_noop_m, exception_alu_w, exception_multdiv_w;
	 wire delay_md_stall;
	 dff_c md_stall_delay(.d(multdiv_stall), .clr(reset), .en(1'b1), .clk(clock), .q(delay_md_stall));
	 mux_2 noop_insert_w(.sel(multdiv_stall & delay_md_stall), .in0(instruction_m), .in1(32'b0), .out(insn_noop_m));
    register insn_mw_reg(   .write(insn_noop_m),   .we(1'b1), .clr(reset), .clk(clock), .read(instruction_w));
    register pc_mw_reg(     .write(pc_m),            .we(1'b1), .clr(reset), .clk(clock), .read(pc_w));
    register regB_mw_reg(   .write(data_memOut_m),   .we(1'b1), .clr(reset), .clk(clock), .read(data_memOut_w));
    register aluout_mw_reg( .write(data_multdiv_em), .we(1'b1), .clr(reset), .clk(clock), .read(data_multdiv_w));
    register excepa_mw_reg( .write(exception_alu_m), .we(1'b1), .clr(reset), .clk(clock), .read(exception_alu_w));
    register excepm_mw_reg( .write(exception_multdiv_em), .we(1'b1), .clr(reset), .clk(clock), .read(exception_multdiv_w));

	 
    // Writeback
    writeback w(.instruction(instruction_w), .pc(pc_w), .data_memOut(data_memOut_w), .data_multdiv(data_multdiv_w), 
    	.data_exception_alu(exception_alu_w), .data_exception_multdiv(exception_multdiv_w), 
		.ctrl_writeReg(ctrl_writeReg), .data_writeReg(data_writeReg));

endmodule
