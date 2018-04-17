module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
		
	 wire multException;
	 wire[31:0] multResult;
	 multiplier myMultiplier(data_operandA, data_operandB, ctrl_MULT, clock, multResult, multException);
	 
	 wire[31:0] divResult;
	 divider myDivider(data_operandA, data_operandB, ctrl_DIV, clock, divResult); //TODO negation
	 
	 wire multReady, divReady;
	 
	 counter multCounter(ctrl_MULT, clock, multReady);
	 
	 counter myDivCounter(ctrl_DIV, clock, divReady);
	 
	 //lastStartedOp DFF
	 wire lastStartedOp; //0 = mult, 1 = div, 0 also before any ops executed
	 singleDFF lastStartedOpDFF(ctrl_DIV, 1'b0, clock, lastStartedOp, ctrl_MULT | ctrl_DIV);

	 //Output choose between mult and div answer
	 assign data_result = lastStartedOp ? divResult : multResult;
	 assign data_resultRDY = lastStartedOp ? divReady : multReady;
	 
	 //Exceptions
	 wire bAllZeros;
	 nor norGate(bAllZeros, data_operandB[0], data_operandB[1], data_operandB[2], data_operandB[3], data_operandB[4], data_operandB[5], data_operandB[6], data_operandB[7], 
	data_operandB[8], data_operandB[9], data_operandB[10], data_operandB[11], data_operandB[12], data_operandB[13], data_operandB[14], data_operandB[15], 
	data_operandB[16], data_operandB[17], data_operandB[18], data_operandB[19], data_operandB[20], data_operandB[21], data_operandB[22], data_operandB[23], 
	data_operandB[24], data_operandB[25], data_operandB[26], data_operandB[27], data_operandB[28], data_operandB[29], data_operandB[30], data_operandB[31]);
	 assign data_exception = lastStartedOp & bAllZeros; //(~lastStartedOp & multException) | (lastStartedOp & data_operandB);
endmodule
