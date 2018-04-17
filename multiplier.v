module multiplier(data_operandA, data_operandB, ctrl_MULT, clock, data_result, data_exception);
	input [31:0] data_operandA, data_operandB;
	input ctrl_MULT, clock;

	output [31:0] data_result;
	output data_exception;
	
	//Multiplicand register
	wire[31:0] multiplicandToALU;
	register multiplicandRegister(1'b0, clock, ctrl_MULT, data_operandA, multiplicandToALU);
	
	//ALU
	wire[31:0] pdctMultiplierToALU, ALUToBoothMux;
	wire[4:0] opcode;
	wire addSub;
	wire dummy0, dummy1, dummy2;
	
	assign opcode[4:1] = 4'b0;
	assign opcode[0] = addSub;
	
	wire lsb, falloutBit;
	assign addSub = lsb;
	
	alu myALU(pdctMultiplierToALU, multiplicandToALU, opcode, 5'b0, ALUToBoothMux, dummy0, dummy1, dummy2);
	
	//Booth Mux (4 to 1, with 32 bit buses)
	wire[1:0] boothMuxSelBits;
	wire[31:0] boothMuxOut;
	assign boothMuxSelBits[1] = lsb;
	assign boothMuxSelBits[0] = falloutBit;
	mux4To1 boothMux(pdctMultiplierToALU, ALUToBoothMux, ALUToBoothMux, pdctMultiplierToALU, boothMuxSelBits, boothMuxOut);
	
	//Product/Multiplicand Register
	wire[63:0] pMRegDataIn, pMRegDataOut;
	wire pMRegInFallout;
	
	productMultiplierReg pMReg(pMRegDataIn, pMRegDataOut, pMRegInFallout, lsb, falloutBit, clock);
	
	//Shifter
	wire[63:0] shiftIn, shiftOut;
	assign shiftIn[63:32] = boothMuxOut;
	assign shiftIn[31:0] = pMRegDataOut[31:0];
	assign shiftOut = shiftIn >>> 1;

	//Input Mux
	wire[63:0] paddedMultiplier;
	assign paddedMultiplier[63:32] = 32'b0;
	assign paddedMultiplier[31:0] = data_operandB;
	assign pMRegDataIn = ctrl_MULT ? paddedMultiplier : shiftOut;
	
	//Fallout Bit (Shifter Bypass and Mini-Input Mux)
	assign pMRegInFallout = ctrl_MULT ? 1'b0 : pMRegDataOut[0];
	
	//Take care of some other wires
	assign data_result = pMRegDataOut[31:0];
	assign pdctMultiplierToALU = pMRegDataOut[63:32];
	
	//Overflows - check if 31st bit same as rest of bits in front - if not, we have overflow.
	wire o1, o2;
	//pMRegDataOut[63:32]
	and and1(o1, pMRegDataOut[31], pMRegDataOut[32], pMRegDataOut[33], pMRegDataOut[34], pMRegDataOut[35], pMRegDataOut[36], pMRegDataOut[37], pMRegDataOut[38], pMRegDataOut[39], 
				pMRegDataOut[40], pMRegDataOut[41], pMRegDataOut[42], pMRegDataOut[43], pMRegDataOut[44], pMRegDataOut[45], pMRegDataOut[46], pMRegDataOut[47], 
				pMRegDataOut[48], pMRegDataOut[49], pMRegDataOut[50], pMRegDataOut[51], pMRegDataOut[52], pMRegDataOut[53], pMRegDataOut[54], pMRegDataOut[55], 
				pMRegDataOut[56], pMRegDataOut[57], pMRegDataOut[58], pMRegDataOut[59], pMRegDataOut[60], pMRegDataOut[61], pMRegDataOut[62], pMRegDataOut[63]);
	
	nor nor1(o2, pMRegDataOut[31], pMRegDataOut[32], pMRegDataOut[33], pMRegDataOut[34], pMRegDataOut[35], pMRegDataOut[36], pMRegDataOut[37], pMRegDataOut[38], pMRegDataOut[39], 
				pMRegDataOut[40], pMRegDataOut[41], pMRegDataOut[42], pMRegDataOut[43], pMRegDataOut[44], pMRegDataOut[45], pMRegDataOut[46], pMRegDataOut[47], 
				pMRegDataOut[48], pMRegDataOut[49], pMRegDataOut[50], pMRegDataOut[51], pMRegDataOut[52], pMRegDataOut[53], pMRegDataOut[54], pMRegDataOut[55], 
				pMRegDataOut[56], pMRegDataOut[57], pMRegDataOut[58], pMRegDataOut[59], pMRegDataOut[60], pMRegDataOut[61], pMRegDataOut[62], pMRegDataOut[63]);
				
	nor nor2(data_exception, o1, o2);
	
endmodule 


/*
module multiplier(data_operandA, data_operandB, ctrl_MULT, clock, data_result, data_exception, data_resultRDY,
	productMultiplierToALUTEST, lsbTEST, falloutBitTEST, multiplicandToALUTEST, boothMuxOutTEST);
	
	//TEST
	input[31:0] productMultiplierToALUTEST;
	input lsbTEST, falloutBitTEST; 
	output[31:0] boothMuxOutTEST;
	output[31:0] multiplicandToALUTEST;
	
	assign pdctMultiplierToALU = productMultiplierToALUTEST ;
	assign lsb = lsbTEST;
	assign falloutBit = falloutBitTEST;
	assign boothMuxOutTEST = boothMuxOut;
	assign multiplicandToALUTEST = multiplicandToALU;
	//ENDTEST
	
	input [31:0] data_operandA, data_operandB;
	input ctrl_MULT, clock;

	output [31:0] data_result;
	output data_exception, data_resultRDY;
	
	//Multiplicand register
	//TODO currently write enable always high (assumes data_operandA does not change during whole multiplication)...may need fix
	wire[31:0] multiplicandToALU;
	register multiplicandRegister(ctrl_MULT, clock, 1'b1, data_operandA, multiplicandToALU);
	
	//ALU
	wire[31:0] pdctMultiplierToALU, ALUToBoothMux;
	wire[4:0] opcode;
	wire addSub;
	wire dummy0, dummy1, dummy2;
	
	assign opcode[4:1] = 1'b0000;
	assign opcode[0] = addSub;
	
	assign addSub = lsb;
	
	alu myALU(pdctMultiplierToALU, multiplicandToALU, addSub, 1'b00000, ALUToBoothMux, dummy0, dummy1, dummy2);
	
	//Booth Mux (4 to 1, with 32 bit buses)
	wire lsb, falloutBit;
	wire[1:0] boothMuxSelBits;
	wire[31:0] boothMuxOut;
	assign boothMuxSelBits[1] = lsb;
	assign boothMuxSelBits[0] = falloutBit;
	mux4To1 boothMux(pdctMultiplierToALU, ALUToBoothMux, ALUToBoothMux, pdctMultiplierToALU, boothMuxSelBits, boothMuxOut);
	
endmodule 
*/