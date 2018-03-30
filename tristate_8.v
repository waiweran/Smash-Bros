module tristate_8(sel, in0, in1, in2, in3, in4, in5, in6, in7, out);
	input [2:0] sel;
	input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
	output [31:0] out;
	
	wire [7:0] select;
	
	decoder_8 dcd(.in(sel), .out(select));
	
	assign out = select[0] ? in0 : 32'bz;
	assign out = select[1] ? in1 : 32'bz;
	assign out = select[2] ? in2 : 32'bz;
	assign out = select[3] ? in3 : 32'bz;
	assign out = select[4] ? in4 : 32'bz;
	assign out = select[5] ? in5 : 32'bz;
	assign out = select[6] ? in6 : 32'bz;
	assign out = select[7] ? in7 : 32'bz;

endmodule
