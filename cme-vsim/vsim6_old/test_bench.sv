


module test_bench;
 logic clk;
 logic reset;
 logic [15:0] writeData;
 logic [4:0] offset;
 logic  write;
 logic  chipselect;
						
 logic [15:0] PriceScanRange;
 logic [15:0] readData;
 logic read;
integer i;

//span_cme span_cme1(.clk(1'b1), .reset(reset),.writeData(writeData), .offset(offset),
//.write(write),.chipselect(chipselect),.PriceScanRange(PriceScanRange), .readData(readData), .read(read));

span_cme span_cme1(.*);

initial begin
clk = 0;
	forever # 10 clk = ~ clk;
end




initial begin
clk = 0;
reset = 1;
write = 0;
chipselect = 0;
@(posedge clk) ;
reset =0 ;
write = 1;
chipselect = 1;
@(posedge clk);
writeData = 16'd96;
offset = 5'd0;
@(posedge clk);
offset = 5'd1;
writeData = 32'd10;
@(posedge clk);
offset = 5'd2;
writeData = 32'd15;
@(posedge clk);
offset = 5'd3;
writeData = 32'b11111111111111111111111111111011;
@(posedge clk);
offset = 5'd4;
writeData = 32'd0;
@(posedge clk);
offset = 5'd5;
writeData = 32'd0;
@(posedge clk);
offset = 5'd6;
writeData = 32'd0;
@(posedge clk);
offset = 5'd7;
writeData = 32'd0;
@(posedge clk);
offset = 5'd8;
writeData = 32'd0;
@(posedge clk);
offset = 5'd9;
writeData = 32'd3;
@(posedge clk);
offset = 5'd10;
writeData = 32'd1;
@(posedge clk);
offset = 5'd11;
writeData = 32'd5;
@(posedge clk);
offset = 5'd12;
writeData = 32'd0;
@(posedge clk);
offset = 5'd13;
writeData = 32'd0;
@(posedge clk);
offset = 5'd14;
writeData = 32'd0;
@(posedge clk);
offset = 5'd15;
writeData = 32'd0;
@(posedge clk);
offset = 5'd16;
writeData = 32'd0;
@(posedge clk);
offset = 5'd17;
writeData = 32'd2;
@(posedge clk);
offset = 5'd18;
writeData = 32'd4;
@(posedge clk);
offset = 5'd19;
writeData = 32'd6;
@(posedge clk);
offset = 5'd20;
writeData = 32'd50;
@(posedge clk);
offset = 5'd21;
writeData = 32'd60;
@(posedge clk);
offset = 5'd22;
writeData = 32'd70;
@(posedge clk);
offset = 5'd23;
writeData = 32'd80;
@(posedge clk);
offset = 5'd24;
writeData = 32'd90;
@(posedge clk);
offset = 5'd25;
writeData = 32'd100;
@(posedge clk);
offset = 5'd26;
writeData = 32'd100;
@(posedge clk);
offset = 5'd27;
writeData = 32'd110;
@(posedge clk);
offset = 5'd28;
writeData = 32'd120;

for (i=0 ; i<200; i=i+1)
	   begin
			@(posedge clk);
	   end

$finish;
end

endmodule


