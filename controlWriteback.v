/*
module controlWriteback(clock, reset, writebackMux_Select_M, regfile_WE_M, writebackMux_Select_W, regfile_WE_W);
	input clock, reset;
	input writebackMux_Select_M, regfile_WE_M;
	output writebackMux_Select_W, regfile_WE_W;

	singleDFF writebackMux_Select(writebackMux_Select_M, reset, clock, writebackMux_Select_W, 1'b1);
	singleDFF regfile_WE(regfile_WE_M, reset, clock, regfile_WE_W, 1'b1);
	
endmodule
*/

module controlWriteback(instruction, writebackMux_Select, regfile_WE, writePortMux_Select);
	input[31:0] instruction;
	output regfile_WE;
	output[1:0] writebackMux_Select, writePortMux_Select;
	
	wire[31:0] decoderOutput;
	
	decoder5to32 myDecoder(instruction[31:27], decoderOutput);
	
	assign writebackMux_Select[1] = decoderOutput[3] || decoderOutput[21];
	assign writebackMux_Select[0] = decoderOutput[8] || decoderOutput[21];
	assign regfile_WE = decoderOutput[0] || decoderOutput[5] || decoderOutput[8] || decoderOutput[3] || decoderOutput[21];
	assign writePortMux_Select[1] = decoderOutput[3];
	assign writePortMux_Select[0] = decoderOutput[21];
	
endmodule

/*
module controlWriteback(clock, reset, writebackMux_Select_M, regfile_WE_M, writePortMux_Select_M, writebackMux_Select, regfile_WE, writePortMux_Select);
	input clock, reset;
	input regfile_WE_M;
	input[1:0] writebackMux_Select_M, writePortMux_Select_M;
	output regfile_WE;
	output[1:0] writebackMux_Select, writePortMux_Select;
	
	singleDFF writebackMux_Select1DFF(writebackMux_Select_M[1], reset, clock, writebackMux_Select[1], 1'b1);
	singleDFF writebackMux_Select0DFF(writebackMux_Select_M[0], reset, clock, writebackMux_Select[0], 1'b1);
	singleDFF regfile_WEDFF(regfile_WE_M, reset, clock, regfile_WE, 1'b1);	
	singleDFF writePortMux_Select1DFF(writePortMux_Select_M[1], reset, clock, writePortMux_Select[1], 1'b1);
	singleDFF writePortMux_Select0DFF(writePortMux_Select_M[0], reset, clock, writePortMux_Select[0], 1'b1);
	
endmodule
*/
