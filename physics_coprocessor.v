module physics_coprocessor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal
    call,									// I: Call to the coprocessor
	 
	 mass1, mass2,							// I: Player masses
	 startPos1, startPos2,				// I: Starting positions
	 
	 force1, force2,						// I: Player Force Inputs
	 freeze1, freeze2,					// I: Player Freeze Inputs
	 paralyze1, paralyze2,				// I: Player paralyze inputs
	 
	 wallL1, wallL2,						// I: Player has wall on left
	 wallR1, wallR2,						// I: Player has wall on right
	 wallD1, wallD2, 						// I: Player on top of wall (ground)
	 wallU1, wallU2,						// I: Player has wall above
	 
	 platfD1, platfD2,					// I: Player on top of platform
	 platfT1, platfT2,					// I: Player dropping thru platform
	 
	 pos1, pos2								// O: Player positions
);

    // Control signals
    input clock, reset, call;
	 
	 // Settings
	 input [31:0] mass1, mass2;
	 input [63:0] startPos1, startPos2;

    // Input to Engine
    input [63:0] force1, force2;
	 input freeze1, freeze2, paralyze1, paralyze2;
	 
	 // Output from Engine
	 output [63:0] pos1, pos2;

    // Players
    player_physics player1(.clock(clock), .reset(reset), 
		.mass(mass1), .gravity(32'd10), .wind(32'd1), .start_Position(startPos1), 
		.wall_Left(wallL1), .wall_Right(wallR1), .wall_Up(wallU1), .wall_Down(wallD1),
		.platform_Down(platfD1), .platform_Thru(platfT1),
		.force_in(), .freeze_in(), .paralyze_in(), .paralyze_const(32'd1000000), .position(pos1));
		
    player_physics player2(.clock(clock), .reset(reset), 
		.mass(mass2), .gravity(32'd10), .wind(32'd1), .start_Position(startPos2), 
		.wall_Left(wallL2), .wall_Right(wallR2), .wall_Up(wallU2), .wall_Down(wallD2),
		.platform_Down(platfD2), .platform_Thru(platfT2),
		.force_in(), .freeze_in(), .paralyze_in(), .paralyze_const(32'd1000000), .position(pos2));

    always@(posedge call) begin

    end

endmodule // physics_coprocessor

module player_physics(
	clock, reset, 			// Master clock, reset signals

	mass, gravity, wind, // Constants set for the player

	start_Position, 		// Starting position

	force_in, 				// Input force

	wall_Left, wall_Right, 	// Hitting walls (left, right)
	wall_Up, wall_Down,		// Hitting walls (up, down)
	platform_Down,			// Landing on platform
	platform_Thru, 			// Going through platform

	freeze_in,				// Holds player still
	paralyze_in,			// Vibrates player
	paralyze_const, 		// Sets amplitude of vibration

	position 				// Output position
);

	// Inputs
	input clock, reset;
	input [31:0] mass, gravity, wind;
	input [63:0] start_Position, force_in;
	input wall_Left, wall_Right, wall_Up, wall_Down, platform_Down, platform_Thru;
	input freeze_in, paralyze_in;
	input [31:0] paralyze_const;

	// Output Position
	output [63:0] position;

	// X, Y components
    reg [31:0] pos_x, pos_y;
    wire [31:0] force_x, force_y;

    // Stored Values
    reg [31:0] vel_x, vel_y;
    reg [31:0] accel_x, accel_y;

    // Vibration Values
    reg [31:0] vibr_pos_y;
    wire vibr_dir;
    assign vibr_dir = (pos_y < vibr_pos_y + paralyze_const)? 1'b1 : 1'b0;

    // Separate input, output components
    assign force_x = force_in[63:32];
    assign force_y =  force_in[31:0];
    assign position[63:32] = pos_x;
    assign position[31:0] = pos_y;

    // Update values every cycle
    always@(posedge clock) begin

    	// Wall hitting calculations
    	if(wall_Left & vel_x < 0) begin
    		vel_x <= 0;
    	end 
    	if(wall_Right & vel_x > 0) begin
    		vel_x <= 0;
    	end
    	if(wall_Up & vel_y < 0) begin
    		vel_y <= 0;
    	end
    	if(wall_Down & vel_y > 0) begin
    		vel_y <= 0;
    	end

    	// Platform calculations
    	if(platform_Down & ~platform_Thru & vel_y > 0) begin
    		vel_y <= 0;
    	end

    	// Acceleration, velocity update
    	accel_x <= force_x / mass - vel_x * vel_x * vel_x / wind;
    	accel_y <= gravity - force_y / mass - vel_y * vel_y * vel_y / wind;
    	vel_x <= vel_x + accel_x;
    	vel_y <= vel_y  + accel_y;

    	// Paralyzer
    	if(paralyze_in) begin
    		if(vibr_dir)
    			pos_y <= pos_y + 31'd100;
    		else
    			pos_y <= pos_y - 31'd100; 
    	end

    	// Freeze
    	else if(~freeze_in | ~paralyze_in) begin
    		pos_x <= pos_x + vel_x;
    		pos_y <= pos_y + vel_y;
    	end

    end

    // Reset values
    always@(posedge reset) begin
    	accel_x <= 0;
    	accel_y <= 0;
    	vel_x <= 0;
    	vel_y <= 0;
    	pos_x <= start_Position[63:32];
    	pos_y <= start_Position[31:0];
    end

    // Store paralyzer position
    always@(posedge paralyze_in) begin
    	vibr_pos_y <= pos_y;
    end

endmodule