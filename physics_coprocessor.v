module physics_coprocessor(
	clock, reset, 			// Master clock, reset signals

	mass, gravity, wind, 	// Constants set for the player
	start_Position, 		// Starting position [x, y]

	controller_in, 			// Input from controller joystick
	knockback_in,			// Input from attack coprocessor
	attack_in,				// Input from attack coprocessor


	wall, 					// Hitting walls

	freeze_in,				// Holds player still

	position 				// Output position [x, y]
);

	// Inputs
	input clock, reset;
	input [31:0] mass, gravity, wind;
	input [31:0] start_Position;
	input [31:0] controller_in, knockback_in;
	input [3:0] wall;
	input attack_in;
	input freeze_in;

	// Output Position
	output [31:0] position;

	// Input from Controller
	wire [7:0] joystick_x, joystick_y; // Unsigned values from 0 to 255 representing joystick position
	assign joystick_x = controller_in[15:8];
	assign joystick_y = controller_in[7:0];
	wire jump;
	wire platform_Thru;
	assign jump = joystick_y[7] & joystick_y[6] & joystick_y[5] & joystick_y[4]; // Joystick Y 240 to 255 (up)
	assign platform_Thru = ~joystick_y[7] & ~joystick_y[6] & ~joystick_y[5] & ~joystick_y[4]; // Joystick Y 0 to 15 (down)
	
	// Input from Collisions
	wire wall_Left, wall_Right, wall_Up, wall_Down, platform_Down;
	assign wall_Left = wall[2] & wall[1] & ~wall[0];
	assign wall_Right = wall[2] & wall[1] & wall[0];
	assign wall_Up = wall[2] & ~wall[1] & wall[0];
	assign wall_Down = wall[2] & ~wall[1] & ~wall[0];
	assign platform_Down = wall[2] & wall[3];

	// Input Physics Parameters
	wire [31:0] move_x, move_y, knockback_x, knockback_y;
	assign move_x[7:0] = joystick_x - 8'b10000000; // Map joystick values to -128 to 127
	assign move_y[7:0] = joystick_y - 8'b10000000; // Map joystick values to -128 to 127
	assign knockback_x[15:0] = knockback_in[31:16]; // Split knockback into x, y
	assign knockback_y[15:0] = knockback_in[31:16];
	genvar i;
	generate // Extend joystick, knockback values to 32 bit signed values
		for(i = 8; i < 32; i = i + 1) begin: signextend1
			assign move_x[i] = ~joystick_x[7];
			assign move_y[i] = ~joystick_y[7];
		end
		for(i = 16; i < 32; i = i + 1) begin: signextend2
			assign knockback_x[i] = knockback_in[31];
			assign knockback_y[i] = knockback_in[15];
		end
	endgenerate

	 // X, Y position components
    reg [31:0] pos_x, pos_y;

    // Stored Values
    reg [31:0] vel_x, vel_y;
    reg [31:0] accel_x, accel_y;

    // Vibration Values
    reg [31:0] vibr_pos_y;
    wire vibr_dir;
    assign vibr_dir = (pos_y < vibr_pos_y + 32'd10000000)? 1'b1 : 1'b0;

    // Attack start, end value
    reg attack_prev;

    // Separate input, output components
    assign position[31:16] = pos_x[31:16];
    assign position[15:0] = pos_y[31:16];

    // Update values every cycle
    always@(posedge clock) begin
	 
		// Reset
		if(reset) begin
		   accel_x <= 32'b0;
			accel_y <= 32'b0;
			vel_x <= 32'b0;
			vel_y <= 32'b0;
			pos_x [31:16] <= start_Position[31:16];
			pos_x [15:0] <= 16'b0;
			pos_y [31:16] <= start_Position[15:0];
			pos_y [15:0] <= 16'b0;
		end

    	// Acceleration, velocity update for in air
    	else if(~freeze_in & ~attack_in & ~wall_Down & ~platform_Down) begin
    		accel_x <= move_x / mass - vel_x * vel_x * vel_x / wind;
    		accel_y <= move_y / mass - gravity - vel_y * vel_y * vel_y / wind;
    		vel_x <= vel_x + accel_x; // TODO Fix for Collisions L, R
    		vel_y <= vel_y  + accel_y; // TODO Fix for collisions U, jumps
    		pos_x <= pos_x + vel_x;
    		pos_y <= pos_y + vel_y;
    	end

    	// Acceleration, velocity update for on ground
    	else if(~freeze_in & ~attack_in & (wall_Down | platform_Down)) begin
    		accel_x <= 32'b0;
    		accel_y <= 32'b0;
    		vel_x <= move_x / mass; // TODO Fix for Collisions L, R
    		vel_y <= 32'b0; // TODO Fix for platform thru, jumps
    		pos_x <= pos_x + vel_x;
    	end

    	// Start of attack
    	if(~reset & attack_in & ~attack_prev) begin
    		attack_prev <= attack_in;
	    	vibr_pos_y <= pos_y + 32'h00010000; // Start up 1 pixel to be off the ground
	    	pos_y <= pos_y + 32'h00010000;
	    end

    	// During Attack
    	if(~reset & attack_prev) begin
    		accel_x <= 32'b0;
	    	accel_y <= 32'b0;
	    	attack_prev <= attack_in;
    		// Knockback velocity
    		vel_x <= knockback_x / mass;
	    	vel_y <= knockback_y / mass;
     		// Attack vibration
    		if(vibr_dir)
    			pos_y <= pos_y + 32'd2;
    		else
    			pos_y <= pos_y - 32'd2; 
    	end

    end

endmodule
