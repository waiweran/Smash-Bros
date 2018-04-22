module collision(
	player_pos, stage_pos, // Positions of x and y objects
	
	player_size, stage_size, // Sizes of x and y objects
	
	coll
);
	input [31:0] player_pos, stage_pos, player_size, stage_size;
	output [3:0] coll; // 1000: left, 0100: right, 0010: bottom, 0001: top
	
	// pos[31:16] x, pos[15:0] y, size[31:16] width, size[15:0] height

	assign coll[3] = ~(player_pos[31:16] > (stage_pos[31:16]+stage_size[31:16]))    			// left collision 
								 & ~(player_pos[31:16] < stage_pos[31:16])
								 & (player_pos[15:0] < (stage_pos[15:0]+stage_size[15:0]))        	// bottom below top edge of stage
								 & ((player_pos[15:0]+player_size[15:0]) > stage_pos[15:0]);    		// top above bottom of stage
                            
	assign coll[2] = ~((player_pos[31:16]+player_size[31:16]) < stage_pos[31:16])     			// right collision
								 & ~((player_pos[31:16]+player_size[31:16]) > (stage_pos[31:16]+stage_size[31:16]))
								 & (player_pos[15:0] < (stage_pos[15:0]+stage_size[15:0]))        	// bottom below top edge of stage
								 & ((player_pos[15:0]+player_size[15:0]) > stage_pos[15:0]);    		// top above bottom of stage
								 
	assign coll[1] = ~(player_pos[15:0] > (stage_pos[15:0]+stage_size[15:0]))         		// bottom collision
								 & ~(player_pos[15:0] < stage_pos[15:0])
								 & (player_pos[31:16] < (stage_pos[31:16]+stage_size[31:16]))    	// left edge within right edge of stage
								 & ((player_pos[31:16]+player_size[31:16]) > stage_pos[31:16]);		// right edge within left edge of stage

	assign coll[0] = ~((player_pos[15:0]+player_size[15:0]) < stage_pos[15:0])        			// top collision
								 & ~((player_pos[15:0]+player_size[15:0]) > (stage_pos[15:0]+stage_size[15:0]))
								 & (player_pos[31:16] < (stage_pos[31:16]+stage_size[31:16]))    	// left edge within right edge of stage
								 & ((player_pos[31:16]+player_size[31:16]) > stage_pos[31:16]);		// right edge within left edge of stage
endmodule
