module branch_table(pc_read, pc_write, branch_result, branch_address, reset, write, clock, 
		branch_prediction, branch_target, prediction_overwrite, target_overwrite);

	/* 
	 * To change branch table size: 
	 *   1. Change decoder size to desired branch table size
	 *   2. Change amount of PC read into decoder to match bit width in
	 *   3. Change limit on i in generate loop to match decoder size
	 */

	input[31:0] pc_read, pc_write, branch_address;
	input branch_result, reset, write, clock;
	output branch_prediction, prediction_overwrite;
	output[31:0] branch_target, target_overwrite;

	wire [31:0] depc_read, depc_write;
	decoder_32 read_select(.in(pc_read[6:2]), .out(depc_read));
	decoder_32 write_select(.in(pc_write[6:2]), .out(depc_write));

	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: counter_loop

			wire write_enable;
			and we_and(write_enable, depc_write[i], write);

			// Branch Predictor
			wire read_val;
			counter_2bit_sat ctr(.in(branch_result), .write(write_enable), 
				.reset(reset), .clock(clock), .out(read_val));
			assign branch_prediction = depc_read[i] ? read_val : 1'bz;
			assign prediction_overwrite = depc_write[i] ? read_val : 1'bz;

			// Target List
			wire [31:0] read_addr;
			register addr_lookup(.write(branch_address), .we(write_enable), 
				.clr(reset), .clk(clock), .read(read_addr));
			assign branch_target = depc_read[i] ? read_addr : 32'bz;
			assign target_overwrite = depc_write[i] ? read_addr : 32'bz;

		end
	endgenerate

endmodule