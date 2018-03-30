module adder_32(inA, inB, cin, cout, ovf, sum);
	input [31:0] inA, inB;
	input cin;
	output[31:0] sum;
	output cout, ovf;

	// Sum
	assign sum = inA + inB;

	// Carry out
	assign cout = ((inA[31] | inB[31]) & ~sum[31]) | (inA[31] & inB[31]);

	// Overflow
	wire overflow1, overflow2;
	xnor overflowxnor(overflow1, inA[31], inB[31]);
	xor overflowxor(overflow2, inA[31], sum[31]);
	and overflowand(ovf, overflow1, overflow2);
	
endmodule