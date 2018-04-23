module isInside7Segsv(seg100, seg10, seg1, myX, myY, damage, isInside);
	input [63:0] seg100 [6:0];
	input [63:0] seg10 [6:0];
	input [63:0] seg1 [6:0];
	input[18:0] myX, myY;
	input [15:0] damage;
	output [6:0] isInside [2:0];
	
	//Translate myY from y axis pointing down to pointing up
	wire[15:0] transX, transY;
	assign transX = myX[15:0];
	assign transY = 16'd480 - myY[15:0];
	
	wire [15:0] bottomLeftX100 [6:0];
	wire [15:0] bottomLeftY100 [6:0];
	wire [15:0] topRightX100 [6:0];
	wire [15:0] topRightY100 [6:0];
	
	wire [15:0] bottomLeftX10 [6:0];
	wire [15:0] bottomLeftY10 [6:0];
	wire [15:0] topRightX10 [6:0];
	wire [15:0] topRightY10 [6:0];
	
	wire [15:0] bottomLeftX1 [6:0];
	wire [15:0] bottomLeftY1 [6:0];
	wire [15:0] topRightX1 [6:0];
	wire [15:0] topRightY1 [6:0];
	
	genvar i;
	generate
		for(i = 0; i < 7; i=i+1) begin: loop1
			assign bottomLeftX100[i] = seg100[i][63:48];
			assign bottomLeftY100[i] = seg100[i][47:32];
			assign topRightX100[i] = bottomLeftX100[i] + seg100[i][31:16];
			assign topRightY100[i] = bottomLeftY100[i] + seg100[i][15:0];
			
			assign bottomLeftX10[i] = seg10[i][63:48];
			assign bottomLeftY10[i] = seg10[i][47:32];
			assign topRightX10[i] = bottomLeftX10[i] + seg10[i][31:16];
			assign topRightY10[i] = bottomLeftY10[i] + seg10[i][15:0];
			
			assign bottomLeftX1[i] = seg1[i][63:48];
			assign bottomLeftY1[i] = seg1[i][47:32];
			assign topRightX1[i] = bottomLeftX1[i] + seg1[i][31:16];
			assign topRightY1[i] = bottomLeftY1[i] + seg1[i][15:0];
		end
	endgenerate
	
	//digit[2]: hundreds, digit[1]: tens, digit[0] ones
	wire [15:0] digit [2:0];
	assign digit[2] = damage / 16'd100;
	assign digit[1] = (damage - (digit[2]*16'd100))/16'd10;
	assign digit[0] = damage - (digit[2]*16'd100) - (digit[1]*16'd10);
	
	//high_segment[0][0]: seg1, a		high_segment[2][6]: seg100, g
	wire [6:0] high_segment [2:0];
	genvar j;
	generate
		for(j = 0; j < 3; j=j+1) begin: loop2
			//a high for 0, 2, 3, 5, 6, 7, 8, 9
			assign high_segment[j][0] = (digit[j]==16'd0)|(digit[j]==16'd2)|(digit[j]==16'd3)|(digit[j]==16'd5)|(digit[j]==16'd6)|(digit[j]==16'd7)|(digit[j]==16'd8)|(digit[j]==16'd9);
			//b high for 0, 1, 2, 3, 4, 7, 8, 9
			assign high_segment[j][1] = (digit[j]==16'd0)|(digit[j]==16'd1)|(digit[j]==16'd2)|(digit[j]==16'd3)|(digit[j]==16'd4)|(digit[j]==16'd7)|(digit[j]==16'd8)|(digit[j]==16'd9);
			//c high for 0, 1, 3, 4, 5, 6, 7, 8, 9
			assign high_segment[j][2] = (digit[j]==16'd0)|(digit[j]==16'd1)|(digit[j]==16'd3)|(digit[j]==16'd4)|(digit[j]==16'd5)|(digit[j]==16'd6)|(digit[j]==16'd7)|(digit[j]==16'd8)|(digit[j]==16'd9);
			//d high for 0, 2, 3, 5, 6, 8
			assign high_segment[j][3] = (digit[j]==16'd0)|(digit[j]==16'd2)|(digit[j]==16'd3)|(digit[j]==16'd5)|(digit[j]==16'd6)|(digit[j]==16'd8);
			//e high for 0, 2, 6, 8
			assign high_segment[j][4] = (digit[j]==16'd0)|(digit[j]==16'd2)|(digit[j]==16'd6)|(digit[j]==16'd8);
			//f high for 0, 4, 5, 6, 8, 9
			assign high_segment[j][5] = (digit[j]==16'd0)|(digit[j]==16'd4)|(digit[j]==16'd5)|(digit[j]==16'd6)|(digit[j]==16'd8)|(digit[j]==16'd9);
			//g high for 2, 3, 4, 5, 6, 8, 9
			assign high_segment[j][6] = (digit[j]==16'd2)|(digit[j]==16'd3)|(digit[j]==16'd4)|(digit[j]==16'd5)|(digit[j]==16'd6)|(digit[j]==16'd8)|(digit[j]==16'd9);
		end
	endgenerate
	

	
	//Test the condition
	genvar k;
	generate
		for(k = 0; k < 7; k=k+1) begin: loop3
			assign isInside[2][k] = (transX > bottomLeftX100[k]) & (transX < topRightX100[k]) & (transY > bottomLeftY100[k]) & (transY < topRightY100[k]) & high_segment[2][k];
			assign isInside[1][k] = (transX > bottomLeftX10[k]) & (transX < topRightX10[k]) & (transY > bottomLeftY10[k]) & (transY < topRightY10[k]) & high_segment[1][k];
			assign isInside[0][k] = (transX > bottomLeftX1[k]) & (transX < topRightX1[k]) & (transY > bottomLeftY1[k]) & (transY < topRightY1[k]) & high_segment[0][k];
		end
	endgenerate
	
endmodule