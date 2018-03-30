module register(write, we, clr, clk, read);
	input [31:0] write;
	input we, clr, clk;
	output [31:0] read;
		
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: dffloop
			dff_c bitstore(.d(write[i]), .clr(clr), .en(we), .clk(clk), .q(read[i]));
		end
	endgenerate
	
endmodule
