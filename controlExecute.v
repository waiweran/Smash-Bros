/*
module controlExecute(PROBE_in, PROBE_out, clock, reset, bImmedMux_Select_D, alu_Opcode_D, dmem_WE_D, writebackMux_Select_D, regfile_WE_D, bImmedMux_Select_X, alu_Opcode_X, dmem_WE_X, writebackMux_Select_X, regfile_WE_X);
	input clock, reset;
	input bImmedMux_Select_D, dmem_WE_D, writebackMux_Select_D, regfile_WE_D;
	output bImmedMux_Select_X, dmem_WE_X, writebackMux_Select_X, regfile_WE_X;
	input[4:0] alu_Opcode_D;
	output[4:0] alu_Opcode_X;
	
	//DEBUGGING
	output PROBE_in, PROBE_out;
	assign PROBE_in = regfile_WE_D;
	assign PROBE_out = regfile_WE_X;
	
	singleDFF bImmedMux_Select   (bImmedMux_Select_D,    reset, clock, bImmedMux_Select_X,   1'b1);
	singleDFF dmem_WE            (dmem_WE_D,             reset, clock, dmem_WE_X,            1'b1);
	singleDFF writebackMux_Select(writebackMux_Select_D, reset, clock, writebackMux_Select_X, 1'b1);
	singleDFF regfile_WE         (regfile_WE_D,          reset, clock, regfile_WE_X,          1'b1);
	
	wire[31:0] in;
	wire[31:0] out;
	assign in[31:5] = 27'b0;
	assign in[4:0] = alu_Opcode_D;
	assign alu_Opcode_X = out[4:0];
	register alu_Opcode(reset, clock, 1'b1, in, out);
	
endmodule
*/


module controlExecute(instruction, bImmedMux_Select, alu_Opcode, bne, blt, j_or_jal, jr);
	input[31:0] instruction;
	output bImmedMux_Select, bne, blt, j_or_jal, jr;
	output[4:0] alu_Opcode;
	
	wire[31:0] decoderOutput;
	
	decoder5to32 myDecoder(instruction[31:27], decoderOutput);
	
	assign bImmedMux_Select = decoderOutput[5] || decoderOutput[7] || decoderOutput[8];
	assign bne = decoderOutput[2];
	assign blt = decoderOutput[6];
	assign j_or_jal = decoderOutput[1] || decoderOutput[3];
	assign jr = decoderOutput[4];
	
	wire[1:0] select;
	assign select[1] = decoderOutput[0];
	assign select[0] = decoderOutput[2] || decoderOutput[6];
	
	mux4To1Opcodes myMux(5'b00000, 5'b00001, instruction[6:2], instruction[6:2], select, alu_Opcode); 
	
endmodule