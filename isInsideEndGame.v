module isInsideEndGame(data, myX, myY, isInside);
	input [63:0] data;
	input [18:0] myX, myY;
	output isInside;
	
	//Translate myY from y axis pointing down to pointing up
	wire[15:0] transX, transY;
	assign transX = myX[15:0];
	assign transY = 16'd480 - myY[15:0];
	
	wire [15:0] bottomLeftX;
	wire [15:0] bottomLeftY;
	wire [15:0] topRightX;
	wire [15:0] topRightY ;
	

	assign bottomLeftX = data[63:48];
	assign bottomLeftY = data[47:32];
	assign topRightX = bottomLeftX + data[31:16];
	assign topRightY = bottomLeftY + data[15:0];
	assign isInside = (transX > bottomLeftX) & (transX < topRightX) & (transY > bottomLeftY) & (transY < topRightY);

endmodule