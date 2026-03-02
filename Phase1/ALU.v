module alu(input wire [31:0] A, 
				input wire [31:0] B, 
				input wire [4:0] opcode,  
				output reg [31:0]  zhi, 
				output reg [31:0] zlow);

wire [31:0] adder_out;		
wire [31:0] overflow_flag_out;		
adder adder(A, B, adder_out, overflow_flag_out);

reg [31:0] neg_B;

wire [31:0] sub_out;
wire [31:0] sub_overflow_flag_out;
adder sub(A, neg_B, sub_out, sub_overflow_flag_out);

wire [63:0] mult_out;

multiplier mult(A, B, mult_out);


wire [31:0] div_rem_out;
wire [31:0] div_quo_out;

divider div(A, B, div_quo_out, div_rem_out);

reg [31:0] shift_reg;
				
always @(*)
	begin
	
	neg_B = ~B + 1;
	
	case (opcode) 
		
		5'b00000 : begin
			zlow = adder_out; //Addition
			zhi = overflow_flag_out;
			end
			
		5'b00001 : begin 
			zlow = sub_out; //Subtraction
			zhi = sub_overflow_flag_out;
			end
		
		5'b00010 : zlow = A & B; //and
		
		5'b00011 : zlow = A | B;//or
		
		5'b00100 : zlow = A >> B[4:0];	//Shift right logical
			
		5'b00101 : zlow = $signed(A) >>> B[4:0];   //Shift right arithmetic
		
		5'b00110 : zlow = A << B[4:0]; //Shift left
			
		5'b00111 : zlow = (A >> B) | (A << (32 - B)); //Rotate right
			
		5'b01000 : zlow = (A << B) | (A >> (32 - B)); //Rotate left
		
		5'b01001 : zlow = adder_out; //Add immediate
		
		5'b01010 : zlow = A & B; //And immediate
		
		5'b01011 : zlow = A | B; //OR immediate
		
		5'b01100 : begin // Division
			zlow = div_quo_out;
			zhi = div_rem_out;
		end
		
			
		5'b01101 : begin //Multiplication
			
			zlow = mult_out[31:0];
			zhi = mult_out[63:32];
			
		end
			
		5'b01110 : zlow = neg_B; //negate
			
		5'b01111 : zlow = ~B; //not
		
		endcase
	end
endmodule
