module decoder2to4(in, out);
	input[1:0] in;
	output[3:0] out;
	
	//Make the nots
	wire[1:0] notIn;
	
	genvar i;
	generate
	for(i = 0; i < 2; i = i + 1) begin: notGateLoop
		not notGate(notIn[i], in[i]);
	end
	endgenerate
	
	and and0(out[0], notIn[1], notIn[0]);
	and and1(out[1], notIn[1], in[0]);
	and and2(out[2], in[1], notIn[0]);
	and and3(out[3], in[1], in[0]);
	
endmodule
