module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB,
	 rego19, rego20, rego21, rego22,
	 regi23, regi24, regi25, regi26, regi27, regi28, regi29
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	//24: mass1, 25: mass2, 
	input[31:0] rego19, rego20, rego21, rego22;
	output[31:0] regi23, regi24, regi25, regi26, regi27, regi28, regi29;
	assign regi23 = read23;
	assign regi24 = read24;
	assign regi25 = read25;
	assign regi26 = read26;
	assign regi27 = read27;
	assign regi28 = read28;
	assign regi29 = read29;
	
   /* YOUR CODE HERE */	
	wire [31:0] writemask;
	wire [4:0] enabled_writeReg;
	
	genvar i;
	generate
		for(i = 0; i < 5; i = i + 1) begin: enableLoop
			and enableAnd(enabled_writeReg[i], ctrl_writeReg[i], ctrl_writeEnable);
		end
	endgenerate
	
	decoder_32 decode(.in(enabled_writeReg), .out(writemask));
	
	wire [31:0] read1, read2, read3, read4, read5, read6, read7, read8, read9, read10, read11, read12, read13, 
	read14, read15, read16, read17, read18, read19, read20, read21, read22, read23, read24, read25, read26, 
	read27, read28, read29, read30, read31;
	
	register reg1(.write(data_writeReg), .we(writemask[1]), .clr(ctrl_reset), .clk(clock), .read(read1));
	register reg2(.write(data_writeReg), .we(writemask[2]), .clr(ctrl_reset), .clk(clock), .read(read2));
	register reg3(.write(data_writeReg), .we(writemask[3]), .clr(ctrl_reset), .clk(clock), .read(read3));
	register reg4(.write(data_writeReg), .we(writemask[4]), .clr(ctrl_reset), .clk(clock), .read(read4));
	register reg5(.write(data_writeReg), .we(writemask[5]), .clr(ctrl_reset), .clk(clock), .read(read5));
	register reg6(.write(data_writeReg), .we(writemask[6]), .clr(ctrl_reset), .clk(clock), .read(read6));
	register reg7(.write(data_writeReg), .we(writemask[7]), .clr(ctrl_reset), .clk(clock), .read(read7));
	register reg8(.write(data_writeReg), .we(writemask[8]), .clr(ctrl_reset), .clk(clock), .read(read8));
	register reg9(.write(data_writeReg), .we(writemask[9]), .clr(ctrl_reset), .clk(clock), .read(read9));
	register reg10(.write(data_writeReg), .we(writemask[10]), .clr(ctrl_reset), .clk(clock), .read(read10));
	register reg11(.write(data_writeReg), .we(writemask[11]), .clr(ctrl_reset), .clk(clock), .read(read11));
	register reg12(.write(data_writeReg), .we(writemask[12]), .clr(ctrl_reset), .clk(clock), .read(read12));
	register reg13(.write(data_writeReg), .we(writemask[13]), .clr(ctrl_reset), .clk(clock), .read(read13));
	register reg14(.write(data_writeReg), .we(writemask[14]), .clr(ctrl_reset), .clk(clock), .read(read14));
	register reg15(.write(data_writeReg), .we(writemask[15]), .clr(ctrl_reset), .clk(clock), .read(read15));
	register reg16(.write(data_writeReg), .we(writemask[16]), .clr(ctrl_reset), .clk(clock), .read(read16));
	register reg17(.write(data_writeReg), .we(writemask[17]), .clr(ctrl_reset), .clk(clock), .read(read17));
	register reg18(.write(data_writeReg), .we(writemask[18]), .clr(ctrl_reset), .clk(clock), .read(read18));
//	register reg19(.write(data_writeReg), .we(writemask[19]), .clr(ctrl_reset), .clk(clock), .read(read19));
//	register reg20(.write(data_writeReg), .we(writemask[20]), .clr(ctrl_reset), .clk(clock), .read(read20));
//	register reg21(.write(data_writeReg), .we(writemask[21]), .clr(ctrl_reset), .clk(clock), .read(read21));
//	register reg22(.write(data_writeReg), .we(writemask[22]), .clr(ctrl_reset), .clk(clock), .read(read22));
	register reg23(.write(data_writeReg), .we(writemask[23]), .clr(ctrl_reset), .clk(clock), .read(read23));
	register reg24(.write(data_writeReg), .we(writemask[24]), .clr(ctrl_reset), .clk(clock), .read(read24));
	register reg25(.write(data_writeReg), .we(writemask[25]), .clr(ctrl_reset), .clk(clock), .read(read25));
	register reg26(.write(data_writeReg), .we(writemask[26]), .clr(ctrl_reset), .clk(clock), .read(read26));
	register reg27(.write(data_writeReg), .we(writemask[27]), .clr(ctrl_reset), .clk(clock), .read(read27));
	register reg28(.write(data_writeReg), .we(writemask[28]), .clr(ctrl_reset), .clk(clock), .read(read28));
	register reg29(.write(data_writeReg), .we(writemask[29]), .clr(ctrl_reset), .clk(clock), .read(read29));
	register reg30(.write(data_writeReg), .we(writemask[30]), .clr(ctrl_reset), .clk(clock), .read(read30));
	register reg31(.write(data_writeReg), .we(writemask[31]), .clr(ctrl_reset), .clk(clock), .read(read31));
	
	tristate_32 readoutA(.sel(ctrl_readRegA), .out(data_readRegA), .in0(32'b0), .in1(read1), .in2(read2), .in3(read3), 
	.in4(read4), .in5(read5), .in6(read6), .in7(read7), .in8(read8), .in9(read9), .in10(read10), .in11(read11), 
	.in12(read12), .in13(read13), .in14(read14), .in15(read15), .in16(read16), .in17(read17), .in18(read18), 
	.in19(rego19), .in20(rego20), .in21(rego21), .in22(rego22), .in23(read23), .in24(read24), .in25(read25),
	.in26(read26), .in27(read27), .in28(read28), .in29(read29), .in30(read30), .in31(read31));
	tristate_32 readoutB(.sel(ctrl_readRegB), .out(data_readRegB), .in0(32'b0), .in1(read1), .in2(read2), .in3(read3), 
	.in4(read4), .in5(read5), .in6(read6), .in7(read7), .in8(read8), .in9(read9), .in10(read10), .in11(read11), 
	.in12(read12), .in13(read13), .in14(read14), .in15(read15), .in16(read16), .in17(read17), .in18(read18), 
	.in19(rego19), .in20(rego20), .in21(rego21), .in22(rego22), .in23(read23), .in24(read24), .in25(read25),
	.in26(read26), .in27(read27), .in28(read28), .in29(read29), .in30(read30), .in31(read31));

endmodule
