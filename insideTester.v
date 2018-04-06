
module insideTester(isInside1, isInside2, isInside3, isInside4, isInside5, isInside6, isInside7, isInside8, isInside9);
	output isInside1, isInside2, isInside3, isInside4, isInside5, isInside6, isInside7, isInside8, isInside9;

	 wire [63:0] p1VGA, p2VGA, stageVGA;
	 assign p1VGA[63:48] = 16'd200;
	 assign p1VGA[47:32] = 16'd200;
	 assign p1VGA[31:16] = 16'd100;
	 assign p1VGA[15:0] = 16'd100;
	 
	 assign p2VGA[63:48] = 16'd400;
	 assign p2VGA[47:32] = 16'd200;
	 assign p2VGA[31:16] = 16'd50;
	 assign p2VGA[15:0] = 16'd100;
	 
	 assign stageVGA[63:48] = 16'd200;
	 assign stageVGA[47:32] = 16'd400;
	 assign stageVGA[31:16] = 16'd400;
	 assign stageVGA[15:0] = 16'd30;
	 
	 wire[15:0] myX1, myX2, myX3, myY1, myY2, myY3;
	  assign myX1 = 16'd210;
	  assign myX2 = 16'd350;
	   assign myX3 = 16'd210;
		 assign myY1 = 16'd480 - 16'd210;
		  assign myY2 = 16'd480 - 16'd350;
		   assign myY3 = 16'd480 - 16'd410;
	 
	 isInsideSprite(p1VGA, myX1, myY1, isInside1);
	 isInsideSprite(p1VGA, myX2, myY2, isInside2);
	 isInsideSprite(p1VGA, myX3, myY3, isInside3);
	 isInsideSprite(p2VGA, myX1, myY1, isInside4);
	 isInsideSprite(p2VGA, myX2, myY2, isInside5);
	 isInsideSprite(p2VGA, myX3, myY3, isInside6);
	 isInsideSprite(stageVGA, myX1, myY1, isInside7);
	 isInsideSprite(stageVGA, myX2, myY2, isInside8);
	 isInsideSprite(stageVGA, myX3, myY3, isInside9);
	 
	 
endmodule