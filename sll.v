module sll(in, shamt, out);
	input [31:0] in;
	input [4:0] shamt;
	output[31:0] out;
	
	wire [31:0] shbit5, shbit4, shbit3, shbit2, shbit1;
	wire [31:0] shout5, shout4, shout3, shout2;
	
	assign shbit5[31:16] = in[15:0];
	assign shbit5[15:0] = 16'b0;
	mux_2 mux5(.sel(shamt[4]), .in0(in), .in1(shbit5), .out(shout5));
	
	assign shbit4[31:8] = shout5[23:0];
	assign shbit4[7:0] = 8'b0;
	mux_2 mux4(.sel(shamt[3]), .in0(shout5), .in1(shbit4), .out(shout4));
	
	assign shbit3[31:4] = shout4[27:0];
	assign shbit3[3:0] = 4'b0;
	mux_2 mux3(.sel(shamt[2]), .in0(shout4), .in1(shbit3), .out(shout3));

	assign shbit2[31:2] = shout3[29:0];
	assign shbit2[1:0] = 2'b0;
	mux_2 mux2(.sel(shamt[1]), .in0(shout3), .in1(shbit2), .out(shout2));

	assign shbit1[31:1] = shout2[30:0];
	assign shbit1[0] = 1'b0;
	mux_2 mux1(.sel(shamt[0]), .in0(shout2), .in1(shbit1), .out(out));
		
endmodule
