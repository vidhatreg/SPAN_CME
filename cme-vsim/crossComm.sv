module crossComm (
	input 	logic 			clk,
	input 	logic 			reset,
	input 	logic [15:0] 	outrightRate [0:1],
	input 	logic [7:0] 	ratio[0:1],
	input 	logic [7:0] 	interRate,
	output 	logic [15:0] 	crossCommCharge
);


/**********************************************************************************************************/
/***********************************************	Declarations	*****************************************/
/**********************************************************************************************************/

	reg [15:0] outrightMargin;				//An intermediate variable for calculation
	reg [31:0] crossCommCharge100;		//Final Cross Commodity charge in multiple of 100

/**********************************************************************************************************/
/************************************************	BODY	**************************************************/
/**********************************************************************************************************/	
	
	always_ff@(posedge clk) begin

		if(~reset)  begin
			outrightMargin 		= 0;
			crossCommCharge100 	= 0;
			crossCommCharge 		= 0;
			
		end else begin
		
			outrightMargin 		= (outrightRate[0] * ratio[0]) + (outrightRate[1] * ratio[1]);		//The Outright Marging as per the ratios between 2 commodities
			crossCommCharge100 	= interRate * outrightMargin;													//Inter rate selects the percentage of Outright Margin that will influence CrossCommCharge
			crossCommCharge 		= (crossCommCharge100 / 100 );												//Dividing by 100 to get the final Cross Commodity Charge
			
		end
					
	 end
 
 endmodule
	







 
 
