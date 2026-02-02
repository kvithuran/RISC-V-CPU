module alu(A,B,Result);

input [31:0] A, B;
output [31:0] Result;

reg [31:0] Result;
reg [32:0] LocalCarry;
