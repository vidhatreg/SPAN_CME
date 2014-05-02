module crossComm (
input logic clk,
input logic reset,
input logic [15:0] outrightRate [0:1],
input logic [7:0] ratio[0:1],
input logic [7:0] interRate,
output logic [15:0] crossCommCharge);

reg [15:0] outrightMargin;
reg [31:0] crossCommCharge100;

always_ff@(posedge clk) begin

	if(~reset)  begin
		outrightMargin <= 0;
		crossCommCharge100 <= 0;
		crossCommCharge <= 0;
	end else begin
		outrightMargin <= (outrightRate[0] * ratio[0]) + (outrightRate[1] * ratio[1]);
		crossCommCharge100 <= interRate * outrightMargin;
		crossCommCharge <= (crossCommCharge100 / 100 );
	end
				
 end
 
 endmodule
	







 
 
