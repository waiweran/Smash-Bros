/*
A single 32-bit wide register.
*/
module register(clear, clock, write_enable, data_input, data_output);
	input clear, clock, write_enable;
	input [31:0] data_input;
	output [31:0] data_output;
	
	genvar bitNum;
	generate
	for(bitNum = 0; bitNum < 32; bitNum = bitNum + 1) begin: dffLoop
		singleDFF bitDFF(data_input[bitNum], clear, clock, data_output[bitNum], write_enable);
	end
	endgenerate
	
endmodule