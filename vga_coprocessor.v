//Sends the data for position, widthHeight to vga_controller
//I think: while VGA updates screen, need to send nops to the processor then signal once done to move on?
//Unless the processor clock is much slower than VGA clock - this seems challenging!
module vga_coprocessor(posIn, whIn, poswhOut);
	input[31:0] posIn, whIn;
	output[63:0] poswhOut;
	
	assign poswhOut[63:32] = posIn;
	assign poswhOut[31:0] = whIn;
	
  //TODO likely another signal that says done with NOPs and can move on
endmodule
