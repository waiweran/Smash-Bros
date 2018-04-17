module pcChooser(sel1, sel2, sel3, d1, d2, d3, dDefault, out);
	input sel1, sel2, sel3;
	input[31:0] d1, d2, d3, dDefault;
	output[31:0] out;
	wire[31:0] outputWire;
	
	assign outputWire = sel1 ? d1 : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign outputWire = sel2 ? d2 : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign outputWire = sel3 ? d3 : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign outputWire = ~(sel1 || sel2 || sel3) ? dDefault : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	
	assign out = outputWire;
	
endmodule
