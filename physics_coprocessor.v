module physics_coprocessor(
	clock, reset, 			// Master clock, reset signals

	mass, gravity, wind, 	// Constants set for the player
	start_Position, 		// Starting position [x, y]

	controller_in, 			// Input from controller joystick

	wall_Left, wall_Right, 	// Hitting walls (left, right)
	wall_Up, wall_Down,		// Hitting walls (up, down)
	platform_Down,			// Landing on platform

	freeze_in,				// Holds player still
	paralyze_in,			// Vibrates player

	position 				// Output position [x, y]
);

	// Inputs
	input clock, reset;
	input [31:0] mass, gravity, wind;
	input [31:0] start_Position;
	input [31:0] controller_in;
	input wall_Left, wall_Right, wall_Up, wall_Down, platform_Down;
	input freeze_in, paralyze_in;

	// Output Position
	output [31:0] position;

	// Input from Controller
	wire [7:0] joystick_x, joystick_y; // Unsigned values from 0 to 255 representing joystick position
	// TODO assign values from controller
	wire jump;
	wire platform_Thru;
	assign jump = = joytcick_y[7] & joystick_y[6] & joystick_y[5] & joystick_y[4]; // Joystick Y 240 to 255 (up)
	assign platform_Thru = ~joytcick_y[7] & ~joystick_y[6] & ~joystick_y[5] & ~joystick_y[4]; // Joystick Y 0 to 15 (down)

	// Input Physics Parameters
	wire [31:0] force_x, force_y;
	assign force_x[7:0] = joystick_x - 8'b10000000; // Map joystick values to -128 to 127
	assign force_y[7:0] = joystick_y - 8'b10000000; // Map joystick values to -128 to 127
	genvar i;
	generate // Extend joystick value to 32 bit signed values
		for(i = 8; i < 32; i = i + 1) begin: signextend
			assign force_x[i] = ~joystick_x[8];
			assign force_y[i] = ~joystick_y[8];
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

    // Separate input, output components
    assign position[31:16] = pos_x[31:16];
    assign position[15:0] = pos_y[31:16];

    // Update values every cycle
    always@(posedge clock) begin

    	// Acceleration, velocity update for in air
    	if(~freeze_in & ~paralyze_in & ~wall_Down) begin
    		accel_x <= force_x / mass - vel_x * vel_x * vel_x / wind;
    		accel_y <= gravity - force_y / mass + vel_y * vel_y * vel_y / wind;
    		vel_x <= vel_x + accel_x;
    		vel_y <= vel_y  + accel_y;
    		pos_x <= pos_x + vel_x;
    		pos_y <= pos_y + vel_y;
    	end

    	// Acceleration, velocity update for on ground
    	if(~freeze_in & ~paralyze_in & wall_Down) begin
    		accel_x <= 32'b0;
    		accel_y <= 32'b0;
    		vel_x <= force_x / mass;
    		vel_y <= 32'b0;
    		pos_x <= pos_x + vel_x;
    	end

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

    	// Paralyzer Vibration
    	if(paralyze_in) begin
    		if(vibr_dir)
    			pos_y <= pos_y + 32'd2;
    		else
    			pos_y <= pos_y - 32'd2; 
    	end

    end

    // Reset values
    always@(posedge reset) begin
    	accel_x <= 32'b0;
    	accel_y <= 32'b0;
    	vel_x <= 32'b0;
    	vel_y <= 32'b0;
    	pos_x [31:16] <= start_Position[31:16];
    	pos_x [15:0] <= 16'b0;
    	pos_y [31:16] <= start_Position[15:0];
    	pos_y [15:0] <= 16'b0;
    end

    // Store paralyzer position
    always@(posedge paralyze_in) begin
    	vibr_pos_y <= pos_y;
    end

endmodule