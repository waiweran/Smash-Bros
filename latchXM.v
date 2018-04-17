module latchXM(pcIn, pcOut, targetIn, targetOut, irIn, irOut, oIn, oOut, bIn, bOut, clock, reset);
	input[31:0] irIn, oIn, bIn, pcIn, targetIn;
	output[31:0] irOut, oOut, bOut, pcOut, targetOut;
	input clock, reset;
	
	register pcReg(reset, clock, 1'b1, pcIn, pcOut);
	register targetReg(reset, clock, 1'b1, targetIn, targetOut);
	register irReg(reset, clock, 1'b1, irIn, irOut);
	register oReg(reset, clock, 1'b1, oIn, oOut);
	register bReg(reset, clock, 1'b1, bIn, bOut);

endmodule
