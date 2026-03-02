module multiplier(input wire [31:0] M, 
						input wire [31:0] Q,
						output reg [63:0] result);
						

integer i;
reg signed [63:0] accumulation; //Must be 64 bit wide for same reason as partial_sum.
reg signed [32:0] Q_extended; //Must be 1 bit wider than 32 to append 0 at the end for recoding purposes.
reg signed [63:0] partial_sum; //Must be 64 bit wide because multiplying 32 bit numbers can get 64 bit result.

//Everything should be 64 bits when doing partial sums and signed to keep signs correct!

reg [2:0] current_bits;

always@(*)
	begin
	
		Q_extended = {Q, 1'b0};
		
		accumulation = 64'sd0;
		
		
	
	
		for (i = 0; i < 32; i = i + 2) begin
			
			current_bits = (Q_extended >> i) & 3'b111;
			
			case (current_bits)
				3'b000, 3'b111 : partial_sum = 64'sd0; //This one is just 64 bit rep of 0.
				3'b001, 3'b010 : partial_sum = {{32{M[31]}}, M}; //This one repeats the sign bit of M 32 times and then follows with 32-bit M for 1 * M
				3'b011 : partial_sum = {{31{M[31]}}, M, 1'b0}; //THis one is repeats the sign bit of M 31 times, then puts M (32 bits) followed by a 0 for 2 times M.
				3'b100 : partial_sum = -{{31{M[31]}}, M, 1'b0}; //Same as 2M but negated.
				3'b101, 3'b110 : partial_sum = -{{32{M[31]}}, M}; //Same as 1 * M but negative for -1 * M.
			endcase
			
			accumulation = accumulation + (partial_sum << i); //Shift what you're adding to sum by 2 bits for each i which represents a bit pair.
		end
		
		result = accumulation;
	end
endmodule


