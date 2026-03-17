`timescale 1ns / 10ps

module load_tb(output wire CON);

    reg PCout, Zlowout, Zhighout, MDRout;
    reg MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
    reg IncPC, read, write;
    reg Clock, Clear;
	 
	 
    reg HIout, LOout, InPortout, Cout, IRout, MARout, OutPortout;
    reg HIin, LOin, InPortin, Cin, OutPortin;
	 reg Gra, Grb, Grc, CONin, Rin, Rout, BAout;
	 
	 
	 
	 //State machine definitions.
	 parameter Default = 5'b00000, Reg_load1a = 5'b00001, Reg_load1b = 5'b00010, Reg_load2a = 5'b00011, Reg_load2b = 5'b00100, Reg_load3a = 5'b00101, Reg_load3b = 5'b00110, 
              T0 = 5'b01000, T1 = 5'b01001, T2 = 5'b01010, T3 = 5'b01011, T4 = 5'b01100, T5 = 5'b01101, T6 = 5'b01110,
				  T7 = 5'b01111, T8 = 5'b10000, T9 = 5'b10001, T10 = 5'b10010, T11 = 5'b10011, T12 = 5'b10100, T13 = 5'b10101;
				  

	

	reg [4:0] Present_state = Default;
	
	DatapathP2 DPTest(.clock(Clock), .clear(Clear),
							
						.Yin(Yin), .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .Zhighout(Zhighout),
					
						.PCout(PCout), .MDRout(MDRout), .PCin(PCin), .MDRin(MDRin), .IRin(IRin), .MARin(MARin),
						
						.read(read), .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(Rin), .Rout(Rout), .BAout(BAout),
						.Cout(Cout), .Cin(Cin), .HIout(HIout), .LOout(LOout), .InPortout(InPortout), .IRout(IRout), .MARout(MARout), .OutPortout(OutPortout), .HIin(HIin), .LOin(LOin), .InPortin(InPortin), .OutPortin(OutPortin), .CONin(CONin), .CON(CON), .write(write), .IncPC(IncPC)
						
						);
						
						initial
							begin
						
								Clock = 0;
								forever #10 Clock = ~Clock;
						
						end
						
	always @(posedge Clock)
		begin
			case(Present_state)
				Default : Present_state = Reg_load1a;
				Reg_load1a : Present_state = Reg_load1b;
				Reg_load1b : Present_state = Reg_load2a;
				Reg_load2a : Present_state = Reg_load2b;
				Reg_load2b : Present_state = Reg_load3a;
				Reg_load3a : Present_state = Reg_load3b;
				Reg_load3b : Present_state = T0;
				T0 : Present_state = T1;
				T1 : Present_state = T2;
				T2 : Present_state = T3;
				T3 : Present_state = T4;
				T4 : Present_state = T5;
				T5 : Present_state = T6;
				T6 : Present_state = T7;
				T7 : Present_state = T8;
				T8 : Present_state = T9;
	endcase
 end
 
 always @(Present_state) // do the required job in each state
	begin
	PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
    MARin <= 0; Zlowin <= 0; Zhighin <= 0; PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
    IncPC <= 0; read <= 0; write <= 0;
	 
	 HIout <= 0; LOout <= 0; InPortout <= 0; Cout <= 0; IRout <= 0; MARout <= 0; OutPortout <= 0;
    HIin <= 0; LOin <= 0; InPortin <= 0; Cin <= 0; OutPortin <= 0;
    Gra <= 0; Grb <= 0; Grc <= 0; CONin <= 0; Rin <= 0; Rout <= 0; BAout <= 0;
    Clear <= 0;
		case (Present_state) // assert the required signals in each clock cycle
			Default: begin	
				PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
				 R2out <= 0; R3out <= 0; R4out <= 0; MARin <= 0;
				 Zlowin <= 0; Zhighin <= 0;
				 PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
				 IncPC <= 0; read <= 0; opcode <= 0;
				 R2in <= 0; R3in <= 0; R4in <= 0;
				 Clear <= 1;
				 
				 
				 
		end

		Reg_load1a: begin
			Clear <= 1;
		end
		
		Reg_load1b: begin
			Clear <= 0;
		end
		Reg_load2a: begin
			
			end
		Reg_load2b: begin
			
		end
		Reg_load3a: begin
			
		end
		Reg_load3b: begin
			
		end
		
		T0: begin
			PCout <= 1;
			MARin <= 1;
			IncPC <= 1; 
			Zhighin <= 1; Zlowin <= 1;
			
		end
		T1: begin
			PCout <= 0;
			MARin <= 0;
			IncPC <= 0; 
			Zhighin <= 0; Zlowin <= 0;
//			Zlowout <= 1;
//			PCin <= 1;
			read <= 1;
			MDRin <= 0;
			
		end
		T2: begin
			MDRin <= 1;
			read <= 1;
		end
		T3: begin
			Zlowout <= 0;
			//PCin <= 0;
			read <= 0;
			MDRin <= 0;
			MDRout <= 1; IRin <= 1;
			end
		T4: begin
			MDRout <= 0; IRin <= 0;
			Grb <= 1;
			BAout <= 1;
			Yin <= 1;
		end
		T5: begin
			Yin <= 0;
			Grb <= 0;
			BAout <= 0;
			
			Cout <= 1;
			//Zhighin <= 1; 
			Zlowin <= 1;
			
		end
		T6: begin
			Cout <= 1;
			Zlowin <= 1;
		end
		T7: begin
			Cout <= 0; Zhighin <= 0; Zlowin <= 0;
			Zlowout <= 1; MARin <= 1;
		end
		T8: begin 
			Zlowout <= 0; MARin <= 0;
			read <= 1; MDRin <= 1;
		end
		T9: begin 
			read <= 1; MDRin <= 1;
		end
		T10: begin
		read <= 0; MDRin <= 0;
		MDRout <= 1;  Gra <= 1; Rin <= 1;
		end
	endcase
end
endmodule
			
			
			
			
		
	
				  
				  
	
	