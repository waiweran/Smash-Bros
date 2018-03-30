module adder_64(inA, inB, out);
	input [63:0] inA, inB;
	output [63:0] out;
	
	wire cout;
	wire c2, c3;
	
	wire [31:0] sum0, sum1;
	
	wire un1, un2, un3;
	
	adder_32 add1(.inA(inA[31:0]), .inB(inB[31:0]), .cin(1'b0), .cout(cout), .sum(out[31:0]), .ovf(un1));
	adder_32 add2(.inA(inA[63:32]), .inB(inB[63:32]), .cin(1'b0), .cout(c2), .sum(sum0), .ovf(un2));
	adder_32 add3(.inA(inA[63:32]), .inB(inB[63:32]), .cin(1'b1), .cout(c3), .sum(sum1), .ovf(un3));
	
	mux_2 mux(.sel(cout), .in0(sum0), .in1(sum1), .out(out[63:32]));
	
endmodule
