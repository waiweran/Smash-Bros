module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
	input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	
	wire[31:0] addMuxIn, subMuxIn, andMuxIn, orMuxIn, sllMuxIn, sraMuxIn;
	wire[31:0] notBLine;
   wire addOverflow, subOverflow;
	
	csa32Bit addModule(data_operandA, data_operandB, 1'b0, addMuxIn, addOverflow);
	csa32Bit subModule(data_operandA, notBLine, 1'b1, subMuxIn, subOverflow);
	bitwise bitwiseModule(data_operandA, data_operandB, andMuxIn, orMuxIn, notBLine);
	sll32 shiftLeftModule(data_operandA, ctrl_shiftamt, sllMuxIn);
	sra32 shiftRightModule(data_operandA, ctrl_shiftamt, sraMuxIn);
	
	wire[7:0] decoderOutput;
	decoder3to8 decoder(ctrl_ALUopcode[2:0], decoderOutput);
	
	assign data_result = decoderOutput[0] ? addMuxIn : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign data_result = decoderOutput[1] ? subMuxIn : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign data_result = decoderOutput[2] ? andMuxIn : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign data_result = decoderOutput[3] ? orMuxIn : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign data_result = decoderOutput[4] ? sllMuxIn : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign data_result = decoderOutput[5] ? sraMuxIn : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	
	//Overflow output
	assign overflow = ctrl_ALUopcode[0] ? subOverflow : addOverflow;
	
	//isNotEqual output
	wire w1, w2, w3, w4;
	or or1(w1, subMuxIn[0], subMuxIn[1], subMuxIn[2], subMuxIn[3], subMuxIn[4], subMuxIn[5], subMuxIn[6], subMuxIn[7]);
	or or2(w2, subMuxIn[8], subMuxIn[9], subMuxIn[10], subMuxIn[11], subMuxIn[12], subMuxIn[13], subMuxIn[14], subMuxIn[15]);
	or or3(w3, subMuxIn[16], subMuxIn[17], subMuxIn[18], subMuxIn[19], subMuxIn[20], subMuxIn[21], subMuxIn[22], subMuxIn[23]);
	or or4(w4, subMuxIn[24], subMuxIn[25], subMuxIn[26], subMuxIn[27], subMuxIn[28], subMuxIn[29], subMuxIn[30], subMuxIn[31]);
	or or5(isNotEqual, w1, w2, w3, w4);
	
	//isLessThan output
	xor isLessThanXor(isLessThan, subOverflow, subMuxIn[31]);
endmodule
