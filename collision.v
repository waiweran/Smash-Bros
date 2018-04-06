module collision(x_pos, x_size, y_pos, y_size, collision);
	input [31:0] x_pos, x_size, y_pos, y_size;
	output [3:0] collision; //1000: left, 0100: right, 0010: bottom, 0001: top
	
	//pos[31:16] x, pos[15:0] y, size[31:16] width, size[15:0] height

	assign collision[3] = ~(x_pos[31:16] > (y_pos[31:16]+y_size[31:16]));
	assign collision[2] = ~((x_pos[31:16]+x_size[31:16]) < y_pos[31:16]);
	assign collision[1] = ~(x_pos[15:0] > (y_pos[15:0]+y_size[15:0]));
	assign collision[0] = ~((x_pos[15:0]+x_size[15:0]) < y_pos[15:16]);
endmodule
