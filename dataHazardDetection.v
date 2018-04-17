module dataHazardDetection(instruction_FD, instruction_DX, instruction_XM, out);
	input[31:0] instruction_FD, instruction_DX, instruction_XM;
	output out;
	
	//DEBUGGING
	/*
	PROBE_1, PROBE_2, PROBE_3, PROBE_4, PROBE_raw_readPortB_FD, PROBE_raw_writePort_DX
	output PROBE_1, PROBE_2, PROBE_3, PROBE_4;
	output[5:0] PROBE_raw_readPortB_FD, PROBE_raw_writePort_DX;
	assign PROBE_1 = fd_readPortA_dx_writePort;
	assign PROBE_2 = fd_readPortB_dx_writePort;
	assign PROBE_3 = fd_readPortA_xm_writePort;
	assign PROBE_4 = fd_readPortB_xm_writePort;
	assign PROBE_raw_readPortB_FD = readPortB_FD;
	assign PROBE_raw_writePort_DX = writePort_DX;
	*/
	
	wire[5:0] readPortA_FD, readPortB_FD, writePort_FD,
				 readPortA_DX, readPortB_DX, writePort_DX,
				 readPortA_XM, readPortB_XM, writePort_XM;
	
	portExtractor extractor_FD(instruction_FD, readPortA_FD, readPortB_FD, writePort_FD);
	portExtractor extractor_DX(instruction_DX, readPortA_DX, readPortB_DX, writePort_DX);
	portExtractor extractor_XM(instruction_XM, readPortA_XM, readPortB_XM, writePort_XM);
	
	wire fd_readPortA_dx_writePort, fd_readPortB_dx_writePort, fd_readPortA_xm_writePort, fd_readPortB_xm_writePort;
	comparePorts cp1(readPortA_FD, writePort_DX, fd_readPortA_dx_writePort);
	comparePorts cp2(readPortB_FD, writePort_DX, fd_readPortB_dx_writePort);
	comparePorts cp3(readPortA_FD, writePort_XM, fd_readPortA_xm_writePort);
	comparePorts cp4(readPortB_FD, writePort_XM, fd_readPortB_xm_writePort);
	
	assign out = fd_readPortA_dx_writePort || fd_readPortB_dx_writePort || fd_readPortA_xm_writePort || fd_readPortB_xm_writePort;

endmodule 