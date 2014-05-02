module span_cme(
input logic clk, 
input logic 			reset, 
input logic [15:0] writeData,
input logic [5:0] offset,
input logic  write,
input 	 chipselect,

output	logic [15:0] readData,
input  logic read 
);

reg [15:0] initialMargin;
reg [3:0] tierMax[0:2];
reg [7:0] maturity [0:7];
reg [15:0] position [0:7];
reg [15:0] scanningRisk, priceScanRange;
reg [15:0] TSC;
reg [7:0] spreadCharge [0:5];
reg [7:0] outright [0:2];
reg [15:0] crossCommCharge;
reg [15:0] outrightRate[0:1];
reg [7:0] ratio[0:1];
reg [7:0] interRate;
logic startScanRisk, startInterMonth, startCross;

scanRisk scanRisk0(.reset(startScanRisk), .*);

crossComm crossComm0(.reset(startCross), .*);

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
			tierMax[0] <= 0;
			tierMax[1] <= 0;
			tierMax[2] <= 0;
			spreadCharge[0] <= 0;
			spreadCharge[1] <= 0;
			spreadCharge[2] <= 0;
			spreadCharge[3] <= 0;
			spreadCharge[4] <= 0;
			spreadCharge[5] <= 0;
			outright[0] <= 0;
			outright[1] <= 0;
			outright[2] <= 0;
			priceScanRange <= 0;
			outrightRate[0] <= 0;
			outrightRate[1] <= 0;
			ratio[0] <= 0;
			ratio[1] <= 0;
			interRate <= 0;
	end else if (chipselect && write) begin
			case (offset) 
				6'd0 :   priceScanRange <= writeData[15:0];
				6'd1 :	position[0] <= writeData[15:0];
				6'd2 :	position[1] <= writeData[15:0];
				6'd3 :	position[2] <= writeData[15:0];
				6'd4 :	position[3] <= writeData[15:0];
				6'd5 :	position[4] <= writeData[15:0];
				6'd6 :	position[5] <= writeData[15:0];
				6'd7 :	position[6] <= writeData[15:0];
				6'd8 :	begin position[7] <= writeData[15:0];
								startScanRisk <= 1; 
							end
				6'd9 :	maturity[0] <= writeData[7:0];
				6'd10 :	maturity[1] <= writeData[7:0];
				6'd11 :	maturity[2] <= writeData[7:0];
				6'd12 :	maturity[3] <= writeData[7:0];
				6'd13 :	maturity[4] <= writeData[7:0];
				6'd14 :	maturity[5] <= writeData[7:0];
				6'd15 :	maturity[6] <= writeData[7:0];
				6'd16 :	maturity[7] <= writeData[7:0];
				6'd17 :	tierMax[0] <= writeData[3:0];
				6'd18 :	tierMax[1] <= writeData[3:0];
				6'd19 :	tierMax[2] <= writeData[3:0];
				6'd20 :	spreadCharge[0] <= writeData[7:0];
				6'd21 :	spreadCharge[1] <= writeData[7:0];
				6'd22 :	spreadCharge[2] <= writeData[7:0];
				6'd23 :	spreadCharge[3] <= writeData[7:0];
				6'd24 :	spreadCharge[4] <= writeData[7:0];
				6'd25 :	spreadCharge[5] <= writeData[7:0];
				6'd26 :	outright[0] <= writeData[7:0];
				6'd27 :	outright[1] <= writeData[7:0];
				6'd28 :	begin outright[2] <= writeData[7:0];
								startInterMonth <= 1; 
							end
				6'd29 : outrightRate[0]	<= writeData[15:0];
			   6'd30 : outrightRate[1] <= writeData[15:0];
				6'd31 : ratio[0] <= writeData[7:0];
				6'd32 : ratio[1] <=  writeData[7:0];
				6'd33 : begin interRate <= writeData[7:0];
				              startCross <= 1;
						  end
				default: begin	startScanRisk <= 0;
									startInterMonth <= 0;
									startCross <= 0;
							end	
			endcase		
	end
	else if (chipselect && read ) begin
		readData[15:0] <= initialMargin[15:0];
	end
end
						
						
always_comb begin

	initialMargin = scanningRisk + TSC + crossCommCharge;

end
endmodule


