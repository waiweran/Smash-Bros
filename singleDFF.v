/*
A single D Flip-Flop clocked on the rising edge.
Inputs:
d = input
aclr = asynchronous clear
clk = clock
writeEnable = writeEnable
Outputs:
q = output 

Code from powerpoint provided on Sakai.
*/
module singleDFF(d, aclr, clk, q, writeEnable);
	input d, aclr, clk, writeEnable;
	output q;
	reg q;
	always @(posedge clk or
	posedge aclr) begin 
		if(aclr) begin
			q = 1'b0;
		end 
		else if(writeEnable)
			begin q = d;
		end
	end
endmodule