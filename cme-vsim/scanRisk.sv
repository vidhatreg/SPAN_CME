`define compareMag(x,y) ((x)>(y)) ? (x) : (y);			//DEFINE: Compares X and Y and returns the greater value
`define compareUnity(x,y,z) (x) ? (y) : (z);				//DEFINE: Checks if X is unity and returns Y if true, else returns Z


module scanRisk(	
	input 	logic 			clk,
	input 	logic 			reset,
	input 	logic [15:0]	priceScanRange,
	input 	logic [15:0]	position [0:7],
	output 	logic [15:0]	scanningRisk
);



/**********************************************************************************************************/
/***********************************************	Declarations	*****************************************/
/**********************************************************************************************************/

	logic [15:0]	netPos;																	//Sum of all the positions in the portfolio
	logic [23:0]	priceChange[0:7];														//Change in the price as per the underlying movement of the Price Scan Range for the 16 scenarios of Risk Array(only 8 scenarios are considered as volity change in not relavent for Futures)
	logic [31:0]	rowLoss[0:7];															//Loss for each of the 16(8) Risk Array scenarios
	logic [31:0]	level1[0:3];															//Array for selecting the greater value between 2 alternate Risk Array scenarios
	logic [31:0]	level2[0:1];															//Array for selecting the greater value between the chosen(level1) values of Risk Array scenarios
	logic [31:0]	level3;																	//The greatest the Risk Array scenario
	logic [7:0] 	underlyingPriceMovement[0:7];										//Risk Array underlying price movements
	logic [31:0]	scanningRiskTmp;														//Temporary scanning risk value to check if it negative or positive
	
//Loop index	
	integer i;
	
	
	
	
	parameter		UNDERLYING33  = 8'd42,												//33% of 128, Wieght 100%
						UNDERLYING67  = 8'd86,												//67% of 128, Wieght 100%
						UNDERLYING100 = 8'd128,												//100% of 128, Wieght 100%
						UNDERLYING300 = 8'd127;												//300% of 128, Wieght 33%

				
/**********************************************************************************************************/
/************************************************	BODY	**************************************************/
/**********************************************************************************************************/
				
	always_ff @ (posedge clk)  begin
	
		if(~reset) begin																		//Preparing for calculation, resetting everything
			scanningRisk = 16'd0;
			netPos = 16'd0;
			level3 = 32'd0;
			scanningRiskTmp = 16'd0;
			for (i = 0; i < 8; i = i + 1) begin
				priceChange[i] = 24'd0;
				rowLoss[i] = 32'd0;
			end
			for (i = 0; i < 4; i = i + 1) begin
				level1[i] = 32'd0;
			end
			for (i = 0; i < 2; i = i + 1) begin
				level2[i] = 32'd0;
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
		end else begin																			//Start Scanning Risk calculation
																									//Accumulating all the positions		
			netPos = (((position[0]+ position[1])+ (position[2]+ position[3]))+ ((position[4]+ position[5])+ (position[6]+ position[7])));
			
			
			for (i = 0; i < 8; i = i + 1) begin											//Underlying price movement of price scan range
				priceChange[i] = underlyingPriceMovement[i] * priceScanRange;
			end
						
			
			for (i = 0; i < 4; i = i + 1) begin											//Row loss multiplied with price change, multiple of 128
				rowLoss[(2*i)] = priceChange[(2*i)] * netPos;						
				rowLoss[((2*i) + 1)] = ~rowLoss[(2*i)] + 1'd1;
			end
				
			
			if (netPos == 0)
			
				scanningRisk = 16'd0;														//If net position is 0 then no need to perform any comparison/multiplication
				
			else begin
			
							
				for (i = 0; i < 4; i = i + 1) begin										//Level 1 comparison between rows with same value but opposite signs, comparing sign bit with 1
				
					level1[i] = `compareUnity(rowLoss[((2*i) + 1)][31],rowLoss[(2*i)],rowLoss[((2*i) + 1)]);
					
				end
				
			end
				
																									//Level 2 comparison between (33% and 67%) and (100% and 300%) underlying price movements
			level2[0] 	= `compareMag(level1[0],level1[1]);
			level2[1] 	= `compareMag(level1[2],level1[3]);
			
			
			level3 		= `compareMag(level2[0],level2[1]);								//Level 3 comparison between the winner of top 2
			
				
			scanningRiskTmp = level3 >> 7;												//Dividing by 128 for the final answer
			
			
			scanningRisk = `compareUnity(scanningRiskTmp[24],16'd0,scanningRiskTmp[15:0]);	//If scanning risk is negetive then scanning risk in 0
			
		end
		
	end
		
endmodule