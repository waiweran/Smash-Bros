module decoder_8(in, out);
	input [2:0] in;
	output [7:0] out;
	wire [2:0] nin;
	
	not notgate0(nin[0], in[0]);
	not notgate1(nin[1], in[1]);
	not notgate2(nin[2], in[2]);
	
	and and0(out[0], nin[2], nin[1], nin[0]);
	and and1(out[1], nin[2], nin[1], in[0]);
	and and2(out[2], nin[2], in[1], nin[0]);
	and and3(out[3], nin[2], in[1], in[0]);
	and and4(out[4], in[2], nin[1], nin[0]);
	and and5(out[5], in[2], nin[1], in[0]);
	and and6(out[6], in[2], in[1], nin[0]);
	and and7(out[7], in[2], in[1], in[0]);

endmodule
