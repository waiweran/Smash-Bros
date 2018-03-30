module full_add_cla(inA, inB, cin, g, p, sum);
	input inA, inB, cin;
	output g, p, sum;

	and g_and(g, inA, inB);
	or p_or(p, inA, inB);

	wire add1;
	xor xor_add1(add1, inA, inB);
	xor xor_add2(sum, add1, cin);

endmodule