module RAM (input clock, input read, input write, input [8:0] Address, input [31:0] DataIn, output [31:0] DataOut);
	
	reg[31:0] RAM1[0:511];
	
	reg [31:0] dataReg;
	
	initial begin
		/* 
		//Tyler Program
		RAM1[0] = 32'h03800065;
		RAM1[1] = 32'h00100072;
		RAM1[2] = 32'h0B800065;
		RAM1[3] = 32'h08100072;
		RAM1[101] = 32'h84;
		RAM1[201] = 32'hC9; */ 
		
		//Vithuran Program
		RAM1[0] = 32'h4BA7FFF7;
		
		//andi
		//RAM1[0] = 32'h53A00071;
		
		//ori
		//RAM1[0] = 32'h5BA00071;
		
		//out r7
		//RAM1[0] = 32'hBB800000;
		//in r5
		//RAM1[0] = 32'hB2800000;
		
		$display("RAM1[0] = %h", RAM1[0]);
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