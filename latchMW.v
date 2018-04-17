module latchMW(pcIn, pcOut, targetIn, targetOut, irIn, irOut, oIn, oOut, dIn, dOut, clock, reset);
	input[31:0] irIn, oIn, dIn, pcIn, targetIn;
	output[31:0] irOut, oOut, dOut, pcOut, targetOut;
	input clock, reset;
	
	register pcReg(reset, clock, 1'b1, pcIn, pcOut);
	register targetReg(reset, clock, 1'b1, targetIn, targetOut);
	register irReg(reset, clock, 1'b1, irIn, irOut);
	register oReg(reset, clock, 1'b1, oIn, oOut);
	register dReg(reset, clock, 1'b1, dIn, dOut);

endmodule
