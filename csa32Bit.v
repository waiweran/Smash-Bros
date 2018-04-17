module csa32Bit(a, b, cIn, sum, overflowDetected); //Notice no Cout...just discard!
	input[31:0] a, b;
	input cIn;
	output[31:0] sum;
	output overflowDetected;
	
	wire dummy0, dummy1, dummy2, dummy3, dummy4, cInMSBIn0, cInMSBIn1;
	
	//Slice 0
	//First cla8Bit doesn't need two copies; one fewer mux delay!
	wire carrySlice0to1;
	cla8Bit subadderSlice0(a[7:0], b[7:0], cIn, sum[7:0], carrySlice0to1, dummy4);
	
	//Slice 1
	wire[7:0] sumToMuxcIn0Slice1, sumToMuxcIn1Slice1;
	wire carryToMuxcIn0Slice1, carryToMuxcIn1Slice1, carrySlice1to2;
	cla8Bit subaddercIn0Slice1(a[15:8], b[15:8], 1'b0, sumToMuxcIn0Slice1, carryToMuxcIn0Slice1, dummy0);
	cla8Bit subaddercIn1Slice1(a[15:8], b[15:8], 1'b1, sumToMuxcIn1Slice1, carryToMuxcIn1Slice1, dummy1);
	assign sum[15:8] = carrySlice0to1 ? sumToMuxcIn1Slice1 : sumToMuxcIn0Slice1;
	assign carrySlice1to2 = carrySlice0to1 ? carryToMuxcIn1Slice1 : carryToMuxcIn0Slice1;
	
	//Slice 2
	wire[7:0] sumToMuxcIn0Slice2, sumToMuxcIn1Slice2;
	wire carryToMuxcIn0Slice2, carryToMuxcIn1Slice2, carrySlice2to3;
	cla8Bit subaddercIn0Slice2(a[23:16], b[23:16], 1'b0, sumToMuxcIn0Slice2, carryToMuxcIn0Slice2, dummy2);
	cla8Bit subaddercIn1Slice2(a[23:16], b[23:16], 1'b1, sumToMuxcIn1Slice2, carryToMuxcIn1Slice2, dummy3);
	assign sum[23:16] = carrySlice1to2 ? sumToMuxcIn1Slice2 : sumToMuxcIn0Slice2;
	assign carrySlice2to3 = carrySlice1to2 ? carryToMuxcIn1Slice2 : carryToMuxcIn0Slice2;
	
	//Slice 3
	wire[7:0] sumToMuxcIn0Slice3, sumToMuxcIn1Slice3;
	wire carryToMuxcIn0Slice3, carryToMuxcIn1Slice3;
	cla8Bit subaddercIn0Slice3(a[31:24], b[31:24], 1'b0, sumToMuxcIn0Slice3, carryToMuxcIn0Slice3, cInMSBIn0);
	cla8Bit subaddercIn1Slice3(a[31:24], b[31:24], 1'b1, sumToMuxcIn1Slice3, carryToMuxcIn1Slice3, cInMSBIn1);
	assign sum[31:24] = carrySlice2to3 ? sumToMuxcIn1Slice3 : sumToMuxcIn0Slice3;
	
	//Overflow detection
	wire cOut, cInMSB;
	assign cOut = carrySlice2to3 ? carryToMuxcIn1Slice3 : carryToMuxcIn0Slice3;
	assign cInMSB = carrySlice2to3 ? cInMSBIn1 : cInMSBIn0;
	xor overflowGate(overflowDetected, cInMSB, cOut);

endmodule
