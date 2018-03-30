module comparator_5(inA, inB, same, snz);
	input [4:0] inA, inB;
	output same, snz;

	wire[4:0] bitcomp;
	genvar i;
	generate
		for(i = 0; i < 5; i = i + 1) begin: xnor_loop
			xnor bitcomp_xnor(bitcomp[i], inA[i], inB[i]);
		end // xnor_loop
	endgenerate

	wire nonzero;
	and same_and(same, bitcomp[0], bitcomp[1], bitcomp[2], bitcomp[3], bitcomp[4]);
	or snz_or(nonzero, inA[0], inA[1], inA[2], inA[3], inA[4]);
	and snz_and(snz, same, nonzero);

endmodule // comparator_5

