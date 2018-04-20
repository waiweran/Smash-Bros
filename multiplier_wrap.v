module multiplier_wrap(inA, inB, start, clock, reset, done, overflow, product);
	input [31:0] inA, inB;
	input start, clock, reset;
	output [31:0] product;
	output done, overflow;

	wire final_sign;
	wire [31:0] positive_inA, positive_inB, positive_product;
	xor sign_gate(final_sign, inA[31], inB[31]);
	sign_inverter inAsign(.invert(inA[31]), .in(inA), .out(positive_inA));
	sign_inverter inBsign(.invert(inB[31]), .in(inB), .out(positive_inB));
	sign_inverter outsign(.invert(final_sign), .in(positive_product), .out(product));

	wire [63:0] out;
	multiplier mult(.inA(positive_inA), .inB(positive_inB), .out(out));
	//assign out = 64'b0;

	wire timing;
	
	assign positive_product[31:0] = out[31:0];

	// Timing
	dff_c startdff(.d(start), .clr(timing | reset), .en(1'b1), .clk(clock), .q(done));
	dff_c enddff(.d(done), .clr(reset), .en(1'b1), .clk(clock), .q(timing));

	wire allCases, largestNeg, not31, notfinalsign;
	or overflow_or(allCases, out[31], out[32], out[33], out[34], out[35], out[36], out[37], out[38], 
		out[39], out[40], out[41], out[42], out[43], out[44], out[45], out[46], out[47], out[48], out[49], 
		out[50], out[51], out[52], out[53], out[54], out[55], out[56], out[57], out[58], out[59], out[60], 
		out[61], out[62], out[63]);	
	not overflow_not(not31, out[31]);
	not overflow_not2(notfinalsign, final_sign);
	or overflow_nor(largestNeg, out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], 
		out[9], out[10], out[11], out[12], out[13], out[14], out[15], out[16], out[17], out[18], out[19], 
		out[20], out[21], out[22], out[23], out[24], out[25], out[26], out[27], out[28], out[29], out[30], 
		not31, out[32], out[33], out[34], out[35], out[36], out[37], out[38], 
		out[39], out[40], out[41], out[42], out[43], out[44], out[45], out[46], out[47], out[48], out[49], 
		out[50], out[51], out[52], out[53], out[54], out[55], out[56], out[57], out[58], out[59], out[60], 
		out[61], out[62], out[63], notfinalsign);
		
	and overflow_and(overflow, allCases, largestNeg);

endmodule // multiplier_wrap