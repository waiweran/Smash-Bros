module mux_2_5bit(sel, in0, in1, out);
	input sel;
	input [4:0] in0, in1;
	output [4:0] out;
	assign out = sel ? in1 : in0;
endmodule
