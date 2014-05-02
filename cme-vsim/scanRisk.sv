module scanRisk(	input logic 			clk,
						input logic 			reset,
						input logic [15:0]	priceScanRange,
						input logic [15:0]		position [0:7],
						
						output logic [15:0]	scanningRisk
);


		logic [15:0]	netPos;
		logic [23:0]	priceChange[0:7];
		logic [31:0]	rowLoss[0:7];
		logic [31:0]	level1[0:3];
		logic [31:0]	level2[0:1];
		logic [31:0]	level3;
		logic [31:0]	scanningRisk100;
		integer i,j,k;
		
		always_ff @ (posedge clk)  begin
		
		if(~reset) begin
		
			scanningRisk = 0;
			netPos = 0;
			for (i = 0; i < 8; i = i + 1) begin
			priceChange[i] = 0;
			rowLoss[i] = 0; end
			for (j = 0; j < 4; j = j + 1) begin
			level1[j] = 0; end
			for (k = 0; k < 2; k = k + 1) begin
			level2[k] = 0; end
			level3 = 0;
			scanningRisk100 = 0;
		end
		else begin
		
				netPos = (((position[0]+ position[1])+ (position[2]+ position[3]))+ ((position[4]+ position[5])+ (position[6]+ position[7])));				

				priceChange[0] =  8'd42 * priceScanRange;		//row 3

				priceChange[1] = -8'd42 * priceScanRange; 	//row 5

				priceChange[2] =  8'd86 * priceScanRange;		//row 7

				priceChange[3] = -8'd86 * priceScanRange;		//row 9

				priceChange[4] =  8'd128 * priceScanRange;	//row 11

				priceChange[5] = -8'd128 * priceScanRange;	//row 13

				priceChange[6] =  8'd127 * priceScanRange;		//row 15

				priceChange[7] = -8'd127 * priceScanRange;		//row 16

//				priceChange[0] =  8'd33 * priceScanRange;		//row 3
//
//				priceChange[1] = -8'd33 * priceScanRange; 	//row 5
//
//				priceChange[2] =  8'd67 * priceScanRange;		//row 7
//
//				priceChange[3] = -8'd67 * priceScanRange;		//row 9
//
//				priceChange[4] =  8'd100 * priceScanRange;	//row 11
//
//				priceChange[5] = -8'd100 * priceScanRange;	//row 13
//
//				priceChange[6] =  8'd99 * priceScanRange;		//row 15
//
//				priceChange[7] = -8'd99 * priceScanRange;		//row 16

				
				
				//Multiple of 128
		
				rowLoss[0] = priceChange[0] * netPos;		//row 3

				//rowLoss[1] = priceChange[1] * netPos;		//row 5
				rowLoss[1] = ~rowLoss[0] + 1'd1;

				rowLoss[2] = priceChange[2] * netPos;		//row 7

				//rowLoss[3] = priceChange[3] * netPos;		//row 9
				rowLoss[3] = ~rowLoss[2] + 1'd1;

				rowLoss[4] = priceChange[4] * netPos;		//row 11

				//rowLoss[5] = priceChange[5] * netPos;		//row 13
				rowLoss[5] = ~rowLoss[4] + 1'd1;

				rowLoss[6] = priceChange[6] * netPos;		//row 15
				
				//rowLoss[7] = priceChange[7] * netPos;		//row 16
				rowLoss[7] = ~rowLoss[6] + 1'd1;

				
			
			if (netPos == 0)
				scanningRisk = 0;
			else begin
				//level1[0] = (rowLoss[0] > rowLoss[1]) ? rowLoss[0] : rowLoss[1];
				level1[0] = (rowLoss[1][31]) ? rowLoss[0] : rowLoss[1];
				
				//level1[1] = (rowLoss[2] > rowLoss[3]) ? rowLoss[2] : rowLoss[3];
				level1[1] = (rowLoss[3][31]) ? rowLoss[2] : rowLoss[3];
				
				//level1[2] = (rowLoss[4] > rowLoss[5]) ? rowLoss[4] : rowLoss[5];
				level1[2] = (rowLoss[5][31]) ? rowLoss[4] : rowLoss[5];
				
				//level1[3] = (rowLoss[6] > rowLoss[7]) ? rowLoss[6] : rowLoss[7];
				level1[3] = (rowLoss[7][31]) ? rowLoss[6] : rowLoss[7];
			end
				

		
			level2[0] = (level1[0] > level1[1]) ? level1[0] : level1[1];
			
			level2[1] = (level1[2] > level1[3]) ? level1[2] : level1[3];
			

			
			//scanningRisk100 = (level2[0] > level2[1]) ? level2[0] : level2[1];
			level3 = (level2[0] > level2[1]) ? level2[0] : level2[1];
			
			scanningRisk100 = (level3[31]) ? 0 : level3;
			scanningRisk = scanningRisk100 >> 7;
			//scanningRisk = (scanningRisk100 / 100);
		end
		
	end
		
endmodule