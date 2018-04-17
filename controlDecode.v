/*
module controlDecode(instruction, rtrd_Select_D, bImmedMux_Select_D, alu_Opcode_D, dmem_WE_D, writebackMux_Select_D, regfile_WE_D);
	input[31:0] instruction;
	output rtrd_Select_D, bImmedMux_Select_D, dmem_WE_D, writebackMux_Select_D, regfile_WE_D;
	output[4:0] alu_Opcode_D;
	
	wire[31:0] decoderOutput;
	
	decoder5to32 myDecoder(instruction[31:27], decoderOutput);

	assign rtrd_Select_D = decoderOutput[7]; //WARNING: If ever edit this line, must change corresponding line in portExtractor.v
	assign bImmedMux_Select_D = decoderOutput[5] || decoderOutput[7] || decoderOutput[8]; 
	assign dmem_WE_D = decoderOutput[7];
	assign writebackMux_Select_D = decoderOutput[8];
	assign regfile_WE_D = decoderOutput[0] || decoderOutput[5] || decoderOutput[8];
	
	//ALU Opcode Determination
	wire[1:0] select;
	assign select[1] = decoderOutput[0];
	assign select[0] = decoderOutput[2] || decoderOutput[6];
	
	mux4To1Opcodes myMux(5'b00000, 5'b00001, instruction[6:2], instruction[6:2], select, alu_Opcode_D); 
	
endmodule
*/


module controlDecode(instruction, rtrd_Select);
	input[31:0] instruction;
	output rtrd_Select;
	
	wire[31:0] decoderOutput;
	
	decoder5to32 myDecoder(instruction[31:27], decoderOutput);
	
	assign rtrd_Select = decoderOutput[7] || decoderOutput[2] || decoderOutput[4] || decoderOutput[6];
	//TODO make this a 2 bit mux for bex instruction
	
endmodule
