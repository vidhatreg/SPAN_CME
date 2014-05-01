module interMonthSpread(input logic clk,
input logic reset,
input logic [3:0] Tier_max[0:2], 
input logic [15:0] position [0:7], 
input logic [7:0] maturity [0:7], 
input logic [7:0] SpreadCharge [0:5], 
input logic [7:0] Outright [0:2],
output logic [15:0] TSC);

//reg j, l;
reg [15:0] /*Short[0:2], Long[0:2],*/ A[0:7], B[0:7], C[0:7], D[0:7], E[0:7], F[0:7];
reg [6:0] Short[0:2], Long[0:2];//, LongUpdated[0:2], ShortUpdated[0:2];
reg [15:0] magA, magC, magE;
logic tsc123Start, tsc1Done, tsc2Done, tsc3Done, tsc4Done, tsc5Done, tsc6Done;
reg [15:0] TSC1, TSC2, TSC3, TSC4, TSC5, TSC6;
reg [15:0] Out1, Out2, Out3;
integer i,j,k;
reg [15:0]Af, Bf, Cf, Df, Ef, Ff;
reg [6:0] TSC1Long, TSC1Short, TSC2Long, TSC2Short, TSC3Long, TSC3Short, TSC4Long, TSC4Short, TSC5Long, TSC5Short, TSC6Long, TSC6Short;
reg tsc123Done;

//wire [5:0] status = {(Bf != 0),(Af != 0),(Df != 0),(Cf != 0),(Ff != 0),(Ef != 0)};
//wire [5:0] statusFor123 = {(Long[0] != 0),(Short[0] != 0),(Long[1] != 0),(Short[1] != 0),(Long[2] != 0),(Short[2] != 0)};
reg [5:0] statusFor123;
wire positionsAccumulated = ((Af != 8'b0) || (Bf != 8'b0) || (Cf != 8'b0)|| (Df != 8'b0)|| (Ef != 8'b0)|| (Ff != 8'b0)) ? 1'b1 : 1'b0;
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
		for (j = 0; j < 8; j = j + 1) begin
			A[j] <= 0;
			B[j] <= 0;
			C[j] <= 0;
			D[j] <= 0;
			E[j] <= 0;
			F[j] <= 0; end
		for (k = 0; k < 3; k = k + 1) begin
			Short[k] <= 0;
			Long[k] <= 0; end
			magA <= 0;
			magC <= 0;
			magE <= 0;
			TSC1 <= 0;
			TSC2 <= 0;
			TSC3 <= 0;
			TSC4 <= 0;
			TSC5 <= 0;
			TSC6 <= 0;
			Out1 <= 0;
			Out2 <= 0;
			Out3 <= 0;
			Af <= 0;
			Bf <= 0;
			Cf <= 0;
			Df <= 0;
			Ef <= 0;
			Ff <= 0;
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
		end else begin
		
		for(i = 0; i < 8; i = i + 1) begin
			if((Tier_max[0] > maturity[i]) && (position[i][15] == 1)) begin
				A[i] <= position[i];
				B[i] <= 0;
				C[i] <= 0;
				D[i] <= 0;
				E[i] <= 0;
				F[i] <= 0;
			
			end else if((Tier_max[0] > maturity[i]) && (position[i][15] == 0)) begin
				B[i] <= position[i];
				A[i] <= 0;
				C[i] <= 0;
				D[i] <= 0;
				E[i] <= 0;
				F[i] <= 0;
			end else if((Tier_max[1] > maturity[i]) && (position[i][15] == 1)) begin
				C[i] <= position[i];
				B[i] <= 0;
				A[i] <= 0;
				D[i] <= 0;
				E[i] <= 0;
				F[i] <= 0;
			
			end else if((Tier_max[1] > maturity[i]) && (position[i][15] == 0)) begin
				D[i] <= position[i];
				B[i] <= 0;
				A[i] <= 0;
				C[i] <= 0;
				E[i] <= 0;
				F[i] <= 0;
				
			end else if((Tier_max[2] > maturity[i]) && (position[i][15] == 1)) begin
				E[i] <= position[i];
				B[i] <= 0;
				A[i] <= 0;
				D[i] <= 0;
				C[i] <= 0;
				F[i] <= 0;
			
			end else if((Tier_max[2] > maturity[i]) && (position[i][15] == 0)) begin
				F[i] <= position[i];
				B[i] <= 0;
				A[i] <= 0;
				D[i] <= 0;
				E[i] <= 0;
				C[i] <= 0;
			end
	end//for(i = 0; i < 8; i = i + 1)

	Af <= A[0] + A[1] + A[2] + A[3] + A[4] + A[5] + A[6] + A[7];
	Bf <= B[0] + B[1] + B[2] + B[3] + B[4] + B[5] + B[6] + B[7];
	Cf <= C[0] + C[1] + C[2] + C[3] + C[4] + C[5] + C[6] + C[7];
	Df <= D[0] + D[1] + D[2] + D[3] + D[4] + D[5] + D[6] + D[7];
	Ef <= E[0] + E[1] + E[2] + E[3] + E[4] + E[5] + E[6] + E[7];
	Ff <= F[0] + F[1] + F[2] + F[3] + F[4] + F[5] + F[6] + F[7]; 

	//positionsAccumulated <= ((Af != 8'b0) || (Bf != 8'b0) || (Cf != 8'b0)|| (Df != 8'b0)|| (Ef != 8'b0)|| (Ff != 8'b0)) ? 1'b1 : 1'b0;


	if (positionsAccumulated == 1) begin 
	
		Long[0] <= Bf[6:0];
		Long[1] <= Df[6:0];
		Long[2] <= Ff[6:0];
		magA = (~Af + 1'd1);
		magC = (~Cf + 1'd1);
		magE = (~Ef + 1'd1);
		Short[0] <= magA[6:0];
		Short[1] <= magC[6:0];
		Short[2] <= magE[6:0]; 

		tsc123Start <= 1'b1;
		
		statusFor123 <= {(Long[0] != 0),(Short[0] != 0),(Long[1] != 0),(Short[1] != 0),(Long[2] != 0),(Short[2] != 0)};
		//if (tsc123Start) begin
//TSC1 start		
		if (statusFor123[5:4] == 2'b11) begin
			tsc1Done <= 1'd1;
			if(Long[0] < Short[0]) begin
				TSC1 <= SpreadCharge[0] * Long[0];
				TSC1Short/*[0]*/ <= Short[0] - Long[0];
				TSC1Long/*[0]*/ <= 7'b0;
			end
			else begin
				TSC1 <= SpreadCharge[0] * Short[0];
				TSC1Long/*[0]*/ <= Long[0] - Short[0];
				TSC1Short/*[0]*/ <= 7'b0;
			end
		end else begin
			TSC1 <= 0;
			tsc1Done <= 1'd1; 
			TSC1Long <= Long[0]; 
			TSC1Short <= Short[0]; end
//TSC1 end

//TSC2 start		
		if (statusFor123[3:2] == 2'b11) begin
			tsc2Done <= 1'd1;
			if(Long[1] < Short[1]) begin
				TSC2 <= SpreadCharge[1] * Long[1];
				TSC2Short/*[1]*/ <= Short[1] - Long[1];
				TSC2Long/*[1]*/ <= 7'b0;
			end
			else begin
				TSC2 <= SpreadCharge[1] * Short[1];
				TSC2Long/*[1]*/ <= Long[1] - Short[1];
				TSC2Short/*[1]*/ <= 7'b0;
			end
		end else begin
			TSC2 <= 0;
			tsc2Done <= 1'd1; 
			TSC2Long <= Long[1]; 
			TSC2Short <= Short[1]; end
//TSC2 end		
		
//TSC3 start		
		if (statusFor123[1:0] == 2'b11) begin
			tsc3Done <= 1'd1;
			if(Long[2] < Short[2]) begin
				TSC3 <= SpreadCharge[2] * Long[2];
				TSC3Short/*[2]*/ <= Short[2] - Long[2];
				TSC3Long/*[2]*/ <= 7'b0;
			end
			else begin
				TSC3 <= SpreadCharge[2] * Short[2];			
				TSC3Long/*[2]*/ <= Long[2] - Short[2];
				TSC3Short/*[2]*/ <= 7'b0;
			end
		end else begin
			TSC3 <= 0;
			tsc3Done <= 1'd1;  
			TSC3Long <= Long[2]; 
			TSC3Short <= Short[2];end
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
//			LongUpdated[l] <= Long[l];
//			ShortUpdated[l] <= Short[l]; end
	
//	if (~tsc456Done) begin
//TSC4 Start	
//		if ((status[5] == 1) && (status[2] == 1)) begin

		statusForTSC4 <= ((TSC1Long != 0) && (TSC2Short != 0));
		
		if (statusForTSC4) begin
		if(TSC1Long/*[0]*/ <= TSC2Short/*[1]*/)/* && (Long[0] != 0))*/ begin
			 if (TSC1Long/*[0]*/ != 0) begin
				TSC4 <= SpreadCharge[3] * TSC1Long/*[0]*/;
				TSC4Short/*[1]*/ <= TSC2Short/*[1]*/ - TSC1Long/*[0]*/;
				TSC4Long/*[0]*/ <= 5'b0;
				Out1 <= Outright[0] - Outright[1];
			end else begin 
				TSC4 <= 0;
				Out1 <= 0;
				TSC4Short/*[1]*/ <= TSC2Short/*[1]*/;
				TSC4Long/*[0]*/ <= TSC1Long/*[0]*/;
			end
		end else if(TSC1Long/*[0]*/ > TSC2Short/*[1]*/) /*&& (Short[1] != 0))*/ begin
			 if (TSC2Short/*[1]*/ != 0) begin
				TSC4 <= SpreadCharge[3] * TSC2Short/*[1]*/;
				TSC4Long/*[0]*/ <= TSC1Long/*[0]*/ - TSC2Short/*[1]*/;
				TSC4Short/*[1]*/ <= 5'b0;
				Out1 <= Outright[0]- Outright[1];
			 end else begin 
				TSC4 <= 0;
				Out1 <= 0;
				TSC4Long/*[0]*/ <= TSC1Long/*[0]*/;
				TSC4Short/*[1]*/ <= TSC2Short/*[1]*/;
			end
		end
		tsc4Done <= 1'd1;
		end else begin//else ((status[5] == 1) && (status[2] == 1))
			TSC4 <= 0;
			Out1 <= 0;
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
			if(TSC4Long/*[0]*/ <= TSC3Short/*[2]*/) /*&& (Long[0] != 0))*/ begin
				if (TSC4Long/*[0]*/ != 0) begin
					TSC5 <= SpreadCharge[4] * TSC4Long/*[0]*/;
					TSC5Short/*[2]*/ <= TSC3Short/*[2]*/ - TSC4Long/*[0]*/;
					TSC5Long/*[0]*/ <= 5'b0;
					Out2 <= Outright[0] - Outright[2];
				end else begin 
					TSC5 <= 0;
					Out2 <= 0;
					TSC5Short/*[2]*/ <= TSC3Short/*[2]*/;
					TSC5Long/*[0]*/ <= TSC4Long/*[0]*/;
				end
			end else if(TSC4Long/*[0]*/ > TSC3Short/*[2]*/)/* && (Long[0] != 0))*/	begin
				if (TSC3Short/*[2]*/ != 0) begin
					TSC5 <= SpreadCharge[4] * TSC3Short/*[2]*/;
					TSC5Long/*[0]*/ <= TSC4Long/*[0]*/ - TSC3Short/*[2]*/;
					TSC5Short/*[2]*/ <= 5'b0;
					Out2 <= Outright[0] - Outright[2];
				 end else begin
					TSC5 <= 0;
					Out2 <= 0;
					TSC5Long/*[0]*/ <= TSC4Long/*[0]*/;
					TSC5Short/*[2]*/ <= TSC3Short/*[2]*/;
				end
			end
			tsc5Done <= 1'd1;
			end else begin//((status[5] == 1) && (status[0] == 1))
			TSC5 <= 0;
			Out2 <= 0;
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
			if(TSC2Long/*[1]*/ < TSC5Short/*[2]*/)/* && (Long[1] != 0))*/	begin
				if (TSC2Long/*[1]*/ != 0) begin
					TSC6 <= SpreadCharge[5] * TSC2Long/*[1]*/;
					TSC6Short/*[2]*/ <= TSC5Short/*[2]*/ - TSC2Long/*[1]*/;
					TSC6Long/*[1]*/ <= 5'b0;
					Out3 <= Outright[1] - Outright[2];
				 end else begin
					TSC6 <= 0;
					Out3 <= 0;
					TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
					TSC6Long/*[1]*/ <= TSC2Long/*[1]*/;
				end
			end else if(TSC2Long/*[1]*/ > TSC5Short/*[2]*/)/* && (Long[1] != 0))*/	begin
				 if (TSC5Short/*[2]*/ != 0) begin
					TSC6 <= SpreadCharge[5] * TSC5Short/*[2]*/;
					TSC6Long/*[1]*/ <= TSC2Long/*[1]*/ - TSC5Short/*[2]*/;
					TSC6Short/*[2]*/ <= 5'b0;
					Out3 <= Outright[1] - Outright[2];
				end else begin
					TSC6 <= 0;
					Out3 <= 0;
					TSC6Long/*[1]*/ <= TSC2Long/*[1]*/;
					TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
				end
					tsc6Done <= 1'd1;
			end else begin //((status[3] == 1) && (status[0] == 1))
				TSC6 <= 0;
				Out3 <= 0;
				TSC6Long/*[1]*/ <= TSC2Long/*[1]*/;
				TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
				tsc6Done <= 1'd1; end
				end
		end else  begin//(/*(tsc123Start == 1'b1) && */tsc123Done)
			TSC4 <= 0;
			TSC5 <= 0;
			TSC6 <= 0;
			Out1 <= 0;
			Out2 <= 0;
			Out3 <= 0;
			//end
//			end else begin
		
			//TSC6Long/*[1]*/ <= Long[1];
			//TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
		end
	end// else (tsc123Start == 1'b1)
	
	TSC <= TSC1 + TSC2 + TSC3 + TSC4 + TSC5 + TSC6 + Out1 + Out2 + Out3; 
	end//if (reset)
	end//always_ff
endmodule
