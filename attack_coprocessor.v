module attack_coprocessor(
	clock, reset,

	// Inputs
	char1pos, char1size,
	char2pos, char2size,
	controls, opp_shield,

	// Outputs
	attack,
	movement,
	knockback
);

	input clock, reset;
	input [31:0] char1pos, char1size;
	input [31:0] char2pos, char2size;
	input [31:0] controls;
	input opp_shield;
	output [31:0] attack, movement, knockback;

	// smash attacks
	wire smashL, smashR, smashU, smashD;
	assign smashL = controls[23];
	assign smashR = controls[22];
	assign smashU = controls[21];
	assign smashD = controls[20];

	// A button attacks
	wire jabNL, jabNR;
	assign jabNL = controls[16] & ~controls[26];
	assign jabNR = controls[16] & controls[26];

	// B button attacks
	wire specialNL, specialNR, specialL, specialR, specialU, specialD;
	wire tiltL, tiltR, tiltU, tiltD, pushB;
	assign pushB = controls[17];
	assign tiltL = ~controls[15] & ~controls[14] & ~controls[13];
	assign tiltR = controls[15] & controls[14] & controls[13];
	assign tiltU = controls[7] & controls[6] & controls[5];
	assign tiltD = ~controls[7] & ~controls[6] & ~controls[5];
	assign specialNL = pushB & ~tiltL & ~tiltR & ~ tiltU & tiltD & ~controls[26];
	assign specialNR = pushB & ~tiltL & ~tiltR & ~ tiltU & tiltD & controls[26];
	assign specialL = pushB & tiltL;
	assign specialR = pushB & tiltR;
	assign specialU = pushB & tiltU;
	assign specialD = pushB & tiltD;
	
	// shield
	wire shield;
	assign shield = controls[18] | controls[19];

	// Hit Boxes
	wire[15:0] char1posX, char1posY;
	assign char1posX = char1pos[31:16];
	assign char1posY = char1pos[15:0];
	wire [31:0] lhbpos, rhbpos, uhbpos,  dhbpos, hbsize;
	assign hbsize[31:16] = char1size[31:16] / 16'd2;
	assign hbsize[15:0] = char1size[15:0] / 16'd2;
	assign lhbpos[31:16] = char1posX - hbsize[31:16];
	assign lhbpos[15:0] = char1posY + hbsize[15:0] / 16'd2;
	assign rhbpos[31:16] = char1posX + char1size[31:16];
	assign rhbpos[15:0] = char1posY + hbsize[15:0] / 16'd2;
	assign uhbpos[31:16] = char1posX + hbsize[31:16] / 16'd2;
	assign uhbpos[15:0] = char1posY + char1size[15:0];
	assign dhbpos[31:16] = char1posX + hbsize[31:16] / 16'd2;
	assign dhbpos[15:0] = char1posY - hbsize[15:0] / 16'd2;
	wire [3:0] hitOutL, hitOutR, hitOutU, hitOutD;
	collision leftCol(lhbpos, char2pos, hbsize, char2size, hitOutL);
	collision rightCol(rhbpos, char2pos, hbsize, char2size, hitOutR);
	collision upCol(uhbpos, char2pos, hbsize, char2size, hitOutU);
	collision downCol(dhbpos, char2pos, hbsize, char2size, hitOutD);
	wire leftHit, rightHit, upHit, downHit;
	assign leftHit = ~opp_shield & (hitOutL[0] | hitOutL[1] | hitOutL[2] | hitOutL[3]);
	assign rightHit = ~opp_shield & (hitOutR[0] | hitOutR[1] | hitOutR[2] | hitOutR[3]);
	assign upHit = ~opp_shield & (hitOutU[0] | hitOutU[1] | hitOutU[2] | hitOutU[3]);
	assign downHit = ~opp_shield & (hitOutD[0] | hitOutD[1] | hitOutD[2] | hitOutD[3]);

	// Attack Duration
	reg [25:0] shieldTimer;
	reg [24:0] longTimer;
	reg [23:0] shortTimer;
	reg lastAttack;
	reg lastSL, lastSR, lastSU, lastSD, lastJNL, lastJNR;
	reg lastBNL, lastBNR, lastBL, lastBR, lastBU, lastBD;
	reg lastShield;
	always@(posedge clock) begin
		
		// Attack Starts
		if(smashL & ~lastAttack) begin
			lastAttack = 1'b1;
			lastSL <= 1'b1;
			longTimer = 25'b0100000000000000000000000;
		end
		if(smashR & ~lastAttack) begin
			lastAttack = 1'b1;
			lastSR <= 1'b1;
			longTimer = 25'b0100000000000000000000000;
		end
		if(smashU & ~lastAttack) begin
			lastAttack = 1'b1;
			lastSU <= 1'b1;
			longTimer = 25'b0100000000000000000000000;
		end
		if(smashD & ~lastAttack) begin
			lastAttack = 1'b1;
			lastSD <= 1'b1;
			longTimer = 25'b0100000000000000000000000;
		end
		if(jabNL & ~lastAttack) begin
			lastAttack = 1'b1;
			lastJNL <= 1'b1;
			shortTimer = 24'b100000000000000000000000;
		end
		if(jabNR & ~lastAttack) begin
			lastAttack = 1'b1;
			lastJNR <= 1'b1;
			shortTimer = 24'b100000000000000000000000;
		end
		if(specialNL & ~lastAttack) begin
			lastAttack = 1'b1;
			lastBNL <= 1'b1;
			longTimer = 25'b1000000000000000000000000;
		end
		if(specialNR & ~lastAttack) begin
			lastAttack = 1'b1;
			lastBNR <= 1'b1;
			longTimer = 25'b1000000000000000000000000;
		end
		if(specialL & ~lastAttack) begin
			lastAttack = 1'b1;
			lastBL <= 1'b1;
			longTimer = 25'b1000000000000000000000000;
		end
		if(specialR & ~lastAttack) begin
			lastAttack = 1'b1;
			lastBR <= 1'b1;
			longTimer = 25'b1000000000000000000000000;
		end
		if(specialU & ~lastAttack) begin
			lastAttack = 1'b1;
			lastBU <= 1'b1;
			longTimer = 25'b1000000000000000000000000;
		end
		if(specialD & ~lastAttack) begin
			lastAttack = 1'b1;
			lastBD <= 1'b1;
			longTimer = 25'b1000000000000000000000000;
		end
		
		// Shield Starts
		if(shield & ~lastShield & ~lastAttack) begin
			lastAttack = 1'b1;
			lastShield = 1'b1;
			shieldTimer = 26'b10000000000000000000000000;
		end

		// Attack Endings
		if(longTimer === 25'b0011111111111111111111111) begin
			lastSL <= 1'b0;
			lastSR <= 1'b0;
			lastSU <= 1'b0;
			lastSD <= 1'b0;
			lastBNL <= 1'b0;
			lastBNR <= 1'b0;
			lastBL <= 1'b0;
			lastBR <= 1'b0;
			lastBL <= 1'b0;
			lastBU <= 1'b0;
			lastBD <= 1'b0;
		end
		if(shortTimer === 24'b001111111111111111111111) begin
			lastJNL <= 1'b0;
			lastJNR <= 1'b0;
		end
		if(~lastSL & ~lastSR & ~lastSU & ~lastSD & ~lastJNL & ~lastJNR & ~lastBNL & 
				~lastBNR & ~lastBL & ~lastBR & ~lastBU & ~lastBD) begin
			lastAttack = 1'b0;
		end
		
		// Shield Ending
		if(shieldTimer === 26'b01111111111111111111111111) begin
			lastShield = 1'b0;
			lastAttack = 1'b0;
		end

		// Timer Increments
		shieldTimer <= shieldTimer + 26'd1;
		longTimer <= longTimer + 25'd1;
		shortTimer <= shortTimer + 24'd1;

	end

	// Duration Output Values
	wire smashL_out, smashR_out, smashU_out, smashD_out, jabNL_out, jabNR_out;
	wire specialNL_out, specialNR_out, specialL_out, specialR_out, specialU_out, specialD_out, my_shield;
	assign smashL_out = lastSL & longTimer[24];
	assign smashR_out = lastSR & longTimer[24];
	assign smashU_out = lastSU & longTimer[24];
	assign smashD_out = lastSD & longTimer[24];
	assign jabNL_out = lastJNL & shortTimer[23];
	assign jabNR_out = lastJNR & shortTimer[23];
	assign specialNL_out = lastBNL & longTimer[24];
	assign specialNR_out = lastBNR & longTimer[24];
	assign specialL_out = lastBL & longTimer[24];
	assign specialR_out = lastBR & longTimer[24];
	assign specialU_out = lastBU & longTimer[24];
	assign specialD_out = lastBD & longTimer[24];
	assign my_shield = lastShield & shieldTimer[25];


	// Attack output
	assign attack[0] = smashU_out & upHit | smashD_out & downHit | smashL_out & leftHit | smashR_out & rightHit | jabNL_out & leftHit
						 | jabNR_out & rightHit | specialU_out & upHit | specialD_out & downHit | specialL_out & leftHit
						 | specialR_out & rightHit | specialNL_out & leftHit | specialNR_out & rightHit;
	assign attack[1] = smashU_out;
	assign attack[2] = smashD_out;
	assign attack[3] = smashL_out;
	assign attack[4] = smashR_out;
	assign attack[5] = jabNL_out | jabNR_out;
	assign attack[6] = specialU_out;
	assign attack[7] = specialD_out;
	assign attack[8] = specialL_out;
	assign attack[9] = specialR_out;
	assign attack[10] = specialNL_out | specialNR_out;
	assign attack[11] = smashU_out | smashD_out | smashL_out | smashR_out | jabNL_out
						 | jabNR_out | specialU_out | specialD_out | specialL_out 
						 | specialR_out | specialNL_out | specialNR_out;
	assign attack[12] = my_shield;
	assign attack[31:13] = 19'b0;
		
	// Giving Knockback
	reg [31:0] knockback;
	always@(posedge clock) begin
		if(smashU_out) knockback <= 32'h0000000A;
		if(smashD_out) knockback <= 32'h0000FFF0;
		if(smashL_out) knockback <= 32'hFFF80001;
		if(smashR_out) knockback <= 32'h00080001;
		if(jabNL_out) knockback <= 32'hFFFC0001;
		if(jabNR_out) knockback <= 32'h00040001;
		if(specialU_out) knockback <= 32'h00000006;
		if(specialD_out) knockback <= 32'h0000FFF8;
		if(specialL_out) knockback <= 32'hFFFA0002;
		if(specialR_out) knockback <= 32'h00060002;
		if(specialNL_out) knockback <= 32'hFFFF0000;
		if(specialNR_out) knockback <= 32'h00010000;
	end

	// Moving the Characters
	reg [31:0] movement;
	always@(posedge clock) begin
		if(specialU_out) movement <= 32'h00007F00;
	end

endmodule // attack_coprocessor