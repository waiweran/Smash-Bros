module isInsideEndGame(data, myX, myY, isInside, index);
	input [63:0] data;
	input [18:0] myX, myY;
	output isInside;
	output [18:0] index;
	
	//Translate myY from y axis pointing down to pointing up
	wire[18:0] transX, transY;
	assign transX = myX;
	assign transY = 19'd480 - myY;
	
	wire[18:0] bottomLeftX, bottomLeftY, topRightX, topRightY;

	assign bottomLeftX = data[63:48];
	assign bottomLeftX[18:16] = 3'b0;
	assign bottomLeftY = data[47:32];
	assign bottomLeftY[18:16] = 3'b0;
	
	assign topRightX = bottomLeftX + data[31:16];
	assign topRightY = bottomLeftY + data[15:0];
	assign isInside = (transX > bottomLeftX) & (transX < topRightX) & (transY > bottomLeftY) & (transY < topRightY);
	
	assign index = myX - bottomLeftX + (myY - (19'd480 - topRightY))*data[31:16];

endmodule