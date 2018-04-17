module latchFD(pcIn, pcOut, irIn, irOut, clock, reset, writeEnable);
	input[31:0] pcIn, irIn;
	output[31:0] pcOut, irOut;
	input clock, reset, writeEnable;
	
	register pcReg(reset, clock, writeEnable, pcIn, pcOut);
	register irReg(reset, clock, writeEnable, irIn, irOut);

endmodule
