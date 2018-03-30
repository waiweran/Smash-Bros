module cla_8bit(inA, inB, cin, G, P, sum);
	input [7:0] inA, inB;
	input cin;
	output[7:0] sum;
	output G, P;

	wire [7:0] c, g, p;

	// Carry bit 0
	assign c[0] = cin;

	// Carry bit 1
	wire cvar1;
	and cand0(cvar1, p[0], cin);
	or cor0(c[1], cvar1, g[0]);

	// Carry bit 2
	wire cvar2_1, cvar2_2;
	and cand2_1(cvar2_1, p[1], p[0], cin);
	and cand2_2(cvar2_2, p[1], g[0]);
	or cor2(c[2], cvar2_1, cvar2_2, g[1]);

	// Carry bit 3
	wire cvar3_1, cvar3_2, cvar3_3;
	and cand3_1(cvar3_1, p[2], p[1], p[0], cin);
	and cand3_2(cvar3_2, p[2], p[1], g[0]);
	and cand3_3(cvar3_3, p[2], g[1]);
	or cor3(c[3], cvar3_1, cvar3_2, cvar3_3, g[2]);

	// Carry bit 4
	wire cvar4_1, cvar4_2, cvar4_3, cvar4_4;
	and cand4_1(cvar4_1, p[3], p[2], p[1], p[0], cin);
	and cand4_2(cvar4_2, p[3], p[2], p[1], g[0]);
	and cand4_3(cvar4_3, p[3], p[2], g[1]);
	and cand4_4(cvar4_4, p[3], g[2]);
	or cor4(c[4], cvar4_1, cvar4_2, cvar4_3, cvar4_4, g[3]);

	// Carry bit 5
	wire cvar5_1, cvar5_2, cvar5_3, cvar5_4, cvar5_5;
	and cand5_1(cvar5_1, p[4], p[3], p[2], p[1], p[0], cin);
	and cand5_2(cvar5_2, p[4], p[3], p[2], p[1], g[0]);
	and cand5_3(cvar5_3, p[4], p[3], p[2], g[1]);
	and cand5_4(cvar5_4, p[4], p[3], g[2]);
	and cand5_5(cvar5_5, p[4], g[3]);
	or cor5(c[5], cvar5_1, cvar5_2, cvar5_3, cvar5_4, cvar5_5, g[4]);

	// Carry bit 6
	wire cvar6_1, cvar6_2, cvar6_3, cvar6_4, cvar6_5, cvar6_6;
	and cand6_1(cvar6_1, p[5], p[4], p[3], p[2], p[1], p[0], cin);
	and cand6_2(cvar6_2, p[5], p[4], p[3], p[2], p[1], g[0]);
	and cand6_3(cvar6_3, p[5], p[4], p[3], p[2], g[1]);
	and cand6_4(cvar6_4, p[5], p[4], p[3], g[2]);
	and cand6_5(cvar6_5, p[5], p[4], g[3]);
	and cand6_6(cvar6_6, p[5], g[4]);
	or cor6(c[6], cvar6_1, cvar6_2, cvar6_3, cvar6_4, cvar6_5, cvar6_6, g[5]);

	// Carry bit 7
	wire cvar7_1, cvar7_2, cvar7_3, cvar7_4, cvar7_5, cvar7_6, cvar7_7;
	and cand7_1(cvar7_1, p[6], p[5], p[4], p[3], p[2], p[1], p[0], cin);
	and cand7_2(cvar7_2, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and cand7_3(cvar7_3, p[6], p[5], p[4], p[3], p[2], g[1]);
	and cand7_4(cvar7_4, p[6], p[5], p[4], p[3], g[2]);
	and cand7_5(cvar7_5, p[6], p[5], p[4], g[3]);
	and cand7_6(cvar7_6, p[6], p[5], g[4]);
	and cand7_7(cvar7_7, p[6], g[5]);
	or cor7(c[7], cvar7_1, cvar7_2, cvar7_3, cvar7_4, cvar7_5, cvar7_6, cvar7_7, g[6]);

	// Adders
	genvar i;
	generate
		for(i = 0; i < 8; i = i + 1) begin: adder_loop
			full_add_cla add0(.inA(inA[i]), .inB(inB[i]), .cin(c[i]), .g(g[i]), .p(p[i]), .sum(sum[i]));
		end
	endgenerate

	// P output
	and pand(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);

	// G output
	wire cvar8_1, cvar8_2, cvar8_3, cvar8_4, cvar8_5, cvar8_6, cvar8_7, cvar8_8;
	and cand8_1(cvar8_1, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0], cin);
	and cand8_2(cvar8_2, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and cand8_3(cvar8_3, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
	and cand8_4(cvar8_4, p[7], p[6], p[5], p[4], p[3], g[2]);
	and cand8_5(cvar8_5, p[7], p[6], p[5], p[4], g[3]);
	and cand8_6(cvar8_6, p[7], p[6], p[5], g[4]);
	and cand8_7(cvar8_7, p[7], p[6], g[5]);
	and cand8_8(cvar8_8, p[7], g[6]);
	or cor8(G, cvar8_1, cvar8_2, cvar8_3, cvar8_4, cvar8_5, cvar8_6, cvar8_7, cvar8_8, g[7]);

endmodule