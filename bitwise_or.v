module bitwise_or(inA, inB, out);
	input [31:0] inA, inB;
	output [31:0] out;
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: orloop
			or my_or(out[i], inA[i], inB[i]);
		end
	endgenerate
endmodule