//TODO write enable off after completes full multiplication
//Outputs "ready" after 32 cycles, starting from the first rising edge after the falling edge of resetWire.
//So that's 33 cycles after the first rising edge within resetWire.
//Holds "ready" until resetWire asserted again.
module counter(ctrl_MULT, clock, ready);
	input ctrl_MULT, clock;
	output ready;
	
	wire[35:0] outOfithDFF;
	wire resetWire;
	
	singleDFF myDFF0(1'b1, resetWire, clock, outOfithDFF[0], 1'b1);
	singleDFF myDFF1(1'b1, resetWire, clock, outOfithDFF[1], outOfithDFF[0]);
	singleDFF myDFF2(1'b1, resetWire, clock, outOfithDFF[2], outOfithDFF[1]);
	singleDFF myDFF3(1'b1, resetWire, clock, outOfithDFF[3], outOfithDFF[2]);
	singleDFF myDFF4(1'b1, resetWire, clock, outOfithDFF[4], outOfithDFF[3]);
	singleDFF myDFF5(1'b1, resetWire, clock, outOfithDFF[5], outOfithDFF[4]);
	singleDFF myDFF6(1'b1, resetWire, clock, outOfithDFF[6], outOfithDFF[5]);
	singleDFF myDFF7(1'b1, resetWire, clock, outOfithDFF[7], outOfithDFF[6]);
	singleDFF myDFF8(1'b1, resetWire, clock, outOfithDFF[8], outOfithDFF[7]);
	singleDFF myDFF9(1'b1, resetWire, clock, outOfithDFF[9], outOfithDFF[8]);
	singleDFF myDFF10(1'b1, resetWire, clock, outOfithDFF[10], outOfithDFF[9]);
	singleDFF myDFF11(1'b1, resetWire, clock, outOfithDFF[11], outOfithDFF[10]);
	singleDFF myDFF12(1'b1, resetWire, clock, outOfithDFF[12], outOfithDFF[11]);
	singleDFF myDFF13(1'b1, resetWire, clock, outOfithDFF[13], outOfithDFF[12]);
	singleDFF myDFF14(1'b1, resetWire, clock, outOfithDFF[14], outOfithDFF[13]);
	singleDFF myDFF15(1'b1, resetWire, clock, outOfithDFF[15], outOfithDFF[14]);
	singleDFF myDFF16(1'b1, resetWire, clock, outOfithDFF[16], outOfithDFF[15]);
	singleDFF myDFF17(1'b1, resetWire, clock, outOfithDFF[17], outOfithDFF[16]);
	singleDFF myDFF18(1'b1, resetWire, clock, outOfithDFF[18], outOfithDFF[17]);
	singleDFF myDFF19(1'b1, resetWire, clock, outOfithDFF[19], outOfithDFF[18]);
	singleDFF myDFF20(1'b1, resetWire, clock, outOfithDFF[20], outOfithDFF[19]);
	singleDFF myDFF21(1'b1, resetWire, clock, outOfithDFF[21], outOfithDFF[20]);
	singleDFF myDFF22(1'b1, resetWire, clock, outOfithDFF[22], outOfithDFF[21]);
	singleDFF myDFF23(1'b1, resetWire, clock, outOfithDFF[23], outOfithDFF[22]);
	singleDFF myDFF24(1'b1, resetWire, clock, outOfithDFF[24], outOfithDFF[23]);
	singleDFF myDFF25(1'b1, resetWire, clock, outOfithDFF[25], outOfithDFF[24]);
	singleDFF myDFF26(1'b1, resetWire, clock, outOfithDFF[26], outOfithDFF[25]);
	singleDFF myDFF27(1'b1, resetWire, clock, outOfithDFF[27], outOfithDFF[26]);
	singleDFF myDFF28(1'b1, resetWire, clock, outOfithDFF[28], outOfithDFF[27]);
	singleDFF myDFF29(1'b1, resetWire, clock, outOfithDFF[29], outOfithDFF[28]);
	singleDFF myDFF30(1'b1, resetWire, clock, outOfithDFF[30], outOfithDFF[29]);
	singleDFF myDFF31(1'b1, resetWire, clock, outOfithDFF[31], outOfithDFF[30]);
	assign ready = outOfithDFF[31];
	singleDFF myDFF32(1'b1, resetWire, clock, outOfithDFF[32], outOfithDFF[31]);
	assign resetWire = ctrl_MULT | outOfithDFF[32];
	
	//singleDFF myDFF32(1'b1, resetWire, clock, ready, outOfithDFF[31]);
	//singleDFF myDFF33(1'b1, resetWire, clock, outOfithDFF[33], outOfithDFF[32]);
	//singleDFF myDFF34(1'b1, resetWire, clock, outOfithDFF[34], outOfithDFF[33]);
	//singleDFF myDFF35(1'b1, resetWire, clock, ready, outOfithDFF[34]);

	

/*
	input resetWire, clock;
	output ready;
	
	wire[31:0] regIn, regOut;
	wire dummy;
	
	csa32Bit myCSA(regOut, 32'b00000000000000000000000000000001, 32'b00000000000000000000000000000000, regIn, dummy);
	
	register myReg(resetWire, clock, ~resetWire, regIn, regOut);
	
	output[31:0] count;
	
	assign count = regOut;
	
	nor nor1(ready, ~regOut[5], regOut[4], regOut[3], regOut[2], regOut[1], regOut[0]);
	*/
endmodule

/*
module counter(resetWire, clock, ready, count);
	input resetWire, clock;
	output ready;
	
	wire[31:0] regIn, regOut;
	wire dummy;
	
	csa32Bit myCSA(regOut, 32'b00000000000000000000000000000001, 32'b00000000000000000000000000000000, regIn, dummy);
	
	register myReg(resetWire, clock, ~resetWire, regIn, regOut);
	
	output[31:0] count;
	
	assign count = regOut;
	
	nor nor1(ready, ~regOut[5], regOut[4], regOut[3], regOut[2], regOut[1], regOut[0]);
	
endmodule
*/