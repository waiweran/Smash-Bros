/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

module skeleton(
	clock, reset_btn, 
	VGA_CLK,   														//	VGA Clock
	VGA_HS,															//	VGA H_SYNC
	VGA_VS,															//	VGA V_SYNC
	VGA_BLANK,														//	VGA BLANK
	VGA_SYNC,														//	VGA SYNC
	VGA_R,   														//	VGA Red[9:0]
	VGA_G,	 														//	VGA Green[9:0]
	VGA_B,															//	VGA Blue[9:0]
	gpio,
	gpioOutput,
	LEDs,
	test_atk,
	TEST_instruction,
	TEST_regfile1,
	TEST_regfile2,
	TEST_regfile3
);
		
	//REGFILE TESTS
	output[31:0] TEST_instruction;
	assign TEST_instruction = q_imem;
	output[31:0] TEST_regfile1, TEST_regfile2, TEST_regfile3;
		
	// VGA Outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
	
	// Clock and Reset Inputs
	input clock, reset_btn, test_atk;
	wire reset;
	assign reset = ~reset_btn;
	
	// GPIO Pins
	input[35:0] gpio;
	output[2:0] gpioOutput;
	
	// LEDs for Testing
	output[17:0] LEDs;
	
    /** IMEM **/
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM and IO **/
    wire [12:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
	 wire [63:0] p1VGA, p2VGA, stageVGA;
	 wire [31:0] p1Controller, p2Controller;
    mmio my_mem(
		  .clock		  (clock),
		  .reset		  (reset),
        .address    (address_dmem),  	// address of data
        .data_in    (data),    			// data you want to write
        .wren	     (wren),      		// write enable
        .data_out   (q_dmem),    		// data from memory module
		  .gpio		  (gpio),				// For controller IO
		  .gpioOutput (gpioOutput),
		  .p1VGA		  (p1VGA),
		  .p2VGA		  (p2VGA),
		  .stageVGA   (stageVGA),
		  .p1Controller(p1Controller),
		  .p2Controller(p2Controller)
    );

    /** REGFILE **/
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        ~clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
		  TEST_regfile1, TEST_regfile2, TEST_regfile3
    );

    /** Processor **/
    processor my_processor(
        // Control signals
        clock,                          // I: The master clock
        reset,                          // I: A reset signal

        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem

        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        data,                           // O: The data to write to dmem
        wren,                           // O: Write enable for dmem
        q_dmem,                         // I: The data from dmem

        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
        data_readRegB                   // I: Data from port B of regfile
    );
	 
	 
	/** VGA **/
	Reset_Delay			r0	(.iCLK(clock),.oRESET(DLY_RST)	);
	VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(clock),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
	vga_controller vga_ins(.iRST_n(DLY_RST),
								 .iVGA_CLK(VGA_CLK),
								 .oBLANK_n(VGA_BLANK),
								 .oHS(VGA_HS),
								 .oVS(VGA_VS),
								 .b_data(VGA_B),
								 .g_data(VGA_G),
								 .r_data(VGA_R),
								 .p1VGA(p1VGA),
								 .p2VGA(p2VGA),
								 .stageVGA(stageVGA),
								 .test_atk(test_atk),
								 .p1Controller(p1Controller),
								 .p2Controller(p2Controller)
	);
	
	/** LEDs **/
	//assign LEDs[12:0] = address_dmem;
	assign LEDs[0] = p1Controller[26];
	assign LEDs[4:3] = p1Controller[15:14];
	assign LEDs[2:1] = 2'b0;
	assign LEDs[17:5] = 13'b0;

endmodule
