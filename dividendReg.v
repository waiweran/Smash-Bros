module dividendReg(dataIn, dataOut, clock);
	input clock;
	input[63:0] dataIn;
	output[63:0] dataOut;
	
	genvar bitNum;
	generate
	for(bitNum = 0; bitNum < 64; bitNum = bitNum + 1) begin: dffLoop
		singleDFF bitDFF(dataIn[bitNum], 1'b0, clock, dataOut[bitNum], 1'b1);
	end
	endgenerate
	
endmodule