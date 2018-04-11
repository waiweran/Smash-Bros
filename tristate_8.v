module tristate_8(sel, in0, in1, in2, in3, in4, in5, in6, in7, out);
	input [2:0] sel;
	input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
	output [31:0] out;
	
	wire [31:0] out1, out2;
	mux_4 mux1(sel[1:0], in0, in1, in2, in3, out1);
	mux_4 mux2(sel[1:0], in4, in5, in6, in7, out2);
	mux_2 mux3(sel[2], out1, out2, out);

endmodule
