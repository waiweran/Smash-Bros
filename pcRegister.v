//Special double edge 2 in 1 register to fix skipping 0th instruction bug.
module pcRegister(reset, clock, writeEnable, pcRegIn, pcRegOut);
	input reset, clock, writeEnable;
	input[31:0] pcRegIn;
	output[31:0] pcRegOut;
	
	wire[31:0] betweenRegs;
	
	register fallingEdgeReg(reset, ~clock, writeEnable, pcRegIn, betweenRegs);
	register risingEdgeReg(reset, clock, writeEnable, betweenRegs, pcRegOut);

endmodule
