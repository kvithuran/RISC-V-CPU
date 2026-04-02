`timescale 1ns / 10ps

module phase3_running_tb;
	reg clock, Reset, Stop;
	reg CON;
	
	DatapathP3 DP( .clock(clock), .Stop(Stop), .Reset(Reset) );
	
	reg [31:0] clock_cycles;
	
	initial begin
		clock <= 0;
		forever #20
		clock = ~clock;
		clock_cycles = clock_cycles + 1;
	end
	
	initial begin
		clock_cycles = 32'd0;
		Reset = 1;
		Stop = 0;
		#21
		Reset = 0;
		DP.InPort.q = 32'h000000E0;
	end
	
	always@ (*) begin
	
		end
		
endmodule
		