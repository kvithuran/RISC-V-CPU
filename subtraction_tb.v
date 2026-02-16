`timescale 1ns / 10ps

module subtraction_tb;

    reg PCout, Zlowout, Zhighout, MDRout;
    reg R2out, R3out, R4out;
    reg MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
    reg IncPC, Read;
    reg R2in, R3in, R4in;
    reg Clock, Clear;
    reg [31:0] Mdatain;
    reg [4:0] opcode;
	 
	 
	 //Defining non relevant signals.
	 reg R0out, R1out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg HIout, LOout, InPortout, Cout, IRout, MARout;
    reg R0in, R1in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    reg HIin, LOin, InPortin, Cin;
	 
	 //State machine definitions.
	 parameter Default = 5'b00000, Reg_load1a = 5'b00001, Reg_load1b = 5'b00010, Reg_load2a = 5'b00011, Reg_load2b = 5'b00100, Reg_load3a = 5'b00101, Reg_load3b = 5'b00110, 
              T0 = 5'b01000, T1 = 5'b01001, T2 = 5'b01010, T3 = 5'b01011, T4 = 5'b01100, T5 = 5'b01101, T6 = 5'b01110;
				  

	

	reg [4:0] Present_state = Default;
	
	DataPath DPTest(.clock(Clock), .clear(Clear), .opcode(opcode),
							
						.R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out), .R8out(R8out), 
						.R9out(R9out), .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),
						.R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in), .R4in(R4in), .R5in(R5in), .R6in(R6in), .R7in(R7in), .R8in(R8in), 
						.R9in(R9in), .R10in(R10in), .R11in(R11in), .R12in(R12in), .R13in(R13in), .R14in(R14in), .R15in(R15in),
						.Yin(Yin), .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .Zhighout(Zhighout),
					
						.PCout(PCout), .MDRout(MDRout), .PCin(PCin), .MDRin(MDRin), .IRin(IRin), .MARin(MARin),
						
						.Mdatain(Mdatain)
						
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
	endcase
 end
 
 always @(Present_state) // do the required job in each state
	begin
		case (Present_state) // assert the required signals in each clock cycle
			Default: begin
				PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
				 R2out <= 0; R3out <= 0; R4out <= 0; MARin <= 0;
				 Zlowin <= 0; Zhighin <= 0;
				 PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
				 IncPC <= 0; Read <= 0; opcode <= 0;
				 R2in <= 0; R3in <= 0; R4in <= 0;
				 Mdatain <= 32'b0;
				 Clear <= 1;
				 
				 
				 
		end

		Reg_load1a: begin
			R2in <= 0; R5in <= 0; R6in <= 0; R2out <= 0; R5out <= 0; R6out <= 0; R4in <= 0; R4out <= 0; Yin <= 0; Zhighin <= 0; Zhighout <= 0; Zlowin <= 0; Zlowout <= 0; MDRin <= 0; MDRout <= 0;
			Clear <= 0;
			Mdatain <= 32'd1200376219;
			//Read <= 0;
			MDRin <= 1;
			//Read <= 1; 
			
			//#25 Read <= 0; MDRin <= 0; // for your current implementation
		end
		
		Reg_load1b: begin
			MDRin <= 0;
			MDRout <= 1; R6in <= 1;
			
			end
		Reg_load2a: begin
			MDRout <= 0; R6in <= 0;
			Mdatain <= -32'd2137996148;
			//Read <= 0;
			MDRin <= 1;
			
			//Read <= 0;
			
			end
		Reg_load2b: begin
			MDRin <= 0;
			MDRout <= 1; R5in <= 1;
		end
		Reg_load3a: begin
			MDRout <= 0; R5in <= 0;
			Mdatain <= 32'd2;
			//Read <= 1;
			MDRin <= 1;
			//Read <= 1;
		end
		Reg_load3b: begin
			MDRin <= 0;
			MDRout <= 1; R2in <= 1;
		end
		
		T0: begin
			MDRout <= 0; R2in <= 0;
			PCout <= 1; MARin <= 1;
			IncPC <= 1; Zhighin <= 1; Zlowin <= 1;
			
		end
		T1: begin
			IncPC <= 0; Zhighin <= 0; Zlowin <= 0;
			PCout <= 0; MARin <= 0;
			Zlowout <= 1;
			PCin <= 1;
			Mdatain <= 32'd0;
			Read <= 1;
			MDRin <= 1;
			
		end
		T2: begin
			Zlowout <= 0;
			PCin <= 0;
			Read <= 0;
			MDRin <= 0;
			MDRout <= 1; IRin <= 1;
			opcode <= 5'b00001;
			end
		T3: begin
			MDRout <= 0; IRin <= 0;
			R5out <= 1; Yin <= 1;
		end
		T4: begin
			R5out <= 0; Yin <= 0;
			
			R6out <= 1;
			Zhighin <= 1; 
			Zlowin <= 1;
		end
		T5: begin
			R6out <= 0; Zhighin <= 0; Zlowin <= 0;
			Zlowout <= 1; R2in <= 1;
		end
		T6: begin 
			Zlowout <= 0; R2in <= 0;
			Zhighout <= 1; R4in <= 1;
			#20 Zhighout <= 0; R4in <= 0;
		end
	endcase
end
endmodule
			
			
			
			
		
	
				  
				  
	
	