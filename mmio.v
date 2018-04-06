module mmio(
	clock, reset,
	address, data_in, wren, data_out
);
	
	input clock, reset;
	input [12:0] address;
	input [31:0] data_in;
	input wren;
	output [31:0] data_out;	
	
	// Player 1 Physics Coprocessor
	reg [31:0] mass1, grav1, wind1, startPos1;
	reg [31:0] ctrl1, knock1, attack1, collis1;
	wire [13:0] pos1;
	physics_coprocessor physP1(
		.clock(clock), .reset(reset),

		.mass(mass1), .gravity(grav1), .wind(wind1),
		.start_Position(startPos1), 

		.controller_in(ctrl1),
		.knockback_in(knock1),
		.attack_in(attack1[0]),


		.wall(collis1[3:0]),

		.freeze_in(1'b0),

		.position(pos1)
	);
	
	// Player 2 Physics Coprocessor
	reg [31:0] mass2, grav2, wind2, startPos2;
	reg [31:0] ctrl2, knock2, attack2, collis2;
	wire [13:0] pos2;
	physics_coprocessor physP2(
		.clock(clock), .reset(reset),

		.mass(mass2), .gravity(grav2), .wind(wind2),
		.start_Position(startPos2), 

		.controller_in(ctrl2),
		.knockback_in(knock2),
		.attack_in(attack2[0]),


		.wall(collis2[3:0]),

		.freeze_in(1'b0),

		.position(pos2)
	);
	
	// Collision
	reg [31:0] x_pos, y_pos, x_size, y_size;
	wire [3:0] coll;
	collision collision1(
		.x_pos(x_pos), .y_pos(y_pos),
		.x_size(x_size), .y_size(y_size),
		
		.coll(coll)
	);
	
	// Game Controller Manager
	
	
	// VGA Controller
	

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
		if (co_sel[0]) begin // physics player 1
			if (co_spec[0]) mass1 <= data_in;
			if (co_spec[1]) grav1 <= data_in;
			if (co_spec[2]) wind1 <= data_in;
			if (co_spec[3]) startPos1 <= data_in;
			if (co_spec[4]) ctrl1 <= data_in;
			if (co_spec[5]) knock1 <= data_in;
			if (co_spec[6]) attack1 <= data_in;
			if (co_spec[7]) collis1 <= data_in;
		end
		if (co_sel[1]) begin // physics player 2
			if (co_spec[0]) mass2 <= data_in;
			if (co_spec[1]) grav2 <= data_in;
			if (co_spec[2]) wind2 <= data_in;
			if (co_spec[3]) startPos2 <= data_in;
			if (co_spec[4]) ctrl2 <= data_in;
			if (co_spec[5]) knock2 <= data_in;
			if (co_spec[6]) attack2 <= data_in;
			if (co_spec[7]) collis2 <= data_in;
		end
		// Game Controller Manager
		if (co_sel[4]) begin
			
		end
		// VGA Controller
		if (co_sel[8]) begin
			
		end
		// Collision
		if (co_sel[12]) begin
			if (co_spec[0]) x_pos <= data_in;
			if (co_spec[1]) y_pos <= data_in;
			if (co_spec[2]) x_size <= data_in;
			if (co_spec[3]) y_size <= data_in;
		end
	end
	
	// Module Outputs
	wire [31:0] coprocessor_out;
	tristate_32 outmux(.sel(co_sel), .in0(pos1), .in1(pos2), .in2(32'b0), .in3(32'b0), 
			.in4(32'b0), .in5(32'b0), .in6(32'b0), .in7(32'b0), .in8(32'b0), .in9(32'b0), 
			.in10(32'b0), .in11(32'b0), .in12(coll), .in13(32'b0), .in14(32'b0), .in15(32'b0), 
			.in16(32'b0), .in17(32'b0), .in18(32'b0), .in19(32'b0), .in20(32'b0), .in21(32'b0), 
			.in22(32'b0), .in23(32'b0), .in24(32'b0), .in25(32'b0), .in26(32'b0), .in27(32'b0), 
			.in28(32'b0), .in29(32'b0), .in30(32'b0), .in31(32'b0), .out(coprocessor_out));
	assign data_out = address[12]? coprocessor_out : q_dmem;

endmodule
	 