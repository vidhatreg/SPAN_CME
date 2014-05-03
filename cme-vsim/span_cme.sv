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
integer i;
wire spreadDone;

scanRisk scanRisk0(.reset(startScanRisk), .*);

crossComm crossComm0(.reset(startCross), .*);

interMonthSpread interMonthSpread0(.reset(startInterMonth), .done(spreadDone), .*);	


always_ff @ (posedge clk) begin
	if (reset) begin
		   startScanRisk <= 0;
			startInterMonth <= 0;
			priceScanRange <= 0;
			startCross <= 0;
			interRate <= 0;
			for (i = 0; i < 8; i = i + 1) begin
				position[i] <= 0;
				maturity[i] <= 0;
			end
			for (i = 0; i < 3; i = i + 1) begin
				tierMax[i] <= 0;
				outright[i] <= 0;
			end 
			for (i = 0; i < 6; i = i + 1) begin
				spreadCharge[i] <= 0;
			end
			for (i = 0; i < 2; i = i + 1) begin
				outrightRate[i] <= 0;
				ratio[i] <= 0;
			end
			
	end else if (chipselect && write) begin
			case (offset) 
				6'd0 	:  priceScanRange 			<= writeData[15:0];
				6'd1 	:	position[0] 				<= writeData[15:0];
				6'd2 	:	position[1] 				<= writeData[15:0];
				6'd3 	:	position[2] 				<= writeData[15:0];
				6'd4 	:	position[3] 				<= writeData[15:0];
				6'd5 	:	position[4] 				<= writeData[15:0];
				6'd6 	:	position[5] 				<= writeData[15:0];
				6'd7 	:	position[6] 				<= writeData[15:0];
				6'd8 	:	begin position[7] 		<= writeData[15:0];
								startScanRisk 			<= 1'd1; 				//Starting Scanning Risk calculation
							end
				6'd9 	:  outrightRate[0]			<= writeData[15:0];
			   6'd10 : 	outrightRate[1] 			<= writeData[15:0];
				6'd11 : 	ratio[0] 					<= writeData[7:0];
				6'd12 : 	ratio[1] 					<=  writeData[7:0];
				6'd13 : 	begin interRate 			<= writeData[7:0];
									startCross 			<= 1'd1;					//Starting Cross Commodity calculation
							end
				6'd14 :	maturity[0] 				<= writeData[7:0];
				6'd15 :	maturity[1] 				<= writeData[7:0];
				6'd16 :	maturity[2] 				<= writeData[7:0];
				6'd17 :	maturity[3] 				<= writeData[7:0];
				6'd18 :	maturity[4] 				<= writeData[7:0];
				6'd19 :	maturity[5] 				<= writeData[7:0];
				6'd20 :	maturity[6] 				<= writeData[7:0];
				6'd21 :	maturity[7] 				<= writeData[7:0];
				6'd22 :	tierMax[0] 					<= writeData[3:0];
				6'd23 :	tierMax[1] 					<= writeData[3:0];
				6'd24 :	tierMax[2] 					<= writeData[3:0];
				6'd25 :	spreadCharge[0] 			<= writeData[7:0];
				6'd26 :	begin	spreadCharge[1] 	<= writeData[7:0];
									startInterMonth 	<= 1'd1;					//Early Start to Intermonth Spread Charge
							end
				6'd27 :	spreadCharge[2] 			<= writeData[7:0];
				6'd28 :	spreadCharge[3] 			<= writeData[7:0];
				6'd29 :	spreadCharge[4] 			<= writeData[7:0];
				6'd30 :	spreadCharge[5] 			<= writeData[7:0];
				6'd31 :	outright[0] 				<= writeData[7:0];
				6'd32 :	outright[1] 				<= writeData[7:0];
				6'd33 :	outright[2] 				<= writeData[7:0];
				default: begin	startScanRisk 		<= 1'd0;
									startInterMonth 	<= 1'd0;
									startCross 			<= 1'd0;
							end	
			endcase		
	end else if (chipselect && read ) begin
		readData[15:0] <= initialMargin[15:0];
	end
end
						
						
always_comb begin

	initialMargin = (spreadDone) ? (scanningRisk + TSC + crossCommCharge) : 0;

end
endmodule


