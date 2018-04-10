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
							 stageVGA);

	
input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;

input [63:0] p1VGA, p2VGA, stageVGA;
                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index, indexc1, indexc2;
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
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+19'd1;
end

assign VGA_CLK_n = ~iVGA_CLK;

img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_background)
);	

/************** OUR CODE STARTS HERE ************/

// Convert ADDR to pixel (x, y)
wire[18:0] myX, myY;
assign myX = ADDR % 19'd640;
assign myY = ADDR / 19'd640;


// Test if inside any sprite
wire isInsideP1, isInsideP2;
wire [18:0] indexP1, indexP2;
isInsideSprite insideP1(p1VGA, myX, myY, isInsideP1, indexP1);
isInsideSprite insideP2(p2VGA, myX, myY, isInsideP2, indexP2);

wire[23:0] bgr_data_raw_background;
wire[23:0] bgr_data_raw_p1;
wire[23:0] bgr_data_raw_p2;


// Load background
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
);
//assign bgr_data_raw_background = 24'b000000000000000011111111;

// Load P1 image
//TEMP color it red
//assign bgr_data_raw_p1 = 24'b000000000000000011111111;

// Load P2 Image
//TEMP Color it blue
assign bgr_data_raw_p2 = 24'b111111110000000000000000;


// Load P1 image
bowser_data	character1_data_inst (
	.address ( indexP1 ),
	.clock ( VGA_CLK_n ),
	.q ( indexc1 )
);
bowser_index	character1_index_inst (
	.address ( indexc1 ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw_p1)
);	

// Load P2 image
//character2_data	character2_data_inst (
//	.address ( ADDR ),
//	.clock ( VGA_CLK_n ),
//	.q ( indexc2 )
//);
//character2_index	character2_index_inst (
//	.address ( indexc2 ),
//	.clock ( iVGA_CLK ),
//	.q ( bgr_data_raw_p2)
//);	


//Choose the color of the frontmost object (can change layering via order of muxes here)
wire[23:0] w1;
//assign w1 = isInsideP2 ? bgr_data_raw_p2 : bgr_data_raw_background;
//assign bgr_data_raw = isInsideP1 ? bgr_data_raw_p1 : w1;
	
assign bgr_data_raw = isInsideP1 & (bgr_data_raw_p1 !== 24'b0) ? bgr_data_raw_p1 : bgr_data_raw_background;
//assign bgr_data_raw = bgr_data_raw_p1;
	
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
