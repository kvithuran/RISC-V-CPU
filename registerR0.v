module registerR0 #(parameter DATA_WIDTH_IN = 32, DATA_WIDTH_OUT = 32, INIT = 32'h0)(
    input clear, clock, enable,
    input  [DATA_WIDTH_IN-1:0]BusMuxOut,
    output wire [DATA_WIDTH_OUT-1:0]BusMuxIn,
	 input wire BAout
);

reg [DATA_WIDTH_IN-1:0]q;
initial q = INIT;

always @ (posedge clock)
	begin
		 if (clear) begin
			  q <= {DATA_WIDTH_IN{1'b0}};
		 end
		 else if (enable) begin
			  q <= BusMuxOut;
		 end
	end

assign BusMuxIn = BAout ? {DATA_WIDTH_IN{1'b0}} : q[DATA_WIDTH_OUT-1:0];

endmodule