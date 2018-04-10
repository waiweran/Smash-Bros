module tristate_8_1bit(sel, in0, in1, in2, in3, in4, in5, in6, in7, out);
	input [2:0] sel;
	input in0, in1, in2, in3, in4, in5, in6, in7;
	output out;
	
	wire [7:0] select;
	
	decoder_8 dcd(.in(sel), .out(select));
	
	assign out = (select[0] & in0) | 
					 (select[1] & in1) |
					 (select[2] & in2) |
					 (select[3] & in3) |
					 (select[4] & in4) |
					 (select[5] & in5) |
					 (select[6] & in6) |
					 (select[7] & in7);

endmodule
