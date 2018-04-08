module isInsideSprite(spriteData, myX, myY, isInside);
	input[63:0] spriteData;
	input[15:0] myX, myY;
	output isInside;
	
	//Translate myY from y axis pointing down to pointing up
	wire[15:0] transX;
	wire[15:0] transY;
	assign transX = myX;
	assign transY = 16'd480 - myY;
	
	//Extract data from spriteData
	wire[16:0] bottomLeftX, bottomLeftY, topRightX, topRightY;
	assign bottomLeftX = spriteData[63:48];
	assign bottomLeftY = spriteData[47:32];
	assign topRightX = bottomLeftX + spriteData[31:16];
	assign topRightY = bottomLeftY + spriteData[15:0];
	
	//Test the condition
	assign isInside = (transX > bottomLeftX) & (transX < topRightX) & (transY > bottomLeftY) & (transY < topRightY); 
	

endmodule
