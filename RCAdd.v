	//Ripple Carry Adder
module adder(input [31:0] A, B, output reg [31:0] Result, Overflow_Flag);

reg [32:0] LocalCarry;

integer i;

always@(A or B)
	begin
		LocalCarry = 33'd0;
		for(i=0; i<32; i=i+1)
		begin
				Result[i] = A[i]^B[i]^LocalCarry[i];
				LocalCarry[i+1] = (A[i]&B[i])|(LocalCarry[i]&(A[i]|B[i]));
		end
		
		
		if (LocalCarry[31] != LocalCarry[32])
		begin
			Overflow_Flag = 32'd1;
		end
		else begin
			Overflow_Flag = 32'd0;
		end
		
end
endmodule
