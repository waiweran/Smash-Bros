module register_5bit(write, we, clr, clk, read);
	input [4:0] write;
	input we, clr, clk;
	output [4:0] read;

	reg[4:0] read;
		
	always @(posedge clk) begin
		if(clr) begin
			read = 5'b0;
		end else begin 
			if(we) begin
				read = write;
			end
		end
	end	
	
endmodule
