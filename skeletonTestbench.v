//Testbench for skeleton

`timescale 1 ns / 100 ps
module skeletonTestbench();

	reg clock, reset;
	
	//wire[31:0] reg5, reg6, reg7, reg8, reg9, reg30, reg31;
	
	//skeleton mySkeleton(clock, reset, reg5, reg6, reg7, reg8, reg9, reg30, reg31);
	skeleton mySkeleton(clock, reset);
	
	initial
	begin
		clock = 1'b0;
		reset = 1'b0;
		$display($time, " << Starting the sKELETON Simulation >>");
	   /*
		@(posedge clock);  //0
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);  //5
		if(reg5 != 32'd3)
			$display($time, "Error");
		else
			$display("Pass");
		
		@(posedge clock);
		if(reg6 != 32'd4)
			$display($time, "Error");
		else
			$display("Pass");
		
		@(posedge clock);
		if(reg7 != 32'd3)
			$display($time, "Error");
		else
			$display("Pass");
		
		@(posedge clock);
		
		@(posedge clock);
		@(posedge clock);  //10
		
		@(posedge clock);
				if(reg8 != -32'd1)
			$display($time, "Error");
		else
			$display("Pass");
		
		@(posedge clock);
		if(reg9 != -32'd1)
			$display($time, "Error");
		else
			$display("Pass");
		
		@(posedge clock);
		@(posedge clock);
		if(reg8 != 32'd1)
			$display($time, "Error");
		else
			$display("Pass");
		
		@(posedge clock);  //15
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		if(reg5 != 32'd6)
			$display($time, "Error");
		else
			$display("Pass");
		@(posedge clock);
		@(posedge clock);  //20
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);
		@(posedge clock);		
		@(posedge clock);	 //25
		if(reg5 != 32'd13)
			$display($time, "Error");
		else
			$display("Pass");
		@(posedge clock);
		if(reg5 != 32'd15)
			$display($time, "Error");
		else
			$display("Pass");
		*/
		
	end
	
	always
     #20     clock = ~clock;	

endmodule



