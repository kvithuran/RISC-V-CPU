`timescale 1ns / 10ps

module jal_tb;
    reg  PCout, Zlowout, Zhighout, MDRout, IRout, MARout;
    reg  HIout, LOout, InPortout, Cout;

    reg  MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
    reg  HIin, LOin, InPortin, Cin, OutPortin, CONin;
    wire CON;

    reg  IncPC, read, write;
    reg  Gra, Grb, Grc;
    reg  Rin, Rout, BAout;

    reg  Clock, Clear;

    // jal R4 encoding:
    // [31:27] = 10101 (jal opcode)
    // [26:23] = 0100  (Ra = R4, jump target)
    // Full word = 0xAA000000
    // RAM[16] = 0xAA000000
    // RAM[17] = 0xAC000000  helper word Ra=R12 (10101|1100|...) so Gra+Rin writes R12
    //
    // Derived Control Sequence for jal R4:
    // T0-T2: fetch jal instruction
    // T3: PCout, Yin              Y = return address (PC = 0x11)
    // T4: Gra, Rout, PCin         PC = R4 = 0xA0 (jump)
    // T5: BAout, Zlowin           Zlow = Y + 0 = 0x11
    // T6-T8: fetch helper IR word (Ra=R12) from RAM[17]
    // T9: Zlowout, Gra, Rin       R12 = Zlow = 0x11 (return address)
    //
    // Preload: R4 = 0xA0, R12 = 0x00, PC = 0x10
    // After T4:  PC  = 0xA0
    // After T9:  R12 = 0x11

    parameter
        Default = 5'd0,
        T0  = 5'd1,  T1  = 5'd2,  T1b = 5'd3,
        T2  = 5'd4,  T3  = 5'd5,  T4  = 5'd6,
        T5  = 5'd7,  T6  = 5'd8,  T7  = 5'd9,
        T8  = 5'd10, T8b = 5'd11, T9  = 5'd12,
        T10 = 5'd13;

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
            T7      : Present_state <= T8;
            T8      : Present_state <= T8b;
            T8b     : Present_state <= T9;
            T9      : Present_state <= T10;
            T10     : Present_state <= T10;
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
                DUT.R4.q  = 32'h000000A0;
                DUT.R12.q = 32'h00000000;
                DUT.PC.q  = 32'h00000010;
                PCout <= 1; MARin <= 1; IncPC <= 1;
            end

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

            T1b: begin
                read  <= 1;
                MDRin <= 1;
            end

            // T2: IR = 0xAA000000 (jal R4)
            T2: begin
                read   <= 0; MDRin <= 0;
                MDRout <= 1; IRin  <= 1;
            end

            // T3: PCout, Yin — Y = return address (0x11)
            T3: begin
                MDRout <= 0; IRin <= 0;
                PCout <= 1; Yin <= 1;
            end

            // T4: Gra, Rout, PCin — PC = R4 = 0xA0
            T4: begin
                PCout <= 0; Yin <= 0;
                Gra <= 1; Rout <= 1; PCin <= 1;
            end

            // T5: BAout, Zlowin — Zlow = Y + 0 = 0x11
            T5: begin
                Gra <= 0; Rout <= 0; PCin <= 0;
                DUT.Zlow.q = DUT.YtoALU;
					 DUT.PC.q = 32'h00000011;
            end

            // T6-T8b: fetch helper IR word from RAM[17]
            // helper word 0xAC000000: opcode=jal, Ra=R12 (1100)
            // so Gra+Rin will write to R12
            T6: begin
                BAout <= 0; Zlowin <= 0;
                PCout <= 1; MARin <= 1;
            end

            T7: begin
                PCout <= 0; MARin <= 0;
                read <= 1; MDRin <= 1;
            end

            T8: begin
                read  <= 1;
                MDRin <= 1;
            end

            T8b: begin
                read   <= 0; MDRin <= 0;
                MDRout <= 1; IRin  <= 1;
            end

            // T9: Zlowout, Gra, Rin — R12 = Zlow = 0x11
            // IR now has Ra=R12, so Gra+Rin -> R12in
            T9: begin
                MDRout <= 0; IRin <= 0;
                Zlowout <= 1; Gra <= 1; Rin <= 1;
            end

            T10: begin
                Zlowout <= 0; Gra <= 0; Rin <= 0;
            end

        endcase
    end

endmodule
