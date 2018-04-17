/*
module controlMemory(clock, reset, dmem_WE_X, writebackMux_Select_X, regfile_WE_X, dmem_WE_M, writebackMux_Select_M, regfile_WE_M);
	input clock, reset;
	input dmem_WE_X, writebackMux_Select_X, regfile_WE_X;
	output dmem_WE_M, writebackMux_Select_M, regfile_WE_M;

	singleDFF dmem_WE(dmem_WE_X, reset, clock, dmem_WE_M, 1'b1);
	singleDFF writebackMux_Select(writebackMux_Select_X, reset, clock, writebackMux_Select_M, 1'b1);
	singleDFF regfile_WE(regfile_WE_X, reset, clock, regfile_WE_M, 1'b1);
	
endmodule
*/


module controlMemory(instruction, dmem_WE);
	input[31:0] instruction;
	output dmem_WE;
	
	wire[31:0] decoderOutput;
	
	decoder5to32 myDecoder(instruction[31:27], decoderOutput);
	
	assign dmem_WE = decoderOutput[7];

endmodule

/*
module controlMemory(instruction, dmem_WE, writebackMux_Select, regfile_WE, writePortMux_Select);
	input[31:0] instruction;
	output dmem_WE;
	
	output regfile_WE;
	output[1:0] writebackMux_Select, writePortMux_Select;
	
	wire[31:0] decoderOutput;
	
	decoder5to32 myDecoder(instruction[31:27], decoderOutput);
	
	assign dmem_WE = decoderOutput[7];
	
	assign writebackMux_Select[1] = decoderOutput[3] || decoderOutput[21];
	assign writebackMux_Select[0] = decoderOutput[8] || decoderOutput[21];
	assign regfile_WE = decoderOutput[0] || decoderOutput[5] || decoderOutput[8] || decoderOutput[3] || decoderOutput[21];
	assign writePortMux_Select[1] = decoderOutput[3];
	assign writePortMux_Select[0] = decoderOutput[21];

endmodule
*/