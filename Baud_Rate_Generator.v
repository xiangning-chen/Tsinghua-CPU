module Baud_Rate_Generator(sgn_clk,scan_clk,sys_clk,Reset);
input Reset,sys_clk;
output sgn_clk,scan_clk;

reg sgn_clk,scan_clk;
reg [12:0] sgn_cnt,scan_cnt;

initial 
begin
	sgn_cnt <= 0;
	scan_cnt <= 0;
	sgn_clk <= 0;
	scan_clk <= 0;
end

always @(posedge sys_clk or posedge Reset)
begin
	if(Reset)
	begin
		sgn_clk <= 0;
		scan_clk<=0;
		sgn_cnt <= 0;
		scan_cnt <= 0;
	end
	else 
	begin
		sgn_cnt <= sgn_cnt + 1;
		scan_cnt <= scan_cnt + 1;
		if(sgn_cnt == 2603)
		begin
			sgn_clk <= ~sgn_clk;
			sgn_cnt <= 0;
		end
		if(scan_cnt == 162)
		begin
			scan_clk <= ~scan_clk;
			scan_cnt <= 0;
		end
	end
end
endmodule
