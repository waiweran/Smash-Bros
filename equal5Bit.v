module equal5Bit(a, b, out);
	input[4:0] a, b;
	output out;
	
	wire w0, w1, w2, w3, w4;
	xor xor0(w0, a[0], b[0]);
	xor xor1(w1, a[1], b[1]);
	xor xor2(w2, a[2], b[2]);
	xor xor3(w3, a[3], b[3]);
	xor xor4(w4, a[4], b[4]);
	
	assign out = !(w0 || w1 || w2 || w3 || w4);
	
endmodule
