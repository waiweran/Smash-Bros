module divider(dividend, divisor, start, clock, reset, done, quotient, remainder);
	input [31:0] dividend, divisor;
	input start, clock, reset;
	output[31:0] quotient, remainder;
	output done;

	wire [31:0] quotient_temp, remainder_temp;
	wire [31:0] input_remainder, shifted_remainder, write_remainder, write_quotient, shifted_quotient;
	wire [31:0] inverted_divisor;
	wire [36:0] timing;

	register remainder_reg(.write(write_remainder), .we(1'b1), .clr(1'b0), .clk(clock), .read(remainder_temp));
	register quotient_reg(.write(write_quotient), .we(1'b1), .clr(1'b0), .clk(clock), .read(quotient_temp));

	mux_2 start_decide_rem(.sel(timing[0]), .in0(shifted_remainder), .in1(32'b0), .out(write_remainder));
	mux_2 start_decide_quo(.sel(timing[0]), .in0(shifted_quotient), .in1(dividend), .out(write_quotient));

	// Shifter
	assign shifted_remainder[0] = quotient_temp[31];
	assign shifted_quotient[31:1] = quotient_temp[30:0];
	assign shifted_remainder[31:1] = input_remainder[30:0];

	// Timer
	wire pulse_c;
	dff_c startdff(.d(start), .clr(pulse_c | reset), .en(1'b1), .clk(clock), .q(timing[0]));
	dff_c flipflop1(.d(timing[0]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[1]));
	dff_c flipflop2(.d(timing[1]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[2]));
	dff_c flipflop3(.d(timing[2]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[3]));
	dff_c flipflop4(.d(timing[3]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[4]));
	dff_c flipflop5(.d(timing[4]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[5]));
	dff_c flipflop6(.d(timing[5]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[6]));
	dff_c flipflop7(.d(timing[6]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[7]));
	dff_c flipflop8(.d(timing[7]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[8]));
	dff_c flipflop9(.d(timing[8]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[9]));
	dff_c flipflop10(.d(timing[9]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[10]));
	dff_c flipflop12(.d(timing[10]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[11]));
	dff_c flipflop13(.d(timing[11]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[12]));
	dff_c flipflop14(.d(timing[12]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[13]));
	dff_c flipflop15(.d(timing[13]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[14]));
	dff_c flipflop16(.d(timing[14]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[15]));
	dff_c flipflop17(.d(timing[15]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[16]));
	dff_c flipflop18(.d(timing[16]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[17]));
	dff_c flipflop19(.d(timing[17]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[18]));
	dff_c flipflop20(.d(timing[18]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[19]));
	dff_c flipflop21(.d(timing[19]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[20]));
	dff_c flipflop22(.d(timing[20]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[21]));
	dff_c flipflop23(.d(timing[21]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[22]));
	dff_c flipflop24(.d(timing[22]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[23]));
	dff_c flipflop25(.d(timing[23]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[24]));
	dff_c flipflop26(.d(timing[24]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[25]));
	dff_c flipflop87(.d(timing[25]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[26]));
	dff_c flipflop29(.d(timing[26]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[27]));
	dff_c flipflop222(.d(timing[27]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[28]));
	dff_c flipflop233(.d(timing[28]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[29]));
	dff_c flipflop244(.d(timing[29]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[30]));
	dff_c flipflop255(.d(timing[30]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[31]));
	dff_c flipflop266(.d(timing[31]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[32]));
	dff_c flipflop277(.d(timing[32]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[33]));
	dff_c flipflop288(.d(timing[33]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[34]));
	dff_c flipflop299(.d(timing[34]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[35]));
	dff_c flipflop200(.d(timing[35]), .clr(reset), .en(1'b1), .clk(clock), .q(timing[36]));
	dff_c enddff(.d(timing[36]), .clr(reset), .en(1'b1), .clk(clock), .q(done));
	dff_c pulsedff(.d(start), .clr(reset | done), .en(~timing[0]), .clk(clock), .q(pulse_c));

	// Inverter
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: invert_loop
			not divisor_inverter(inverted_divisor[i], divisor[i]);
		end
	endgenerate

	wire cout, ovf, signchange;
	wire [31:0] subtracted_val;
	adder_32 subtractor(.inA(remainder_temp), .inB(inverted_divisor), .cin(1'b1), .cout(cout), .ovf(ovf), .sum(subtracted_val));
	xor sign_check(signchange, remainder_temp[31], subtracted_val[31]);
	mux_2 sign_decide(.sel(signchange), .in0(subtracted_val), .in1(remainder_temp), .out(input_remainder));
	not invert_signchange(shifted_quotient[0], signchange);
	
	wire [31:0] sign_fixed_quotient;
	assign sign_fixed_quotient[30:0] = quotient_temp[30:0];
	assign sign_fixed_quotient[31] = dividend[31];

	register remainder_final(.write(remainder_temp), .we(timing[34]), .clr(reset), .clk(clock), .read(remainder));
	register quotient_final(.write(sign_fixed_quotient), .we(timing[34]), .clr(reset), .clk(clock), .read(quotient));
	

endmodule // divider