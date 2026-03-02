//module RAM6116 (Cs_b, We_b, 0e_b, Address, I0);
//
//	input Cs_b;
//	input We_b;
//	input 0e_b;
//	input[7:0] Address;
//	inout[7:0] I0;
//	
//	reg[7:0] RAM1[0:255];
//	
//	assign I0 = (Cs_b == 1'b1 | We_b == 1'b1 | 0e_b == 1'b1) ?
//				8'bZZZZZZZZ : RAM1[Address] ; 
//				
//	always @(We_b, Cs_b)
//	begin
//	     @(negedge We_b)
//		  if(Cs_b == 1'b0)
//		  begin
//			RAM1[Address] <= I0;
//		  end
//		end
//endmodule
