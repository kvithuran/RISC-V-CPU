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
		
		
		RAM1[0] = 32'h8A800043;
		RAM1[1] = 32'h8AA80006;
		RAM1[2] = 32'h82000089;
		RAM1[3] = 32'h8A200004;
		RAM1[4] = 32'h8027FFF8;
		RAM1[5] = 32'h89000004;
		RAM1[6] = 32'h8A800087;
		RAM1[7] = 32'hAA980003;
		RAM1[8] = 32'h8AA80005;
		RAM1[9] = 32'h80AFFFFD;
		RAM1[10] = 32'hD0000000;
		RAM1[11] = 32'hA8900002;
		RAM1[12] = 32'h89A80007;
		RAM1[13] = 32'h8B9FFFFC;
		RAM1[14] = 32'h03A90000;
		RAM1[15] = 32'h48880003;
		RAM1[16] = 32'h70880000;
		RAM1[17] = 32'h78880000;
		RAM1[18] = 32'h5088000F;
		RAM1[19] = 32'h3A010000;
		RAM1[20] = 32'h58A00005;
		RAM1[21] = 32'h2A090000;
		RAM1[22] = 32'h22A90000;
		RAM1[23] = 32'h928000A3;
		RAM1[24] = 32'h42810000;
		RAM1[25] = 32'h1B900000;
		RAM1[26] = 32'h12280000;
		RAM1[27] = 32'h93A00089;
		RAM1[28] = 32'h082B8000;
		RAM1[29] = 32'h32290000;
		RAM1[30] = 32'h8B800007;
		RAM1[31] = 32'h89800019;
		RAM1[32] = 32'h69B80000;
		RAM1[33] = 32'hC0800000;
		RAM1[34] = 32'hCB000000;
		RAM1[35] = 32'h61B80000;
		RAM1[36] = 32'h8C380002;
		RAM1[37] = 32'h8C9FFFFC;
		RAM1[38] = 32'h8D300003;
		RAM1[39] = 32'h8D880005;
		RAM1[40] = 32'h9D000000;
		RAM1[41] = 32'hB3000000;
		RAM1[42] = 32'h93000077;
		RAM1[43] = 32'h8980002E;
		RAM1[44] = 32'h8A800001;
		RAM1[45] = 32'h89000028;
		RAM1[46] = 32'hBB000000;
		RAM1[47] = 32'h8917FFFF;
		RAM1[48] = 32'hA9000008;
		RAM1[49] = 32'h83800088;
		RAM1[50] = 32'h8BBFFFFF;
		RAM1[51] = 32'hD0000000;
		RAM1[52] = 32'hAB8FFFFD;
		RAM1[53] = 32'h23328000;
		RAM1[54] = 32'hAB0FFFF7;
		RAM1[55] = 32'h83000077;
		RAM1[56] = 32'hA1800000;
		RAM1[57] = 32'h8B000063;
		RAM1[58] = 32'hBB000000;
		RAM1[59] = 32'hD8000000;
		RAM1[136] = 32'h000000FF;   // 0x88
		RAM1[137] = 32'h000000A7;   // 0x89
		RAM1[163] = 32'h00000068;   // 0xA3
		RAM1[178] = 32'h07450000;   // 0xB2
		RAM1[179] = 32'h0ECD8000;
		RAM1[180] = 32'h0F768000;
		RAM1[181] = 32'hA6000000;
		
		
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
