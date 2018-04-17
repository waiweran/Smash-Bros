module sra32(in, shamt, out);
	input[31:0] in;
	input[4:0] shamt;
	output[31:0] out;
	
	wire[31:0] shift16Out, mux16Out, shift8Out, mux8Out, shift4Out, mux4Out, shift2Out, mux2Out, shift1Out; //mux1Out is "out"
	
	sra16 shift16(in, shift16Out);
	assign mux16Out = shamt[4] ? shift16Out : in;
	sra8 shift8(mux16Out, shift8Out);
	assign mux8Out = shamt[3] ? shift8Out : mux16Out;
	sra4 shift4(mux8Out, shift4Out);
	assign mux4Out = shamt[2] ? shift4Out : mux8Out;
	sra2 shift2(mux4Out, shift2Out);
	assign mux2Out = shamt[1] ? shift2Out : mux4Out;
	sra1 shift1(mux2Out, shift1Out);
	assign out = shamt[0] ? shift1Out : mux2Out;
	
endmodule