module physics_coprocessor(
	clock, reset, 			// Master clock, reset signals

	mass_in, gravity_in, wind_in, 	// Constants set for the player
	start_Position, 		// Starting position [x, y]

	controller_in, 			// Input from controller joystick
	knockback_in,			// Input from attack coprocessor
	attack_in,				// Input from attack coprocessor
	movement_in,			// Input from attack coprocessor
	damage_in,				// Input from register


	wall, 					// Hitting walls

	freeze_in,				// Holds player still
	
	ctrl_num,				// Indicates which joystick is used

	position 				// Output position [x, y]
);

	// Inputs
	input clock, reset;
	input [31:0] mass_in, gravity_in, wind_in;
	input [31:0] start_Position;
	input [31:0] controller_in, knockback_in, movement_in, damage_in;
	input [31:0] wall;
	input attack_in;
	input freeze_in;
	input ctrl_num;

	// Output Position
	output [31:0] position;

	// Input from Controller
	wire signed [8:0] joystick_x, joystick_y; // Unsigned values from 0 to 255 representing joystick position
	assign joystick_x[7:0] = controller_in[15:8];
	assign joystick_x[8] = 1'b0;
	assign joystick_y[7:0] = controller_in[7:0];
	assign joystick_y[8] = 1'b0;
	wire jump_pushed;
	wire platform_Thru;
	assign jump_pushed = controller_in[24] | (joystick_y[7] & joystick_y[6] & joystick_y[5] & joystick_y[4]); // Joystick Y 240 to 255 (up)
	assign platform_Thru = ~joystick_y[7] & ~joystick_y[6] & ~joystick_y[5] & ~joystick_y[4]; // Joystick Y 0 to 15 (down)
	
	// Input from Collisions
	wire wall_Left, wall_Right, wall_Up, wall_Down, platform_Down;
	assign wall_Left = wall[3];
	assign wall_Right = wall[2];
	assign wall_Up = wall[0];
	assign wall_Down = wall[1];
	assign platform_Down = wall[4];

	// Input Physics Parameters
	wire signed [47:0] mass, gravity, wind;
   wire signed [8:0] sjoy_x, sjoy_y;
	wire signed [47:0] damage_multiplier, move_x, move_y, kb_temp_x, kb_temp_y, knockback_x, knockback_y, movement_x, movement_y;
	assign mass[31:0] = mass_in;
	assign mass[47:32] = 16'b0;
	assign gravity[31:0] = gravity_in;
	assign gravity[47:32] = 16'b0;
	assign wind[31:0] = wind_in;
	assign wind[47:32] = 16'b0;
	assign sjoy_x = joystick_x - (ctrl_num ? 9'sb001110000 : 9'sb010000000); // Map joystick values to -128 to 127
	assign sjoy_y = joystick_y - 9'sb001110000; // Map joystick values to -128 to 127
	assign move_x[19:11] = sjoy_x;
	assign move_x[10:0] = 11'b0;
	assign move_y[19:11] = sjoy_y;
	assign move_y[10:0] = 11'b0;
	assign damage_multiplier[19:4] = damage_in[15:0] + 16'sd100;
	assign damage_multiplier[3:0] = 4'b0;
	assign damage_multiplier[47:20] = 28'b0;
	assign kb_temp_x[19:4] = knockback_in[31:16]; // Split knockback into x, y
	assign kb_temp_y[19:4] = knockback_in[15:0];
	assign kb_temp_x[3:0] = 4'b0;
	assign kb_temp_y[3:0] = 4'b0;
	assign movement_x[19:4] = movement_in[31:16]; // Split attack movement into x, y
	assign movement_y[19:4] = movement_in[15:0];
	assign movement_x[3:0] = 4'b0;
	assign movement_y[3:0] = 4'b0;
	genvar i;
	generate // Extend joystick, knockback values to 32 bit signed values
		for(i = 20; i < 48; i = i + 1) begin: signextend1
			assign move_x[i] = move_x[19];
			assign move_y[i] = move_y[19];
		end
		for(i = 20; i < 48; i = i + 1) begin: signextend2
			assign kb_temp_x[i] = knockback_in[31];
			assign kb_temp_y[i] = knockback_in[15];
		end
		for(i = 20; i < 48; i = i + 1) begin: signextend3
			assign movement_x[i] = movement_in[31];
			assign movement_y[i] = movement_in[15];
		end
	endgenerate
	assign knockback_x = kb_temp_x*damage_multiplier;
	assign knockbadk_y = kb_temp_y*damage_multiplier;

	 // X, Y position components
    reg signed [47:0] pos_x, pos_y;

    // Stored Values
    reg signed [47:0] vel_x, vel_y;
    reg signed [47:0] vel_x_t, vel_y_t;
	 
	 // Slowed clock for acceleration
	 reg [15:0] slowClock;
	 wire slowClockBit;
	 assign slowClockBit = slowClock[10];
	 always@(negedge clock) begin
		if(reset) slowClock <= ~slowClock;
		else slowClock <= slowClock + 16'd1;
	 end
	 
	 // Jump Control
	 reg jump, jump_prev, jump_count;
	 always@(posedge slowClock[15]) begin
	 		if(jump_prev) jump <= 1'b0;
			else if(jump_pushed & ~jump_count) begin
				jump <= 1'b1;
				jump_prev <= 1'b1;
				jump_count <= jump_count + 1'b1;
			end
			if(~jump_pushed) begin
				jump_prev <= 1'b0;
			end
			if(wall_Down | platform_Down) jump_count <= 1'b0;
	 end

    // Attack start, end
    reg attack_prev;

    // Separate input, output components
    assign position[31:16] = pos_x[47:32];
    assign position[15:0] = pos_y[47:32];

    // Update values every cycle
    always@(posedge clock) begin
	 
		// Reset
		if(reset) begin
			attack_prev <= 1'b0;
		   vel_x_t <= 48'b0;
			vel_y_t <= 48'b0;
			pos_x [47:32] <= start_Position[31:16];
			pos_x [31:0] <= 32'b0;
			pos_y [47:32] <= start_Position[15:0];
			pos_y [31:0] <= 32'b0;
		end
		
		// Knockback application when attacked
		else if(attack_in & ~attack_prev) begin
			attack_prev <= 1'b1;
			if(wall_Down) pos_y <= pos_y + 48'h000800000000;
		end
		else if(attack_in & attack_prev) begin
			pos_x <= pos_x + movement_x;
			pos_y <= pos_y + movement_y;
		end
		else if(~attack_in & attack_prev) begin
			attack_prev <= 1'b0;
		end			

    	// Acceleration, position update for in air
    	else if(~freeze_in & ~wall_Down & ~platform_Down) begin
    		vel_x_t <= move_x / mass;// - vel_x * vel_x * vel_x / wind;
    		vel_y_t <= move_y / mass - gravity;// - vel_y * vel_y * vel_y / wind;
    		if((vel_x < 48'sb0 | ~wall_Right) & (vel_x > 48'sb0 | ~wall_Left)) pos_x <= pos_x + vel_x;
    		if(vel_y < 48'sb0 | ~wall_Up) pos_y <= pos_y + vel_y;
    	end

    	// Acceleration, velocity update for on ground
    	else if(~freeze_in) begin
    		vel_x_t <= move_x / mass;
    		vel_y_t <= jump ? (48'h000000040000 / mass) : 48'b0;
    		pos_x <= pos_x + vel_x_t;
         pos_y <= pos_y + vel_y_t;
    	end

    end
	 	 
	 always@(posedge slowClockBit) begin
				
		// Reset
		if(reset) begin
			vel_x <= 48'b0;
			vel_y <= 48'b0;
		end
		
		// Attack velocity update
		else if(attack_in) begin
			vel_x <= knockback_x;
			vel_y <= knockback_y;
		end

    	// Acceleration, velocity update for in air
    	else if(~freeze_in & ~wall_Down & ~platform_Down) begin
    		if(vel_x < vel_x_t) vel_x <= vel_x + 48'd1;
   		else vel_x <= vel_x - 48'd1;
    		if(vel_y < vel_y_t) vel_y <= jump ? (48'h000000040000 / mass) : (vel_y + 48'd1);
    		else vel_y <= jump ? (48'h000000040000 / mass) : (vel_y - 48'd1);
    	end
		
		// Acceleration, velocity update for on ground
    	else if(~freeze_in) begin
    		vel_x <= vel_x_t;
			vel_y <= vel_y_t;
    	end

	 end

endmodule
