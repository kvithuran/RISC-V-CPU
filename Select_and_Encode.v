module Select_and_Encode(
    input [31:0] Instruction,
    input Gra, Grb, Grc,
    input Rin, Rout, BAout,
	 input Cout,
	 
	 
	 output reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
	 output reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
	 output [31:0] CSignExtended
);

wire [3:0] Ra, Rb, Rc;
wire [18:0] C;
reg  [3:0] reg_sel;
reg  [15:0] decoder;


assign Ra = Instruction[26:23];
assign Rb = Instruction[22:19];
assign Rc = Instruction[18:15];
assign C = Instruction[18:0];


always @(*) begin
    if (Gra)
        reg_sel = Ra;
    else if (Grb)
        reg_sel = Rb;
    else if (Grc)
        reg_sel = Rc;
    else
        reg_sel = 4'bzzzz;
end



always @(*) begin
    decoder = 16'b0;
	 if (Rin) begin
		 case(reg_sel)
			  4'd0: R0in = 1;
			  4'd1: R1in = 1;
			  4'd2: R2in = 1;
			  4'd3: R3in = 1;
			  4'd4: R4in = 1;
			  4'd5: R5in = 1;
			  4'd6: R6in = 1;
			  4'd7: R7in = 1;
			  4'd8: R8in = 1;
			  4'd9: R9in = 1;
			  4'd10: R10in = 1;
			  4'd11: R11in = 1;
			  4'd12: R12in = 1;
			  4'd13: R13in = 1;
			  4'd14: R14in = 1;
			  4'd15: R15in = 1;
				
		 endcase
	 end
	 else if (Rout) begin
		 case(reg_sel)
			  4'd0: R0out = 1;
			  4'd1: R1out = 1;
			  4'd2: R2out = 1;
			  4'd3: R3out = 1;
			  4'd4: R4out = 1;
			  4'd5: R5out = 1;
			  4'd6: R6out = 1;
			  4'd7: R7out = 1;
			  4'd8: R8out = 1;
			  4'd9: R9out = 1;
			  4'd10: R10out = 1;
			  4'd11: R11out = 1;
			  4'd12: R12out = 1;
			  4'd13: R13out = 1;
			  4'd14: R14out = 1;
			  4'd15: R15out = 1;
				
		 endcase
	 end
	 else begin
			R0out = 0;
			R1out = 0;
			R2out = 0;
			R3out = 0;
			R4out = 0;
			R5out = 0;
			R6out = 0;
			R7out = 0;
			R8out = 0;
			R9out = 0;
			R10out = 0;
			R11out = 0;
			R12out = 0;
			R13out = 0;
			R14out = 0;
			R15out = 0;
			R0in = 0;
			R1in = 0;
			R2in = 0;
			R3in = 0;
			R4in = 0;
			R5in = 0;
			R6in = 0;
			R7in = 0;
			R8in = 0;
			R9in = 0;
			R10in = 0;
			R11in = 0;
			R12in = 0;
			R13in = 0;
			R14in = 0;
			R15in = 0;
	 end
	 
end

assign CSignExtended = Cout ? {{13{C[18]}}, C} : 32'b0;


endmodule
