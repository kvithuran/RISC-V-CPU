module RAM (input clock, input read, input write, input [8:0] Address, input [31:0] DataIn, output [31:0] DataOut);
	
	reg[31:0] RAM1[0:511];
	
	reg [31:0] dataReg;
	
	initial begin
		RAM1[0x0] = 32'h0x03800065;
		RAM1[0x1] = 32'h0x00100072;
		RAM1[0x2] = 32'h0x0B800065;
		RAM1[0x3] = 32'h0x08100072;
		RAM1[0x65] = 32'h0x84;
		RAM1[0xC9] = 32'h0xC9;
		end
	
	
	//Must assert read for one clock cycle and get data in MDR on the next clock cycle.
	always @(posedge clock)
	begin
	
		  if (read) begin
			dataReg <= RAM1[Address];
			end
			
		  else if (write)
		  begin
			RAM1[Address] <= DataIn;
		  end
		  
	end
		
	assign DataOut = dataReg;
	
endmodule