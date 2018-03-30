module branch_predictor(pc_read, pc_write, branch_result, branch_address, reset, write, clock, 
		branch_prediction, branch_target, mispredict);

	input[31:0] pc_read, pc_write, branch_address;
	input branch_result, reset, write, clock;
	output branch_prediction, mispredict;
	output[31:0] branch_target;

	// Global State
	wire [2:0] gs;
	wire global_in;
	and gs_and(global_in, branch_result, write);
	dff_c gs1_ff(.d(global_in), .clr(reset), .en(write), .clk(clock), .q(gs[0]));
	dff_c gs2_ff(.d(gs[0]), .clr(reset), .en(write), .clk(clock), .q(gs[1]));
	dff_c gs3_ff(.d(gs[1]), .clr(reset), .en(write), .clk(clock), .q(gs[2]));

	// Branch Tables
	wire [7:0] table_select;
	wire [31:0] pc_overwrite;
	wire predict_overwrite;
	decoder_8 gs_dcd(.in(gs), .out(table_select));
	genvar i;
	generate
		for(i = 0; i < 8; i = i + 1) begin: table_loop
			wire local_write, prediction, overwritten_predict;
			wire[31:0] predicted_target, overwritten_target;
			and write_and(local_write, table_select[i], write);
			branch_table bt(.pc_read(pc_read), .pc_write(pc_write), .write(local_write), 
				.branch_result(branch_result), .branch_address(branch_address), .reset(reset), 
				.clock(clock), .branch_prediction(prediction), .branch_target(predicted_target), 
				.prediction_overwrite(overwritten_predict), .target_overwrite(overwritten_target));
			assign predict_overwrite = table_select[i] ? overwritten_predict : 1'bz;
			assign branch_prediction = table_select[i] ? prediction : 1'bz;
			assign pc_overwrite = table_select[i] ? overwritten_target : 32'bz;
			assign branch_target = table_select[i] ? predicted_target : 32'bz;
		end
	endgenerate

	// Mispredict Logic
	wire same1, same2, same3, pred_correct, unz1, unz2, unz3, mispred_inter;
	comparator_5 comp1(.inA(pc_write[7:3]), .inB(pc_overwrite[7:3]), .same(same1), .snz(unz1));
	comparator_5 comp2(.inA(pc_write[11:7]), .inB(pc_overwrite[11:7]), .same(same2), .snz(unz2));
	comparator_5 comp3(.inA(pc_write[16:12]), .inB(pc_overwrite[16:12]), .same(same3), .snz(unz3));
	xnor pred_corr(pred_correct, predict_overwrite, branch_result);
	or mispred_or(mispred_inter, ~same1, ~same2, ~same3, ~pred_correct);
	and mispred_and(mispredict, mispred_inter, write);

endmodule
