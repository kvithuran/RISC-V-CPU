`timescale 1ns / 10ps

module phase3_running_tb;
	reg clock, Reset, Stop;
	reg CON;
	
	DatapathP3 DP( .clock(clock), .Stop(Stop), .Reset(Reset) );
	
	initial begin
		clock <= 0;
		forever #20
		clock = ~clock;
	end
	
	initial begin
		Reset = 1;
		Stop = 0;
		#21
		Reset = 0;
	end
	
	always@ (*) begin
	
		end
		
endmodule
		