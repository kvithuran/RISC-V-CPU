`timescale 1ns / 10ps

module brzr_tb;
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
        T2  = 5'd4,  T3  = 5'd5,  T4  = 5'd6,
        T5  = 5'd7,  T6  = 5'd8,  T7  = 5'd9;

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

    always @(posedge Clock) begin
        case (Present_state)
            Default : Present_state <= T0;
            T0      : Present_state <= T1;
            T1      : Present_state <= T1b;
            T1b     : Present_state <= T2;
            T2      : Present_state <= T3;
            T3      : Present_state <= T4;
            T4      : Present_state <= T5;
            T5      : Present_state <= T6;
            T6      : Present_state <= T7;
            T7      : Present_state <= T7;  // stop here
        endcase
    end

    always @(Present_state) begin
        case (Present_state)

            Default: begin
                Clear  <= 1;
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

            // T0: PC -> MAR, increment PC
            T0: begin
                Clear  <= 0;
                PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
                IRout <= 0; MARout  <= 0; HIout    <= 0; LOout  <= 0;
                InPortout <= 0; Cout <= 0;
                MARin  <= 0; Zlowin <= 0; Zhighin <= 0; PCin   <= 0;
                MDRin  <= 0; IRin   <= 0; Yin     <= 0; HIin   <= 0;
                LOin   <= 0; InPortin <= 0; Cin   <= 0; OutPortin <= 0;
                CONin  <= 0; read   <= 0; write  <= 0;
                Gra    <= 0; Grb    <= 0; Grc    <= 0;
                Rin    <= 0; Rout   <= 0; BAout  <= 0;
                // preload R3 and PC
					 // ── brzr 
					 // TAKEN:     DUT.R3.q = 32'h00000000; // R3 = 0
					 // NOT TAKEN: DUT.R3.q = 32'h00000005; // R3 = 5
					 // ── brnz
					 // TAKEN:     DUT.R3.q = 32'h00000005; // R3 = 5
					 // NOT TAKEN: DUT.R3.q = 32'h00000000; // R3 = 0
					 // ── brpl
					 // TAKEN:     DUT.R3.q = 32'h00000005; // R3 positive, bit31=0
					 // NOT TAKEN: DUT.R3.q = 32'h80000000; // R3 negative, bit31=1
					 // ── brmi
					 // TAKEN:     DUT.R3.q = 32'h80000000; // R3 negative, bit31=1
					 // NOT TAKEN: DUT.R3.q = 32'h00000005; // R3 positive, bit31=0
                DUT.R3.q = 32'h00000005;
                DUT.PC.q = 32'h00000010;
                PCout <= 1; MARin <= 1; IncPC <= 1;
            end

            // T1: start read
            T1: begin
                PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
                IRout <= 0; MARout  <= 0; HIout    <= 0; LOout  <= 0;
                InPortout <= 0; Cout <= 0;
                MARin  <= 0; Zlowin <= 0; Zhighin <= 0; PCin   <= 0;
                MDRin  <= 0; IRin   <= 0; Yin     <= 0; HIin   <= 0;
                LOin   <= 0; InPortin <= 0; Cin   <= 0; OutPortin <= 0;
                CONin  <= 0; IncPC  <= 0; write  <= 0;
                Gra    <= 0; Grb    <= 0; Grc    <= 0;
                Rin    <= 0; Rout   <= 0; BAout  <= 0;
                read <= 1; MDRin <= 1;
            end

            // T1b: hold read so synchronous RAM data is valid
            T1b: begin
                read  <= 1;
                MDRin <= 1;
            end

            // T2: MDRout, IRin — load instruction into IR
            T2: begin
                read  <= 0; MDRin <= 0;
                MDRout <= 1; IRin <= 1;
            end

            // T3 (spec): Gra, Rout, CONin — R3 onto bus, latch CON
            // CON=1 if R3==0 (brzr TAKEN), CON=0 if R3!=0 (NOT TAKEN)
            T3: begin
                MDRout <= 0; IRin <= 0;
                Gra <= 1; Rout <= 1; CONin <= 1;
            end

            // T4 (spec): PCout, Yin — capture PC into Y
            T4: begin
                Gra <= 0; Rout <= 0; CONin <= 0;
                PCout <= 1; Yin <= 1;
            end

            // T5 (spec): Cout, ADD, Zin
            // C_sign_extended (=48=0x30) onto bus
            // ALU computes Y + 0x30 = 0x11 + 48 = 0x41
            T5: begin
                PCout <= 0; Yin <= 0;
                Cout <= 1; Zhighin <= 1; Zlowin <= 1;
            end

            // T6 (spec): Zlowout, CON->PCin
            // TAKEN:     PCin <= 1, PC becomes 0x41
            // NOT TAKEN: remove PCin <= 1, PC stays at 0x11
            T6: begin
                Cout <= 0; Zhighin <= 0; Zlowin <= 0;
                Zlowout <= 1; PCin <= 1;
            end

            T7: begin
                Zlowout <= 0; PCin <= 0;
            end

        endcase
    end

endmodule
