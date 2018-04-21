module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 p1VGA,
							 p2VGA
);

	
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;

input [127:0] p1VGA, p2VGA;
                        
///////// ////                     
reg [18:0] ADDR;
reg [16:0] stage_addr;
reg [8:0] count;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index, indexc1, indexc1_a, indexc1_down, indexc1_downb, indexc1_sideb, indexc1_upb, indexc1_walk, indexc1_b;
wire [7:0] indexc2;
wire [23:0] bgr_data_raw;
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
//		count<=9'd0;
//		stage_addr<=17'd0;
	end
	else if (cHS==1'b0 && cVS==1'b0) begin
		ADDR<=19'd0;
//		count<=9'd0;
//		stage_addr<=17'd0;
	end
	else if (cBLANK_n==1'b1)
		ADDR<=ADDR+19'd1;
	
	
end

//always@(negedge iVGA_CLK)
//begin
//	if (ADDR % 19'd640 == 19'b0) // increase the count for each line that passes
//		count<=count+9'd1;
//	if (ADDR % 2 == 19'b0) //increment stage addr every other pixel
//		stage_addr<=stage_addr+9'd1;
//	if (count % 2 == 9'd1)
//		stage_addr<=stage_addr-9'd320;
//end

assign VGA_CLK_n = ~iVGA_CLK;


/************** OUR CODE STARTS HERE ************/

 //Load background
stage_data	stage_data_inst (
	.address ( ADDR/19'd2 ),
	.clock ( VGA_CLK_n ),
	.q ( index )
);
stage_index stage_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_background )
);	
//img_data	img_data_inst (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( index )
//);
//img_index	img_index_inst (
//	.address ( index ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_raw_background)
//);	

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
	.address ( indexP1 ),
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
	.address ( indexP1 ),
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
	.address ( indexP1 ),
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
	.address ( indexP1 ),
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
	.address ( indexP1 ),
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
	.address ( indexP1 ),
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
	.address ( indexP1 ),
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
	.address ( indexP2 ),
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
	.address ( indexP2 ),
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
	.address ( indexP2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_down )
);
kirby_down_index character2_down_index_inst (
	.address ( indexc2_down ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_down )
);	// Load P2 downb
kirby_downb_data	character2_adownb_data_inst (
	.address ( indexP2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_downb )
);
kirby_downb_index character2_downb_index_inst (
	.address ( indexc2_a ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_downb )
);	// Load P2 sideb
kirby_sideb_data	character2_sideb_data_inst (
	.address ( indexP2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_sideb )
);
kirby_sideb_index character2_sideb_index_inst (
	.address ( indexc2_sideb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_sideb )
);	// Load P2 upb
kirby_upb_data	character2_upb_data_inst (
	.address ( indexP2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_upb )
);
kirby_upb_index character2_upb_index_inst (
	.address ( indexc2_upb ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_upb )
);	// Load P2 b
kirby_b_data	character2_b_data_inst (
	.address ( indexP2 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc2_b )
);
kirby_b_index character2_b_index_inst (
	.address ( indexc2_b ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p2_b )
);	// Load P2 walk
kirby_walk_data	character2_walk_data_inst (
	.address ( indexP2 ),
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
	else if(p1VGA[103]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_downb;
	end
	else if(p1VGA[102]) begin
		bgr_data_raw_p1 <= bgr_data_raw_p1_upb;
	end
	else if(p1VGA[104] | p1VGA[105]) begin
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
	if(p2VGA[101]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_a;
	end
	else if(p2VGA[103]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_downb;
	end
	else if(p2VGA[102]) begin
		bgr_data_raw_p2 <= bgr_data_raw_p2_upb;
	end
	else if(p2VGA[104] | p2VGA[105]) begin
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

//assign bgr_data_raw_background = 24'b010101010101010101010101;

assign w1 = isInsideP1 & (bgr_data_raw_p1 !== 24'b0) ? bgr_data_raw_p1 : bgr_data_raw_background;

assign bgr_data_raw = isInsideP2 & (bgr_data_raw_p2 !== 24'b0) ? bgr_data_raw_p2 : w1;


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
