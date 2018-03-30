module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, reset, data_result, data_exception, data_resultRDY);
	 input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock, reset;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // Your code here
    wire [31:0] mult_result, div_result;
    wire mult_ready, div_ready, mult_exception, div_exception;

    multiplier_wrap mult(.inA(data_operandA), .inB(data_operandB), .start(ctrl_MULT), 
    	.clock(clock), .reset(reset), .done(mult_ready), .overflow(mult_exception), .product(mult_result));

   divider_wrap div(.dividend(data_operandA), .divisor(data_operandB), .start(ctrl_DIV), 
    	.clock(clock), .reset(reset), .done(div_ready), .div_by_0(div_exception), .quotient(div_result));


	mux_2 output_mux(.sel(ctrl_MULT), .in0(div_result), .in1(mult_result), .out(data_result));
	assign data_resultRDY = ctrl_MULT ? mult_ready : div_ready;
	assign data_exception = ctrl_MULT ? mult_exception : div_exception;


endmodule
