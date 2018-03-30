module sign_inverter(invert, in, out);
	input [31:0] in;
	input invert;
	output [31:0] out;
	
	wire [31:0] inv_in, negated_in;
	
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: invert_loop
			not invA(inv_in[i], in[i]);
		end
	endgenerate

	wire cout, ovf;
	adder_32 inverting_adder(.inA(inv_in), .inB(32'b0), .cin(1'b1), .cout(cout), .sum(negated_in), .ovf(ovf));
	mux_2 muxA(.sel(invert), .in0(in), .in1(negated_in), .out(out));
	
endmodule
