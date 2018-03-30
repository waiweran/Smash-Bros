module full_add(inA, inB, cin, cout, out);
	input inA, inB, cin;
	output cout, out;
	
	wire and1, and2, and3;
	
	xor gate1(and1, inA, inB);
	xor gate2(out, and1, cin);
	
	and gate3(and2, inA, inB);
	and gate4(and3, and1, cin);
	or gate5(cout, and2, and3);
	
endmodule
