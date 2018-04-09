//For a single player
//See google doc for documentation on bits of in and out
module gameControllerManager(mmioBoardOutput, mmioBoardInput, halfgpio);
	input[19:0] halfgpio;
	input[31:0] mmioBoardOutput;
	output[31:0] mmioBoardInput;
	
	assign mmioBoardInput[7:4] = halfgpio[7:4];
	assign mmioBoardInput[3:0] = 4'b0;
	assign mmioBoardInput[15:12] = halfgpio[15:12];
	assign mmioBoardInput[11:8] = 4'b0;
	
	assign mmioBoardInput[31:16] = 16'b0; //TODO rest of controller inputs
	
	//assign halfgpio[0] = mmioBoardOutput[0];

endmodule
