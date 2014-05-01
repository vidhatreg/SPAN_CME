module span_cme(input logic clk, 
input logic 			reset, 
input logic [15:0] writeData,
input logic [4:0] offset,
input logic  write,
input logic	 chipselect,

output	logic [15:0] readData,
input  logic read 
);

logic [15:0] initialMargin;
logic [3:0] Tier_max[0:2];
logic [7:0] maturity [0:7];
logic [15:0] position [0:7];
logic [15:0] scanningRisk, Trash, PriceScanRange;
logic [15:0] TSC;
logic [7:0] SpreadCharge [0:5];
logic [7:0] Outright [0:2];

logic startScanRisk, startInterMonth;

scanRisk scanRisk0(.reset(startScanRisk), .*);

interMonthSpread interMonthSpread0(.reset(startInterMonth), .*);	


always_ff @ (posedge clk) begin
	if (reset) begin
		   startScanRisk <= 0;
			startInterMonth <= 0;
			position[0] <= 0;
			position[1] <= 0;
			position[2] <= 0;
			position[3] <= 0;
			position[4] <= 0;
			position[5] <= 0;
			position[6] <= 0;
			position[7] <= 0;
			maturity[0] <= 0;
			maturity[1] <= 0;
			maturity[2] <= 0;
			maturity[3] <= 0;
			maturity[4] <= 0;
			maturity[5] <= 0;
			maturity[6] <= 0;
			maturity[7] <= 0;
			Tier_max[0] <= 0;
			Tier_max[1] <= 0;
			Tier_max[2] <= 0;
			SpreadCharge[0] <= 0;
			SpreadCharge[1] <= 0;
			SpreadCharge[2] <= 0;
			SpreadCharge[3] <= 0;
			SpreadCharge[4] <= 0;
			Outright[0] <= 0;
			Outright[1] <= 0;
			Outright[2] <= 0;
			PriceScanRange <= 0;
			Trash <= 0;
	end
	else if (chipselect && write) begin
			case (offset) 
				5'd0 :  PriceScanRange <= writeData[15:0];
				5'd1 :	position[0] <= writeData[15:0];
				5'd2 :	position[1] <= writeData[15:0];
				5'd3 :	position[2] <= writeData[15:0];
				5'd4 :	position[3] <= writeData[15:0];
				5'd5 :	position[4] <= writeData[15:0];
				5'd6 :	position[5] <= writeData[15:0];
				5'd7 :	position[6] <= writeData[15:0];
				5'd8 :	begin position[7] <= writeData[15:0];
								startScanRisk <= 1; 
							end
				5'd9 :	maturity[0] <= writeData[7:0];
				5'd10 :	maturity[1] <= writeData[7:0];
				5'd11 :	maturity[2] <= writeData[7:0];
				5'd12 :	maturity[3] <= writeData[7:0];
				5'd13 :	maturity[4] <= writeData[7:0];
				5'd14 :	maturity[5] <= writeData[7:0];
				5'd15 :	maturity[6] <= writeData[7:0];
				5'd16 :	maturity[7] <= writeData[7:0];
				5'd17 :	Tier_max[0] <= writeData[3:0];
				5'd18 :	Tier_max[1] <= writeData[3:0];
				5'd19 :	Tier_max[2] <= writeData[3:0];
				5'd20 :	SpreadCharge[0] <= writeData[7:0];
				5'd21 :	SpreadCharge[1] <= writeData[7:0];
				5'd22 :	SpreadCharge[2] <= writeData[7:0];
				5'd23 :	SpreadCharge[3] <= writeData[7:0];
				5'd24 :	SpreadCharge[4] <= writeData[7:0];
				5'd25 :	SpreadCharge[5] <= writeData[7:0];
				5'd26 :	Outright[0] <= writeData[7:0];
				5'd27 :	Outright[1] <= writeData[7:0];
				5'd28 :	begin Outright[2] <= writeData[7:0];
								startInterMonth <= 1; 
							end
				default: begin	startScanRisk <= 0;
									startInterMonth <= 0;
									Trash <= writeData; 
							end	
			endcase		
	end
	else if (chipselect && read) begin
		readData[15:0] <= initialMargin[15:0];
	end
end
						
						
always_comb begin

	initialMargin = scanningRisk + TSC;

end
endmodule

