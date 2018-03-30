module dff_c(d, clr, en, clk, q);
	input d, clr, en, clk;
	output q;
	reg q;
	always @(posedge clk) begin
		if(clr) begin
			q = 1'b0;
		end else begin 
			if(en) begin
				q = d;
			end
		end
	end	
endmodule
