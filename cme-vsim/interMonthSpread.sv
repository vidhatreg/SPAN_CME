module interMonthSpread(
	input 	logic 			clk,
	input 	logic 			reset,
	input 	logic [3:0] 	tierMax			[0:2], 
	input 	logic [15:0] 	position 		[0:7], 
	input 	logic [7:0] 	maturity 		[0:7], 
	input 	logic [7:0] 	spreadCharge 	[0:5], 
	input 	logic [7:0] 	outright 		[0:2],
	output 	logic [15:0] 	TSC,
	output 	logic 			done
);



/**********************************************************************************************************/
/***********************************************	Declarations	*****************************************/
/**********************************************************************************************************/

	reg [15:0] 	tier1Short[0:7],											//Array of Shorts sorted by Maturity
					tier2Short[0:7],
					tier3Short[0:7], 
					tier1Long[0:7],											//Array of Longs sorted my Maturity
					tier2Long[0:7],
					tier3Long[0:7];
				
				
	reg [6:0] 	short[0:2],													//Short's Tier spread table
					long[0:2];													//Long's Tier spread table
					
	reg [15:0] 	magTier1ShortFinal,										//Magnitude of Shorts in Tier Spread table
					magTier2ShortFinal,
					magTier3ShortFinal;
					

	reg [15:0]	tier1ShortFinal,											//Total Short values in a Tier
					tier2ShortFinal,
					tier3ShortFinal,
					tier1LongFinal,											//Total Long values in a Tier
					tier2LongFinal,
					tier3LongFinal;
																					//Signals triggering spread calculation
	reg 			tsc123Start,												//Triggering spread 1, 2 and 3 calculation
					tsc4Start,													//Triggering spread 4 calculation
					tsc5Start,													//Triggering spread 5 calculation
					tsc6Start,													//Triggering spread 6 calculation
					tscDone,														//All spreads calculated
					spreadTotalDone;											//All spreads added up
				
	reg [6:0] 	TSC1Long,													//Long results after Spread calculation
					TSC2Long,
					TSC3Long,
					TSC4Long,
					TSC5Long,
					TSC6Long,
					TSC1Short,													//Short result for Spread calculation
					TSC2Short,
					TSC3Short,
					TSC4Short,
					TSC5Short,
					TSC6Short;
					
	reg [6:0] 	inputTSC5Long,												//Long input for Spread 5
					inputTSC6Short;											//Short input for Spread 6
					
	reg [15:0] 	TSC1,															//Calculated Tier spreads 
					TSC2,
					TSC3,
					TSC4,			
					TSC5,
					TSC6;
					
	reg [15:0] 	out1,															//Outright charge of Spread 4
					out2,															//Outright charge of Spread 5
					out3;															//Outright charge of Spread 6
					
					
	wire 			positionsAccumulated,									//Signals informing the status about intermediate steps
					spreadTableFormed,
					
					goSpread4,													//Signals informing whether Spreads 4, 5 and 6 are possible or not
					goSpread5,
					goSpread6,
					goSpread5From4,
					goSpread6From4,
					goSpread6From5;
					
	reg [3:0] state;															//State variable
	
	localparam 	IDLE			= 0,											//Initial state
					SORTPOS		= 1,											//State for starting the sorting of Positions based on Maturity
					ACCPOS		= 2,											//State for adding all the positions in a Tier
					SPREAD123	= 3,											//State for calculating spreads 1, 2 and 3
					WAIT123		= 4,											//State for waiting for the values of spreads 1, 2 amd 3 to settle
					SPREAD4		= 5,											//State for calculating spread 4
					WAIT4			= 6,											//State for waiting for the values of spread 4 to settle
					SPREAD5		= 7,											//State for calculating spread 5
					WAIT5			= 8,											//State for waiting for the values of spread 5 to settle
					SPREAD6		= 9,											//State for calculating spread 6
					SPREADTOTAL	= 10,											//State for adding up all the spreads
					DONE			= 11;											//State representing that Inter Month Spread calculation is Done					

//Loop Index					
	integer i;					
						

/**********************************************************************************************************/
/************************************************	BODY	**************************************************/
/**********************************************************************************************************/

																					//Signal informing that positions have been sorted and accumulated
	assign 	positionsAccumulated = 	((tier1ShortFinal != 8'b0) || (tier1LongFinal != 8'b0) || (tier2ShortFinal != 8'b0) || (tier2LongFinal != 8'b0) || (tier3ShortFinal != 8'b0) || (tier3LongFinal != 8'b0)) ? 1'b1 : 1'b0;
																					//Signal informing that spread table has been formed
	assign 	spreadTableFormed 	= ((long[0] != 0) || (short[0] != 0) || (long[1] != 0) || (short[1] != 0) || (long[2] != 0) || (short[2] != 0));

	
	assign 	goSpread4 				= ((TSC1Long != 0) && (TSC2Short != 0));				//Spread 4 can be formed
	assign 	goSpread5 				= ((TSC1Long != 0) && (TSC3Short != 0));				//Spread 5 can be formed
	assign 	goSpread6 				= ((TSC2Long != 0) && (TSC3Short != 0));				//Spread 6 can be formed
	assign 	goSpread5From4 		= ((TSC4Long != 0) && (TSC3Short != 0));				//Spread 5 can be formed after spread 4
	assign 	goSpread6From4 		= ((TSC2Long != 0) && (TSC3Short != 0));				//Spread 6 can be formed after spread 4
	assign 	goSpread6From5 		= ((TSC2Long != 0) && (TSC5Short != 0));				//Spread 6 can be formed after spread 5
	
	assign 	done 						= spreadTotalDone;											//Spreads formed




	always_ff @(posedge clk) begin
	
		if (~reset) begin																					//Initializing FSM, resetting everything
							tsc123Start 					<= 1'd0;
							tsc4Start 						<= 1'd0;
							tsc5Start 						<= 1'd0;
							tsc6Start 						<= 1'd0;
							tscDone 							<= 1'd0;
							spreadTotalDone 				<= 1'd0;
							state 							<= IDLE;
		end else begin																						//FSM starts												
		
			case (state)
	
				IDLE:	begin																					//STATE 0				
							tsc123Start 					<= 1'd0;
							tsc4Start 						<= 1'd0;
							tsc5Start 						<= 1'd0;
							tsc6Start 						<= 1'd0;
							tscDone 							<= 1'd0;
							spreadTotalDone 				<= 1'd0;
							state 							<= SORTPOS;									//Always go to next state for sorting positions
						end
				
				SORTPOS:	begin																				//STATE 1
								state 						<= ACCPOS;									//Always go to next state for  accumulating all the positions
							end
					
				ACCPOS:	begin																				//STATE 2
				
								if ((positionsAccumulated) && (spreadTableFormed)) begin
										state 				<= SPREAD123;								//Start spread 1, 2 and 3 calculation after positions have been sorted and spread table is formed
										tsc123Start 		<= 1'd1;
										
								end else state 			<= ACCPOS;									//Else stay in the same state
								
							end
				
				SPREAD123: state 							<= WAIT123;									//STATE 3	
		
				WAIT123:	begin																				//STATE 4
				
								if (goSpread4) begin														//Start spread 4 calculation (the next spread in sequence)
									state 					<= SPREAD4;
									tsc4Start 				<= 1'd1;
									
								end else if (~goSpread4 && goSpread5) begin						//Jump to spread 5 calculation skipping spread 4
									state 					<= SPREAD5;
									tsc5Start 				<= 1'd1;
									
								end else if (~goSpread4 && ~goSpread5 && goSpread6) begin	//Jump to spread 6 calculation skipping spread 4 and 5
									state 					<= SPREAD6;
									tsc6Start 				<= 1'd1;
									
								end else if (~goSpread4 && ~goSpread5 && ~goSpread6)begin	//No more spreads can be formed, add up spread 1, 2 and 3
									state 					<= SPREADTOTAL;
									tscDone 					<= 1'd1;
									
								end
								
							end
						
				SPREAD4: state 							<= WAIT4;									//STATE 5
		
				WAIT4:	begin																				//STATE 6
				
								if (goSpread5From4)begin												//Start spread 5 calculation (the next spread in sequence)
									state 					<= SPREAD5;
									tsc5Start 				<= 1'd1;
									
								end else if (~goSpread5From4 && goSpread6From4) begin			//Jump to spread 6 calculation skipping spread 5
									state 					<= SPREAD6;
									tsc6Start 				<= 1'd1;
									
								end else if (~goSpread5From4 && ~goSpread6From4) begin		//No more spreads can be formed, add up spread 1, 2, 3 and 4
									state 					<= SPREADTOTAL;
									tscDone 					= 1'd1;
									
								end
								
							end
					
				SPREAD5: state 							<= WAIT5;									//STATE 7
		
				WAIT5: begin																				//STATE 8
				
							if (goSpread6From5) begin													//Start spread 6 calculation (the next spread in sequence)
								state 						<= SPREAD6;
								tsc6Start 					<= 1'd1;
								
							end else begin																	//No more spreads can be formed, add up spread 1, 2, 3, 4 and 5
								state 						<= SPREADTOTAL;
								tscDone 						= 1'd1;
								
							end
							
						end
					
				SPREAD6: begin																				//STATE 9
								state 						<= SPREADTOTAL;							//All the spreads calculated, proceed to add them
								tscDone 						= 1'd1;
							end
					
				SPREADTOTAL:	begin																		//STATE 10
										state 				<= DONE;
										spreadTotalDone 	<= 1'd1;										//All spreads added up
									end
							
				DONE:	begin																					//STATE 11
							state 							<= DONE;										//Final state the FSM terminates in
						end
						
				default: state 							<= IDLE;
				
			endcase
			
		end
		
	end

						
	always_ff @(posedge clk) begin
	
		if (~reset) begin 												//Preparing for calculation, resetting everything
		
			TSC <= 0;
			magTier1ShortFinal 	<= 0;
			magTier2ShortFinal 	<= 0;
			magTier3ShortFinal 	<= 0;
			tier1ShortFinal 		<= 0;
			tier1LongFinal 		<= 0;
			tier2ShortFinal 		<= 0;
			tier2LongFinal 		<= 0;
			tier3ShortFinal 		<= 0;
			tier3LongFinal 		<= 0;
			
			for (i = 0; i < 8; i = i + 1) begin
				tier1Short[i]		<= 0;
				tier1Long[i] 		<= 0;
				tier2Short[i] 		<= 0;
				tier2Long[i] 		<= 0;
				tier3Short[i] 		<= 0;
				tier3Long[i] 		<= 0; end
				
			for (i = 0; i < 3; i = i + 1) begin
				short[i] 			<= 0;
				long[i] 				<= 0; end
				
		end else begin															//Starting the calculation for Inter Month Spread
		
				for(i = 0; i < 8; i = i + 1) begin						//Sorting Positions based upon Maturity
				
					tier1Short[i] 	<= ((tierMax[0] > maturity[i]) && (position[i][15] == 1)) ? position[i] : 1'd0;
					tier1Long[i] 	<= ((tierMax[0] > maturity[i]) && (position[i][15] == 0)) ? position[i] : 1'd0;
					tier2Short[i] 	<= ((tierMax[1] > maturity[i]) && (tierMax[0] <= maturity[i]) && (position[i][15] == 1)) ? position[i] : 1'd0;
					tier2Long[i] 	<= ((tierMax[1] > maturity[i]) && (tierMax[0] <= maturity[i]) && (position[i][15] == 0)) ? position[i] : 1'd0;
					tier3Short[i] 	<= ((tierMax[2] > maturity[i]) && (tierMax[1] <= maturity[i]) && (position[i][15] == 1)) ? position[i] : 1'd0;
					tier3Long[i] 	<= ((tierMax[2] > maturity[i]) && (tierMax[1] <= maturity[i]) && (position[i][15] == 0)) ? position[i] : 1'd0;
				
				end

							
																					//Accumulating all the Longs and Shorts in all Tiers
				tier1ShortFinal 	<= tier1Short[0] + tier1Short[1] + tier1Short[2] + tier1Short[3] + tier1Short[4] + tier1Short[5] + tier1Short[6] + tier1Short[7];
				tier2ShortFinal 	<= tier2Short[0] + tier2Short[1] + tier2Short[2] + tier2Short[3] + tier2Short[4] + tier2Short[5] + tier2Short[6] + tier2Short[7];
				tier3ShortFinal 	<= tier3Short[0] + tier3Short[1] + tier3Short[2] + tier3Short[3] + tier3Short[4] + tier3Short[5] + tier3Short[6] + tier3Short[7];
				tier1LongFinal 	<= tier1Long[0] + tier1Long[1] + tier1Long[2] + tier1Long[3] + tier1Long[4] + tier1Long[5] + tier1Long[6] + tier1Long[7];
				tier2LongFinal 	<= tier2Long[0] + tier2Long[1] + tier2Long[2] + tier2Long[3] + tier2Long[4] + tier2Long[5] + tier2Long[6] + tier2Long[7];
				tier3LongFinal 	<= tier3Long[0] + tier3Long[1] + tier3Long[2] + tier3Long[3] + tier3Long[4] + tier3Long[5] + tier3Long[6] + tier3Long[7];

			
																					//Forming Tier Spread Table
			if (positionsAccumulated) begin 
				long[0] 					<= tier1LongFinal[6:0];
				long[1] 					<= tier2LongFinal[6:0];
				long[2] 					<= tier3LongFinal[6:0];
				magTier1ShortFinal 	= (~tier1ShortFinal + 1'd1);	//Taking the magnitude of Shorts	
				magTier2ShortFinal 	= (~tier2ShortFinal + 1'd1);
				magTier3ShortFinal 	= (~tier3ShortFinal + 1'd1);
				short[0] 				<= magTier1ShortFinal[6:0];
				short[1] 				<= magTier2ShortFinal[6:0];
				short[2] 				<= magTier3ShortFinal[6:0]; 
			end
																					//Adding up all the spreads for the final Tier Spread Charge
			if (tscDone) TSC 			<= TSC1 + TSC2 + TSC3 + TSC4 + TSC5 + TSC6 + out1 + out2 + out3; 

		end//if (reset)
		
	end//always_ff
	


	always_comb begin
	
		inputTSC5Long 	= (goSpread4) ? TSC4Long : TSC1Long;		//Checking if Spread charge 4 is skipped and passing appropriate value to instance "tier13SpreadCharge"
																					
		inputTSC6Short = ((goSpread5From4) ||(~goSpread4 && goSpread5)) ? TSC5Short : TSC3Short;	//Checking if Spread charge 5 is skipped and passing appropriate value to instance "tier23SpreadCharge"
	end


																					//Modules for Tier Spread Calculation
	tierSpread 	tier11SpreadCharge(.clk(clk), .reset(tsc123Start), .long(long[0]), .short(short[0]), .spreadCharge(spreadCharge[0]), .outrightChargeTier1(0), .outrightChargeTier2(0), .newLong(TSC1Long), .newShort(TSC1Short), .spread(TSC1), .outright());

	tierSpread 	tier22SpreadCharge(.clk(clk), .reset(tsc123Start), .long(long[1]), .short(short[1]), .spreadCharge(spreadCharge[1]), .outrightChargeTier1(0), .outrightChargeTier2(0), .newLong(TSC2Long), .newShort(TSC2Short), .spread(TSC2), .outright());

	tierSpread 	tier33SpreadCharge(.clk(clk), .reset(tsc123Start), .long(long[2]), .short(short[2]), .spreadCharge(spreadCharge[2]), .outrightChargeTier1(0), .outrightChargeTier2(0), .newLong(TSC3Long), .newShort(TSC3Short), .spread(TSC3), .outright());

	tierSpread 	tier12SpreadCharge(.clk(clk), .reset(tsc4Start), .long(TSC1Long), .short(TSC2Short), .spreadCharge(spreadCharge[3]), .outrightChargeTier1(outright[0]), .outrightChargeTier2(outright[1]), .newLong(TSC4Long), .newShort(TSC4Short), .spread(TSC4), .outright(out1));

	tierSpread 	tier13SpreadCharge(.clk(clk), .reset(tsc5Start), .long(inputTSC5Long), .short(TSC3Short), .spreadCharge(spreadCharge[4]), .outrightChargeTier1(outright[0]), .outrightChargeTier2(outright[2]), .newLong(TSC5Long), .newShort(TSC5Short), .spread(TSC5), .outright(out2));

	tierSpread 	tier23SpreadCharge(.clk(clk), .reset(tsc6Start), .long(TSC2Long), .short(inputTSC6Short), .spreadCharge(spreadCharge[5]), .outrightChargeTier1(outright[1]), .outrightChargeTier2(outright[2]), .newLong(TSC6Long), .newShort(TSC6Short), .spread(TSC6), .outright(out3));

endmodule