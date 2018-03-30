module adder_64(inA, inB, out);
	input [63:0] inA, inB;
	output [63:0] out;
	
	assign out = inA + inB;
	
endmodule
