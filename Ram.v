module RAM (input clock, input read, input write, input [8:0] Address, inout wire [31:0] Data);
	
	reg[31:0] RAM1[0:511];
	
	reg [31:0] dataReg;
	
	assign Data = (read && !write) ? dataReg : 32'bz;
				
	always @(posedge clock)
	begin
	
		  if (read) begin
			dataReg <= RAM1[Address];
			end
			
		  else if (write)
		  
		  begin
			RAM1[Address] <= Data;
		  end
		  
		end
endmodule