module RAM (input clock, input read, input write, input [8:0] Address, input [31:0] DataIn, output [31:0] DataOut);
	
	reg[31:0] RAM1[0:511];
	
	reg [31:0] dataReg;
	
	initial begin
		 
		//Tyler Program
		//RAM1[0] = 32'h83800065; //ld R7, 0x65
		//RAM1[0] = 32'h80100072; //ld R0, 0x72(R2)
		//RAM1[0] = 32'h8B800065; //ldi R7, 0x65
		//RAM1[0] = 32'h88100072; //ldi R0, 0x72(R2)
		//RAM1[0] = 32'h9300001F; // st 0x1F, R6
		//RAM1[0] = 32'h9330001F; // st 0x1F(R6), R6
		
		//RAM1[101] = 32'h84;
		//RAM1[201] = 32'h2B;
		//RAM1[31] = 32'hD4;
		//RAM1[130] = 32'hA7;
		
		//Vithuran Program
		//addi
		//RAM1[0] = 32'h4BA7FFF7;
		
		//andi
		//RAM1[0] = 32'h53A00071;
		
		//ori
		//RAM1[0] = 32'h5BA00071;
		
		//out r7
		//RAM1[0] = 32'hBB800000;
		//in r5
		//RAM1[0] = 32'hB2800000;
		//mfhi
		//RAM1[0] = 32'hC2800000;
		//mflo
		//RAM1[0] = 32'hC8800000;
		
		//$display("RAM1[0] = %h", RAM1[0]);

		//Thomas
		// RAM1[0] = 32'h81800030; // brzr R3, 48
		// RAM1[16] = 32'h81800030; // brzr R3, 48
		// RAM1[16] = 32'h89880030; brnz R3,48
		// RAM1[16] = 32'h91900030; brpl R3, 48
		// RAM1[16] = 32'h99980030; brmi R3,48
		
		//RAM1[16] = 32'hA6000000; // jr R12
		//RAM1[16] = 32'hAA000000; // jal R4
		//RAM1[17] = 32'hAE000000; // helper word Ra=R12 (bits[26:23]=1100)
		
		
		RAM1[0] = 32'h82800008;
		RAM1[1] = 32'h83000009;
		RAM1[2] = 32'h012B0000;
		RAM1[3] = 32'h09AB0000;
		RAM1[4] = 32'hD8000000;
		RAM1[8] = 32'd8;
		RAM1[9] = 32'd4;
		
		
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
