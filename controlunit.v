`timescale 1ns/10ps
module control_unit (
	output reg 		clear, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout, IRout, MARout, OutPortout,
					HIin, LOin, Zhighin, Zlowin, PCin, MDRin, InPortin, Cin, IRin, Yin, MARin, OutPortin, CONin,
					read, write, IncPC, Grb, Gra, Grc,
					Rout, Rin, BAout, R12ForceIn,
	input 		[31:0] IR,
	input 		clock, Reset, Stop, Con_FF);
	
parameter reset_state = 8'b00000000, fetch0 = 8'b00000001, fetch1 = 8'b00000010, fetch2 = 8'b00000011,
    addsub3 = 8'b00000100, addsub4 = 8'b00000101, addsub5 = 8'b00000110, addsub6 = 8'b00000111, addsub7 = 8'b00001000,
    andor3 = 8'b00001001, andor4 = 8'b00001010, andor5 = 8'b00001011, andor6 = 8'b00001100,
    load3 = 8'b00001101, load4 = 8'b00001110, load5 = 8'b00001111, load6 = 8'b00010000, load7 = 8'b00010001, load8 = 8'b00010010,
    loadi3 = 8'b00010011, loadi4 = 8'b00010100, loadi5 = 8'b00010101, loadi6 = 8'b00010110,
    store3 = 8'b00010111, store4 = 8'b00011000, store5 = 8'b00011001, store6 = 8'b00011010, store7 = 8'b00011011, store8 = 8'b00011100,
    halt3 = 8'b00011101, fetch1b = 8'b00011110, branch3 = 8'b00011111, branch4 = 8'b00100000, branch5 = 8'b00100001, branch6 = 8'b00100010, nop3 = 8'b00100011,
    sh3 = 8'b00100100, rot3 = 8'b00100101, imm3 = 8'b00100110, muldiv3 = 8'b00100111, negnot3 = 8'b00101000, jal3 = 8'b00101001, jr3 = 8'b00101010, in3 = 8'b00101011, out3 = 8'b00101100, mfhi3 = 8'b00101101, mflo3 = 8'b00101110,
    load9 = 8'b00101111, fetch3 = 8'b00110000, mfhi4 = 8'b00110001, mflo4 = 8'b00110010,
    rot4 = 8'b00110101, rot5 = 8'b00110110, rot6 = 8'b00110111, imm4 = 8'b00111000, imm5 = 8'b00111001, imm6 = 8'b00111010,
    in4 = 8'b00111011, out4 = 8'b00111100, muldiv4 = 8'b00111101, muldiv5 = 8'b00111110, muldiv6 = 8'b00111111, negnot4 = 8'b01000000, negnot5 = 8'b01000001, sh4 = 8'b01000010, sh5 = 8'b01000011, sh6 = 8'b01000100, jr4 = 8'b01000101, jal4 = 8'b01000110, jal5 = 8'b01000111;
				
	reg [7:0] present_state = reset_state; // adjust the bit pattern based on the number of states
	
	
always @(posedge clock, posedge Reset) // finite state machine; if clock or reset rising-edge
	begin
		if (Reset == 1'b1) present_state = reset_state;
		else if (Stop == 1'b1) present_state = halt3; // define a stop state if needed
		else case (present_state)
			reset_state: present_state = fetch0;
			fetch0: present_state = fetch1;
			fetch1: present_state = fetch1b;
			fetch1b: present_state = fetch2;
			fetch2: present_state = fetch3;
			fetch3: begin
					case (IR[31:27]) // inst. decoding based on the opcode to set the next state
						5'b00000: present_state = addsub3; // this is the add instruction Tyler
						5'b00001: present_state = addsub3; 
						5'b00010: present_state = andor3;  //Tyler
						5'b00011: present_state = andor3;  
						5'b00100: present_state = sh3;  //Thomas
						5'b00101: present_state = sh3;  
						5'b00110: present_state = sh3;  
						5'b00111: present_state = rot3; //Vithuran
						5'b01000: present_state = rot3; 
						5'b01001: present_state = imm3;    //Vithuran
						5'b01010: present_state = imm3;    
						5'b01011: present_state = imm3;    
						5'b01100: present_state = muldiv3; //Vithuran
						5'b01101: present_state = muldiv3; 
						5'b01110: present_state = negnot3; //Thomas
						5'b01111: present_state = negnot3;
						5'b10000: present_state = load3;   //Tyler
						5'b10001: present_state = loadi3;  //Tyler
						5'b10010: present_state = store3;  //Tyler
						5'b10011: present_state = jal3;  //Thomas
						5'b10100: present_state = jr3;  //Thomas
						5'b10101: present_state = branch3;  //Thomas
						5'b10110: present_state = in3;  //Vithuran
						5'b10111: present_state = out3;  //Vithuran
						5'b11000: present_state = mfhi3;  //Vithuran
						5'b11001: present_state = mflo3;  //Vithuran
						5'b11010: present_state = nop3; //Thomas
						5'b11011: present_state = halt3; //Tyler


						
						

						//⁞
					endcase
				end
				
			//HERE DEFINE WHAT CLOCK CYCLE COMES NEXT. DO FOR ALL INSTRUCTIONS. AFTER LAST CLOCK CYCLE GO TO fetch0.
			addsub3: present_state = addsub4;
			addsub4: present_state = addsub5;
			addsub5: present_state = addsub6;
			addsub6: present_state = addsub7;
			addsub7: present_state = fetch0;
			andor3: present_state = andor4;
			andor4: present_state = andor5;
			andor5: present_state = andor6;
			andor6: present_state = fetch0;
			load3: present_state = load4;
			load4: present_state = load5;
			load5: present_state = load6;
			load6: present_state = load7;
			load7: present_state = load8;
			load8: present_state = load9;
			load9: present_state = fetch0;
			loadi3: present_state = loadi4;
			loadi4: present_state = loadi5;
			loadi5: present_state = loadi6;
			loadi6: present_state = fetch0;
			store3: present_state = store4;
			store4: present_state = store5;
			store5: present_state = store6;
			store6: present_state = store7;
			store7: present_state = store8;
			store8: present_state = fetch0;
			branch3: present_state = branch4;
			branch4: present_state = branch5;
			branch5: present_state = branch6;
			branch6: present_state = fetch0;
			nop3:    present_state = fetch0;
			halt3: present_state = halt3;
			muldiv3: present_state = muldiv4;
			muldiv4: present_state = muldiv5;
			muldiv5: present_state = muldiv6;
			muldiv6: present_state = fetch0;
			negnot3: present_state = negnot4;
			negnot4: present_state = negnot5;
			negnot5: present_state = fetch0;
			rot3: present_state = rot4;
			rot4: present_state = rot5;
			rot5: present_state = rot6;
			rot6: present_state = fetch0;
			imm3: present_state = imm4;
			imm4: present_state = imm5;
			imm5: present_state = imm6;
			imm6: present_state = fetch0;
			in3: present_state = in4;
			in4: present_state = fetch0;
			out3: present_state = out4;
			out4: present_state = fetch0;
			mfhi3: present_state = mfhi4;
			mfhi4: present_state = fetch0;
			mflo3: present_state = mflo4;
			mflo4: present_state = fetch0;
			sh3: present_state = sh4;
			sh4: present_state = sh5;
			sh5: present_state = sh6;
			sh6: present_state = fetch0;
			jr3: present_state = jr4;
			jr4: present_state = fetch0;
			jal3: present_state = jal4;
			jal4: present_state = jal5;
			jal5: present_state = fetch0;

			
			//⁞
		endcase
	end
always @(present_state) // do the job for each state : HERE PUT YOUR ACTUAL CLOCK CYCLES DOING WORK.
	begin
		case (present_state) // assert the required signals in each state
			reset_state: begin
				Gra = 0; Grb = 0; Grc = 0; Yin = 0; // initialize the signals
				Zhighin = 0; Zlowin = 0; Zhighout = 0; Zlowout = 0; PCout = 0; IncPC = 0; MARin = 0;
				read = 0; write = 0; clear = 1;
				HIout = 0; LOout = 0; InPortout = 0; Cout = 0; IRout = 0; MARout = 0; OutPortout = 0;
				HIin = 0; LOin = 0; InPortin = 0; Cin = 0; OutPortin = 0;
			end
			fetch0: begin
					clear = 0;
					PCout = 1; // see if you need to de-assert these signals
					MARin = 1;
					IncPC = 1;
			end
			fetch1: begin
				PCout = 0;
				MARin = 0;
				IncPC = 0; 
				read = 1;
				MDRin = 1;
			end
			fetch1b: begin
				MDRin = 1;
				read = 1;
			end
			fetch2: begin
				read = 0;
				MDRin = 0;
				MDRout = 1; IRin = 1;
			end
			fetch3: begin
				MDRout = 0; IRin = 0;
			end
			addsub3: begin
				Grb = 1; Rout = 1;
				Yin = 1;
			end
			addsub4: begin
				Grb = 0; Rout = 0; Yin = 0;
				Grc = 1; Rout = 1;
				Zhighin = 1; Zlowin = 1;
			end
			addsub5: begin
				Grc = 0; Rout = 0;
				Zhighin = 0; Zlowin = 0;
				Zlowout = 1; Gra = 1; Rin = 1;
			end
			addsub6: begin
				Zlowout = 0; Gra = 0; Rin = 0;
				Zhighout = 1; HIin = 1;
			end
			addsub7: begin
				Zhighout = 0; HIin = 0;
			end
			andor3: begin
				Grb = 1; Rout = 1;
				Yin = 1;
			end
			andor4: begin
				Grb = 0; Rout = 0; Yin = 0;
				Grc = 1; Rout = 1;
				Zhighin = 1; Zlowin = 1;
			end
			andor5: begin
				Grc = 0; Rout = 0;
				Zhighin = 0; Zlowin = 0;
				Zlowout = 1; Gra = 1; Rin = 1;
			end
			andor6: begin
				Zlowout = 0; Gra = 0; Rin = 0;
			end
			load3: begin
				Grb = 1;
				BAout = 1;
				Rout = 1;
				Yin = 1;
			end
			load4: begin
				Yin = 0;
				Grb = 0;
				BAout = 0;
				Rout = 0;
				
				Cout = 1;
				Zlowin = 1;
				
			end
			load5: begin
				Cout = 0; Zhighin = 0; Zlowin = 0;
				Zlowout = 1; MARin = 1;
			end
			load6: begin
				Zlowout = 0; MARin = 0;
				read = 1; MDRin = 1;
			end
			load7: begin
				read = 1; MDRin = 1;
			end
			load8: begin
				read = 0; MDRin = 0;
				MDRout = 1;  Gra = 1; Rin = 1;
			end
			load9: begin
				MDRout = 0; Gra = 0; Rin = 0;
			end
			loadi3: begin
				Grb = 1;
				BAout = 1;
				Rout = 1;
				Yin = 1;
			end
			loadi4: begin
				Yin = 0;
				Grb = 0;
				BAout = 0;
				Rout = 0;
				
				Cout = 1;
				Zlowin = 1;
				
			end
			loadi5: begin
				Cout = 0; Zhighin = 0; Zlowin = 0;
				Zlowout = 1; Gra = 1; Rin = 1;
			end
			loadi6: begin
				Zlowout = 0; Gra = 0; Rin = 0;
			end
			store3: begin
				Grb = 1;
				BAout = 1;
				Rout = 1;
				Yin = 1;
			end
			store4: begin
				Yin = 0;
				Grb = 0;
				BAout = 0;
				Rout = 0;
				
				Cout = 1;
				Zlowin = 1;
				
			end
			store5: begin
				Cout = 0; Zhighin = 0; Zlowin = 0;
				Zlowout = 1; MARin = 1;
			end
			store6: begin
				Zlowout = 0; MARin = 0;
				Gra = 1; Rout = 1; MDRin = 1;
			end
			store7: begin
				Gra = 0; Rout = 0; MDRin = 0;
				write = 1;
			end
			store8: begin
				write = 0;
			end
			branch3: begin
    			Gra = 1; Rout = 1; CONin = 1; 
			end
			branch4: begin
    			Gra = 0; Rout = 0; CONin = 0;
    			PCout = 1; Yin = 1;             
			end
			branch5: begin
   				PCout = 0; Yin = 0;
					Cout = 1; Zhighin = 1; Zlowin = 1; 
			end
			branch6: begin
					Cout = 0; Zhighin = 0; Zlowin = 0;
   			 	Zlowout = 1;
    			if (Con_FF) PCin = 1;            
    			else        PCin = 0;
			end
			nop3: begin 

			end
			halt3: begin

			end
			muldiv3: begin
			MDRout = 0; IRin = 0;
			Gra = 1; Yin = 1;
            Rout = 1;
			end


			muldiv4: begin
						Gra = 0; Yin = 0;
						Rout = 0;
						Grb = 1; 
							Rout = 1;
						Zlowin = 1;
						Zhighin = 1;
			end

			muldiv5: begin
						Grb = 0; Rout = 0; Zlowin = 0; Zhighin = 0;
						Zlowout = 1; LOin = 1;
			end

			muldiv6: begin
						Zlowout = 0; LOin = 0;
						Zhighout = 1; HIin = 1;
						#20 Zhighout = 0; HIin =0;
			end

			negnot3: begin
						 MDRout = 0;
						 IRin = 0;
							 Grb = 1;
							 Rout = 1;
						 Zlowin = 1;
			end

			negnot4: begin
						 //R7out = 0;
						 Grb = 0;
							 Rout = 0;
							 Zlowin = 0;

						 Zlowout = 1;
						 //R4in = 1;
							 Gra = 1;
							 Rin = 1;
			end

			negnot5: begin
						 Zlowout = 0;
						 //R4in = 0;
							 Gra = 0;
							 Rin = 0;
			end



			rot3: begin
						 MDRout = 0;
						 IRin = 0;

						 //R0out = 1;   // source register
							 Grb = 1;
							 Rout = 1;
						 Yin = 1;
			end

			rot4: begin
						 //R0out = 0;
							 Grb = 0;
							 Rout = 0;
						 Yin = 0;

						 //R4out = 1;     // rotate count
							 Grc = 1;
							 Rout = 1;
						 Zlowin = 1;
						 Zhighin = 1;
			end


			rot5: begin
						 //R4out = 0;
							 Grc = 0;
							 Rout = 0;
						 Zlowin = 0;
						 Zhighin = 0;

						 Zlowout = 1;
						 //R7in = 1;
							 Gra = 1;
							 Rin = 1;
			end

			rot6: begin
						 Zlowout = 0;
						 //R7in = 0;
							 Gra = 0;
							 Rin = 0;
			end



			imm3: begin
								 MDRout = 0; IRin   = 0;
								 Grb    = 1; Rout   = 1; Yin    = 1;
			end

			imm4: begin
								 Grb    = 0; Rout   = 0; Yin    = 0;
								 Cout   = 1; Zhighin= 1; Zlowin = 1;
			end

			imm5: begin
								 Cout   = 0; Zhighin= 0; Zlowin = 0;
								 Zlowout= 1; Gra    = 1; Rin    = 1;
			end

			imm6: begin
								 Zlowout= 0; Gra    = 0; Rin    = 0;
			end

			in3: begin
								 MDRout = 0; IRin   = 0;
							Gra = 1; Rin = 1; InPortout = 1;
			end

			in4: begin
								Gra = 0; Rin = 0; InPortout = 0;
			end

			out3: begin
								 MDRout = 0; IRin   = 0;
							Gra = 1; Rout = 1; OutPortin = 1;
			end

			out4: begin
								 Gra = 0; Rout = 0; OutPortin = 0;
			end

			mfhi3: begin
								 MDRout = 0; IRin   = 0;
								 HIout = 1;
								 Gra   = 1;
								 Rin   = 1;
			end
			mfhi4: begin
								 HIout = 0;
								 Gra   = 0;
								 Rin   = 0;
			end

			mflo3: begin
								 MDRout = 0; IRin   = 0;
								 LOout = 1;
								 Gra   = 1;
								 Rin   = 1;
			end

			mflo4: begin
								 LOout = 0;
								 Gra   = 0;
								 Rin   = 0;
			end
			sh3: begin
                Grb = 1;
					 Rout = 1;
                Yin   = 1;
			end
			sh4: begin
					 Grb = 0; Rout = 0; Yin = 0;  // de-assert sh3 signals
					 Grc = 1; Rout = 1;
					 Zlowin = 1; Zhighin = 1;
			end
			sh5: begin
			       Zlowout = 1;
                Gra = 1;
					 Rin = 1;
			end
			sh6: begin 
					 Zlowout = 0;
					 Gra = 0;
					 Rin = 0;
			end
			jr3: begin
					MDRout = 0; IRin = 0;
					Gra = 1; Rout = 1; PCin = 1;
			end

			jr4: begin
					Gra = 0; Rout = 0; PCin = 0;
			end

			jal3: begin
				MDRout = 0; IRin = 0;
				PCout = 1; Grb = 1; Rin = 1;
			end
			jal4: begin
				PCout = 0; Grb = 0; Rin = 0;
				Gra = 1; Rout = 1; PCin = 1;
			end
			jal5: begin
				Gra = 0; Rout = 0; PCin = 0;
			end
			
		endcase
	end
endmodule
