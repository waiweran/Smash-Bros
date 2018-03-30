module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	
	wire [31:0] add_out, sub_out, and_out, or_out, sll_out, sra_out;
	wire ovfadd, ovfsub, un;
	
	adder_32 adder(.inA(data_operandA), .inB(data_operandB), .cin(1'b0), 
		.ovf(ovfadd), .sum(add_out), .cout(un));
	sub_comp subtractor(.inA(data_operandA), .inB(data_operandB), .lt(isLessThan), 
		.neq(isNotEqual), .ovf(ovfsub), .sum(sub_out));
	bitwise_and and_module(.inA(data_operandA), .inB(data_operandB), .out(and_out));
	bitwise_or or_module(.inA(data_operandA), .inB(data_operandB), .out(or_out));
	sll left_shift(.in(data_operandA), .shamt(ctrl_shiftamt), .out(sll_out));
	sra right_shift(.in(data_operandA), .shamt(ctrl_shiftamt), .out(sra_out));
	
	assign overflow = ctrl_ALUopcode[0] ? ovfsub : ovfadd;
	tristate_8 outmux(.sel(ctrl_ALUopcode[2:0]), .in0(add_out), .in1(sub_out), .in2(and_out), .in3(or_out), 
							.in4(sll_out), .in5(sra_out), .in6(32'b0), .in7(32'b0), .out(data_result));

endmodule
