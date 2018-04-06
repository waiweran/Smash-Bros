module collision(
	x_pos, y_pos, // Positions of x and y objects
	
	x_size, y_size, // Sizes of x and y objects
	
	coll
);
	input [31:0] x_pos, y_pos, x_size, y_size;
	output [3:0] coll; // 1000: left, 0100: right, 0010: bottom, 0001: top
	
	// pos[31:16] x, pos[15:0] y, size[31:16] width, size[15:0] height

	assign coll[3] = ~(x_pos[31:16] > (y_pos[31:16]+y_size[31:16])); 	// left collision
	assign coll[2] = ~((x_pos[31:16]+x_size[31:16]) < y_pos[31:16]); 	// right collision
	assign coll[1] = ~(x_pos[15:0] > (y_pos[15:0]+y_size[15:0])); 		// bottom collision
	assign coll[0] = ~((x_pos[15:0]+x_size[15:0]) < y_pos[15:0]);		// top collision
endmodule
