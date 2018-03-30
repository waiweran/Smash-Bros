module stall(readRegA, readRegB, writeReg, 
			multdiv_start, multdiv_ready, 
			ctrl_ew, ctrl_er,
			ctrl_load, ctrl_store, ctrl_mult, ctrl_div, ctrl_link,
			clock, reset, 
			by_aluinA, by_aluinB, by_regB,
			stall, multdiv_stall);

	input [4:0] readRegA, readRegB, writeReg;
	input multdiv_start, multdiv_ready, ctrl_ew, ctrl_er;
	input ctrl_load, ctrl_store, ctrl_mult, ctrl_div, ctrl_link;
	input clock, reset;
	output [1:0] by_aluinA, by_aluinB, by_regB;
	output stall, multdiv_stall;
	

	// Write Reg Storage
	wire [4:0] writeReg_Decode, writeReg_Execute, writeReg_Memory;
	assign writeReg_Decode = stall ? 5'b0 : writeReg;
	register_5bit dx_write(.write(writeReg_Decode), .we(~multdiv_stall), .clr(reset), .clk(clock), .read(writeReg_Execute));
	register_5bit xm_write(.write(writeReg_Execute), .we(~multdiv_stall), .clr(reset), .clk(clock), .read(writeReg_Memory));

	// Bypass Signal Storage
	wire [4:0] bypass_Decode, bypass_Execute, bypass_Memory;
	or byor1(bypass_Decode[0], ctrl_mult, ctrl_div, ctrl_load);
	assign bypass_Decode[1] = ctrl_link;
	or byor2(bypass_Decode[2], ctrl_mult, ctrl_div);
	assign bypass_Decode[4:3] = 2'b0;
	register_5bit dx_bysig(.write(bypass_Decode), .we(~multdiv_stall), .clr(reset), .clk(clock), .read(bypass_Execute));
	register_5bit xm_bysig(.write(bypass_Execute), .we(~multdiv_stall), .clr(reset), .clk(clock), .read(bypass_Memory));
	
	// Exception Write Storage
	wire ew_Decode, ew_Execute, ew_Memory, uns0, ctrl_ew_full, ctrl_ew_nm;
	comparator_5 regW_exc_comp(.inA(writeReg), .inB(5'b11110), .same(uns0), .snz(ctrl_ew_nm));
	or exp_or(ctrl_ew_full, ctrl_ew, ctrl_ew_nm);
	assign ew_Decode = stall ? 1'b0 : ctrl_ew_full;
	dff_c dx_ew(.d(ew_Decode), .clr(reset), .en(~multdiv_stall), .clk(clock), .q(ew_Execute));
	dff_c xm_ew(.d(ew_Execute), .clr(reset), .en(~multdiv_stall), .clk(clock), .q(ew_Memory));

	// Compare write reg to read regs
	wire uns1, uns2, uns3, uns4, uns5, uns6;
	wire stall_execute_A, stall_execute_B, stall_memory_A, stall_memory_B;
	comparator_5 regA_x_comp(.inA(readRegA), .inB(writeReg_Execute), .same(uns1), .snz(stall_execute_A));
	comparator_5 regB_x_comp(.inA(readRegB), .inB(writeReg_Execute), .same(uns2), .snz(stall_execute_B));
	comparator_5 regA_m_comp(.inA(readRegA), .inB(writeReg_Memory), .same(uns3), .snz(stall_memory_A));
	comparator_5 regB_m_comp(.inA(readRegB), .inB(writeReg_Memory), .same(uns4), .snz(stall_memory_B));

	// Compare write exception to read exception
	wire stall_execute_exc, stall_memory_exc;
	and exc_x_comp(stall_execute_exc, ctrl_er, ew_Execute);
	and exc_m_comp(stall_memory_exc, ctrl_er, ew_Memory);
	
	// Bypass Logic
	wire [1:0] by_aluinA_D, by_aluinB_D, by_regB_D;
	wire bypass, nobp_stall;
	wire canBypass_X, ctrl_store_x, canBypass_M, fromMD;
	assign canBypass_X = ~bypass_Execute[0];
	assign canBypass_M = ~bypass_Memory[1];
	assign fromMD = bypass_Memory[2];
	//								Bypass ALU output into A        Bypass Multdiv Output into A
	assign by_aluinA_D[0] = (stall_execute_A & canBypass_X | stall_memory_A & fromMD) ? 1'b1 : 1'b0; 
	//								            Bypass ALU output into B        Bypass Multdiv Output into B
	assign by_aluinB_D[0] = (~ctrl_store & (stall_execute_B & canBypass_X | stall_memory_B & fromMD)) ? 1'b1 : 1'b0; 
	//								            Bypass ALU output into B (store) Bypass Multdiv Output into B (store)
	assign by_regB_D[0] = (ctrl_store & (stall_execute_B & canBypass_X | stall_memory_B & fromMD)) ? 1'b1 : 1'b0;
	//                      Bypass Mem or Multdiv Output into A
	assign by_aluinA_D[1] = (stall_memory_A & canBypass_M) ? 1'b1 : 1'b0; 
   //                                  Bypass Mem or Multdiv Output into B
	assign by_aluinB_D[1] = (~ctrl_store & stall_memory_B & canBypass_M) ? 1'b1 : 1'b0; 
	//                                  Bypass Mem or Multdiv Output into B (store)
	assign by_regB_D[1] = (ctrl_store & stall_memory_B & canBypass_M) ? 1'b1 : 1'b0;
	// Did we successfully bypass?
	assign bypass = (
	//             Fixed stall for A
						(~stall_execute_A & ~stall_memory_A | stall_execute_A & canBypass_X | stall_memory_A & canBypass_M) & 
	// 				Fixed stall for B
						(~stall_execute_B & ~stall_memory_A | stall_execute_B & canBypass_X | stall_memory_B & canBypass_M));
		
		
	// Bypass Signal Storage
	dff_c by_aluinA_0(.d(by_aluinA_D[0]), .clr(reset), .en(~multdiv_stall), .clk(clock), .q(by_aluinA[0]));	
	dff_c by_aluinA_1(.d(by_aluinA_D[1]), .clr(reset), .en(~multdiv_stall), .clk(clock), .q(by_aluinA[1]));	
	dff_c by_aluinB_0(.d(by_aluinB_D[0]), .clr(reset), .en(~multdiv_stall), .clk(clock), .q(by_aluinB[0]));	
	dff_c by_aluinB_1(.d(by_aluinB_D[1]), .clr(reset), .en(~multdiv_stall), .clk(clock), .q(by_aluinB[1]));	
	dff_c by_regB_0(.d(by_regB_D[0]), .clr(reset), .en(~multdiv_stall), .clk(clock), .q(by_regB[0]));	
	dff_c by_regB_1(.d(by_regB_D[1]), .clr(reset), .en(~multdiv_stall), .clk(clock), .q(by_regB[1]));	
	
	// General Stall Logic
	wire gen_stall;
	or stall_or(nobp_stall, stall_execute_A, stall_execute_B, stall_memory_A, stall_memory_B);
	and stall_and(gen_stall, nobp_stall, ~bypass);
	or stall_or2(stall, gen_stall, stall_execute_exc, stall_memory_exc, multdiv_stall);

	// Multdiv Stall Logic
	wire clear;
	or clear_or(clear, reset, multdiv_ready);
	dff_c md_st(.d(1'b1), .clr(clear), .en(multdiv_start), .clk(~clock), .q(multdiv_stall));

endmodule // stall
