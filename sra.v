module sra(in, shamt, out);
	input [31:0] in;
	input [4:0] shamt;
	output[31:0] out;
	
	wire [31:0] shbit5, shbit4, shbit3, shbit2, shbit1;
	wire [31:0] shout5, shout4, shout3, shout2;
	
	genvar i;
	generate
		for(i = 16; i < 32; i = i + 1) begin: arloop5
			assign shbit5[i] = in[31];
		end
	endgenerate	
	assign shbit5[15:0] = in[31:16];
	mux_2 mux5(.sel(shamt[4]), .in0(in), .in1(shbit5), .out(shout5));
	
	generate
		for(i = 24; i < 32; i = i + 1) begin: arloop4
			assign shbit4[i] = shout5[31];
		end
	endgenerate	
	assign shbit4[23:0] = shout5[31:8];
	mux_2 mux4(.sel(shamt[3]), .in0(shout5), .in1(shbit4), .out(shout4));
	
	generate
		for(i = 28; i < 32; i = i + 1) begin: arloop3
			assign shbit3[i] = shout4[31];
		end
	endgenerate	
	assign shbit3[27:0] = shout4[31:4];
	mux_2 mux3(.sel(shamt[2]), .in0(shout4), .in1(shbit3), .out(shout3));

	generate
		for(i = 30; i < 32; i = i + 1) begin: arloop2
			assign shbit2[i] = shout3[31];
		end
	endgenerate	
	assign shbit2[29:0] = shout3[31:2];
	mux_2 mux2(.sel(shamt[1]), .in0(shout3), .in1(shbit2), .out(shout2));

	generate
		for(i = 31; i < 32; i = i + 1) begin: arloop1
			assign shbit1[i] = shout2[31];
		end
	endgenerate	
	assign shbit1[30:0] = shout2[31:1];
	mux_2 mux1(.sel(shamt[0]), .in0(shout2), .in1(shbit1), .out(out));
	
	
	
endmodule
