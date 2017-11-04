`timescale 1ns/1ns
module UART_Receiver(RX_DATA,RX_STATUS,Reset,UART_RX,scan_clk);
input Reset,UART_RX,scan_clk;
output RX_STATUS;
output [7:0] RX_DATA;

reg [7:0] RX_DATA,RX_data;
reg RX_STATUS;
reg [3:0] num;
reg RX_EN1,RX_EN2;
reg [8:0] sample_cnt;
reg [7:0] count1;

initial 
begin
	RX_STATUS <= 0;
	RX_EN1 <= 0;
	RX_EN2 <= 0;
	sample_cnt <= 0;
	count1 <= 0;
	num <= 0;
end

always @(posedge scan_clk or posedge Reset)
begin   
	if(Reset) begin
		RX_DATA <= 0;
		RX_STATUS <= 0;
		RX_EN1 <= 0;
		RX_EN2 <= 0;
	end
	else begin
		if(RX_STATUS == 1)
			count1 <= count1 + 1;
    	if(count1 == 100) begin
       	 	RX_STATUS <= 0;  
        	count1 <= 0;
    	end
		if((~UART_RX) && (~RX_EN1)) begin
			RX_EN1 <= 1;
			sample_cnt <= 0;
		end
		if(RX_EN1) begin
			if((sample_cnt < 7)&&(~RX_EN2))
				sample_cnt <= sample_cnt + 1;
			if(sample_cnt == 7) begin
				sample_cnt <= 0;
				RX_EN2 <= 1;
			end
		end
		if(RX_EN2) begin
			sample_cnt <= sample_cnt + 1;
			if(sample_cnt == 15) begin
				sample_cnt <= 0;
				if(num < 8)
					RX_data[num] <= UART_RX;
				num <= num + 1;
				if(num == 8) begin
					RX_STATUS <= 1;
					RX_DATA <= RX_data;
					num <= 0;
					RX_EN1 <= 0;
					RX_EN2 <= 0;
				end
			end
		end	
	end
end
endmodule
