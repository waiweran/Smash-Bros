module physics_coprocessor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal
    call,							// I: Call to the coprocessor

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);

    // Control signals
    input clock, reset, call;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */

    // Regfile Controls
    reg [5:0] ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
    reg [31:0] data_writeReg;
    reg ctrl_writeEnable;

    // Input to Engine
    reg [31:0] operation;

    // Players
    player_physics player1(.clock(clock), .reset(reset), .mass(), .gravity(), 
    	.start_Position(), .force_in(), .freeze_in(), .paralyze_in(), 
    	.paralyze_const(), .position());
    player_physics player2(.clock(clock), .reset(reset), .mass(), .gravity(), 
    	.start_Position(), .force_in(), .freeze_in(), .paralyze_in(), 
    	.paralyze_const(), .position());

    always@(posedge call) begin
  		@(posedge clock);
    	assign ctrl_readRegA = 5'b00001;
    	@(posedge clock);
    	assign operation = data_readRegA;

    end

endmodule // physics_coprocessor

module player_physics(
	clock, reset 			// Master clock, reset signals

	mass, gravity, 			// Constants set for the player

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
	input [31:0] mass, gravity;
	input [63:0] start_Position, force_in;
	input wall_Left, wall_Right, wall_Up, wall_Down, platform_Down, platform_Thru;
	input freeze_in, paralyze_in;
	input [31:0] paralyze_const;

	// Output Position
	output [63:0] position;

	// X, Y components
    reg [31:0] pos_x, pos_y;
    wire [31:0] force_x, force_Y;

    // Stored Values
    reg [31:0] vel_x, vel_y;
    reg [31:0] accel_x, accel_y;

    // Vibration Values
    reg [31:0] vibr_pos_y;
    wire vibr_dir;
    assign vibr_dir = (pos_y < vibr_pos_y + paralyze_const)? 1'b1 : 1'b0;

    // Separate input, output components
    assign force_in[63:32] = force_x;
    assign force_in[31:0] = force_y;
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
    	accel_x <= force_x * mass;
    	accel_y <= (gravity - force_y) * mass;
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
    	else if(~freeze_in) begin
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