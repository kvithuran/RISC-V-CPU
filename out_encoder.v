module out_encoder(
	input wire [22:0] inputs, 
	output wire [4:0] outputs
	);

	always@(inputs) 
	begin
		if (inputs[0]==1) outputs=5'b00000
		else if (inputs[1]==1) outputs=5'00001
		else if (inputs[2]==1) outputs=5'00010
		else if (inputs[3]==1) outputs=5'00011
		else if (inputs[4]==1) outputs=5'00100
		else if (inputs[5]==1) outputs=5'00101
		else if (inputs[6]==1) outputs=5'00110
		else if (inputs[7]==1) outputs=5'00111
		else if (inputs[8]==1) outputs=5'01000
		else if (inputs[9]==1) outputs=5'01001
		else if (inputs[10]==1) outputs=5'01010
		else if (inputs[11]==1) outputs=5'01011
		else if (inputs[12]==1) outputs=5'01100
		else if (inputs[13]==1) outputs=5'01101
		else if (inputs[14]==1) outputs=5'01110
		else if (inputs[15]==1) outputs=5'01111
		else if (inputs[16]==1) outputs=5'10000
		else if (inputs[17]==1) outputs=5'10001
		else if (inputs[18]==1) outputs=5'10010
		else if (inputs[19]==1) outputs=5'10011
		else if (inputs[20]==1) outputs=5'10100
		else if (inputs[21]==1) outputs=5'10101
		else if (inputs[22]==1) outputs=5'10110
	end
	endmodule
