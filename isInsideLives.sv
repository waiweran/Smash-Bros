module isInsideLives(data, myX, myY, lives, isInside);
	//maximum 5 lives, 11111 means 5 lives
	input [63:0] data [4:0];
	input [18:0] myX, myY;
	input [15:0] lives;
	output [4:0] isInside;
	
	//Translate myY from y axis pointing down to pointing up
	wire[15:0] transX, transY;
	assign transX = myX[15:0];
	assign transY = 16'd480 - myY[15:0];
	
	wire [15:0] bottomLeftX [4:0];
	wire [15:0] bottomLeftY [4:0];
	wire [15:0] topRightX [4:0];
	wire [15:0] topRightY [4:0];
	
	genvar i;
	generate
		for(i=0; i<5; i=i+1) begin: loop1
			assign bottomLeftX[i] = data[i][63:48];
			assign bottomLeftY[i] = data[i][47:32];
			assign topRightX[i] = bottomLeftX[i] + data[i][31:16];
			assign topRightY[i] = bottomLeftY[i] + data[i][15:0];
			
			assign isInside[i] = (transX > bottomLeftX[i]) & (transX < topRightX[i]) & (transY > bottomLeftY[i]) & (transY < topRightY[i]) & lives[i];
		end
	endgenerate

endmodule