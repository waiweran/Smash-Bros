`timescale 1 ns / 100 ps

module main_tb();

    // Control signals
    reg clock, reset;

    // Tracking the number of errors
    integer errors;

    // Instantiate
    skeleton skel(clock, reset);	
		 
	 // Instructions thru Processor
	 wire [31:0] insn_f, insn_d, insn_x, insn_m, insn_w;
	 assign insn_f = skel.my_processor.instruction_f;
	 assign insn_d = skel.my_processor.instruction_d;
	 assign insn_x = skel.my_processor.instruction_e;
	 assign insn_m = skel.my_processor.instruction_m;
	 assign insn_w = skel.my_processor.instruction_w;
	 
	 // Register Values
	 wire [31:0] regValA, regValB, regValWrite;
	 wire [4:0] regA, regB, regWrite;
	 assign regValA = skel.data_readRegA;
	 assign regValB = skel.data_readRegB;
	 assign regValWrite = skel.data_writeReg;
	 assign regA = skel.ctrl_readRegA;
	 assign regB = skel.ctrl_readRegB;
	 assign regWrite = skel.ctrl_writeReg;
	 
	 
	 // PC Values
	 wire [31:0] pc_f, pc_d, pc_x, pc_m, pc_w;
	 assign pc_f = skel.my_processor.pc_f;
	 assign pc_d = skel.my_processor.pc_d;
	 assign pc_x = skel.my_processor.pc_e;
	 assign pc_m = skel.my_processor.pc_m;
	 assign pc_w = skel.my_processor.pc_w;

	 
	 // Stall Signals
	 wire stall, nobp_stall, bypass;
	 wire [1:0] by_aluinA, by_aluinB, by_regB;
	 assign stall = skel.my_processor.stall;
	 assign nobp_stall = skel.my_processor.stall_logic.nobp_stall;
	 assign bypass = skel.my_processor.stall_logic.bypass;
	 assign by_aluinA = skel.my_processor.bypass_aluinA;
	 assign by_aluinB = skel.my_processor.bypass_aluinB;
	 assign by_regB = skel.my_processor.bypass_readRegB;

	 
    initial

    begin
        $display($time, " << Starting the Simulation >>");
        clock = 1'b0;    // at time 0
		  errors = 0;
		  reset = 1'b1;
		  @(negedge clock);
		  reset = 1'b0;

        // Run Tests
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);

        if(errors == 0) begin
            $display("The simulation completed without errors");
        end
        else begin
            $display("The simulation failed with %d errors", errors);
        end

        $stop;
    end

    // Clock generator
    always
         #10     clock = ~clock;


endmodule
