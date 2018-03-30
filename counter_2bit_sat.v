module counter_2bit_sat(in, write, reset, clock, out);
	input in, write, reset, clock;
	output out;

	wire c1, c2, n1, n2;
	dff_c bit1(.d(n1), .clr(reset), .en(write), .clk(clock), .q(c1));
	dff_c bit2(.d(n2), .clr(reset), .en(write), .clk(clock), .q(c2));

	wire n1_and1, n1_and2, n1_and3, n2_and1, n2_and2;
	and n1_1(n1_and1, c1, c2);
	and n1_2(n1_and2, c1, in);
	and n1_3(n1_and3, ~c2, in);
	or n1_or(n1, n1_and1, n1_and2, n1_and3);
	and n2_1(n2_and1, c1, in);
	and n2_2(n2_and2, ~c1, ~in);
	or n2_or(n2, n2_and1, n2_and2);

	assign out = c1;

endmodule