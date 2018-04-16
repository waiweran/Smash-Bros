//For a single player
//See google doc for documentation on bits of in and out
module gameControllerManager(mmioBoardOutput, mmioBoardInput, halfgpio, halfoverflowgpio, ledMotorOut, fastClock, slowClock);
	
	input[15:0] halfgpio;
	input[1:0] halfoverflowgpio;
	input[31:0] mmioBoardOutput; //Only LSB is used! Everything else is padding just because assembly is 32 bits.
	output[31:0] mmioBoardInput;  
	output ledMotorOut;
	input fastClock;
	output slowClock;
	
	assign mmioBoardInput[3:0] = 4'b0;
	assign mmioBoardInput[7:4] = halfgpio[7:4]; //x
	assign mmioBoardInput[11:8] = 4'b0;
	assign mmioBoardInput[15:12] = halfgpio[15:12]; //y
	assign mmioBoardInput[19:16] = halfgpio[3:0]; //a, b, grab, shield
	assign mmioBoardInput[23:20] = halfgpio[11:8]; //D pad
	assign mmioBoardInput[25:24] = halfoverflowgpio; //Reset, Jump
	
	//Pattern for ledMotorOut
	reg[31:0] ledCount;
	reg ledMotorOutReg;
	initial
	begin
		ledCount = 0;
		ledMotorOutReg = 0;
	end
	always @(posedge fastClock) begin
		if(mmioBoardOutput[0] == 1'b1) begin
			ledCount = 1;
		end
		if(ledCount >= 1) begin
			ledCount = ledCount + 1;
			if(ledCount == 31'd2) begin
				ledMotorOutReg = 1;
			end
			if(ledCount == 31'd2000000) begin
				ledMotorOutReg = 0;
			end
			if(ledCount == 31'd4000000) begin
				ledMotorOutReg = 1;
			end
			if(ledCount == 31'd6000000) begin
				ledMotorOutReg = 0;
			end
			if(ledCount == 31'd8000000) begin
				ledMotorOutReg = 1;
			end
			if(ledCount == 31'd10000000) begin
				ledMotorOutReg = 0;
				ledCount = 0;
			end
			/*
			if(ledCount == 31'd25000000) begin
				ledMotorOutReg = 0;
			end
			if(ledCount == 31'd50000000) begin
				ledMotorOutReg = 1;
			end
			if(ledCount == 31'd75000000) begin
				ledMotorOutReg = 0;
			end
			if(ledCount == 31'd10000000) begin
				ledMotorOutReg = 1;
			end
			if(ledCount == 31'd125000000) begin
				ledMotorOutReg = 0;
				ledCount = 0;
			end
			*/
		end
	end
	
	assign ledMotorOut = ledMotorOutReg;
	
	//Slow clock for ADCs
	reg[4:0] counter;
	reg slowClockReg;
	
	initial
	begin
		counter = 0;
		slowClockReg = 0;
	end
	always @(posedge fastClock) begin
		counter = counter + 5'b00001;
		if(counter == 5'b11111) begin
			counter = 0;  //Note this is one cycle off from perfectly dividing by power of 2, but not a problem here (too small a difference)
			slowClockReg = ~slowClockReg;
		end
	end
	
	assign slowClock = slowClockReg;
	
	// Direction last pointed
	reg lastDirection;
	wire tiltL, tiltR;
	assign tiltL = ~mmioBoardInput[15] & ~mmioBoardInput[14];
	assign tiltR = mmioBoardInput[15] & mmioBoardInput[14];
	initial begin
		lastDirection <= 1'b1;
	end
	always@(posedge fastClock) begin
		if(tiltL) lastDirection <= 1'b0;
		if(tiltR) lastDirection <= 1'b1;
	end
	assign mmioBoardInput[26] = lastDirection;


	
	
	/*
	assign mmioBoardInput[7:4] = halfgpio[7:4];
	assign mmioBoardInput[3:0] = 4'b0;
	assign mmioBoardInput[15:12] = halfgpio[15:12];
	assign mmioBoardInput[11:8] = 4'b0;
	
	assign mmioBoardInput[31:16] = 16'b0; //TODO rest of controller inputs
	*/
	//assign halfgpio[0] = mmioBoardOutput[0];

endmodule
