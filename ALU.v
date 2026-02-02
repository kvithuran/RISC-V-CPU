module alu(input wire [31:0] A, 
				input wire [31:0] B, 
				input wire [4:0] opcode,  
				output reg [31:0]  zhi, 
				output reg [31:0] zlow);

wire [31;0] adder_out;				
RCAdd adder(A, B, adder_out)
				
always @(A or B or opcode)
	begin
	
	case (opcode)
		
		5b'00000 : zlow = adder_out; //Addition
			
		5b'00001 : //Subtraction
		
		5b'00010 : zlow = A & B; //and
		
		5b'00011 : //or
		
		5b'00100 : //Shift right logical
			
		5b'00101 : //Shift right arithmetic
		
		5b'00110 : //Shift left
			
		5b'00111 : //Rotate right
			
		5b'01000 : //Rotate left
		
		5b'01001 : //Add immediate
		
		5b'01010 : //And immediate
		
		5b'01011 : //OR immediate
		
		5b'01100 : //Division
			
		5b'01101 : //Multiplication
			
		5b'01110 : //negate
			
		5b'01111 : //not
			
		
			
		
			
		
		
			
			
			
			
			
			
			
			
			
						
		



				
				


