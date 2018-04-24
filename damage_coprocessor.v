module damage_coprocessor(
    // Inputs
    clock, reset,
    attack,

    // Outputs
    damage
);
    input clock, reset;
    input [31:0] attack;
    output [31:0] damage;

    reg [31:0] damage;
    always@(posedge clock) begin
      if(reset) begin
        damage <= 32'b0;
      end
		// up smash
		else if(attack[0] & attack[1]) begin
		  damage <= 32'd18;
		end
		// down smash
		else if(attack[0] & attack[2]) begin
		  damage <= 32'd13;
		end
		// side smash
		else if(attack[0] & (attack[3] | attack[4])) begin
		  damage <= 32'd15;
		end
      // a
      else if(attack[0] & attack[5]) begin
        damage <= 32'd3;
      end
      // up b
      else if(attack[0] & attack[6]) begin
        damage <= 32'd12;
      end
      // down b
      else if(attack[0] & attack[7]) begin
        damage <= 32'd8;
      end
      // side b
      else if(attack[0] & (attack[8] | attack[9])) begin
        damage <= 32'd11;
      end
      // b
      else if(attack[0] & attack[10]) begin
        damage <= 32'd5;
      end
      else begin
        damage <= 32'b0;
      end
    end
endmodule