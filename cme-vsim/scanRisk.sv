`define compareMag(x,y) ((x)>(y)) ? (x) : (y);
`define compareUnity(x,y,z) (x) ? (y) : (z);


module scanRisk(	
input 	logic 			clk,
input 	logic 			reset,
input 	logic [15:0]	priceScanRange,
input 	logic [15:0]	position [0:7],
output 	logic [15:0]	scanningRisk
);


		logic [15:0]	netPos;
		logic [23:0]	priceChange[0:7];
		logic [31:0]	rowLoss[0:7];
		logic [31:0]	level1[0:3];
		logic [31:0]	level2[0:1];
		logic [31:0]	level3;
		logic [15:0]	scanningRiskTmp;
		integer i;
		logic [7:0] 	underlyingPriceMovement[0:7];
		
		parameter	UNDERLYING33  = 8'd42,	//33% of 128, Wieght 100%
						UNDERLYING67  = 8'd86,	//67% of 128, Wieght 100%
						UNDERLYING100 = 8'd128,	//100% of 128, Wieght 100%
						UNDERLYING300 = 8'd127;	//300% of 128, Wieght 33%
		
		always_ff @ (posedge clk)  begin
		
			if(~reset) begin
				scanningRisk = 0;
				netPos = 0;
				level3 = 0;
				scanningRiskTmp = 0;
				for (i = 0; i < 8; i = i + 1) begin
					priceChange[i] = 0;
					rowLoss[i] = 0;
				end
				for (i = 0; i < 4; i = i + 1) begin
					level1[i] = 0;
				end
				for (i = 0; i < 2; i = i + 1) begin
					level2[i] = 0;
				end
				for (i = 0; i < 8; i = i + 1) begin
					case (i)
						0 : underlyingPriceMovement[i] =  UNDERLYING33;
						1 : underlyingPriceMovement[i] = -UNDERLYING33;
						2 : underlyingPriceMovement[i] =  UNDERLYING67;
						3 : underlyingPriceMovement[i] = -UNDERLYING67;
						4 : underlyingPriceMovement[i] =  UNDERLYING100;
						5 : underlyingPriceMovement[i] = -UNDERLYING100;
						6 : underlyingPriceMovement[i] =  UNDERLYING300;
						7 : underlyingPriceMovement[i] = -UNDERLYING300;
					endcase
				end
			end else begin
					
					
				//Accumulating all the positions		
				netPos = (((position[0]+ position[1])+ (position[2]+ position[3]))+ ((position[4]+ position[5])+ (							position[6]+ position[7])));
				
				//Underlying price movement of price scan range
				for (i = 0; i < 8; i = i + 1) begin
					priceChange[i] = underlyingPriceMovement[i] * priceScanRange;
				end
					
				//Row loss multiplied with price change				
				//Multiple of 128
				for (i = 0; i < 4; i = i + 1) begin
					rowLoss[(2*i)] = priceChange[(2*i)] * netPos;
					rowLoss[((2*i) + 1)] = ~rowLoss[(2*i)] + 1'd1;
				end
					
				
				if (netPos == 0)
				
					scanningRisk = 0;//If net position is 0 then no need to perform any comparison/multiplication
					
				else begin
				
					//Level 1 comparison between rows with same value but opposite signs			
					for (i = 0; i < 4; i = i + 1) begin
						level1[i] = `compareUnity(rowLoss[((2*i) + 1)][31],rowLoss[(2*i)],rowLoss[((2*i) + 1)]);
					end
					
				end
					
				//Level 2 comparison between (33% and 67%) and (100% and 300%) underlying price movements
				level2[0] = `compareMag(level1[0],level1[1]);
				level2[1] = `compareMag(level1[2],level1[3]);
				
				//Level 3 comparison between the winner of top 2
				level3 = `compareMag(level2[0],level2[1]);
				
							
				//Dividing by 128 for the final answer
				scanningRiskTmp = level3 >> 7;
				
				//If scanning risk is negetive then scanning risk in 0
				scanningRisk = `compareUnity(scanningRiskTmp[15],0,scanningRiskTmp);
			end
		
	end
		
endmodule