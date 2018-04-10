module isInsideSprite(spriteData, myX, myY, isInside, index);
	input[63:0] spriteData;
	input[18:0] myX, myY;
	output isInside;
	output[18:0] index;
	
	//Translate myY from y axis pointing down to pointing up
	wire[18:0] transX, transY;
	assign transX = myX;
	assign transY = 19'd480 - myY;
	
	//Extract data from spriteData
	wire[18:0] bottomLeftX, bottomLeftY, topRightX, topRightY;
	assign bottomLeftX[15:0] = spriteData[63:48];
	assign bottomLeftX[18:16] = 3'b0;
	assign bottomLeftY[15:0] = spriteData[47:32];
	assign bottomLeftY[18:16] = 3'b0;
	assign topRightX = bottomLeftX + spriteData[31:16];
	assign topRightY = bottomLeftY + spriteData[15:0];
	
	//Test the condition
	assign isInside = (transX > bottomLeftX) & (transX < topRightX) & (transY > bottomLeftY) & (transY < topRightY); 
	
	//Calculate Index
	assign index = myX - bottomLeftX + (myY - (19'd480 - topRightY))*spriteData[31:16];
	

endmodule
