module divider_wrap(dividend, divisor, start, clock, reset, done, div_by_0, quotient);
	input [31:0] dividend, divisor;
	input start, clock, reset;
	output done, div_by_0;
	output [31:0] quotient;
	
	wire [31:0] positive_divisor, positive_quotient, remainder;
	
	sign_inverter divisor_sign(.invert(divisor[31]), .in(divisor), .out(positive_divisor));
	sign_inverter quotient_sign(.invert(divisor[31]), .in(positive_quotient), .out(quotient));
	
	divider div(.dividend(dividend), .divisor(positive_divisor), .start(start), 
    	.clock(clock), .reset(reset), .done(done), .quotient(positive_quotient), 
    	.remainder(remainder));
		
	nor divbyzero(div_by_0, divisor[0], divisor[1], divisor[2], divisor[3], divisor[4], divisor[5], divisor[6], 
		divisor[7], divisor[8], divisor[9], divisor[10], divisor[11], divisor[12], divisor[13], divisor[14],
		divisor[15], divisor[16], divisor[17], divisor[18], divisor[19], divisor[20], divisor[21], divisor[22], 
		divisor[23], divisor[24], divisor[25], divisor[26], divisor[27], divisor[28], divisor[29], divisor[30], 
		divisor[31]);


endmodule
