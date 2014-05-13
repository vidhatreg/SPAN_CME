module tierSpread ( 
	input 	logic 			clk,
	input 	logic 			reset, 
	input 	logic [6:0] 	long,
	input 	logic [6:0] 	short,
	input 	logic [7:0] 	spreadCharge,
	input 	logic [7:0] 	outrightChargeTier1,
	input 	logic [7:0] 	outrightChargeTier2,
	output 	logic [6:0] 	newLong,
	output 	logic [6:0] 	newShort,
	output 	logic [15:0] 	spread,
	output 	logic [15:0] 	outright
);
							

				
/**********************************************************************************************************/
/************************************************	BODY	**************************************************/
/**********************************************************************************************************/
				
	always_ff @(posedge clk) begin
	
		if (~reset)begin																	//Preparing for calculation, resetting everything
		
			spread 	<= 0;
			outright <= 0;
			newLong 	<= 0;
			newShort <= 0;
			
		end else begin																		//Start spread calculation
		
			if (long <= short) begin													//If Short positions are more than Long Positions,
			
				if (long != 0) begin														//Skip if there are no Long positions, i.e. no spreads
					
					spread 	<= spreadCharge * long;									//Number of spreads is equal to number of Long positions
					newShort <= short - long;											//Subtract Long from Short positions to calculate the remaining Short positions after spreads have been formed
					newLong 	<= 0;															//The remaining Long positions is zero
					outright <= outrightChargeTier1 - outrightChargeTier2;	//Calculating outright only when spreads exist
					
				end else begin																//When no spreads are formed, pass input Longs and Shorts directly to output
				
					spread 	<= 0;
					outright <= 0;
					newShort <= short;
					newLong 	<= long;
					
				end
				
			end else begin																	//If Long positions are more than Short positions
			
				if (short != 0) begin													//Skip if there are no Short positions
				
					spread 	<= spreadCharge * short;								//Number of spreads is equal to number of Short positions
					newLong 	<= long - short;											//Subtract Short from Long positions to calculate the remaining Long positions after spreads have been formed
					newShort <= 0;															//The remaining Short positions is zero
					outright <= outrightChargeTier1 - outrightChargeTier2;	//Calculating outright only when spreads exist
					
				end else begin																//When no spreads are formed, pass input Longs and Shorts directly to output
				
					spread 	<= 0;
					outright <= 0;
					newShort <= short;
					newLong 	<= long;
					
				end
				
			end
			
		end
		
	end
	
endmodule