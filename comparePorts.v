module comparePorts(a, b, out);
	input[5:0] a, b;
	output out;
	
	wire doCare, rawEqual;
	nor norGate(doCare, a[5], b[5]);
	equal5Bit myEqual(a[4:0], b[4:0], rawEqual);
	
	assign out = doCare ? rawEqual : 1'b0;

endmodule
