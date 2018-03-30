module register(write, we, clr, clk, read);
	input [31:0] write;
	input we, clr, clk;
	output [31:0] read;
		
	reg[31:0] read;
		
	always @(posedge clk) begin
		if(clr) begin
			read = 32'b0;
		end else begin 
			if(we) begin
				read = write;
			end
		end
	end	
	
endmodule
