module divider(data_operandA, data_operandB, ctrl_DIV, clock, data_result);
	input [31:0] data_operandA, data_operandB;
	input ctrl_DIV, clock;

	output [31:0] data_result;

	
	//Divisor register
	wire[31:0] divisorToALU;
	register divisorRegister(1'b0, clock, ctrl_DIV, data_operandB, divisorToALU);
	
	//ALU
	wire[31:0] shiftedDividendToALU, ALUToLessMux; //shiftedDividendToALU: top
	wire isLessThan, dummyWire0, dummyWire1;
	
	alu divALU(shiftedDividendToALU, divisorToALU, 5'b00001, 5'b00000, ALUToLessMux, dummyWire0, isLessThan, dummyWire1);
	
	//Less Mux
	wire[31:0] lessMuxOutput;
	assign lessMuxOutput = isLessThan ? shiftedDividendToALU : ALUToLessMux;
	
	//Input Mux
	wire[63:0] dividendInput;
	wire[31:0] shiftedDividendToInputMux; //bottom
	wire[63:0] inputMuxInput0;
	assign inputMuxInput0[63:32] = lessMuxOutput;
	assign inputMuxInput0[31:0] = shiftedDividendToInputMux;
	
	wire[63:0] inputMuxInput1;
	assign inputMuxInput1[63:32] = 32'b0;
	assign inputMuxInput1[31:0] = data_operandA;
	
	assign dividendInput = ctrl_DIV ? inputMuxInput1 : inputMuxInput0;
	
	//Dividend register
	wire[63:0] dividendOutput;
	
	dividendReg myDividendReg(dividendInput, dividendOutput, clock);
	
	//Dividend shifter
	wire[63:0] dividendShifterOutput;
	assign dividendShifterOutput = dividendOutput << 1;
	assign shiftedDividendToALU = dividendShifterOutput[63:32];
	assign shiftedDividendToInputMux = dividendShifterOutput[31:0];
	
	//Quotient
	wire[31:0] quotientInput, quotientOutput;
	register quotientRegister(ctrl_DIV, clock, 1'b1, quotientInput, quotientOutput);
	
	wire[31:0] shiftedQuotient;
	assign shiftedQuotient = quotientOutput << 1;
	
	assign quotientInput[31:1] = shiftedQuotient[31:1];
	assign quotientInput[0] = ~isLessThan;
	
	//data_result
	assign data_result = quotientOutput;
	
endmodule

//TODO Negation