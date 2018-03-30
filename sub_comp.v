module sub_comp(inA, inB, neq, lt, ovf, sum);
	input [31:0] inA, inB;
	output [31:0] sum;
	output neq, lt, ovf;

	wire [31:0] invertB, comp;

	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: invloop
			not inverter(invertB[i], inB[i]);
		end
	endgenerate

	wire un;
	adder_32 adder(.inA(inA), .inB(invertB), .cin(1'b1), .ovf(ovf), .sum(sum), .cout(un));
	
	generate
		for(i = 0; i < 32; i = i + 1) begin: comploop
			xor comparator(comp[i], inA[i], inB[i]);
		end
	endgenerate

	or notEqual(neq, comp[0], comp[1], comp[2], comp[3], comp[4], comp[5], comp[6], comp[7], 
		comp[8], comp[9], comp[10], comp[11], comp[12], comp[13], comp[14], comp[15], comp[16], 
		comp[17], comp[18], comp[19], comp[20], comp[21], comp[22], comp[23], comp[24], comp[25], 
		comp[26], comp[27], comp[28], comp[29], comp[30], comp[31]);

	xor lessThan(lt, sum[31], ovf);

endmodule