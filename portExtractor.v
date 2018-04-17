//Note readPortA, readPortB, and writePort all have an extra MSB saying if it is "invalid" (i.e. because this instruction does not specify that particular port)

module portExtractor(instruction, readPortA, readPortB, writePort);
	input[31:0] instruction;
	output[5:0] readPortA, readPortB, writePort;
	
	//Instruction Type Determination
	wire[31:0] mainDecoderOutput, aluOpcodeDecoderOutput;
	decoder5to32 mainDecoder(instruction[31:27], mainDecoderOutput);
	decoder5to32 aluOpcodeDecoder(instruction[6:2], aluOpcodeDecoderOutput);
	
	wire category2, category3, category4, category5, category6, category7, isShift;
	
	assign isShift = aluOpcodeDecoderOutput[4] || aluOpcodeDecoderOutput[5]; //Could be non-R-type, in which case this is inaccurate, but need check main opcode == 00000 too
	//assign category1 = mainDecoderOutput[0] && ~isShift; //Unneeded
	assign category2 = (mainDecoderOutput[0] && isShift) || mainDecoderOutput[5] || mainDecoderOutput[8];
	assign category3 = mainDecoderOutput[7] || mainDecoderOutput[2] || mainDecoderOutput[6];
	assign category4 = mainDecoderOutput[1] || mainDecoderOutput[22];
	assign category5 = mainDecoderOutput[4];
	assign category6 = mainDecoderOutput[3];
	assign category7 = mainDecoderOutput[21];
	
	//nop
	wire nop;
	assign nop = !(instruction[0] || instruction[1] || instruction[2] || instruction[3] ||
						instruction[4] || instruction[5] || instruction[6] || instruction[7] ||
						instruction[8] || instruction[9] || instruction[10] || instruction[11] ||
						instruction[12] || instruction[13] || instruction[14] || instruction[15] ||
						instruction[16] || instruction[17] || instruction[18] || instruction[19] ||
						instruction[20] || instruction[21] || instruction[22] || instruction[23] ||
						instruction[24] || instruction[25] || instruction[26] || instruction[27] ||
						instruction[28] || instruction[29] || instruction[30] || instruction[31]);
	
	//Forming rs, rt, rd
	wire[4:0] rs, rt, rd;
	assign rs = instruction[21:17];
	assign rt = instruction[16:12];
	assign rd = instruction[26:22];
	
	assign readPortA[4:0] = rs;
	assign readPortA[5] = category4 || category5 || category6 || category7 || nop;
	assign readPortB[4:0] = (category3 || category5) ? rd : rt;
	assign readPortB[5] = category2 || category4 || category6 || category7 || nop;
	//assign writePort[4:0] = rd;
	
	assign writePort[4:0] = !(category6 || category7) ? rd : 5'bz;
	assign writePort[4:0] = category6 ? 5'd31 : 5'bz;
	assign writePort[4:0] = category7 ? 5'd30 : 5'bz;
	
	assign writePort[5] = category3 || category4 || category5 || nop;
	
	
	
endmodule

/*
module portExtractor(instruction, readPortA, readPortB, writePort);
	input[31:0] instruction;
	output[5:0] readPortA, readPortB, writePort;
	
	//Instruction Type Determination
	wire[31:0] decoderOutput;
	decoder5to32 myDecoder(instruction[31:27], decoderOutput);
	
	wire i, ji, jii;
	assign i = decoderOutput[5] || decoderOutput[7] || decoderOutput[8] || decoderOutput[2] || decoderOutput[6];
	assign ji = decoderOutput[1] || decoderOutput[6];
	assign jii = decoderOutput[4];
	
	//Forming rs, rt, rd
	wire[2:0] select;
	wire[2:0] muxOut;
	assign select[2] = jii;
	assign select[1] = ji;
	assign select[0] = i;
	
	//Should never output 000 - good for error testing
	mux8to1PortExtractor myMux(3'b000,3'b010,3'b111,3'b000,3'b000,3'b000,3'b000,3'b011, select, muxOut);
	
	wire[5:0] rs, rt, rd;
	assign rs[4:0] = instruction[21:17];
	assign rt[4:0] = instruction[16:12];
	assign rd[4:0] = instruction[26:22];
	assign rs[5] = muxOut[0];
	assign rt[5] = muxOut[1];
	assign rd[5] = muxOut[2];
	
	//readPortA, readPortB, writePort
	wire rtrd_Select;
	assign rtrd_Select = decoderOutput[7]; //WARNING: If ever edit this line, must change corresponding line in controlDecode.v
	
	assign readPortA = rs;
	assign readPortB = rtrd_Select ? rd : rt;
	assign writePort = rd;
	
endmodule
*/