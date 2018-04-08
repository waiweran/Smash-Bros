module gameControllerManager(inLR, runL, walkL, still, walkR, runR);
    input[3:0] inLR;
    output runL, walkL, still, walkR, runR;
    
    assign runR = (inLR >= 13 & inLR <= 15);
    assign walkR = (inLR >= 9 & inLR <= 12);
    assign still = (inLR >= 7 & inLR <= 8);
    assign walkL = (inLR >= 3 & inLR <= 6);
    assign runL = (inLR >= 0 & inLR <= 2);

endmodule
