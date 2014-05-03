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



reg [15:0] 	tier1Short[0:7],
				tier2Short[0:7],
				tier3Short[0:7], 
				tier1Long[0:7],
				tier2Long[0:7],
				tier3Long[0:7];
				
				
reg [6:0] 	short[0:2],
				long[0:2];
				
reg [15:0] 	magTier1ShortFinal,
				magTier2ShortFinal,
				magTier3ShortFinal;
				
reg [15:0] 	TSC1,
				TSC2,
				TSC3,
				TSC4,
				TSC5,
				TSC6;
				
reg [15:0] 	out1,
				out2,
				out3;
				
integer i;

reg [15:0]	tier1ShortFinal,
				tier2ShortFinal,
				tier3ShortFinal,
				tier1LongFinal,
				tier2LongFinal,
				tier3LongFinal;
				
reg 			tsc123Start,
				tsc4Start,
				tsc5Start,
				tsc6Start,
				tscDone,
				spreadTotalDone;
				
reg [6:0] 	TSC1Long,
				TSC2Long,
				TSC3Long,
				TSC4Long,
				TSC5Long,
				TSC6Long,
				TSC1Short,
				TSC2Short,
				TSC3Short,
				TSC4Short,
				TSC5Short,
				TSC6Short;
				
reg [6:0] 	inputTSC5Long,
				inputTSC6Short;
wire 			positionsAccumulated,
				spreadTableFormed,
				goSpread4,
				goSpread5,
				goSpread6,
				goSpread5From4,
				goSpread6From4,
				goSpread6From5;
				
assign 	positionsAccumulated = 	((tier1ShortFinal != 8'b0) || (tier1LongFinal != 8'b0) || (tier2ShortFinal != 8'b0) || 											(tier2LongFinal != 8'b0) || (tier3ShortFinal != 8'b0) || (tier3LongFinal != 8'b0)) 												? 1'b1 : 1'b0;

assign 	spreadTableFormed = ((long[0] != 0) || (short[0] != 0) || (long[1] != 0) || (short[1] != 0) || (long[2] != 0) || 										(short[2] != 0));

assign goSpread4 = ((TSC1Long != 0) && (TSC2Short != 0));
assign goSpread5 = ((TSC1Long != 0) && (TSC3Short != 0));
assign goSpread6 = ((TSC2Long != 0) && (TSC3Short != 0));
assign goSpread5From4 = ((TSC4Long != 0) && (TSC3Short != 0));
assign goSpread6From4 = ((TSC2Long != 0) && (TSC3Short != 0));
assign goSpread6From5 = ((TSC2Long != 0) && (TSC5Short != 0));
assign done = spreadTotalDone;


reg [3:0] state;
localparam 	IDLE			= 0,
				SORTPOS		= 1,
				ACCPOS		= 2,
				SPREAD123	= 3,
				WAIT123		= 4,
				SPREAD4		= 5,
				WAIT4			= 6,
				SPREAD5		= 7,
				WAIT5			= 8,
				SPREAD6		= 9,
				SPREADSDONE	= 10,
				DONE			= 11;

always_ff @(posedge clk) begin
	if (~reset) begin
						tsc123Start <= 1'd0;
						tsc4Start <= 1'd0;
						tsc5Start <= 1'd0;
						tsc6Start <= 1'd0;
						tscDone <= 1'd0;
						spreadTotalDone <= 1'd0;
						state <= IDLE;
	end else begin
		case (state)
//STATE 0
			IDLE:	begin
						tsc123Start <= 1'd0;
						tsc4Start <= 1'd0;
						tsc5Start <= 1'd0;
						tsc6Start <= 1'd0;
						tscDone <= 1'd0;
						spreadTotalDone <= 1'd0;
						state <= SORTPOS;
					end
//STATE 1			
			SORTPOS:	begin
							state <= ACCPOS;
						end
//STATE 2				
			ACCPOS:	begin
							if ((positionsAccumulated) && (spreadTableFormed)) begin
									state <= SPREAD123;
									tsc123Start <= 1'd1;
							end else state <= ACCPOS;
						end
//STATE 3				
			SPREAD123: state <= WAIT123;
//STATE 4	
			WAIT123:	begin
							if (goSpread4) begin
								state <= SPREAD4;
								tsc4Start <= 1'd1;
							end else if (~goSpread4 && goSpread5) begin
								state <= SPREAD5;
								tsc5Start <= 1'd1;
							end else if (~goSpread4 && ~goSpread5 && goSpread6) begin
								state <= SPREAD6;
								tsc6Start <= 1'd1;
							end else if (~goSpread4 && ~goSpread5 && ~goSpread6)begin
								state <= SPREADSDONE;
								tscDone <= 1'd1;
							end
						end
//STATE 5					
			SPREAD4: state <= WAIT4;
//STATE 6	
			WAIT4:	begin
							if (goSpread5From4)begin
								state <= SPREAD5;
								tsc5Start <= 1'd1;
							end else if (~goSpread5From4 && goSpread6From4) begin
								state <= SPREAD6;
								tsc6Start <= 1'd1;
							end else if (~goSpread5From4 && ~goSpread6From4) begin
								state <= SPREADSDONE;
								tscDone = 1'd1;
							end
						end
//STATE 7				
			SPREAD5: state <= WAIT5;
//STATE 8	
			WAIT5: begin
						if (goSpread6From5) begin
							state <= SPREAD6;
							tsc6Start <= 1'd1;
						end else begin
							state <= SPREADSDONE;
							tscDone = 1'd1;
						end
					end
//STATE 9				
			SPREAD6: begin
							state <= SPREADSDONE;
							tscDone = 1'd1;
						end
//STATE 10				
			SPREADSDONE:	begin
									state <= DONE;
									spreadTotalDone <= 1'd1;	
								end
//STATE 11						
			DONE:	begin
						state <= DONE;
					end
			default: state <= IDLE;
		endcase
	end
end

					
always_ff @(posedge clk) begin
	if (~reset) begin 
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
			
	end else begin
//Sorting Positions based upon Maturity	
			for(i = 0; i < 8; i = i + 1) begin
			
				tier1Short[i] 	<= ((tierMax[0] > maturity[i]) && (position[i][15] == 1)) ? position[i] : 0;
				tier1Long[i] 	<= ((tierMax[0] > maturity[i]) && (position[i][15] == 0)) ? position[i] : 0;
				tier2Short[i] 	<= ((tierMax[1] > maturity[i]) && (tierMax[0] <= maturity[i]) && (position[i][15] == 										1)) ? position[i] : 0;
				tier2Long[i] 	<= ((tierMax[1] > maturity[i]) && (tierMax[0] <= maturity[i]) && (position[i][15] == 										0)) ? position[i] : 0;
				tier3Short[i] 	<= ((tierMax[2] > maturity[i]) && (tierMax[1] <= maturity[i]) && (position[i][15] == 										1)) ? position[i] : 0;
				tier3Long[i] 	<= ((tierMax[2] > maturity[i]) && (tierMax[1] <= maturity[i]) && (position[i][15] == 										0)) ? position[i] : 0;
			
			end

						
//Accumulating all the Longs and Shorts in all Tiers

			tier1ShortFinal <= tier1Short[0] + tier1Short[1] + tier1Short[2] + tier1Short[3] + tier1Short[4] + tier1Short[5] + 										tier1Short[6] + tier1Short[7];
			tier1LongFinal <= tier1Long[0] + tier1Long[1] + tier1Long[2] + tier1Long[3] + tier1Long[4] + tier1Long[5] + 										tier1Long[6] + tier1Long[7];
			tier2ShortFinal <= tier2Short[0] + tier2Short[1] + tier2Short[2] + tier2Short[3] + tier2Short[4] + tier2Short[5] + 										tier2Short[6] + tier2Short[7];
			tier2LongFinal <= tier2Long[0] + tier2Long[1] + tier2Long[2] + tier2Long[3] + tier2Long[4] + tier2Long[5] + 										tier2Long[6] + tier2Long[7];
			tier3ShortFinal <= tier3Short[0] + tier3Short[1] + tier3Short[2] + tier3Short[3] + tier3Short[4] + tier3Short[5] + 										tier3Short[6] + tier3Short[7];
			tier3LongFinal <= tier3Long[0] + tier3Long[1] + tier3Long[2] + tier3Long[3] + tier3Long[4] + tier3Long[5] + 										tier3Long[6] + tier3Long[7];

		
//Forming Tier Spread Table
		if (positionsAccumulated) begin 
			long[0] <= tier1LongFinal[6:0];
			long[1] <= tier2LongFinal[6:0];
			long[2] <= tier3LongFinal[6:0];
			magTier1ShortFinal = (~tier1ShortFinal + 1'd1);
			magTier2ShortFinal = (~tier2ShortFinal + 1'd1);
			magTier3ShortFinal = (~tier3ShortFinal + 1'd1);
			short[0] <= magTier1ShortFinal[6:0];
			short[1] <= magTier2ShortFinal[6:0];
			short[2] <= magTier3ShortFinal[6:0]; 
		end

		if (tscDone) TSC <= TSC1 + TSC2 + TSC3 + TSC4 + TSC5 + TSC6 + out1 + out2 + out3; 

	end//if (reset)
end//always_ff
	


always_comb begin
//Checking if Spread charge 4 is skipped and passing appropriate value to instance "tier13SpreadCharge"
	inputTSC5Long = (goSpread4) ? TSC4Long : TSC1Long;
//Checking if Spread charge 5 is skipped and passing appropriate value to instance "tier23SpreadCharge"
	inputTSC6Short = ((goSpread5From4) ||(~goSpread4 && goSpread5)) ? TSC5Short : TSC3Short;
end



tierSpread 	tier11SpreadCharge(.clk(clk), .reset(tsc123Start), .long(long[0]), .short(short[0]),										.spreadCharge(spreadCharge[0]), .outrightChargeTier1(0), .outrightChargeTier2(0),										.newLong(TSC1Long), .newShort(TSC1Short), .spread(TSC1), .outright());

tierSpread 	tier22SpreadCharge(.clk(clk), .reset(tsc123Start), .long(long[1]), .short(short[1]),										.spreadCharge(spreadCharge[1]), .outrightChargeTier1(0), .outrightChargeTier2(0),										.newLong(TSC2Long), .newShort(TSC2Short), .spread(TSC2), .outright());

tierSpread 	tier33SpreadCharge(.clk(clk), .reset(tsc123Start), .long(long[2]), .short(short[2]),										.spreadCharge(spreadCharge[2]), .outrightChargeTier1(0), .outrightChargeTier2(0),										.newLong(TSC3Long), .newShort(TSC3Short), .spread(TSC3), .outright());

tierSpread 	tier12SpreadCharge(.clk(clk), .reset(tsc4Start), .long(TSC1Long), .short(TSC2Short),										.spreadCharge(spreadCharge[3]), .outrightChargeTier1(outright[0]),										.outrightChargeTier2(outright[1]), .newLong(TSC4Long), .newShort(TSC4Short),										 .spread(TSC4), .outright(out1));

tierSpread 	tier13SpreadCharge(.clk(clk), .reset(tsc5Start), .long(inputTSC5Long), .short(TSC3Short),
										.spreadCharge(spreadCharge[4]), .outrightChargeTier1(outright[0]),
										.outrightChargeTier2(outright[2]), .newLong(TSC5Long), .newShort(TSC5Short),
										.spread(TSC5), .outright(out2));

tierSpread 	tier23SpreadCharge(.clk(clk), .reset(tsc6Start), .long(TSC2Long), .short(inputTSC6Short),
										.spreadCharge(spreadCharge[5]), .outrightChargeTier1(outright[1]),
										.outrightChargeTier2(outright[2]), .newLong(TSC6Long), .newShort(TSC6Short),
										.spread(TSC6), .outright(out3));

endmodule