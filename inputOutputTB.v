`timescale 1ns / 10ps

module inputOutputTB;
    reg  PCout, Zlowout, Zhighout, MDRout, IRout, MARout;
    reg  HIout, LOout, InPortout, Cout;

    reg  MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
    reg  HIin, LOin, InPortin, Cin, OutPortin, CONin;
    wire CON;

    reg  IncPC, read, write;
    reg  Gra, Grb, Grc;
    reg  Rin, Rout, BAout;

    reg  Clock, Clear;
    parameter
		 Default = 5'd0,
		 T0  = 5'd1,  T1  = 5'd2,  T1b = 5'd3,
		 T2  = 5'd4,  T3  = 5'd5,  T4  = 5'd6;

    reg [4:0] Present_state = Default;

    DatapathP2 DUT (
        .clock      (Clock),      .clear      (Clear),
        .HIout      (HIout),      .LOout      (LOout),
        .Zhighout   (Zhighout),   .Zlowout    (Zlowout),
        .PCout      (PCout),      .MDRout     (MDRout),
        .InPortout  (InPortout),  .Cout       (Cout),
        .IRout      (IRout),      .MARout     (MARout),
        .OutPortout (1'b0),
        .HIin       (HIin),       .LOin       (LOin),
        .Zhighin    (Zhighin),    .Zlowin     (Zlowin),
        .PCin       (PCin),       .MDRin      (MDRin),
        .InPortin   (InPortin),   .Cin        (Cin),
        .IRin       (IRin),       .Yin        (Yin),
        .MARin      (MARin),      .OutPortin  (OutPortin),
        .CONin      (CONin),      .CON        (CON),
        .read       (read),       .write      (write),
        .IncPC      (IncPC),
        .Gra        (Gra),        .Grb        (Grb),        .Grc   (Grc),
        .Rin        (Rin),        .Rout       (Rout),       .BAout (BAout)
    );

    initial begin
			Clock = 0;
			forever #10 Clock = ~Clock;
	 end

	 initial begin
		 #25; // wait past Default state clear
		 DUT.R7.q = 32'hABCD1234;
	 end



    always @(posedge Clock) begin
    case (Present_state)
        Default : Present_state <= T0;
        T0      : Present_state <= T1;
        T1      : Present_state <= T1b;
        T1b     : Present_state <= T2;
        T2      : Present_state <= T3;
        T3      : Present_state <= T4;
        T4      : Present_state <= T4;
    endcase
end

    always @(Present_state) begin
        case (Present_state)
            Default: begin
                Clear <= 1;
                PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
                IRout <= 0; MARout  <= 0; HIout    <= 0; LOout  <= 0;
                InPortout <= 0; Cout <= 0;
                MARin  <= 0; Zlowin <= 0; Zhighin <= 0; PCin   <= 0;
                MDRin  <= 0; IRin   <= 0; Yin     <= 0; HIin   <= 0;
                LOin   <= 0; InPortin <= 0; Cin   <= 0; OutPortin <= 0;
                CONin  <= 0; IncPC  <= 0; read   <= 0; write  <= 0;
                Gra    <= 0; Grb    <= 0; Grc    <= 0;
                Rin    <= 0; Rout   <= 0; BAout  <= 0;
            end

      
            // Fetch T0
            T0: begin
					 Clear   <= 0;
					 // Clear all first
					 PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
					 IRout <= 0; MARout  <= 0; HIout    <= 0; LOout  <= 0;
					 InPortout <= 0; Cout <= 0;
					 MARin  <= 0; Zlowin <= 0; Zhighin <= 0; PCin   <= 0;
					 MDRin  <= 0; IRin   <= 0; Yin     <= 0; HIin   <= 0;
					 LOin   <= 0; InPortin <= 0; Cin   <= 0; OutPortin <= 0;
					 CONin  <= 0; read   <= 0; write  <= 0;
					 Gra    <= 0; Grb    <= 0; Grc    <= 0;
					 Rin    <= 0; Rout   <= 0; BAout  <= 0;
					 // T0: PC -> MAR, increment PC
					 PCout <= 1; MARin <= 1; IncPC <= 1;
				end

				T1: begin
					 // Clear all first
					 PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
					 IRout <= 0; MARout  <= 0; HIout    <= 0; LOout  <= 0;
					 InPortout <= 0; Cout <= 0;
					 MARin  <= 0; Zlowin <= 0; Zhighin <= 0; PCin   <= 0;
					 MDRin  <= 0; IRin   <= 0; Yin     <= 0; HIin   <= 0;
					 LOin   <= 0; InPortin <= 0; Cin   <= 0; OutPortin <= 0;
					 CONin  <= 0; IncPC  <= 0; write  <= 0;
					 Gra    <= 0; Grb    <= 0; Grc    <= 0;
					 Rin    <= 0; Rout   <= 0; BAout  <= 0;
					 // T1: read RAM[MAR] into MDR
					 read <= 1; MDRin <= 1;
				end
				T1b: begin
					read   <= 1;   // hold read high so dataReg is valid
					MDRin  <= 1;   // latch dataReg into MDR on this posedge
				end
				
				T2: begin
					Zlowout <= 0;
					PCin <= 0;
					read <= 0;
					MDRin <= 0;
					MDRout <= 1; IRin <= 1;
					end
				T3: begin
					MDRout <= 0; IRin   <= 0;
					Gra <= 1; Rout <= 1; OutPortin <= 1;
				end
				
				T4: begin
					Gra <= 0; Rout <= 0; OutPortin <= 0;
				end
		endcase
    end

endmodule