module mmio(
	clock, reset,
	address, data_in, wren, data_out, gpio, gpioOutput, p1VGA, p2VGA, stageVGA, p1Controller, p2Controller
);
	
	input clock, reset;
	input [12:0] address;
	input [31:0] data_in;
	input wren;
	output [31:0] data_out;

	input [35:0] gpio;
	output[2:0] gpioOutput;
	output [63:0] p1VGA, p2VGA, stageVGA;
	output [31:0] p1Controller, p2Controller;

	// Player 1 Physics Coprocessor
	reg [31:0] mass1, grav1, wind1, startPos1;
	reg [31:0] ctrl1, knock1, attack1, collis1;
	wire [31:0] pos1;
	physics_coprocessor physP1(
		.clock(clock), .reset(reset),

		.mass_in(mass1), .gravity_in(grav1), .wind_in(wind1),
		.start_Position(startPos1),

		.controller_in(ctrl1),
		.knockback_in(knock1),
		.attack_in(attack1[0]),


		.wall(collis1),

		.freeze_in(1'b0),

		.position(pos1)
	);

	// Player 2 Physics Coprocessor
	reg [31:0] mass2, grav2, wind2, startPos2;
	reg [31:0] ctrl2, knock2, attack2, collis2;
	wire [31:0] pos2;
	physics_coprocessor physP2(
		.clock(clock), .reset(reset),

		.mass_in(mass2), .gravity_in(grav2), .wind_in(wind2),
		.start_Position(startPos2),

		.controller_in(ctrl2),
		.knockback_in(knock2),
		.attack_in(attack2[0]),


		.wall(collis2),

		.freeze_in(1'b0),

		.position(pos2)
	);

	// Collision Player 1
	reg [31:0] player_pos_p1, stage_pos, player_size_p1, stage_size;
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
	reg [31:0] player_pos_p2, player_size_p2;  //Note: also reuses stage_pos and stage_size from Collision Player 1 - Is this OK? - Matthew
	wire [3:0] coll_p2;
	wire [31:0] collision_out_p2;
	assign collision_out_p2[31:4] = 28'b0;
	assign collision_out_p2[3:0] = coll_p2;
	collision collision2(
		.player_pos(player_pos_p2), .stage_pos(stage_pos),
		.player_size(player_size_p2), .stage_size(stage_size),

		.coll(coll_p2)
	);

	// Player 1 Game Controller Manager
	reg[31:0] gameControllerOutputP1;
	wire[31:0] gameControllerInputP1;
	gameControllerManager controllerP1(.mmioBoardOutput(gameControllerOutputP1),
												  .mmioBoardInput(gameControllerInputP1),
												  .halfgpio(gpio[15:0]), .halfoverflowgpio(gpio[33:32]), .ledMotorOut(gpioOutput[0]), .fastClock(clock), .slowClock(gpioOutput[2]));

	// Player 2 Game Controller Manager
	reg[31:0] gameControllerOutputP2;
	wire[31:0] gameControllerInputP2;
    wire unused;
	gameControllerManager controllerP2(.mmioBoardOutput(gameControllerOutputP2),
												  .mmioBoardInput(gameControllerInputP2),
												  .halfgpio(gpio[31:16]), .halfoverflowgpio(gpio[35:34]), .ledMotorOut(gpioOutput[1]), .fastClock(clock), .slowClock(unused));

	// VGA Coprocessor Player 1

	reg[31:0] posP1InVGA, whP1InVGA;
	vga_coprocessor vgaP1(.posIn(posP1InVGA), .whIn(whP1InVGA), .poswhOut(p1VGA), .controller(gameControllerInputP1), .controller_out(p1Controller));

	// VGA Coprocessor Player 2
	reg[31:0] posP2InVGA, whP2InVGA;
	vga_coprocessor vgaP2(.posIn(posP2InVGA), .whIn(whP2InVGA), .poswhOut(p2VGA), .controller(gameControllerInputP2), .controller_out(p2Controller));


	// VGA Coprocessor Stage
	reg[31:0] posStageInVGA, whStageInVGA;
	vga_coprocessor vgaStage(.posIn(posStageInVGA), .whIn(whStageInVGA), .poswhOut(stageVGA));


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
		mass1 <= 32'h00000010;
		grav1 <= 32'h00010000;
		wind1 <= 32'h00000010;
		startPos1 <= 32'h016000fa;  //x = 352, y = 250
		
		mass2 <= 32'h00000010;
		grav2 <= 32'h00010000;
		wind2 <= 32'h00000010;
		startPos2 <= 32'h01a900fa;   //x = 425 y = 250

		// Collision Constants
		player_size_p1 <= 32'h0085007d;
		stage_pos <= 32'h01430014;
		stage_size <= 32'h01fa00c8;
		
		player_size_p2 <= 32'h0085007d;
		//No need for stage_pos and stage_size again

		// VGA Constants
		//whP1InVGA, whP2InVGA no longer exist, use player_size_p1 and player_size_p2
		posStageInVGA <= 32'h01430014;
		whStageInVGA <= 32'h01fa00c8;

		// Physics Inputs
		ctrl1 <= gameControllerInputP1;
		knock1 <= 32'h00000000;
		attack1 <= 32'h00000000;
		collis1 <= collision_out_p1;
		ctrl2 <= gameControllerInputP2;
		knock2 <= 32'h00000000;
		attack2 <= 32'h00000000;
		collis2 <= collision_out_p2;
		
		// Collision Inputs
		player_pos_p1 <= pos1;
		player_pos_p2 <= pos2;

		// VGA Inputs
		posP1InVGA <= pos1;
		posP2InVGA <= pos2;
		
		/*
		if (wren & co_sel[0]) begin // physics player 1
			if (co_spec[0]) mass1 <= data_in;
			if (co_spec[1]) grav1 <= data_in;
			if (co_spec[2]) wind1 <= data_in;
			if (co_spec[3]) startPos1 <= data_in;
			if (co_spec[4]) ctrl1 <= data_in;
			if (co_spec[5]) knock1 <= data_in;
			if (co_spec[6]) attack1 <= data_in;
			if (co_spec[7]) collis1 <= data_in;
		end
		if (wren & co_sel[1]) begin // physics player 2
			if (co_spec[0]) mass2 <= data_in;
			if (co_spec[1]) grav2 <= data_in;
			if (co_spec[2]) wind2 <= data_in;
			if (co_spec[3]) startPos2 <= data_in;
			if (co_spec[4]) ctrl2 <= data_in;
			if (co_spec[5]) knock2 <= data_in;
			if (co_spec[6]) attack2 <= data_in;
			if (co_spec[7]) collis2 <= data_in;
		end
		if (wren & co_sel[4]) begin // Game Controller Manager for player 1
			if (co_spec[0]) gameControllerOutputP1 <= data_in;
		end
		if (wren & co_sel[5]) begin // Game Controller Manager for player 2
			if (co_spec[0]) gameControllerOutputP2 <= data_in;
		end
		if (wren & co_sel[8]) begin // VGA Coprocessor P1
			if (co_spec[0])  posP1InVGA <= data_in;
			if (co_spec[1])  whP1InVGA <= data_in;
		end
		if (wren & co_sel[9]) begin // VGA Coprocessor P2
			if (co_spec[0])  posP2InVGA <= data_in;
			if (co_spec[1])  whP2InVGA <= data_in;
		end
		if (wren & co_sel[10]) begin // VGA Coprocessor Stage
			if (co_spec[0])  posStageInVGA <= data_in;
			if (co_spec[1])  whStageInVGA <= data_in;
		end
		if (wren & co_sel[12]) begin  // Collision P1
			if (co_spec[0]) player_pos_p1 <= data_in;
			if (co_spec[1]) stage_pos <= data_in;
			if (co_spec[2]) player_size_p1 <= data_in;
			if (co_spec[3]) stage_size <= data_in;
		end
		if (wren & co_sel[13]) begin // Collision P2
			if (co_spec[0]) player_pos_p2 <= data_in;
			if (co_spec[1]) stage_pos <= data_in;
			if (co_spec[2]) player_size_p2 <= data_in;
			if (co_spec[3]) stage_size <= data_in;
		end
	*/
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
			.in16(32'b0),							// Unused
			.in17(32'b0), 							// Unused
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
