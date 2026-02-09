`timescale 1ns / 10ps

module divisionTB;

    reg PCout, Zlowout, Zhighout, MDRout; //Select Signals
    reg R2out, R3out, R4out; //Needed register out controls.
    reg MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
    reg IncPC, Read; //Placeholders based from provided template
    reg R2in, R3in, R4in; //Register in controls.
    reg Clock, Clear;
    reg [31:0] Mdatain; //From template
    reg [4:0] opcode;   //Opcode directely used
	 
	 //Defining non relevant signals.
	 reg RZout, RAout, RBout, R0out, R1out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg HIout, LOout, InPortout, Cout, IRout, MARout;
    reg RAin, RBin, RZin, R0in, R1in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    reg HIin, LOin, InPortin, Cin;
	 
	 //State machine definitions.
	 parameter Default = 5'b00000, Reg_load1a = 5'b00001, Reg_load1b = 5'b00010, Reg_load2a = 5'b00011, Reg_load2b = 5'b00100, Reg_load3a = 5'b00101, Reg_load3b = 5'b00110, 
              T0 = 5'b01000, T1 = 5'b01001, T2 = 5'b01010, T3 = 5'b01011, T4 = 5'b01100, T5 = 5'b01101, T6 = 5'b01110;
				  

	

	reg [4:0] Present_state = Default;
	
	DataPath DPTest(.clock(Clock), .clear(Clear), .opcode(opcode),
							
						.R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out), .R6out(R6out), .R2in(R2in), .R3in(R3in), .R4in(R4in), .R5in(R5in), .R6in(R6in), .Yin(Yin), .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .Zhighout(Zhighout),
						
						.RZout(0), .RAout(0), .RBout(0), .R0out(0), .R1out(0), .R7out(0), 
						.R8out(0), .R9out(0), .R10out(0), .R11out(0), .R12out(0), .R13out(0), .R14out(0), .R15out(0),
						.HIout(0), .LOout(0), .PCout(PCout), .MDRout(MDRout), .InPortout(0), .Cout(0), .IRout(0), .MARout(0),
						.RAin(0), .RBin(0), .RZin(0), .R0in(0), .R1in(0), .R7in(0), 
						.R8in(0), .R9in(0), .R10in(0), .R11in(0), .R12in(0), .R13in(0), .R14in(0), .R15in(0),
						.HIin(0), .LOin(0), .PCin(PCin), .MDRin(MDRin), .InPortin(0), .Cin(0), .IRin(IRin), .MARin(MARin),
						
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
			R2in <= 0; R5in <= 0; R6in <= 0; R2out <= 0; R5out <= 0; R6out <= 0; Yin <= 0; Zhighin <= 0; Zhighout <= 0; Zlowin <= 0; Zlowout <= 0; MDRin <= 0; MDRout <= 0;
			Clear <= 0;
			Mdatain <= 32'd4056;
			//Read <= 0;
			MDRin <= 1;
			//Read <= 1; 
			
			//#25 Read <= 0; MDRin <= 0; // for your current implementation
		end
		
		Reg_load1b: begin
			MDRin <= 0;
			MDRout <= 1; R5in <= 1;
			
			end
		Reg_load2a: begin
			MDRout <= 0; R5in <= 0;
			Mdatain <= 32'd2000;
			//Read <= 0;
			MDRin <= 1;
			
			//Read <= 0;
			
			end
		Reg_load2b: begin
			MDRin <= 0;
			MDRout <= 1; R6in <= 1;
		end
		Reg_load3a: begin
			MDRout <= 0; R6in <= 0;
			Mdatain <= 32'd67;
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
			//IncPC <= 1;
			
		end
		T1: begin
			PCout <= 0; MARin <= 0;
			Mdatain <= 32'd0;
			//Read <= 1;
			//MDRin <= 1; Mdatain <= [OPCODE FOR mul R2, R5, R6] instead we will force op code in T2.
			MDRin <= 1;
			
		end
		T2: begin
			MDRin <= 0;
			MDRout <= 1; IRin <= 1;
			opcode <= 5'b01100;
			end
		T3: begin
			MDRout <= 0; IRin <= 0;
			R5out <= 1; Yin <= 1;
		end
		T4: begin
			R5out <= 0; Yin <= 0;
			
			R6out <= 1; 
			Zlowin <= 1;
			Zhighin <=1;
		end
		T5: begin
			R6out <= 0; Zlowin <= 0; Zhighin <= 0;
			Zlowout <= 1; R2in <= 1;
		end
		T6: begin
			Zlowout <= 0; R2in <= 0;
			Zhighout <= 1; R3in <= 1;
			#20 Zhighout <= 0; R3in <=0;
			
		end
			
	endcase
end
endmodule
			
			
			
			
		
	
				  
				  
	
	