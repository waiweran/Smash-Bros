module mmio(
	clock, reset,
	address, data_in, wren, data_out, gpio, gpioOutput, p1VGA, p2VGA
);
	
	input clock, reset;
	input [12:0] address;
	input [31:0] data_in;
	input wren;
	output [31:0] data_out;

	input [35:0] gpio;
	output[2:0] gpioOutput;
	output [127:0] p1VGA, p2VGA;
	
	
	
	/******** Physics Coprocessors ********/
	
	reg [31:0] gravity, wind;

	// Player 1 Physics Coprocessor
	reg [31:0] mass1, startPos1;
	reg [31:0] ctrl1_inP, knock1_inP, attack1_inP, collis1_inP;
	wire [31:0] pos1;
	physics_coprocessor physP1(
		.clock(clock), .reset(reset),

		.mass_in(mass1), .gravity_in(gravity), .wind_in(wind),
		.start_Position(startPos1),

		.controller_in(ctrl1_inP),
		.knockback_in(knock1_inP),
		.attack_in(attack1_inP[0]),


		.wall(collis1_inP),

		.freeze_in(1'b0),
		
		.ctrl_num(1'b0),

		.position(pos1)
	);

	// Player 2 Physics Coprocessor
	reg [31:0] mass2, startPos2;
	reg [31:0] ctrl2_inP, knock2_inP, attack2_inP, collis2_inP;
	wire [31:0] pos2;
	physics_coprocessor physP2(
		.clock(clock), .reset(reset),

		.mass_in(mass2), .gravity_in(gravity), .wind_in(wind),
		.start_Position(startPos2),

		.controller_in(ctrl2_inP),
		.knockback_in(knock2_inP),
		.attack_in(attack2_inP[0]),


		.wall(collis2_inP),

		.freeze_in(1'b0),
		
		.ctrl_num(1'b1),

		.position(pos2)
	);
	
	
	
	/******** Collision Coprocessors ********/
	
	reg [31:0] stage_pos, stage_size;

	// Collision Player 1
	reg [31:0] player_pos_p1, player_size_p1;
	wire [3:0] coll_p1;
	wire [31:0] collision_out_p1;
	assign collision_out_p1[31:4] = 28'b0;
	assign collision_out_p1[3:0] = coll_p1;
	collision collision1(
		.player_pos(player_pos_p1), .stage_pos(stage_pos),
		.player_size(player_size_p1), .stage_size(stage_size),

		.coll(coll_p1)
	);
	
	// Collision Player 2
	reg [31:0] player_pos_p2, player_size_p2;
	wire [3:0] coll_p2;
	wire [31:0] collision_out_p2;
	assign collision_out_p2[31:4] = 28'b0;
	assign collision_out_p2[3:0] = coll_p2;
	collision collision2(
		.player_pos(player_pos_p2), .stage_pos(stage_pos),
		.player_size(player_size_p2), .stage_size(stage_size),

		.coll(coll_p2)
	);
	
	
	
	/******** Game Controller Managers ********/
	
	// Player 1 Game Controller Manager
	reg[31:0] gameControllerOutputP1;
	wire[31:0] gameControllerInputP1;
	gameControllerManager controllerP1(.mmioBoardOutput(gameControllerOutputP1),
												  .mmioBoardInput(gameControllerInputP1),
												  .halfgpio(gpio[15:0]), .halfoverflowgpio(gpio[33:32]), .ledMotorOut(gpioOutput[0]), 
												  .fastClock(clock), .slowClock(gpioOutput[2]), .startDir(1'b1), .reset(reset));

	// Player 2 Game Controller Manager
	reg[31:0] gameControllerOutputP2;
	wire[31:0] gameControllerInputP2;
   wire unused;
	gameControllerManager controllerP2(.mmioBoardOutput(gameControllerOutputP2),
												  .mmioBoardInput(gameControllerInputP2),
												  .halfgpio(gpio[31:16]), .halfoverflowgpio(gpio[35:34]), .ledMotorOut(gpioOutput[1]), 
												  .fastClock(clock), .slowClock(unused), .startDir(1'b0), .reset(reset));
	
	
	
	/******** Attack Coprocessors ********/
	reg[31:0] pos1_attack, pos2_attack, size1_attack, size2_attack;

	// Attack Coprocessor Player 1
	reg[31:0] p1controls_attack;
	wire[31:0] attack_out1, move_out1, knock_out1; 
	attack_coprocessor attackP1(.clock(clock), .reset(reset), 
			.char1pos(pos1_attack), .char1size(size1_attack),
			.char2pos(pos2_attack), .char2size(size2_attack),
			.controls(p1controls_attack),
			.attack(attack_out1),
			.movement(move_out1),
			.knockback(knock_out1));
																									
	// Attack Coprocessor Player 2
	reg[31:0] p2controls_attack;
	wire[31:0] attack_out2, move_out2, knock_out2; 
	attack_coprocessor attackP2(.clock(clock), .reset(reset), 
			.char1pos(pos2_attack), .char1size(size2_attack),
			.char2pos(pos1_attack), .char2size(size1_attack),
			.controls(p2controls_attack),
			.attack(attack_out2),
			.movement(move_out2),
			.knockback(knock_out2));
					

					
	/******** VGA Coprocessors ********/
	
	// VGA Coprocessor Player 1
	reg[31:0] posP1InVGA, whP1InVGA, controlP1VGA, attackP1VGA, collision_p1vga_in;
	vga_coprocessor vgaP1(.posIn(posP1InVGA), .whIn(whP1InVGA), .controller(controlP1VGA), .attack(attackP1VGA), .collision(collision_p1vga_in), .vga_output(p1VGA));

	// VGA Coprocessor Player 2
	reg[31:0] posP2InVGA, whP2InVGA, controlP2VGA, attackP2VGA, collision_p2vga_in;
	vga_coprocessor vgaP2(.posIn(posP2InVGA), .whIn(whP2InVGA), .controller(controlP2VGA), .attack(attackP2VGA), .collision(collision_p2vga_in), .vga_output(p2VGA));

	// DMEM
   wire [11:0] address_dmem;
   wire wren_dmem;
   wire [31:0] q_dmem;
   dmem my_dmem(
        .address    (address_dmem),  	// address of data
        .clock      (~clock),   			// may need to invert the clock
        .data	    (data_in),    			// data you want to write
        .wren	    (wren_dmem),      	// write enable
        .q          (q_dmem)    			// data from dmem
   );



	// Module Inputs
	wire [31:0] co_sel, co_spec;
	assign wren_dmem = wren & ~address[12];
	assign address_dmem = address[11:0];
	decoder_32 coprocessor_select(.in(address[11:7]), .out(co_sel));
	decoder_32 coprocessor_inspec(.in(address[6:2]), .out(co_spec));


	always @(negedge clock) begin

		
		// Testing, Remove Later - Now updated for P2

		// Physics Constants
		gravity <= 32'h00010000;
		wind <= 32'h00000010;
		mass1 <= 32'h00000010;
		startPos1 <= 32'h016000fa;
		mass2 <= 32'h00000010;
		startPos2 <= 32'h02a900fa;

		// Collision Constants
		stage_pos <= 32'h01430014;
		stage_size <= 32'h01fa00c8;
		player_size_p1 <= 32'h0085007d;
		player_size_p2 <= 32'h00590055;
		
		// Attack Constants
		size1_attack <= player_size_p1;
		size2_attack <= player_size_p2;
		
		// VGA Constants
		whP1InVGA <= player_size_p1;
		whP2InVGA <= player_size_p2;

		
		// Physics Inputs
		ctrl1_inP <= gameControllerInputP1;
		knock1_inP <= knock_out2;
		attack1_inP <= attack_out2;
		collis1_inP <= collision_out_p1;
		ctrl2_inP <= gameControllerInputP2;
		knock2_inP <= knock_out1;
		attack2_inP <= attack_out1;
		collis2_inP <= collision_out_p2;
		
		// Collision Inputs
		player_pos_p1 <= pos1;
		player_pos_p2 <= pos2;
		
		// Attack Inputs
		pos1_attack <= pos1;
		pos2_attack <= pos2;
		p1controls_attack <= gameControllerInputP1;
		p2controls_attack <= gameControllerInputP2;

		// VGA Inputs
		posP1InVGA <= pos1;
		controlP1VGA <= gameControllerInputP1;
		attackP1VGA <= attack_out1;
		posP2InVGA <= pos2;
		controlP2VGA <= gameControllerInputP2;
		attackP2VGA <= attack_out2;
		collision_p1vga_in <= collision_out_p1;
		collision_p2vga_in <= collision_out_p2;
	end
	


	// Module Outputs
	wire [31:0] coprocessor_out;
	tristate_32 outmux(.sel(co_sel),
			.in0(pos1),								// Player 1 Physics Coprocessor
			.in1(pos2),								// Player 2 Physics Coprocessor
			.in2(32'b0),							// Player 3 Physics Coprocessor (Unused)
			.in3(32'b0),							// Player 4 Physics Coprocessor (Unused)
			.in4(gameControllerInputP1), 		// Player 1 Game Controller Manager
			.in5(gameControllerInputP2), 		// Player 2 Game Controller Manager
			.in6(32'b0),  							// Player 3 Game Controller Manager (Unused)
			.in7(32'b0),  							// Player 4 Game Controller Manager (Unused)
			.in8(32'b0),  							// Player 1 VGA Coprocessor (Unused)
			.in9(32'b0), 							// Player 2 VGA Coprocessor (Unused)
			.in10(32'b0),  						// Player 3 VGA Coprocessor (Unused)
			.in11(32'b0),  						// Player 4 VGA Coprocessor (Unused)
			.in12(collision_out_p1), 			// Player 1 Collision Coprocessor
			.in13(collision_out_p2), 			// Player 2 Collision Coprocessor
			.in14(32'b0), 							// Unused
			.in15(32'b0), 							// Unused
			.in16(attack1),						// Player 1 Attack Coprocessor
			.in17(attack2), 						// Player 2 Attack Coprocessor
			.in18(32'b0), 							// Unused
			.in19(32'b0), 							// Unused
			.in20(32'b0), 							// Unused
			.in21(32'b0), 							// Unused
			.in22(32'b0), 							// Unused
			.in23(32'b0), 							// Unused
			.in24(32'b0), 							// Unused
			.in25(32'b0), 							// Unused
			.in26(32'b0), 							// Unused
			.in27(32'b0), 							// Unused
			.in28(32'b0), 							// Unused
			.in29(32'b0), 							// Unused
			.in30(32'b0), 							// Unused
			.in31(32'b0), 							// Unused
			.out(coprocessor_out));
	assign data_out = address[12]? coprocessor_out : q_dmem;

endmodule
