`timescale 1ns/10ps
module control_unit (
	output reg 	Gra, Grb, Grc, Rin, …, Rout, // define the inputs and outputs to your Control Unit here
					Yin, Zin, PCout, IncPC, MARin,
					Read, Write, Clear,
					ADD, AND, SHR,
	input 		[31:0] IR,
	input 		Clock, Reset, Stop, Con_FF);
	parameter 	reset_state = 4’b0000, fetch0 = 4’b0001, fetch1 = 4’b0010, fetch2 = 4’b0011,
					add3 = 4’b0100, add4 = 4’b0101, add5 = 4’b0110, …;
	reg 			[3:0] present_state = reset_state; // adjust the bit pattern based on the number of states
	
	
always @(posedge Clock, posedge Reset) // finite state machine; if clock or reset rising-edge
	begin
		if (Reset == 1’b1) present_state = reset_state;
		else case (present_state)
			reset_state: present_state = fetch0;
			fetch0: present_state = fetch1;
			fetch1: present_state = fetch2;
			fetch2: begin

					case (IR[31:27]) // inst. decoding based on the opcode to set the next state
						5’b00000: present_state = addsub3; // this is the add instruction Tyler
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
			//⁞
		endcase
	end
always @(present_state) // do the job for each state : HERE PUT YOUR ACTUAL CLOCK CYCLES DOING WORK.
	begin
		case (present_state) // assert the required signals in each state
			reset_state: begin
				Gra <= 0; Grb <= 0; Grc <= 0; Yin <= 0; // initialize the signals
				⁞
			end
			fetch0: begin
					PCout <= 1; // see if you need to de-assert these signals
					MARin <= 1;
					IncPC <= 1;
			end
			fetch1: begin
				PCout <= 0;
				MARin <= 0;
				IncPC <= 0; 
				read <= 1;
				MDRin <= 1;
			end
			fetch1b: begin
				MDRin <= 1;
				read <= 1;
			end
			fetch2: begin
				read <= 0;
				MDRin <= 0;
				MDRout <= 1; IRin <= 1;
			end
			add3: begin
					Grb <= 1; Rout <= 1;
					Yin <= 1;
			end
			⁞
		endcase
	end
endmodule
