module mux8to1PortExtractor(in0, in1, in2, in3, in4, in5, in6, in7, select, out);
	input[2:0] in0, in1, in2, in3, in4, in5, in6, in7;
	input[2:0] select;
	output[2:0] out;
	
	wire[7:0] decoderOutput;
	decoder3to8 myDecoder(select, decoderOutput);
	
	assign out = decoderOutput[0] ? in0 : 3'bzzz;
	assign out = decoderOutput[1] ? in1 : 3'bzzz;
	assign out = decoderOutput[2] ? in2 : 3'bzzz;
	assign out = decoderOutput[3] ? in3 : 3'bzzz;
	assign out = decoderOutput[4] ? in4 : 3'bzzz;
	assign out = decoderOutput[5] ? in5 : 3'bzzz;
	assign out = decoderOutput[6] ? in6 : 3'bzzz;
	assign out = decoderOutput[7] ? in7 : 3'bzzz;
	
endmodule