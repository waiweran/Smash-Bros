module bitwise(in1, in2, andOut, orOut, notOut); //Note the NOT operation inverts "in2"
	input[31:0] in1, in2;
	output[31:0] andOut, orOut, notOut;
	
	genvar i;
	generate
	for(i = 0; i < 32; i = i + 1) begin: loop
		and andGate(andOut[i], in1[i], in2[i]);
		or orGate(orOut[i], in1[i], in2[i]);
		not notGate(notOut[i], in2[i]);
	end
	endgenerate

endmodule
