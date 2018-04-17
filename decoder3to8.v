module decoder3to8(in, out);
	input[2:0] in;
	output[7:0] out;
	
	//Make the nots
	wire[2:0] notIn;
	
	genvar i;
	generate
	for(i = 0; i < 3; i = i + 1) begin: notGateLoop
		not notGate(notIn[i], in[i]);
	end
	endgenerate
	
	//Make the ands
	and and0(out[0], notIn[2], notIn[1], notIn[0]);
	and and1(out[1], notIn[2], notIn[1], in[0]);
	and and2(out[2], notIn[2], in[1], notIn[0]);
	and and3(out[3], notIn[2], in[1], in[0]);
	and and4(out[4], in[2], notIn[1], notIn[0]);
	and and5(out[5], in[2], notIn[1], in[0]);
	and and6(out[6], in[2], in[1], notIn[0]);
	and and7(out[7], in[2], in[1], in[0]);
	
endmodule
