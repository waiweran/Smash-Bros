module mux4To1Opcodes(in0, in1, in2, in3, select, out);
	input[4:0] in0, in1, in2, in3;
	input[1:0] select;
	output[4:0] out;
	
	wire[3:0] decoderOutput;
	decoder2to4 myDecoder(select, decoderOutput);
	
	assign out = decoderOutput[0] ? in0 : 5'bzzzzz;
	assign out = decoderOutput[1] ? in1 : 5'bzzzzz;
	assign out = decoderOutput[2] ? in2 : 5'bzzzzz;
	assign out = decoderOutput[3] ? in3 : 5'bzzzzz;
endmodule