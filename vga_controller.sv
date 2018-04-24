module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 p1VGA,
							 p2VGA,
							 reg18
);

	
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;
output [31:0] reg18; //register for lives

input [159:0] p1VGA, p2VGA;
                        
///////// //// 
//reg [31:0] reg18;                    
reg [18:0] ADDR;
reg [16:0] stage_addr;
reg [8:0] count;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index, indexc1, indexc1_a, indexc1_down, indexc1_downb, indexc1_sideb, indexc1_upb, indexc1_walk, indexc1_b;
wire [7:0] indexc2, indexc2_a, indexc2_down, indexc2_downb, indexc2_sideb, indexc2_upb, indexc2_walk, indexc2_b;
reg[23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Address generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
	if (!iRST_n) begin
		ADDR<=19'd0;
//		reg18 <= (setlives1 << 16'd16) + setlives2;
	end
	else if (cHS==1'b0 && cVS==1'b0)
		ADDR<=19'd0;
	else if (cBLANK_n==1'b1)
		ADDR<=ADDR+19'd1;
	
end

assign VGA_CLK_n = ~iVGA_CLK;


/************** OUR CODE STARTS HERE ************/

 //Load background
stage_data	stage_data_inst (
	.address ( ADDR/2 ),
	.clock ( VGA_CLK_n ),
	.q ( index )
);
stage_index stage_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_background )
);	

// Convert ADDR to pixel (x, y)
wire[18:0] myX, myY;
assign myX = 19'd256 + ADDR % 19'd640;
assign myY = ADDR / 19'd640;


// Test if inside any sprite
wire isInsideP1, isInsideP2;
wire [18:0] indexP1, indexP2;
isInsideSprite insideP1(p1VGA, myX, myY, isInsideP1, indexP1);
isInsideSprite insideP2(p2VGA, myX, myY, isInsideP2, indexP2);

wire[23:0] bgr_data_raw_background;
reg[23:0] bgr_data_raw_p1;
reg[23:0] bgr_data_raw_p2;
wire[23:0] bgr_data_raw_p1_normal, bgr_data_raw_p1_a, bgr_data_raw_p1_down, bgr_data_raw_p1_downb, bgr_data_raw_p1_sideb, bgr_data_raw_p1_upb, bgr_data_raw_p1_b, bgr_data_raw_p1_walk;
wire[23:0] bgr_data_raw_p2_normal, bgr_data_raw_p2_a, bgr_data_raw_p2_down, bgr_data_raw_p2_downb, bgr_data_raw_p2_sideb, bgr_data_raw_p2_upb, bgr_data_raw_p2_b, bgr_data_raw_p2_walk;


// Load P1 image
bowser_data	character1_data_inst (
	.address ( indexP1/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1 )
);
bowser_index character1_index_inst (
	.address ( indexc1 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1_normal )
);	
// Load P1 attack
bowser_a_data	character1_attack_data_inst (
	.address ( indexP1/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1_a )
);
bowser_a_index character1_attack_index_inst (
	.address ( indexc1_a ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1_a )
);	
//Load P1 down
bowser_down_data	character1_down_data_inst (
	.address ( indexP1/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1_down )
);
bowser_down_index character1_down_index_inst (
	.address ( indexc1_down ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1_down )
);	
//Load P1 downb
bowser_downb_data	character1_downb_data_inst (
	.address ( indexP1 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1_downb )
);
bowser_downb_index character1_downb_index_inst (
	.address ( indexc1_downb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1_downb )
);	
//Load P1 sideb
bowser_sideb_data	character1_sideb_data_inst (
	.address ( indexP1/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1_sideb )
);
bowser_sideb_index character1_sideb_index_inst (
	.address ( indexc1_sideb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1_sideb )
);	
//Load P1 upb
bowser_upb_data	character1_upb_data_inst (
	.address ( indexP1/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1_upb )
);
bowser_upb_index character1_upb_index_inst (
	.address ( indexc1_upb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1_upb )
);	
//Load P1 b
bowser_b_data	character1_b_data_inst (
	.address ( indexP1/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1_b )
);
bowser_b_index character1_b_index_inst (
	.address ( indexc1_b ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1_b )
);	
//Load P1 walk
bowser_walk_data	character1_walk_data_inst (
	.address ( indexP1/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1_walk )
);
bowser_walk_index character1_walk_index_inst (
	.address ( indexc1_walk ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1_walk )
);	


// Load P2 image
kirby_data	character2_data_inst (
	.address ( indexP2/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2 )
);
kirby_index	character2_index_inst (
	.address ( indexc2 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_normal)
);	
// Load P2 attack
kirby_a_data	character2_attack_data_inst (
	.address ( indexP2/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_a )
);
kirby_a_index character2_attack_index_inst (
	.address ( indexc2_a ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_a )
);	
// Load P2 down
kirby_down_data	character2_down_data_inst (
	.address ( indexP2/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_down )
);
kirby_down_index character2_down_index_inst (
	.address ( indexc2_down ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_down )
);	// Load P2 downb
kirby_downb_data	character2_downb_data_inst (
	.address ( indexP2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_downb )
);
kirby_downb_index character2_downb_index_inst (
	.address ( indexc2_a ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_downb )
);	
// Load P2 sideb
kirby_sideb_data	character2_sideb_data_inst (
	.address ( indexP2/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_sideb )
);
kirby_sideb_index character2_sideb_index_inst (
	.address ( indexc2_sideb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_sideb )
);	// Load P2 upb
kirby_upb_data	character2_upb_data_inst (
	.address ( indexP2/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_upb )
);
kirby_upb_index character2_upb_index_inst (
	.address ( indexc2_upb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_upb )
);	// Load P2 b
kirby_b_data	character2_b_data_inst (
	.address ( indexP2/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_b )
);
kirby_b_index character2_b_index_inst (
	.address ( indexc2_b ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_b )
);	// Load P2 walk
kirby_walk_data	character2_walk_data_inst (
	.address ( indexP2/2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_walk )
);
kirby_walk_index character2_walk_index_inst (
	.address ( indexc2_walk ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_walk )
);	
//Choose the color of the frontmost object (can change layering via order of muxes here)
wire[23:0] w1;
//assign w1 = isInsideP2 ? bgr_data_raw_p2 : bgr_data_raw_background;
//assign bgr_data_raw = isInsideP1 ? bgr_data_raw_p1 : w1;

// Choose image for player 1
always@(posedge VGA_CLK_n) begin
	if(p1VGA[101]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_a;
	end
	else if(p1VGA[98]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_downb;
	end
	else if(p1VGA[102] | p1VGA[97]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_upb;
	end
	else if(p1VGA[104] | p1VGA[105] | p1VGA[99] | p1VGA[100]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_sideb;
	end
	else if(p1VGA[106]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_b;
	end
	else if((p1VGA[71:69] == 3'b000) & p1VGA[113]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_down;
	end	
	else if((p1VGA[79:78] != 2'b10) & (p1VGA[79:78] != 2'b01) & p1VGA[113]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_walk;
	end
	else begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_normal;
	end
end
// Choose image for p2
always@(posedge VGA_CLK_n) begin
	if(p2VGA[101] | p2VGA[97]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_a;
	end
	else if(p2VGA[98]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_downb;
	end
	else if(p2VGA[102] | p2VGA[97]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_upb;
	end
	else if(p2VGA[104] | p2VGA[105] | p2VGA[99] | p2VGA[100]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_sideb;
	end
	else if(p2VGA[106]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_b;
	end
	else if((p2VGA[71:69] == 3'b000) & p2VGA[113]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_down;
	end	
	else if((p2VGA[79:78] != 2'b10) & (p2VGA[79:78] != 2'b01) & p2VGA[113]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_walk;
	end
	else begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_normal;
	end
end

wire[23:0] bgr_data_raw_sevseg;
assign bgr_data_raw_sevseg = 24'b111111111111111111111111;
wire [63:0] seg100_1 [6:0];
wire [63:0] seg10_1 [6:0];
wire [63:0] seg1_1 [6:0];
wire [63:0] seg100_2 [6:0];
wire [63:0] seg10_2 [6:0];
wire [63:0] seg1_2 [6:0];
genvar i;
generate
	//height of whole 7 segment: 75, width: 25
	//each segment 5 by 25
	for(i=0; i<7; i=i+1) begin: seven_seg	
		//xpos
		if((i==4'd1) | (i==4'd2)) begin
			assign seg100_1[i][63:48] = 16'd405 + 16'd20;
			assign seg10_1[i][63:48] = 16'd405 + 16'd20 + 16'd30;
			assign seg1_1[i][63:48] = 16'd405 + 16'd20 + 16'd60;
			
			assign seg100_2[i][63:48] = 16'd710 + 16'd20;
			assign seg10_2[i][63:48] = 16'd710 + 16'd20 + 16'd30;
			assign seg1_2[i][63:48] = 16'd710 + 16'd20 + 16'd60;
		end
		else begin
			assign seg100_1[i][63:48] = 16'd405;
			assign seg10_1[i][63:48] = 16'd405 + 16'd30;
			assign seg1_1[i][63:48] = 16'd405 + 16'd60;
			
			assign seg100_2[i][63:48] = 16'd710;
			assign seg10_2[i][63:48] = 16'd710 + 16'd30;
			assign seg1_2[i][63:48] = 16'd710 + 16'd60;
		end
		//ypos
		if((i==4'd1)|(i==4'd5)) begin
			assign seg100_1[i][47:32] = 16'd90 - 16'd20;
			assign seg10_1[i][47:32] = 16'd90 - 16'd20;
			assign seg1_1[i][47:32] = 16'd90 - 16'd20;
			
			assign seg100_2[i][47:32] = 16'd90 - 16'd20;
			assign seg10_2[i][47:32] = 16'd90 - 16'd20;
			assign seg1_2[i][47:32] = 16'd90 - 16'd20;
		end
		else if((i==4'd2)|(i==4'd3)|(i==4'd4)) begin
			assign seg100_1[i][47:32] = 16'd90 - 16'd45;
			assign seg10_1[i][47:32] = 16'd90 - 16'd45;
			assign seg1_1[i][47:32] = 16'd90 - 16'd45;
			
			assign seg100_2[i][47:32] = 16'd90 - 16'd45;
			assign seg10_2[i][47:32] = 16'd90 - 16'd45;
			assign seg1_2[i][47:32] = 16'd90 - 16'd45;
		end
		else if(i==4'd6) begin
			assign seg100_1[i][47:32] = 16'd90 - 16'd22;
			assign seg10_1[i][47:32] = 16'd90 - 16'd22;
			assign seg1_1[i][47:32] = 16'd90 - 16'd22;
			
			assign seg100_2[i][47:32] = 16'd90 - 16'd22;
			assign seg10_2[i][47:32] = 16'd90 - 16'd22;
			assign seg1_2[i][47:32] = 16'd90 - 16'd22;
		end
		else begin
			assign seg100_1[i][47:32] = 16'd90;
			assign seg10_1[i][47:32] = 16'd90;
			assign seg1_1[i][47:32] = 16'd90;
			
			assign seg100_2[i][47:32] = 16'd90;
			assign seg10_2[i][47:32] = 16'd90;
			assign seg1_2[i][47:32] = 16'd90;
		end
		//width
		if((i==4'd0)|(i==4'd3)|(i==4'd6)) begin
			assign seg100_1[i][31:16] = 16'd25;
			assign seg10_1[i][31:16] = 16'd25;
			assign seg1_1[i][31:16] = 16'd25;
			
			assign seg100_2[i][31:16] = 16'd25;
			assign seg10_2[i][31:16] = 16'd25;
			assign seg1_2[i][31:16] = 16'd25;
		end
		else begin
			assign seg100_1[i][31:16] = 16'd5;
			assign seg10_1[i][31:16] = 16'd5;
			assign seg1_1[i][31:16] = 16'd5;
			
			assign seg100_2[i][31:16] = 16'd5;
			assign seg10_2[i][31:16] = 16'd5;
			assign seg1_2[i][31:16] = 16'd5;
		end
		//height
		if((i==4'd0)|(i==4'd3)|(i==4'd6)) begin
			assign seg100_1[i][15:0] = 16'd5;
			assign seg10_1[i][15:0] = 16'd5;
			assign seg1_1[i][15:0] = 16'd5;
			
			assign seg100_2[i][15:0] = 16'd5;
			assign seg10_2[i][15:0] = 16'd5;
			assign seg1_2[i][15:0] = 16'd5;
		end
		else begin
			assign seg100_1[i][15:0] = 16'd25;
			assign seg10_1[i][15:0] = 16'd25;
			assign seg1_1[i][15:0] = 16'd25;
			
			assign seg100_2[i][15:0] = 16'd25;
			assign seg10_2[i][15:0] = 16'd25;
			assign seg1_2[i][15:0] = 16'd25;
		end	
	end
endgenerate

wire [6:0] isInside7seg1 [2:0];
wire [6:0] isInside7seg2 [2:0];
//isInside7Segsv inside7Seg1(seg100_1, seg10_1, seg1_1, myX, myY, p1VGA[159:144], isInside7seg1);
isInside7Segsv inside7Seg1(seg100_1, seg10_1, seg1_1, myX, myY, p1VGA[159:144], isInside7seg1);
isInside7Segsv inside7Seg2(seg100_2, seg10_2, seg1_2, myX, myY, p2VGA[159:144], isInside7seg2);

wire [23:0] bgr_data_raw_wow;
assign bgr_data_raw_wow = (isInside7seg1[0][0]|isInside7seg1[0][1]|isInside7seg1[0][2]|isInside7seg1[0][3]|isInside7seg1[0][4]|isInside7seg1[0][5]|isInside7seg1[0][6]|isInside7seg1[1][0]|isInside7seg1[1][1]|isInside7seg1[1][2]|isInside7seg1[1][3]|isInside7seg1[1][4]|isInside7seg1[1][5]|isInside7seg1[1][6]|isInside7seg1[2][0]|isInside7seg1[2][1]|isInside7seg1[2][2]|isInside7seg1[2][3]|isInside7seg1[2][4]|isInside7seg1[2][5]|isInside7seg1[2][6]
								  |isInside7seg2[0][0]|isInside7seg2[0][1]|isInside7seg2[0][2]|isInside7seg2[0][3]|isInside7seg2[0][4]|isInside7seg2[0][5]|isInside7seg2[0][6]|isInside7seg2[1][0]|isInside7seg2[1][1]|isInside7seg2[1][2]|isInside7seg2[1][3]|isInside7seg2[1][4]|isInside7seg2[1][5]|isInside7seg2[1][6]|isInside7seg2[2][0]|isInside7seg2[2][1]|isInside7seg2[2][2]|isInside7seg2[2][3]|isInside7seg2[2][4]|isInside7seg2[2][5]|isInside7seg2[2][6]) ? bgr_data_raw_sevseg : bgr_data_raw_background;


wire [23:0] bgr_data_raw_lives1, bgr_data_raw_lives2 , bgr_data_raw_wow2, bgr_data_raw_wow3, bgr_data_raw_wow4;
assign bgr_data_raw_lives1 = 24'b000000000000000001111100;
assign bgr_data_raw_lives2 = 24'b101010101010101010101010;

wire [63:0] lives1 [4:0];
wire [63:0] lives2 [4:0];

genvar j;
generate
	for(j=0; j<5; j=j+1) begin: lives
		assign lives1[j][63:48] = 16'd405 + j*16'd15;
		assign lives1[j][47:32] = 16'd100;
		assign lives1[j][31:16] = 16'd10;
		assign lives1[j][15:0] = 16'd10;
		
		assign lives2[j][63:48] = 16'd710 + j*16'd15;
		assign lives2[j][47:32] = 16'd100;
		assign lives2[j][31:16] = 16'd10;
		assign lives2[j][15:0] = 16'd10;
	end
endgenerate

wire [4:0] isInsideLives1;
wire [4:0] isInsideLives2;
isInsideLives insidelives1(lives1, myX, myY, p1VGA[143:128], isInsideLives1);
isInsideLives insidelives2(lives2, myX, myY, p2VGA[143:128], isInsideLives2);	
		  
assign bgr_data_raw_wow2 = isInsideP2 & (bgr_data_raw_p2 !== 24'b0) ? bgr_data_raw_p2 : (isInsideP1 & (bgr_data_raw_p1 !== 24'b0)) ? bgr_data_raw_p1 : bgr_data_raw_wow;

assign bgr_data_raw_wow3 = (isInsideLives1[0]|isInsideLives1[1]|isInsideLives1[2]|isInsideLives1[3]|isInsideLives1[4]) ? bgr_data_raw_lives1 : bgr_data_raw_wow2;	
assign bgr_data_raw_wow4 = (isInsideLives2[0]|isInsideLives2[1]|isInsideLives2[2]|isInsideLives2[3]|isInsideLives2[4]) ? bgr_data_raw_lives2 : bgr_data_raw_wow3;	
	  

wire [23:0] bgr_data_raw_endscreen1, bgr_data_raw_endscreen2;
assign bgr_data_raw_endscreen1 = 24'b000000001111111111111111;
assign bgr_data_raw_endscreen2 = 24'b111111110000000000000000;

wire [4:0] isInsideLives3, isInsideLives4;
reg [4:0] setlives1, setlives2;
isInsideLives insidesetlives1(lives1, myX, myY, setlives1, isInsideLives3);
isInsideLives insidesetLives2(lives2, myX, myY, setlives2, isInsideLives4);
//reg uplastpressed, downlastpressed;

//Check ending
always@(negedge VGA_CLK_n) begin
//	if((p1VGA[143:128] == 16'b0) | (p2VGA[143:128] == 16'b0)) begin
//		//dpad down, decrease lives
//		
//	end
	
	if((p1VGA[143:128] == 16'b0)) begin		
		if(p1VGA[84] ) begin
			setlives1 <= setlives1 >> 1'b1;
		end
//		else if(~p1VGA[84] & uplastpressed)begin
//			uplastpressed <= 1'b0;
//		end
//		//dpad up, increase lives
		else if(p1VGA[85]) begin
			setlives1 <= (setlives1 << 1'b1) + 1'b1;
		end
//		else if(~p1VGA[85] & downlastpressed) begin
//			downlastpressed <= 1'b0;
//		end
//			
//		//dpad down, decrease lives
		if(p2VGA[84]) begin
			setlives2 <= setlives2 >> 1'b1;
		end
//		else if(~p2VGA[84] & uplastpressed)begin
//			uplastpressed <= 1'b0;
//		end
//		//dpad up, increase lives
		else if(p2VGA[85]) begin
			setlives2 <= (setlives2 << 1'b1) + 1'b1;
		end
//		else if(~p2VGA[85] & downlastpressed) begin
//			downlastpressed <= 1'b0;
//		end
		bgr_data_raw <= (isInsideLives3[0]|isInsideLives3[1]|isInsideLives3[2]|isInsideLives3[3]|isInsideLives3[4]) ? bgr_data_raw_lives1 : ((isInsideLives4[0]|isInsideLives4[1]|isInsideLives4[2]|isInsideLives4[3]|isInsideLives4[4]) ? bgr_data_raw_lives2 : bgr_data_raw_endscreen1);
	end
	else if((p2VGA[143:128] == 16'b0)) begin
		if(p1VGA[84] ) begin
			setlives1 <= setlives1 >> 1'b1;
		end
//		else if(~p1VGA[84] & uplastpressed)begin
//			uplastpressed <= 1'b0;
//		end
//		//dpad up, increase lives
		else if(p1VGA[85]) begin
			setlives1 <= (setlives1 << 1'b1) + 1'b1;
		end
//		else if(~p1VGA[85] & downlastpressed) begin
//			downlastpressed <= 1'b0;
//		end
//			
//		//dpad down, decrease lives
		if(p2VGA[84]) begin
			setlives2 <= setlives2 >> 1'b1;
		end
//		else if(~p2VGA[84] & uplastpressed)begin
//			uplastpressed <= 1'b0;
//		end
//		//dpad up, increase lives
		else if(p2VGA[85]) begin
			setlives2 <= (setlives2 << 1'b1) + 1'b1;
		end
//		else if(~p2VGA[85] & downlastpressed) begin
//			downlastpressed <= 1'b0;
//		end
		bgr_data_raw <= (isInsideLives3[0]|isInsideLives3[1]|isInsideLives3[2]|isInsideLives3[3]|isInsideLives3[4]) ? bgr_data_raw_lives1 : ((isInsideLives4[0]|isInsideLives4[1]|isInsideLives4[2]|isInsideLives4[3]|isInsideLives4[4]) ? bgr_data_raw_lives2 : bgr_data_raw_endscreen2);
	end
	else begin
		bgr_data_raw <= bgr_data_raw_wow4;
	end
end
assign reg18[31:16] = setlives1;
assign reg18[15:0] = setlives2;
					
/************** OUR CODE ENDS HERE **************/

	

//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule