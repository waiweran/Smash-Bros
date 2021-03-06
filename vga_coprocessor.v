//Sends the data for position, widthHeight to vga_controller
//I think: while VGA updates screen, need to send nops to the processor then signal once done to move on?
//Unless the processor clock is much slower than VGA clock - this seems challenging!
module vga_coprocessor(posIn, whIn, controller, attack, collision, damage_lives, vga_output);
	input[31:0] posIn, whIn, controller, attack, collision, damage_lives;
	output[159:0] vga_output;
	
	assign vga_output[159:128] = damage_lives;
	assign vga_output[127:112] = collision[15:0];
	assign vga_output[111:96] = attack[15:0];
	assign vga_output[95:64] = controller;
	assign vga_output[63:32] = posIn;
	assign vga_output[31:0] = whIn;
	
  //TODO likely another signal that says done with NOPs and can move on
endmodule
