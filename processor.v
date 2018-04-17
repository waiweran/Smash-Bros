/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
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

    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	
	 //-----------MY CODE BEGINS HERE----------
	 
	 //------------Control------------
	 //Decode
	 wire rtrd_Select; //0 = rt, 1 = rd

	 //Execute
	 wire bImmedMux_Select; //0 = let B through, 1 = let signExtensionOutput through
	 wire[4:0] alu_Opcode;
	 wire bne;
	 wire blt;
	 wire j_or_jal;
	 wire jr;
	 
	 //Memory
	 wire dmem_WE;
	 
	 //Writeback
	 wire[1:0] writebackMux_Select; //0 = O, 1 = D
	 wire regfile_WE;
	 wire[1:0] writePortMux_Select;
	 
	 //Decode
	 /*
	 wire rtrd_Select_D; //0 = rt, 1 = rd
	 wire bImmedMux_Select_D; //0 = let B through, 1 = let signExtensionOutput through
	 wire[4:0] alu_Opcode_D;
	 wire dmem_WE_D;
	 wire writebackMux_Select_D; //0 = O, 1 = D
	 wire regfile_WE_D;
	 
	 //Execute
	 wire bImmedMux_Select_X; //0 = let B through, 1 = let signExtensionOutput through
	 wire[4:0] alu_Opcode_X;
	 wire dmem_WE_X;
	 wire writebackMux_Select_X; //0 = O, 1 = D
	 wire regfile_WE_X;
	 
	 //Memory
	 wire dmem_WE_M;
	 wire writebackMux_Select_M; //0 = O, 1 = D
	 wire regfile_WE_M;
	 
	 //Writeback
	 wire writebackMux_Select_W; //0 = O, 1 = D
	 wire regfile_WE_W;
	 */
	 
    //----------Fetch-----------
	 wire[31:0] pcRegIn, pcRegOut, irFetch_beforeMux, irFetch_afterMux;
	 
	 //PC Register 
	 wire pcReg_WE;
	 pcRegister pcReg(reset, clock, pcReg_WE, pcRegIn, pcRegOut); //Current clocking: Double edge
	 
	 //IMEM Connection
	 assign address_imem = pcRegOut[11:0];
	 
	 //PC Incrementer
	 wire[31:0] incrementedPC;
	 wire dummy0, dummy1, dummy2;
	 alu pcALU(pcRegOut, 32'b00000000000000000000000000000001, 5'b00000, 5'b00000, incrementedPC, dummy0, dummy1, dummy2);
	 
	 assign irFetch_beforeMux = q_imem;
	 
	 //nop mux (Control flow hazards)
	 wire controlFlowHazardDetected;
	 assign irFetch_afterMux = controlFlowHazardDetected ? 32'b00000000000000000000000000000000 : irFetch_beforeMux; 
	 
	 //----------FD Latch-----------
	 wire[31:0] pcDecode, irDecode_beforeMux, irDecode_afterMux;
	 wire latchFD_WE; 
	 latchFD myLatchFD(incrementedPC, pcDecode, irFetch_afterMux, irDecode_beforeMux, clock, reset, latchFD_WE); 
	 //controlDecode myControlDecode(irDecode_beforeMux, rtrd_Select_D, bImmedMux_Select_D, alu_Opcode_D, dmem_WE_D, writebackMux_Select_D, regfile_WE_D); //This is the "main" decode.
	 controlDecode myControlDecode(irDecode_beforeMux, rtrd_Select);   //Should this be _beforeMux or _afterMux?
	 
	 //---------Decode----------
	 
	 //Regfile, including rtrdMux
	 //assign ctrl_writeEnable = DONE IN WRITEBACK STAGE
	 //assign ctrl_writeReg = DONE IN WRITEBACK STAGE
	 assign ctrl_readRegA = irDecode_beforeMux[21:17];
	 assign ctrl_readRegB = rtrd_Select ? irDecode_beforeMux[26:22] : irDecode_beforeMux[16:12];
	 //assign data_writeReg = DONE IN WRITEBACK STAGE
	 
	 //nop mux (Data hazards and control flow hazards)
	 wire dataHazardDetected;
	 assign irDecode_afterMux = (dataHazardDetected || controlFlowHazardDetected) ? 32'b00000000000000000000000000000000 : irDecode_beforeMux; //this string of 0's is the nop
	
	 //---------DX Latch-----------
	 wire[31:0] pcExecute, targetExecute, irExecute_beforeMux, irExecute_afterMux, aExecute, bExecute;
	 //wire latchDX_reset; //See Data Hazard Section
	 latchDX myLatchDX(pcDecode, pcExecute, irDecode_afterMux, irExecute_beforeMux, data_readRegA, aExecute, data_readRegB, bExecute, clock, reset);
	 //controlExecute myControlExecute(PROBE_in, PROBE_out, clock, latchDX_reset, bImmedMux_Select_D, alu_Opcode_D, dmem_WE_D, writebackMux_Select_D, regfile_WE_D, bImmedMux_Select_X, alu_Opcode_X, dmem_WE_X, writebackMux_Select_X, regfile_WE_X);
	 controlExecute myControlExecute(irExecute_beforeMux, bImmedMux_Select, alu_Opcode, bne, blt, j_or_jal, jr);
	 
	 //--------Execute----------
	 
	 //Sign Extender
	 wire[31:0] signExtenderOutput;
	 signExtender mySignExtender(irExecute_beforeMux[16:0], signExtenderOutput);
	 
	 //Immediate Mux
	 wire[31:0] bImmedMuxOutput;
	 assign bImmedMuxOutput = bImmedMux_Select ? signExtenderOutput : bExecute;
	 
	 //Main ALU
	 wire[31:0] mainALUOutput;
	 wire isNotEqual, isLessThan, aluOverflow;
	 alu mainALU(aExecute, bImmedMuxOutput, alu_Opcode, irExecute_beforeMux[11:7], mainALUOutput, isNotEqual, isLessThan, aluOverflow);
	 
	 //~~~Branching and Control Flow~~~
	 //shouldBranch (bne and blt)
	 wire shouldBranch;
	 assign shouldBranch = (bne && isNotEqual) || (blt && ((~isLessThan) && isNotEqual));
	 
	 //branchingNewPC (bne and blt)
	 wire dummyBranchingALU1, dummyBranchingALU2, dummyBranchingALU3;
	 wire[31:0] branchingNewPC;
	 alu branchingALU(pcExecute, signExtenderOutput, 5'b00000, 5'b00000, branchingNewPC, dummyBranchingALU1, dummyBranchingALU2, dummyBranchingALU3);
	 
	 //Jump Target Calculation
	 wire[11:0] shortTarget;
	 assign shortTarget = irExecute_beforeMux[11:0];
	 wire[31:0] target;
	 assign target[11:0] = shortTarget;
	 assign target[31:12] = 20'b0;
	 assign targetExecute = target;
	 
	 //PC Chooser
	 pcChooser myPCChooser(shouldBranch, j_or_jal, jr, branchingNewPC, target, bExecute, incrementedPC, pcRegIn);
	 
	 //nop mux (Just for multiplication) -- TODO
	 assign irExecute_afterMux = irExecute_beforeMux;
	 
	 //----------XM Latch-----------
	 wire[31:0] pcMemory, targetMemory, irMemory, oMemory, bMemory;
	 latchXM myLatchXM(pcExecute, pcMemory, targetExecute, targetMemory, irExecute_afterMux, irMemory, mainALUOutput, oMemory, bExecute, bMemory, clock, reset);
	 //controlMemory myControlMemory(clock, reset, dmem_WE_X, writebackMux_Select_X, regfile_WE_X, dmem_WE_M, writebackMux_Select_M, regfile_WE_M);
	 controlMemory myControlMemory(irMemory, dmem_WE);
	 
	 //---------Memory-----------
	 assign address_dmem = oMemory[11:0];
	 assign data = bMemory;
	 assign wren = dmem_WE;
	 
	 //----------MW Latch---------
	 wire[31:0] pcWriteback, targetWriteback, irWriteback, oWriteback, dWriteback;
	 latchMW myLatchMW(pcMemory, pcWriteback, targetMemory, targetWriteback, irMemory, irWriteback, oMemory, oWriteback, q_dmem, dWriteback, clock, reset);
	 //controlWriteback myControlWriteback(clock, reset, writebackMux_Select_M, regfile_WE_M, writePortMux_Select_M, writebackMux_Select, regfile_WE, writePortMux_Select);
	 controlWriteback myControlWriteback(irWriteback, writebackMux_Select, regfile_WE, writePortMux_Select);
	 
	 //-------Writeback----------
	 //Writeback Mux
	 wire[31:0] writebackMuxOutput;
	 //assign writebackMuxOutput = writebackMux_Select ? dWriteback : oWriteback;
	 mux4To1 writebackMux(oWriteback, dWriteback, pcWriteback, targetWriteback, writebackMux_Select, writebackMuxOutput);
	 
	 //Make connections to regfile (including Write Port Mux)
	 //assign ctrl_writeReg = irWriteback[26:22];
	 mux4To1Data5Bit writePortMux(irWriteback[26:22], 5'd30, 5'd31, 5'd31, writePortMux_Select, ctrl_writeReg);
	 assign data_writeReg = writebackMuxOutput;
	 assign ctrl_writeEnable = regfile_WE;
	 
	 //-------Hazard Detection------
	 //Data hazard detection
	 dataHazardDetection myHazardDetector(irDecode_beforeMux, irExecute_beforeMux, irMemory, dataHazardDetected);
	 
	 //Clear datapath control signals
	 //assign latchDX_reset = reset || dataHazardDetected;
	 
	 //Control Flow Hazard Detection
	 assign controlFlowHazardDetected = shouldBranch || j_or_jal || jr;
	 
	 //Disable FD latch and PC write enables
	 wire notDataHazardDetected;
	 assign notDataHazardDetected = ~dataHazardDetected;
	 //wire notControlFlowHazardDetected;
	 //assign notControlFlowHazardDetected = ~controlFlowHazardDetected;
	 
	 assign pcReg_WE = notDataHazardDetected;
	 assign latchFD_WE = notDataHazardDetected;
	 
endmodule