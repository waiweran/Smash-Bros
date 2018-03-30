module tristate_8_1bit(sel, in0, in1, in2, in3, in4, in5, in6, in7, out);
	input [2:0] sel;
	input in0, in1, in2, in3, in4, in5, in6, in7;
	output out;
	
	wire [7:0] select;
	
	decoder_8 dcd(.in(sel), .out(select));
	
	assign out = select[0] ? in0 : 1'bz;
	assign out = select[1] ? in1 : 1'bz;
	assign out = select[2] ? in2 : 1'bz;
	assign out = select[3] ? in3 : 1'bz;
	assign out = select[4] ? in4 : 1'bz;
	assign out = select[5] ? in5 : 1'bz;
	assign out = select[6] ? in6 : 1'bz;
	assign out = select[7] ? in7 : 1'bz;

endmodule
