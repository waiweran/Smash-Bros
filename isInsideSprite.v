module isInsideSprite(spriteData, myX, myY, isInside, index);
	input[159:0] spriteData;
	input[18:0] myX, myY;
	output isInside;
	output[18:0] index;
	
	//Translate myY from y axis pointing down to pointing up
	wire[18:0] transX, transY;
	assign transX = myX;
	assign transY = 19'd480 - myY;
	
	//Extract data from spriteData
	wire[18:0] bottomLeftX, bottomLeftY, topRightX, topRightY;
	assign bottomLeftX[15:0] = spriteData[63:48] - (16'd256 - spriteData[31:16])/16'd2;
	assign bottomLeftX[18:16] = 3'b0;
	assign bottomLeftY[15:0] = spriteData[47:32];
	assign bottomLeftY[18:16] = 3'b0;
	assign topRightX = bottomLeftX + 18'd256;//spriteData[31:16];
	assign topRightY = bottomLeftY + 18'd125;//spriteData[15:0];
	
	//Test the condition
	assign isInside = (transX > bottomLeftX) & (transX < topRightX) & (transY > bottomLeftY) & (transY < topRightY); 
	
	wire [18:0] normal_index, flipped_index;
	//Calculate Index
	assign normal_index = myX - bottomLeftX + (myY - (19'd480 - topRightY))*18'd256;//spriteData[31:16];
	
	//Flipped Index
	assign flipped_index = topRightX - myX + (myY - (19'd480 - topRightY))*18'd256;
	
	assign index = spriteData[90] ? normal_index : flipped_index;

endmodule
