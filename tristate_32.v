module tristate_32(sel, in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, 
			in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, out);
	input [4:0] sel;
	input [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, 
					in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, 
					in28, in29, in30, in31;
	output [31:0] out;
	
	wire [31:0] select;
	
	decoder_32 dcd(.in(sel), .out(select));
	
	assign out = select[0] ? in0 : 32'bz;
	assign out = select[1] ? in1 : 32'bz;
	assign out = select[2] ? in2 : 32'bz;
	assign out = select[3] ? in3 : 32'bz;
	assign out = select[4] ? in4 : 32'bz;
	assign out = select[5] ? in5 : 32'bz;
	assign out = select[6] ? in6 : 32'bz;
	assign out = select[7] ? in7 : 32'bz;
	assign out = select[8] ? in8 : 32'bz;
	assign out = select[9] ? in9 : 32'bz;
	assign out = select[10] ? in10 : 32'bz;
	assign out = select[11] ? in11 : 32'bz;
	assign out = select[12] ? in12 : 32'bz;
	assign out = select[13] ? in13 : 32'bz;
	assign out = select[14] ? in14 : 32'bz;
	assign out = select[15] ? in15 : 32'bz;
	assign out = select[16] ? in16 : 32'bz;
	assign out = select[17] ? in17 : 32'bz;
	assign out = select[18] ? in18 : 32'bz;
	assign out = select[19] ? in19 : 32'bz;
	assign out = select[20] ? in20 : 32'bz;
	assign out = select[21] ? in21 : 32'bz;
	assign out = select[22] ? in22 : 32'bz;
	assign out = select[23] ? in23 : 32'bz;
	assign out = select[24] ? in24 : 32'bz;
	assign out = select[25] ? in25 : 32'bz;
	assign out = select[26] ? in26 : 32'bz;
	assign out = select[27] ? in27 : 32'bz;
	assign out = select[28] ? in28 : 32'bz;
	assign out = select[29] ? in29 : 32'bz;
	assign out = select[30] ? in30 : 32'bz;
	assign out = select[31] ? in31 : 32'bz;

endmodule
