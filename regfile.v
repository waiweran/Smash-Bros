/*
A 32-bit wide regfile with 32 registers. The 0th register
is hardwired to an input of 0 and always reads 0.

Source for multidimensional arrays/buses: http://www.asic-world.com/systemverilog/data_types11.html
*/

module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB,
		  regtest1,
	     regtest2,
	     regtest4,
		  regtest5,
	     regtest6,
		  regtest7
 
);
	//TESTING
	//output[31:0] regtest0;
	output[31:0] regtest1;
	output[31:0] regtest2;
	//output[31:0] regtest3;
	output[31:0] regtest4;
	output[31:0] regtest5;
	output[31:0] regtest6;	
	output[31:0] regtest7;
	
	//assign regtest0 = dataOutputWires[0];
	assign regtest1 = dataOutputWires[1];
	assign regtest2 = dataOutputWires[2];
	//assign regtest3 = dataOutputWires[3];
	assign regtest4 = dataOutputWires[4];
	assign regtest5 = dataOutputWires[5];
	assign regtest6 = dataOutputWires[6];	
	assign regtest7 = dataOutputWires[7];
	
   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	
	//Make the registers and hardwire reg 0
	wire[31:0] dataOutputWires [0:31];
	wire[31:0] writeEnableWires;
	
	register reg0(ctrl_reset, clock, 1'b0, 32'b00000000000000000000000000000000, dataOutputWires[0]);
	
	genvar i;
	generate 
	for(i = 1; i < 32; i = i + 1) begin: regLoop
		register genericReg(ctrl_reset, clock, writeEnableWires[i], data_writeReg, dataOutputWires[i]); 
	end
	endgenerate
	
	//Make write port
	wire[31:0] decoderOutputWires;
	
	decoder5to32 addressDecoder(ctrl_writeReg, decoderOutputWires);
	
	genvar j;
	generate
	//Careful: Do not connect to reg0
	for(j = 1; j < 32; j = j + 1) begin: andGateLoop
		and andGate(writeEnableWires[j], ctrl_writeEnable, decoderOutputWires[j]);
	end
	endgenerate
	
	//Both read ports
	
	//Make read port a
	//Careful: Do connect to reg0
	wire[31:0] decoderOutReadPortA;
	decoder5to32 decoderReadPortA(ctrl_readRegA, decoderOutReadPortA);
	
	genvar regNumA;
	generate
	for(regNumA = 0; regNumA < 32; regNumA = regNumA + 1) begin: triStateALoop
		assign data_readRegA = decoderOutReadPortA[regNumA] ? dataOutputWires[regNumA] : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	end
	endgenerate
	
	//Make read port b
	//Careful: Do connect to reg0
	wire[31:0] decoderOutReadPortB;
	decoder5to32 decoderReadPortB(ctrl_readRegB, decoderOutReadPortB);
	
	genvar regNumB;
	generate
	for(regNumB = 0; regNumB < 32; regNumB = regNumB + 1) begin: triStateBLoop
		assign data_readRegB = decoderOutReadPortB[regNumB] ? dataOutputWires[regNumB] : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	end
	endgenerate
endmodule
