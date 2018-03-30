module register_5bit(write, we, clr, clk, read);
	input [4:0] write;
	input we, clr, clk;
	output [4:0] read;
		
	genvar i;
	generate
		for(i = 0; i < 5; i = i + 1) begin: dffloop
			dff_c bitstore(.d(write[i]), .clr(clr), .en(we), .clk(clk), .q(read[i]));
		end
	endgenerate
	
endmodule
