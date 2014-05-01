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
reg [6:0] Short[0:2], Long[0:2];
reg [15:0] magA, magC, magE;
logic tsc123Done;
reg [15:0] TSC1, TSC2, TSC3, TSC4, TSC5, TSC6;
reg [15:0] Out;
integer i,j,k;
reg [15:0]Af, Bf, Cf, Df, Ef, Ff;
//wire [5:0] status = {(Bf != 0),(Af != 0),(Df != 0),(Cf != 0),(Ff != 0),(Ef != 0)};
wire [5:0] status = {(Long[0] != 0),(Short[0] != 0),(Long[1] != 0),(Short[1] != 0),(Long[2] != 0),(Short[2] != 0)};
wire positionsAccumulated = ((Af != 8'b0) || (Bf != 8'b0) || (Cf != 8'b0)|| (Df != 8'b0)|| (Ef != 8'b0)|| (Ff != 8'b0)) ? 1'b1 : 1'b0;

reg [6:0] TSC4Long, TSC4Short, TSC5Long, TSC5Short, TSC6Long, TSC6Short;

always_ff@(posedge clk) begin
	if (~reset) begin 
	   TSC <= 0;
	   tsc123Done <= 0; 
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
		Out <= 0;
		Af <= 0;
		Bf <= 0;
		Cf <= 0;
		Df <= 0;
		Ef <= 0;
		Ff <= 0;		
		end
	else begin
//if(i < NumInput)
//begin
//if(NumInput < 10)
//begin
		for(i = 0; i < 8; i = i + 1) begin
			if((Tier_max[0] > maturity[i]) && (position[i][15] == 1)) begin
				A[i] <= position[i];
				B[i] <= 0;
			C[i] <= 0;
			D[i] <= 0;
			E[i] <= 0;
			F[i] <= 0;
			
		end
		else if((Tier_max[0] > maturity[i]) && (position[i][15] == 0))
		begin
			B[i] <= position[i];
			A[i] <= 0;
			C[i] <= 0;
			D[i] <= 0;
			E[i] <= 0;
			F[i] <= 0;
		end
		else if((Tier_max[1] > maturity[i]) && (position[i][15] == 1))
		begin
			C[i] <= position[i];
			B[i] <= 0;
			A[i] <= 0;
			D[i] <= 0;
			E[i] <= 0;
			F[i] <= 0;
		
		end
		else if((Tier_max[1] > maturity[i]) && (position[i][15] == 0))
		begin
			D[i] <= position[i];
			B[i] <= 0;
			A[i] <= 0;
			C[i] <= 0;
			E[i] <= 0;
			F[i] <= 0;
			
		end
		else if((Tier_max[2] > maturity[i]) && (position[i][15] == 1))
		begin
			E[i] <= position[i];
			B[i] <= 0;
			A[i] <= 0;
			D[i] <= 0;
			C[i] <= 0;
			F[i] <= 0;
		
		end
		else if((Tier_max[2] > maturity[i]) && (position[i][15] == 0))
		begin
			F[i] <= position[i];
			B[i] <= 0;
			A[i] <= 0;
			D[i] <= 0;
			E[i] <= 0;
			C[i] <= 0;
		
		end
		//l = (i==7) ? 1 : 0;
	end


	Af <= A[0] + A[1] + A[2] + A[3] + A[4] + A[5] + A[6] + A[7];
	Bf <= B[0] + B[1] + B[2] + B[3] + B[4] + B[5] + B[6] + B[7];
	Cf <= C[0] + C[1] + C[2] + C[3] + C[4] + C[5] + C[6] + C[7];
	Df <= D[0] + D[1] + D[2] + D[3] + D[4] + D[5] + D[6] + D[7];
	Ef <= E[0] + E[1] + E[2] + E[3] + E[4] + E[5] + E[6] + E[7];
	Ff <= F[0] + F[1] + F[2] + F[3] + F[4] + F[5] + F[6] + F[7]; 




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

		tsc123Done <= 1'b1;
		
		if (status[5:4] == 2'b11) begin
		if(Long[0] < Short[0])
		begin
			Short[0] <= Short[0] - Long[0];
			Long[0] <= 7'b0;
			TSC1 <= SpreadCharge[0] * Long[0];
		end
		else 
		begin
			Long[0] <= Long[0] - Short[0];
			Short[0] <= 7'b0;
			TSC1 <= SpreadCharge[0] * Short[0];
		end
		end else TSC1 <= 0;
		
		if (status[3:2] == 2'b11) begin
		if(Long[1] < Short[1])
		begin
			Short[1] <= Short[1] - Long[1];
			Long[1] <= 7'b0;
			TSC2 <= SpreadCharge[1] * Long[1];
		end
		else 
		begin
			Long[1] <= Long[1] - Short[1];
			Short[1] <= 7'b0;
			TSC2 <= SpreadCharge[1] * Short[1];
		end
		end else TSC2 <= 0;
		
		
		if (status[1:0] == 2'b11) begin
		if(Long[2] < Short[2])
		begin
			Short[2] <= Short[2] - Long[2];
			Long[2] <= 7'b0;
			TSC3 <= SpreadCharge[2] * Long[2];
		end
		else 
		begin
			Long[2] <= Long[2] - Short[2];
			Short[2] <= 7'b0;
			TSC3 <= SpreadCharge[2] * Short[2];
		end
		end else TSC3 <= 0;
	end
	else tsc123Done <= 1'b0;


	if(tsc123Done == 1'b1)
	begin
//TSC4 Start	
		if ((status[5] == 1) && (status[2] == 1)) begin
		if(Long[0] <= Short[1])// && (Long[0] != 0))
		begin
			 if (Long[0] != 0) begin
				TSC4 = SpreadCharge[3] * Long[0];
				TSC4Short/*[1]*/ <= Short[1] - Long[0];
				TSC4Long/*[0]*/ <= 5'b0;
				Out = Outright[0] - Outright[1];
			end 
			else begin 
				TSC4 = 0;
				Out = 0;
				TSC4Short/*[1]*/ <= Short[1];
				TSC4Long/*[0]*/ <= Long[0];
			end
		end
		else if(Long[0] > Short[1]) //&& (Short[1] != 0))
		begin
			 if (Short[1] != 0) begin
				TSC4 = SpreadCharge[3] * Short[1];
				TSC4Long/*[0]*/ <= Long[0] - Short[1];
				TSC4Short/*[1]*/ <= 5'b0;
				Out = Outright[0]- Outright[1];
			 end 
			 else begin 
				TSC4 = 0;
				Out = 0;
				TSC4Long/*[0]*/ <= Long[0];
				TSC4Short/*[1]*/ <= Short[1];
			end
		end
		end 
		else begin
			TSC4 = 0;
			Out = 0;
			TSC4Long/*[0]*/ <= Long[0];
			TSC4Short/*[1]*/ <= Short[1];
		end
//TSC4 end		
	
//TSC5 start	
		if ((status[5] == 1) && (status[0] == 1)) begin
		if(TSC4Long/*[0]*/ <= Short[2]) //&& (Long[0] != 0))
		begin
			 if (TSC4Long/*[0]*/ != 0) begin
				TSC5 = SpreadCharge[4] * TSC4Long/*[0]*/;
				TSC5Short/*[2]*/ <= Short[2] - TSC4Long/*[0]*/;
				TSC5Long/*[0]*/ <= 5'b0;
				Out = Out + Outright[0] - Outright[2];
			end 
			else begin 
				TSC5 = 0;
				Out = Out;
				TSC5Short/*[2]*/ <= Short[2];
				TSC5Long/*[0]*/ <= TSC4Long/*[0]*/;
			end
		end
		else if(TSC4Long/*[0]*/ > Short[2])// && (Long[0] != 0))
		begin
			 if (Short[2] != 0) begin
				TSC5 = SpreadCharge[4] * Short[2];
				TSC5Long/*[0]*/ <= TSC4Long/*[0]*/ - Short[2];
				TSC5Short/*[2]*/ <= 5'b0;
				Out = Out + Outright[0] - Outright[2];
			 end 
			 else begin
				TSC5 = 0;
				Out = Out;
				TSC5Long/*[0]*/ <= TSC4Long/*[0]*/;
				TSC5Short/*[2]*/ <= Short[2];
			end
		end
		end 
		else begin
			TSC5 = 0;
			Out = Out;
			TSC5Short/*[2]*/ <= Short[2];
			TSC5Long/*[0]*/ <= TSC4Long/*[0]*/;
		end
//TSC5 end		
		
//TSC6 start		
		if ((status[3] == 1) && (status[0] == 1)) begin
		if(Long[1] < TSC5Short/*[2]*/)// && (Long[1] != 0))
		begin
			 if (Long[1] != 0) begin
				TSC6 = SpreadCharge[5] * Long[1];
				TSC6Short/*[2]*/ <= TSC5Short/*[2]*/ - Long[1];
				TSC6Long/*[1]*/ <= 5'b0;
				Out = Out + Outright[1] - Outright[2];
			 end 
			 else begin
				TSC6 = 0;
				Out = Out;
				TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
				TSC6Long/*[1]*/ <= Long[1];
			end
		end
		else if(Long[1] > TSC5Short/*[2]*/)// && (Long[1] != 0))
		begin
			 if (TSC5Short/*[2]*/ != 0) begin
				TSC6 = SpreadCharge[5] * TSC5Short/*[2]*/;
				TSC6Long/*[1]*/ <= Long[1] - TSC5Short/*[2]*/;
				TSC6Short/*[2]*/ <= 5'b0;
				Out = Out + Outright[1] - Outright[2];
			end 
			else begin
				TSC6 = 0;
				Out = Out;
				TSC6Long/*[1]*/ <= Long[1];
				TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
			end
		end
		end 
		else  begin
			TSC6 = 0;
			Out = Out;
			TSC6Long/*[1]*/ <= Long[1];
			TSC6Short/*[2]*/ <= TSC5Short/*[2]*/;
		end
	end

	TSC = TSC1 + TSC2 + TSC3 + TSC4 + TSC5 + TSC6 + Out; 
	end
	end
endmodule
