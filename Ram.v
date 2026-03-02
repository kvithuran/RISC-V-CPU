module RAM (input read, input write, input [8:0] Address, inout [31:0] Data);
	
	reg[31:0] RAM1[0:511];
				
	always @(posedge read, posedge write)
	begin
		  if (read) begin
			Data <= RAM1[Address] 
			end
			
		  else if(write)
		  
		  begin
			RAM1[Address] <= Data;
		  
		  end
		  
		end
<<<<<<< HEAD
endmodule
=======
endmodule
>>>>>>> d97735d5b7aa77a69f0f6355cf343af1cdfb049c
