module adder_32(inA, inB, cin, cout, ovf, sum);
	input [31:0] inA, inB;
	input cin;
	output[31:0] sum;
	output cout, ovf;

	wire [3:0] G, P;
	wire carry1, carry2, carry3;

	// Carry bit 1
	wire cvar1;
	and cand0(cvar1, P[0], cin);
	or cor0(carry1, G[0], cvar1);

	// Carry bit 2
	wire cvar2_1, cvar2_2;
	and cand2_1(cvar2_1, P[1], P[0], cin);
	and cand2_2(cvar2_2, P[1], G[0]);
	or cor2(carry2, cvar2_1, cvar2_2, G[1]);

	// Carry bit 3
	wire cvar3_1, cvar3_2, cvar3_3;
	and cand3_1(cvar3_1, P[2], P[1], P[0], cin);
	and cand3_2(cvar3_2, P[2], P[1], G[0]);
	and cand3_3(cvar3_3, P[2], G[1]);
	or cor3(carry3, cvar3_1, cvar3_2, cvar3_3, G[2]);

	// 8-bit Adders
	cla_8bit add1(.inA(inA[7:0]), .inB(inB[7:0]), .cin(cin), .G(G[0]), .P(P[0]), .sum(sum[7:0]));
	cla_8bit add2(.inA(inA[15:8]), .inB(inB[15:8]), .cin(carry1), .G(G[1]), .P(P[1]), .sum(sum[15:8]));
	cla_8bit add3(.inA(inA[23:16]), .inB(inB[23:16]), .cin(carry2), .G(G[2]), .P(P[2]), .sum(sum[23:16]));
	cla_8bit add4(.inA(inA[31:24]), .inB(inB[31:24]), .cin(carry3), .G(G[3]), .P(P[3]), .sum(sum[31:24]));

	// Carry bit 4
	wire cvar4_1, cvar4_2, cvar4_3, cvar4_4;
	and cand4_1(cvar4_1, P[3], P[2], P[1], P[0], cin);
	and cand4_2(cvar4_2, P[3], P[2], P[1], G[0]);
	and cand4_3(cvar4_3, P[3], P[2], G[1]);
	and cand4_4(cvar4_4, P[3], G[2]);
	or cor4(cout, cvar4_1, cvar4_2, cvar4_3, G[3]);

	// Overflow
	wire overflow1, overflow2;
	xnor overflowxnor(overflow1, inA[31], inB[31]);
	xor overflowxor(overflow2, inA[31], sum[31]);
	and overflowand(ovf, overflow1, overflow2);
	
endmodule