module mux4To1(in0, in1, in2, in3, select, out);
	input[31:0] in0, in1, in2, in3;
	input[1:0] select;
	output[31:0] out;
	
	wire[3:0] decoderOutput;
	decoder2to4 myDecoder(select, decoderOutput);
	
	assign out = decoderOutput[0] ? in0 : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign out = decoderOutput[1] ? in1 : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign out = decoderOutput[2] ? in2 : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign out = decoderOutput[3] ? in3 : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
endmodule
