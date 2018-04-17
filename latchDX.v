module latchDX(pcIn, pcOut, irIn, irOut, aIn, aOut, bIn, bOut, clock, reset);
	input[31:0] pcIn, irIn, aIn, bIn;
	output[31:0] pcOut, irOut, aOut, bOut;
	input clock, reset;
	
	register pcReg(reset, clock, 1'b1, pcIn, pcOut);
	register irReg(reset, clock, 1'b1, irIn, irOut);
	register aReg(reset, clock, 1'b1, aIn, aOut);
	register bReg(reset, clock, 1'b1, bIn, bOut);

endmodule