module span_cme(
	input 	logic 			clk, 
	input 	logic 			reset, 
	input 	logic [15:0] 	writeData,
	input 	logic [5:0] 	offset,
	input		logic  			write,
	input 	logic				chipselect,
	input  	logic 			read, 
	output	logic [15:0] 	readData
);


/**********************************************************************************************************/
/***********************************************	Declarations	*****************************************/
/**********************************************************************************************************/


	reg [15:0] 	initialMargin;			//Final calculated value of Initial Margin
	reg [15:0] 	scanningRisk;			//First Component: The Scanning Risk
	reg [15:0] 	TSC;						//Second Component: Tier Spread Charge
	reg [15:0] 	crossCommCharge;		//Third Component: Cross Commodity Charge


//Portfolio inputs
//Maximum number of instruments is 8
//Maximum number of Tiers is 3
	reg [15:0]	priceScanRange;		//Price Scan Range
	reg [15:0] 	position [0:7];		//Array for positions of instrument
	reg [7:0] 	maturity [0:7];		//Array for maturity of instrument, in months
	reg [3:0] 	tierMax[0:2];			//Array for upper limit of tiers, in months
	reg [7:0] 	spreadCharge [0:5];	//Array for spread charge between tiers, in order of priority
	reg [7:0] 	outright [0:2];		//Array for outright rate for spreads between tiers, in order of priority
	reg [15:0] 	outrightRate[0:1];	//Array for Outright rate for Cross Commodity Charge
	reg [7:0] 	ratio[0:1];				//Array for Ratio between 2 commodities for Cross Commodity Charge
	reg [7:0] 	interRate;				//Rate for Cross Commodity Charge
	
	
//Start signals for the 3 components
	logic 		startScanRisk,			//Start Scanning Risk Calculation
					startInterMonth,		//Start Intermonth Spread Charge calculation
					startCross;				//Start Cross Commodity Calculation

//Tier Spread Calculation done, representing the end of all the 3 components.
	wire 			spreadDone;	
	
//Loop index
	integer i;

	
	
	/**********************************************************************************************************/
	/************************************************	BODY	**************************************************/
	/**********************************************************************************************************/

//Module for calculating the Scanning Risk
	scanRisk scanRisk0(.reset(startScanRisk), .*);

//Module for calculating Cross Commodity Charge	
	crossComm crossComm0(.reset(startCross), .*);

//Module for calculating Inter Month Spread Charge
	interMonthSpread interMonthSpread0(.reset(startInterMonth), .done(spreadDone), .*);	


	always_ff @ (posedge clk) begin
	
		if (reset) begin																//Preparing for calculation, resetting everything
				startScanRisk 		<= 1'd0;
				startInterMonth 	<= 1'd0;
				startCross 			<= 1'd0;
				
				priceScanRange 	<= 1'd0;
				interRate 			<= 1'd0;
				
				
				for (i = 0; i < 8; i = i + 1) begin
					position[i] <= 16'd0;
					maturity[i] <= 8'd0;
				end
				
				
				
				for (i = 0; i < 3; i = i + 1) begin
					tierMax[i] 	<= 4'd0;
					outright[i] <= 8'd0;
				end 
				
				
				
				for (i = 0; i < 6; i = i + 1) begin
					spreadCharge[i] <= 8'd0;
				end
				
				
				
				for (i = 0; i < 2; i = i + 1) begin
					outrightRate[i] 	<= 16'd0;
					ratio[i] 			<= 8'd0;
				end
				
				
		end else if (chipselect && write) begin								//Reading input data from C code
		
				case (offset) 
					6'd0 	:  priceScanRange 			<= writeData[15:0];	//Price scan range
					
					6'd1 	:	position[0] 				<= writeData[15:0];	//Positions of 1st instrument
					6'd2 	:	position[1] 				<= writeData[15:0];	//Positions of 2nd instrument
					6'd3 	:	position[2] 				<= writeData[15:0];	//Positions of 3rd instrument
					6'd4 	:	position[3] 				<= writeData[15:0];	//Positions of 4th instrument
					6'd5 	:	position[4] 				<= writeData[15:0];	//Positions of 5th instrument
					6'd6 	:	position[5] 				<= writeData[15:0];	//Positions of 6th instrument
					6'd7 	:	position[6] 				<= writeData[15:0];	//Positions of 7th instrument
					6'd8 	:	begin position[7] 		<= writeData[15:0];	//Positions of 8th instrument
					
									startScanRisk 			<= 1'd1; 				//Starting Scanning Risk calculation
								
								end
					6'd9 	:  outrightRate[0]			<= writeData[15:0];	//Outright rate for 1st commodity
					6'd10 : 	outrightRate[1] 			<= writeData[15:0];	//Outright rate for 2nd commodity
					
					6'd11 : 	ratio[0] 					<= writeData[7:0];	//Cross commodity ratio for 1st commodity
					6'd12 : 	ratio[1] 					<= writeData[7:0];	//Cross commodity ratio for 2nd commodity
					6'd13 : 	begin interRate 			<= writeData[7:0];	//Cross commodity ratio
					
										startCross 			<= 1'd1;					//Starting Cross Commodity calculation
										
								end
					6'd14 :	maturity[0] 				<= writeData[7:0];	//Maturity for 1st instrument in months
					6'd15 :	maturity[1] 				<= writeData[7:0];	//Maturity for 2nd instrument in months
					6'd16 :	maturity[2] 				<= writeData[7:0];	//Maturity for 3rd instrument in months
					6'd17 :	maturity[3] 				<= writeData[7:0];	//Maturity for 4th instrument in months
					6'd18 :	maturity[4] 				<= writeData[7:0];	//Maturity for 5th instrument in months
					6'd19 :	maturity[5] 				<= writeData[7:0];	//Maturity for 6th instrument in months
					6'd20 :	maturity[6] 				<= writeData[7:0];	//Maturity for 7th instrument in months
					6'd21 :	maturity[7] 				<= writeData[7:0];	//Maturity for 8th instrument in months
					
					6'd22 :	tierMax[0] 					<= writeData[3:0];	//Upper value of a Tier 1 in months
					6'd23 :	tierMax[1] 					<= writeData[3:0];	//Upper value of a Tier 2 in months
					6'd24 :	tierMax[2] 					<= writeData[3:0];	//Upper value of a Tier 3 in months
					
					6'd25 :	spreadCharge[0] 			<= writeData[7:0];	//Charge for spread between tier 1 Long and tier 1 Short
					6'd26 :	begin	spreadCharge[1] 	<= writeData[7:0];	//Charge for spread between tier 2 Long and tier 2 Short
					
										startInterMonth 	<= 1'd1;					//Early Start to Intermonth Spread Charge
										
								end
					6'd27 :	spreadCharge[2] 			<= writeData[7:0];	//Charge for spread between tier 3 Long and tier 3 Short
					6'd28 :	spreadCharge[3] 			<= writeData[7:0];	//Charge for spread between tier 1 Long and tier 2 Short
					6'd29 :	spreadCharge[4] 			<= writeData[7:0];	//Charge for spread between tier 1 Long and tier 3 Short
					6'd30 :	spreadCharge[5] 			<= writeData[7:0];	//Charge for spread between tier 2 Long and tier 3 Short
					
					6'd31 :	outright[0] 				<= writeData[7:0];	//Outright rate for spread between tier 1 Long and tier 2 Short
					6'd32 :	outright[1] 				<= writeData[7:0];	//Outright rate for spread between tier 1 Long and tier 3 Short
					6'd33 :	outright[2] 				<= writeData[7:0];	//Outright rate for spread between tier 2 Long and tier 3 Short
					
					default: begin	startScanRisk 		<= 1'd0;
										startInterMonth 	<= 1'd0;
										startCross 			<= 1'd0;
								end	
				endcase
				
		end else if (chipselect && read ) begin								//Passing the calculated margin to Readdata output
			
			readData[15:0] <= initialMargin[15:0];
																							//Preparing for next calculation, resetting everything
			startScanRisk 		<= 1'd0;
			startInterMonth 	<= 1'd0;
			startCross 			<= 1'd0;
			
			priceScanRange 	<= 1'd0;
			interRate 			<= 1'd0;
			
			
			for (i = 0; i < 8; i = i + 1) begin
				position[i] <= 16'd0;
				maturity[i] <= 8'd0;
			end
			
			
			
			for (i = 0; i < 3; i = i + 1) begin
				tierMax[i] 	<= 4'd0;
				outright[i] <= 8'd0;
			end
			
			
			
			for (i = 0; i < 6; i = i + 1) begin
				spreadCharge[i] <= 8'd0;
			end
			
			
			
			for (i = 0; i < 2; i = i + 1) begin
				outrightRate[i] 	<= 16'd0;
				ratio[i] 			<= 8'd0;
			end
			
		end
		
	end
							
							
	always_comb begin
		
		initialMargin = (spreadDone) ? (scanningRisk + TSC + crossCommCharge) : 16'd0;		//Final total of all the 3 components

	end
	
endmodule


