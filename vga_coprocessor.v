//Sends the data for position, widthHeight to vga_controller
//I think: while VGA updates screen, need to send nops to the processor then signal once done to move on?
//Unless the processor clock is much slower than VGA clock - this seems challenging!
module vga_coprocessor(posIn, whIn, poswhOut, controller, controller_out);
	input[31:0] posIn, whIn, controller;
	output[63:0] poswhOut;
	output[31:0] controller_out;
	
	assign poswhOut[63:32] = posIn;
	assign poswhOut[31:0] = whIn;
	assign controller_out = controller;
	
  //TODO likely another signal that says done with NOPs and can move on
endmodule
