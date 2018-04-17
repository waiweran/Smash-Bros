module cla8Bit(a, b, c0, sum, c8, c7);   //need output c7 for overflow detection
	input[7:0] a, b;
	input c0;
	output[7:0] sum;
	output c8, c7;
	
	wire[7:0] gen;
	wire[7:0] prop;
	wire[8:0] carry; //one extra!
	
	assign carry[0] = c0;
	assign c8 = carry[8];
	assign c7 = carry[7];
	
	genvar i;
	generate
	for(i = 0; i < 8; i = i + 1) begin: genPropLoop
		and genGate(gen[i], a[i], b[i]);
		xor propGate(prop[i], a[i], b[i]);
	end
	endgenerate

	genvar j;
	generate
	for(j = 0; j < 8; j = j + 1) begin: sumLoop
		xor sumGate(sum[j], a[j], b[j], carry[j]);
	end
	endgenerate
	
	wire w0, w1, w2, w3, w4, w5, w6, w7;

	and and0(w0, prop[0], carry[0]);
	or or0(carry[1], gen[0], w0);
	
	and and1(w1, prop[1], carry[1]);
	or or1(carry[2], gen[1], w1);
	
	and and2(w2, prop[2], carry[2]);
	or or2(carry[3], gen[2], w2);
	
	and and3(w3, prop[3], carry[3]);
	or or3(carry[4], gen[3], w3);
	
	and and4(w4, prop[4], carry[4]);
	or or4(carry[5], gen[4], w4);
	
	and and5(w5, prop[5], carry[5]);
	or or5(carry[6], gen[5], w5);
	
	and and6(w6, prop[6], carry[6]);
	or or6(carry[7], gen[6], w6);
	
	and and7(w7, prop[7], carry[7]);
	or or7(carry[8], gen[7], w7);
endmodule
