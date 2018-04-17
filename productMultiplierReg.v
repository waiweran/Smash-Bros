//A 65 bit register.
//Must do data cycles falling-edge to falling-edge. See waveform for what happens for rising edge to rising edge case.
module productMultiplierReg(dataIn, dataOut, dataInFallout, dataOutLSB, dataOutFallout, clock);
	input clock, dataInFallout;
	input[63:0] dataIn;
	output[63:0] dataOut;
	output dataOutLSB, dataOutFallout;
	
	singleDFF falloutBit(dataInFallout, 1'b0, clock, dataOutFallout, 1'b1);
	
	assign dataOutLSB = dataOut[0];
	
	genvar bitNum;
	generate
	for(bitNum = 0; bitNum < 64; bitNum = bitNum + 1) begin: dffLoop
		singleDFF bitDFF(dataIn[bitNum], 1'b0, clock, dataOut[bitNum], 1'b1);
	end
	endgenerate
	
endmodule
