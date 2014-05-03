//`define sortPosition(a=0,b=0,c=0,d=0,e=0,f=0)	tier1Short[i] 	<= a;\
//																tier1Long[i] 	<= b;\
//																tier2Short[i] 	<= c;\
//																tier2Long[i] 	<= d;\
//																tier3Short[i] 	<= e;\
//																tier3Long[i] 	<= f;

//`define accumulate(index,direction) /*tier``index``direction``Final <= */tier``index``direction``[0] + tier``index``direction``[1] + tier``index``direction``[2] + tier``index``direction``[3] + tier``index``direction``[4] + tier``index``direction``[5] + tier``index``direction``[6] + tier``index``direction``[7];
//`ifndef accumulate
//`define accumulate(index) (tier``index``Short[0])// + (tier``index``Short[1]) + (tier``index``Short[2]) + (tier``index``Short[3]) + (tier``index``Short[4]) + (tier``index``Short[5]) + (tier``index``Short[6]) + (tier``index``Short[7]);
//`endif

//`define TSCLong(i) \
//	reg [6:0] TSC``i``Long;\
///*`define TSCShort(i)*/reg [6:0]TSC``i``Short;

module interMonthSpread(input logic clk,
input logic reset,
input logic [3:0] tierMax[0:2], 
input logic [15:0] position [0:7], 
input logic [7:0] maturity [0:7], 
input logic [7:0] spreadCharge [0:5], 
input logic [7:0] outright [0:2],
output logic [15:0] TSC);

//reg j, l;
reg [15:0] /*short[0:2], long[0:2],*/ tier1Short[0:7], tier1Long[0:7], tier2Short[0:7], tier2Long[0:7], tier3Short[0:7], tier3Long[0:7];
reg [6:0] short[0:2], long[0:2];//, LongUpdated[0:2], ShortUpdated[0:2];
reg [15:0] magTier1ShortFinal, magTier2ShortFinal, magTier3ShortFinal;
logic tsc123Start, tsc1Done, tsc2Done, tsc3Done, tsc4Done, tsc5Done, tsc6Done;
reg [15:0] TSC1, TSC2, TSC3, TSC4, TSC5, TSC6;
reg [15:0] out1, out2, out3;
integer i,l;
reg [15:0]tier1ShortFinal, tier1LongFinal, tier2ShortFinal, tier2LongFinal, tier3ShortFinal, tier3LongFinal;
////for(i = 1; i < 7; i = i + 1) begin
//	`TSCLong(i);
//	reg [6:0] `TSCShort(i);
//end
reg [6:0] TSC1Long, TSC1Short, TSC2Long, TSC2Short, TSC3Long, TSC3Short, TSC4Long, TSC4Short, TSC5Long, TSC5Short, TSC6Long, TSC6Short;
reg tsc123Done;

//wire [5:0] status = {(tier1LongFinal != 0),(tier1ShortFinal != 0),(tier2LongFinal != 0),(tier2ShortFinal != 0),(tier3LongFinal != 0),(tier3ShortFinal != 0)};
//wire [5:0] statusFor123 = {(long[0] != 0),(short[0] != 0),(long[1] != 0),(short[1] != 0),(long[2] != 0),(short[2] != 0)};
reg [5:0] statusFor123;
wire positionsAccumulated = ((tier1ShortFinal != 8'b0) || (tier1LongFinal != 8'b0) || (tier2ShortFinal != 8'b0)|| (tier2LongFinal != 8'b0)|| (tier3ShortFinal != 8'b0)|| (tier3LongFinal != 8'b0)) ? 1'b1 : 1'b0;
//reg positionsAccumulated;
//wire tsc123Done = (tsc1Done || tsc2Done || tsc3Done);
wire tsc456Done = (tsc4Done && tsc5Done && tsc6Done);
//wire statusForTSC4 = ((TSC1Long != 0) && (TSC2Short != 0));
//wire statusForTSC5 = ((TSC4Long != 0) && (TSC3Short != 0));
//wire statusForTSC6 = ((TSC2Long != 0) && (TSC5Short != 0));
reg statusForTSC4;// = ((TSC1Long != 0) && (TSC2Short != 0));
reg statusForTSC5;// = ((TSC4Long != 0) && (TSC3Short != 0));
reg statusForTSC6;// = ((TSC2Long != 0) && (TSC5Short != 0));


always_ff@(posedge clk) begin
	if (~reset) begin 
	   TSC <= 0;
	   tsc123Start <= 0;
		magTier1ShortFinal <= 0;
		magTier2ShortFinal <= 0;
			magTier3ShortFinal <= 0;
			TSC1 <= 0;
			TSC2 <= 0;
			TSC3 <= 0;
			TSC4 <= 0;
			TSC5 <= 0;
			TSC6 <= 0;
			out1 <= 0;
			out2 <= 0;
			out3 <= 0;
			tier1ShortFinal <= 0;
			tier1LongFinal <= 0;
			tier2ShortFinal <= 0;
			tier2LongFinal <= 0;
			tier3ShortFinal <= 0;
			tier3LongFinal <= 0;
			tsc1Done <= 1'd0;
			tsc2Done <= 1'd0;
			tsc3Done <= 1'd0;
			tsc4Done <= 1'd0;
			tsc5Done <= 1'd0;
			tsc6Done <= 1'd0;
			tsc123Done <= 1'd0;
			TSC1Long <= 0;
			TSC2Long <= 0;
			TSC3Long <= 0;
			TSC1Short <= 0;
			TSC2Short <= 0;
			TSC3Short <= 0;
			TSC4Long <= 0;
			TSC5Long <= 0;
			TSC6Long <= 0;
			TSC4Short <= 0;
			TSC5Short <= 0;
			TSC6Short <= 0;
			statusForTSC4 <= 1'd0;
			statusForTSC5 <= 1'd0;
			statusForTSC6 <= 1'd0;
			statusFor123 <= 1'd0; 
		for (i = 0; i < 8; i = i + 1) begin
			tier1Short[i]	<= 0;
			tier1Long[i] 	<= 0;
			tier2Short[i] 	<= 0;
			tier2Long[i] 	<= 0;
			tier3Short[i] 	<= 0;
			tier3Long[i] 	<= 0; end
		for (i = 0; i < 3; i = i + 1) begin
			short[i] <= 0;
			long[i] 	<= 0; end
		end else begin
//`define sort(index,short1=0,long1=0,short2=0,long2=0,short3=0,long3=0)\
//				for (i = 0tier``index``Short[index] <= short1;\
//				tier``index``Long[index] <= long1;\
		for(i = 0; i < 8; i = i + 1) begin
			
			tier1Short[i] 	<= ((tierMax[0] > maturity[i]) && (position[i][15] == 1)) ? position[i] : 0;
			tier1Long[i] 	<= ((tierMax[0] > maturity[i]) && (position[i][15] == 0)) ? position[i] : 0;
			tier2Short[i] 	<= ((tierMax[1] > maturity[i]) && (tierMax[0] <= maturity[i]) && (position[i][15] == 									1)) ? position[i] : 0;
			tier2Long[i] 	<= ((tierMax[1] > maturity[i]) && (tierMax[0] <= maturity[i]) && (position[i][15] == 									0)) ? position[i] : 0;
			tier3Short[i] 	<= ((tierMax[2] > maturity[i]) && (tierMax[1] <= maturity[i]) && (position[i][15] == 									1)) ? position[i] : 0;
			tier3Long[i] 	<= ((tierMax[2] > maturity[i]) && (tierMax[1] <= maturity[i]) && (position[i][15] == 									0)) ? position[i] : 0;
			
		end
		
//`define accumulate(index,direction) \
//						tier``index``direction``Final <= tier``index``direction``[0] + tier``index``direction``[1] + tier``index``direction``[2] + tier``index``direction``[3] + tier``index``direction``[4] + tier``index``direction``[5] + tier``index``direction``[6] + tier``index``direction``[7];
						
						
//		for (l = 0; l < 8; l = l + 1) begin
	tier1ShortFinal <= tier1Short[0] + tier1Short[1] + tier1Short[2] + tier1Short[3] + tier1Short[4] + tier1Short[5] + tier1Short[6] + tier1Short[7];
//	 tier1ShortFinal <= `accumulate(1) + tier1Short[1] + tier1Short[2] + tier1Short[3] + tier1Short[4] + tier1Short[5] + tier1Short[6] + tier1Short[7];
	tier1LongFinal <= tier1Long[0] + tier1Long[1] + tier1Long[2] + tier1Long[3] + tier1Long[4] + tier1Long[5] + tier1Long[6] + tier1Long[7];
	tier2ShortFinal <= tier2Short[0] + tier2Short[1] + tier2Short[2] + tier2Short[3] + tier2Short[4] + tier2Short[5] + tier2Short[6] + tier2Short[7];
	tier2LongFinal <= tier2Long[0] + tier2Long[1] + tier2Long[2] + tier2Long[3] + tier2Long[4] + tier2Long[5] + tier2Long[6] + tier2Long[7];
	tier3ShortFinal <= tier3Short[0] + tier3Short[1] + tier3Short[2] + tier3Short[3] + tier3Short[4] + tier3Short[5] + tier3Short[6] + tier3Short[7];
	tier3LongFinal <= tier3Long[0] + tier3Long[1] + tier3Long[2] + tier3Long[3] + tier3Long[4] + tier3Long[5] + tier3Long[6] + tier3Long[7];
		
//		tier1ShortFinal <= tier1ShortFinal + tier1Short[l];
//		tier1LongFinal <= tier1LongFinal + tier1Long[l];
//		tier2ShortFinal <= tier2ShortFinal + tier2Short[l];
//		tier2LongFinal <= tier2LongFinal + tier2Long[l];
//		tier3ShortFinal <= tier3ShortFinal + tier3Short[l];
//		tier3LongFinal <= tier3LongFinal + tier3Long[l];
//		
//		
//	end

	//positionsAccumulated <= ((tier1ShortFinal != 8'b0) || (tier1LongFinal != 8'b0) || (tier2ShortFinal != 8'b0)|| (tier2LongFinal != 8'b0)|| (tier3ShortFinal != 8'b0)|| (tier3LongFinal != 8'b0)) ? 1'b1 : 1'b0;


	if (positionsAccumulated == 1) begin 
	
		long[0] <= tier1LongFinal[6:0];
		long[1] <= tier2LongFinal[6:0];
		long[2] <= tier3LongFinal[6:0];
		magTier1ShortFinal = (~tier1ShortFinal + 1'd1);
		magTier2ShortFinal = (~tier2ShortFinal + 1'd1);
		magTier3ShortFinal = (~tier3ShortFinal + 1'd1);
		short[0] <= magTier1ShortFinal[6:0];
		short[1] <= magTier2ShortFinal[6:0];
		short[2] <= magTier3ShortFinal[6:0]; 

		tsc123Start <= 1'b1;
		
		statusFor123 <= {(long[0] != 0),(short[0] != 0),(long[1] != 0),(short[1] != 0),(long[2] != 0),(short[2] != 0)};
		//if (tsc123Start) begin
//TSC1 start		
		if (statusFor123[5:4] == 2'b11) begin
			tsc1Done <= 1'd1;
			if(long[0] < short[0]) begin
				TSC1 <= spreadCharge[0] * long[0];
				TSC1Short/*[0]*/ <= short[0] - long[0];
				TSC1Long/*[0]*/ <= 7'b0;
			end
			else begin
				TSC1 <= spreadCharge[0] * short[0];
				TSC1Long/*[0]*/ <= long[0] - short[0];
				TSC1Short/*[0]*/ <= 7'b0;
			end
		end else begin
			TSC1 <= 0;
			tsc1Done <= 1'd1; 
			TSC1Long <= long[0]; 
			TSC1Short <= short[0]; end
//TSC1 end

//TSC2 start		
		if (statusFor123[3:2] == 2'b11) begin
			tsc2Done <= 1'd1;
			if(long[1] < short[1]) begin
				TSC2 <= spreadCharge[1] * long[1];
				TSC2Short/*[1]*/ <= short[1] - long[1];
				TSC2Long/*[1]*/ <= 7'b0;
			end
			else begin
				TSC2 <= spreadCharge[1] * short[1];
				TSC2Long/*[1]*/ <= long[1] - short[1];
				TSC2Short/*[1]*/ <= 7'b0;
			end
		end else begin
			TSC2 <= 0;
			tsc2Done <= 1'd1; 
			TSC2Long <= long[1]; 
			TSC2Short <= short[1]; end
//TSC2 end		
		
//TSC3 start		
		if (statusFor123[1:0] == 2'b11) begin
			tsc3Done <= 1'd1;
			if(long[2] < short[2]) begin
				TSC3 <= spreadCharge[2] * long[2];
				TSC3Short/*[2]*/ <= short[2] - long[2];
				TSC3Long/*[2]*/ <= 7'b0;
			end
			else begin
				TSC3 <= spreadCharge[2] * short[2];			
				TSC3Long/*[2]*/ <= long[2] - short[2];
				TSC3Short/*[2]*/ <= 7'b0;
			end
		end else begin
			TSC3 <= 0;
			tsc3Done <= 1'd1;  
			TSC3Long <= long[2]; 
			TSC3Short <= short[2];end
		end else begin tsc123Start <= 1'b0;//else (positionsAccumulated == 1)
			tsc1Done <= 1'd0;
			tsc2Done <= 1'd0;
			tsc3Done <= 1'd0; end
//TSC3 end
	//tsc123Done <= (tsc1Done || tsc2Done || tsc3Done);
	//end
	tsc123Done <= (tsc1Done || tsc2Done || tsc3Done);
	
	if(/*(tsc123Start == 1'b1) && */tsc123Done && ~tsc456Done) begin
//		for (l = 0; l < 3; l = l + 1) begin
//			LongUpdated[l] <= long[l];
//			ShortUpdated[l] <= short[l]; end
	
//	if (~tsc456Done) begin
//TSC4 Start	
//		if ((status[5] == 1) && (status[2] == 1)) begin

		statusForTSC4 <= ((TSC1Long != 0) && (TSC2Short != 0));
		
		if (statusForTSC4) begin
		if(TSC1Long/*[0]*/ <= TSC2Short/*[1]*/)/* && (long[0] != 0))*/ begin
			 if (TSC1Long/*[0]*/ != 0) begin
				TSC4 <= spreadCharge[3] * TSC1Long/*[0]*/;
				TSC4Short/*[1]*/ <= TSC2Short/*[1]*/ - TSC1Long/*[0]*/;
				TSC4Long/*[0]*/ <= 5'b0;
				out1 <= outright[0] - outright[1];
			end else begin 
				TSC4 <= 0;
				out1 <= 0;
				TSC4Short/*[1]*/ <= TSC2Short/*[1]*/;
				TSC4Long/*[0]*/ <= TSC1Long/*[0]*/;
			end
		end else if(TSC1Long/*[0]*/ > TSC2Short/*[1]*/) /*&& (short[1] != 0))*/ begin
			 if (TSC2Short/*[1]*/ != 0) begin
				TSC4 <= spreadCharge[3] * TSC2Short/*[1]*/;
				TSC4Long/*[0]*/ <= TSC1Long/*[0]*/ - TSC2Short/*[1]*/;
				TSC4Short/*[1]*/ <= 5'b0;
				out1 <= outright[0]- outright[1];
			 end else begin 
				TSC4 <= 0;
				out1 <= 0;
				TSC4Long/*[0]*/ <= TSC1Long/*[0]*/;
				TSC4Short/*[1]*/ <= TSC2Short/*[1]*/;
			end
		end
		tsc4Done <= 1'd1;
		end else begin//else ((status[5] == 1) && (status[2] == 1))
			TSC4 <= 0;
			out1 <= 0;
			TSC4Long/*[0]*/ <= TSC1Long/*[0]*/;
			TSC4Short/*[1]*/ <= TSC2Short/*[1]*/;
			tsc4Done <= 1'd1;
		end
//TSC4 end		
	
//TSC5 start	
//		if ((status[5] == 1) && (status[0] == 1)) begin
		if (tsc4Done) begin
		statusForTSC5 <= ((TSC4Long != 0) && (TSC3Short != 0));
		if (statusForTSC5 /*&& tsc4Done*/) begin
		//if (tsc4Done) begin
			if(TSC4Long/*[0]*/ <= TSC3Short/*[2]*/) /*&& (long[0] != 0))*/ begin
				if (TSC4Long/*[0]*/ != 0) begin
					TSC5 <= spreadCharge[4] * TSC4Long/*[0]*/;
					TSC5Short/*[2]*/ <= TSC3Short/*[2]*/ - TSC4Long/*[0]*/;
					TSC5Long/*[0]*/ <= 5'b0;
					out2 <= outright[0] - outright[2];
				end else begin 
					TSC5 <= 0;
					out2 <= 0;
					TSC5Short/*[2]*/ <= TSC3Short/*[2]*/;
					TSC5Long/*[0]*/ <= TSC4Long/*[0]*/;
				end
			end else if(TSC4Long/*[0]*/ > TSC3Short/*[2]*/)/* && (long[0] != 0))*/	begin
				if (TSC3Short/*[2]*/ != 0) begin
					TSC5 <= spreadCharge[4] * TSC3Short/*[2]*/;
					TSC5Long/*[0]*/ <= TSC4Long/*[0]*/ - TSC3Short/*[2]*/;
					TSC5Short/*[2]*/ <= 5'b0;
					out2 <= outright[0] - outright[2];
				 end else begin
					TSC5 <= 0;
					out2 <= 0;
					TSC5Long/*[0]*/ <= TSC4Long/*[0]*/;
					TSC5Short/*[2]*/ <= TSC3Short/*[2]*/;
				end
			end
			tsc5Done <= 1'd1;
			end else begin//((status[5] == 1) && (status[0] == 1))
			TSC5 <= 0;
			out2 <= 0;
			TSC5Short/*[2]*/ <= TSC3Short/*[2]*/;
			TSC5Long/*[0]*/ <= TSC4Long/*[0]*/;
			tsc5Done <= 1'd1;
		end
		end
//TSC5 end		
		
//TSC6 start		
//		if ((status[3] == 1) && (status[0] == 1)) begin
		if (tsc5Done) begin
		statusForTSC6 <= ((TSC2Long != 0) && (TSC5Short != 0));
		if (statusForTSC6 /*&& tsc5Done*/) begin
			if(TSC2Long/*[1]*/ < TSC5Short/*[2]*/)/* && (long[1] != 0))*/	begin
				if (TSC2Long/*[1]*/ != 0) begin
					TSC6 <= spreadCharge[5] * TSC2Long/*[1]*/;
					TSC6Short/*[2]*/ <= TSC5Short/*[2]*/ - TSC2Long/*[1]*/;
					TSC6Long/*[1]*/ <= 5'b0;
					out3 <= outright[1] - outright[2];
				 end else begin
					TSC6 <= 0;
					out3 <= 0;
					TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
					TSC6Long/*[1]*/ <= TSC2Long/*[1]*/;
				end
			end else if(TSC2Long/*[1]*/ > TSC5Short/*[2]*/)/* && (long[1] != 0))*/	begin
				 if (TSC5Short/*[2]*/ != 0) begin
					TSC6 <= spreadCharge[5] * TSC5Short/*[2]*/;
					TSC6Long/*[1]*/ <= TSC2Long/*[1]*/ - TSC5Short/*[2]*/;
					TSC6Short/*[2]*/ <= 5'b0;
					out3 <= outright[1] - outright[2];
				end else begin
					TSC6 <= 0;
					out3 <= 0;
					TSC6Long/*[1]*/ <= TSC2Long/*[1]*/;
					TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
				end
					tsc6Done <= 1'd1;
			end else begin //((status[3] == 1) && (status[0] == 1))
				TSC6 <= 0;
				out3 <= 0;
				TSC6Long/*[1]*/ <= TSC2Long/*[1]*/;
				TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
				tsc6Done <= 1'd1; end
				end
		end else  begin//(/*(tsc123Start == 1'b1) && */tsc123Done)
			TSC4 <= 0;
			TSC5 <= 0;
			TSC6 <= 0;
			out1 <= 0;
			out2 <= 0;
			out3 <= 0;
			//end
//			end else begin
		
			//TSC6Long/*[1]*/ <= long[1];
			//TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
		end
	end// else (tsc123Start == 1'b1)
	
	TSC <= TSC1 + TSC2 + TSC3 + TSC4 + TSC5 + TSC6 + out1 + out2 + out3; 
	end//if (reset)
	end//always_ff
endmodule
