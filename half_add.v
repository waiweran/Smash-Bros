module half_add(inA, inB, cout, out);
	input inA, inB;
	output cout, out;
	
	xor gate1(out, inA, inB);
	and gate2(cout, inA, inB);
	
endmodule
