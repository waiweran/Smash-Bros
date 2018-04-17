//Test bench for testing dataHazardDetection.v

`timescale 1 ns / 100 ps
module portExtractorTestbench();
	reg[31:0] instruction;
	reg clock;

	wire[5:0] readPortA, readPortB, writePort;
	
	portExtractor myPortExtractor(instruction, readPortA, readPortB, writePort);
	
	initial
	
		
	begin
	clock = 1'b0;
	$display($time, " << Starting the Simulation >>");
	
	//add $3, $1, $2
	@(posedge clock);
	assign instruction = 32'b00000000110000100010000000000000;
	@(posedge clock);
	if(readPortA[4:0] != 1 || readPortB[4:0] != 2 || writePort[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
		
		//addi $5, $7, 10
	@(posedge clock);
	assign instruction = 32'b00101001010011100000000000001010;
	@(posedge clock);
	if(readPortA[4:0] != 7 || writePort[4:0] != 5 || readPortA[5] != 0 || readPortB[5] != 1 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");	
	
	
			//sub $10, $30, $17
	@(posedge clock);
	assign instruction = 32'b00000010101111010001000000000100;
	@(posedge clock);
	if(readPortA[4:0] != 30 || readPortB[4:0] != 17 || writePort[4:0] != 10 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
				//and $1, $30, $25
	@(posedge clock);
	assign instruction = 32'b00000000011111011001000000001000;
	@(posedge clock);
	if(readPortA[4:0] != 30 || readPortB[4:0] != 25 || writePort[4:0] != 1 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
					//or $3, $1, $2
	@(posedge clock);
	assign instruction = 32'b00000000110000100010000000001100;
	@(posedge clock);
	if(readPortA[4:0] != 1 || readPortB[4:0] != 2 || writePort[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
						//sll $3, $1, 1
	@(posedge clock);
	assign instruction = 32'b00000000110000100000000010010000;
	@(posedge clock);
	if(readPortA[4:0] != 1 || writePort[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 1 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
							//sra $3, $1, -1
	@(posedge clock);
	assign instruction = 32'b00000000110000100000000000010100;
	@(posedge clock);
	if(readPortA[4:0] != 1 || writePort[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 1 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
		
							//mul $3, $1, $2
	@(posedge clock);
	assign instruction = 32'b00000000110000100010000000011000;
	@(posedge clock);
	if(readPortA[4:0] != 1 || readPortB[4:0] != 2 || writePort[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
			
		  
								//div $3, $1, $2
	@(posedge clock);
	assign instruction = 32'b00000000110000100010000000011100;
	@(posedge clock);
	if(readPortA[4:0] != 1 || readPortB[4:0] != 2 || writePort[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
									//sw $3, 5($1)
	@(posedge clock);
	assign instruction = 32'b00111000110000100000000000000101;
	@(posedge clock);
	if(readPortA[4:0] != 1 || readPortB[4:0] != 3|| readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");

											//sw $10, 4($11)
	@(posedge clock);
	assign instruction = 32'b00111010100101100000000000000100;
	@(posedge clock);
	if(readPortA[4:0] != 11 || readPortB[4:0] != 10 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
											//lw $4, -3($2)
	@(posedge clock);
	assign instruction = 32'b01000001000001011111111111111101;
	@(posedge clock);
	if(readPortA[4:0] != 2 || writePort[4:0] != 4 || readPortA[5] != 0 || readPortB[5] != 1 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");	
		
												//lw $3, 2($10)
	@(posedge clock);
	assign instruction = 32'b01000000110101000000000000000010;
	@(posedge clock);
	if(readPortA[4:0] != 10 || writePort[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 1 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
	//j 15
		@(posedge clock);
	assign instruction = 32'b00001000000000000000000000001111;
	@(posedge clock);
	if(readPortA[5] != 1 || readPortB[5] != 1 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
		  
	//bne $3, $1, 15
			@(posedge clock);
	assign instruction = 32'b00010000110000100000000000001111;
	@(posedge clock);
	if(readPortA[4:0] != 1 || readPortB[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
		
	//addi $7, $1, 3
				@(posedge clock);
	assign instruction = 32'b00101001110000100000000000000011;
	@(posedge clock);
	if(readPortA[4:0] != 1 || writePort[4:0] != 7 || readPortA[5] != 0 || readPortB[5] != 1 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
	//bne $5, $7, 3
				@(posedge clock);
	assign instruction = 32'b00010001010011100000000000000011;
	@(posedge clock);
	if(readPortA[4:0] != 7 || readPortB[4:0] != 5 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
	//jal 15
				@(posedge clock);
	assign instruction = 32'b00011000000000000000000000001111;
	@(posedge clock);
	if(writePort[4:0] != 31 || readPortA[5] != 1 || readPortB[5] != 1 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
	//jr $3
					@(posedge clock);
	assign instruction = 32'b00100000110000000000000000000000;
	@(posedge clock);
	if(readPortB[4:0] != 3 || readPortA[5] != 1 || readPortB[5] != 0 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
	//blt $3, $1, 15
						@(posedge clock);
	assign instruction = 32'b00110000110000100000000000001111;
	@(posedge clock);
	if(readPortA[4:0] != 1 || readPortB[4:0] != 3 || readPortA[5] != 0 || readPortB[5] != 0 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
	//bex 15
							@(posedge clock);
	assign instruction = 32'b10110000000000000000000000001111;
	@(posedge clock);
	if(readPortA[5] != 1 || readPortB[5] != 1 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
		
	//setx 15
								@(posedge clock);
	assign instruction = 32'b10101000000000000000000000001111;
	@(posedge clock);
	if(writePort[4:0] != 30 || readPortA[5] != 1 || readPortB[5] != 1 || writePort[5] != 0)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
		//nop
										@(posedge clock);
	assign instruction = 32'b00000000000000000000000000000000;
	@(posedge clock);
	if(readPortA[5] != 1 || readPortB[5] != 1 || writePort[5] != 1)
		$display($time, "Error: %b, %b, %b", readPortA, readPortB, writePort);
	else
		$display($time, "Passed test");
	
	end
	
	always
        #10     clock = ~clock;	

endmodule
