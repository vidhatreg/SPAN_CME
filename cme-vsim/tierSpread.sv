module tierSpread ( 	input logic clk,
							input logic reset, 
							input logic [6:0] long,
							input logic [6:0] short,
							input logic [7:0] spreadCharge,
							input logic [7:0] outrightChargeTier1,
							input logic [7:0] outrightChargeTier2,
							output logic [6:0] newLong,
							output logic [6:0] newShort,
							output logic [15:0] spread,
							output logic [15:0] outright);
							
			
	always_ff @(posedge clk) begin
		if (~reset)begin
			spread <= 0;
			outright <= 0;
			newLong <= 0;
			newShort <= 0;
		end else begin
			if (long <= short) begin
				if (long != 0) begin
					spread <= spreadCharge * long;
					newShort <= short - long;
					newLong <= 0;
					outright <= outrightChargeTier1 - outrightChargeTier2;
				end else begin
					spread <= 0;
					outright <= 0;
					newShort <= short;
					newLong <= long;
				end
			end else begin
				if (short != 0) begin
					spread <= spreadCharge * short;
					newLong <= long - short;
					newShort <= 0;
					outright <= outrightChargeTier1 - outrightChargeTier2;
				end else begin
					spread <= 0;
					outright <= 0;
					newShort <= short;
					newLong <= long;
				end
			end
		end
	end



endmodule