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

    parameter
        Default = 5'd0,
        T0  = 5'd1,  T1  = 5'd2,  T1b = 5'd3,
        T2  = 5'd4,  T3  = 5'd5,  T4  = 5'd6,
        T5  = 5'd7;

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
            T5      : Present_state <= T5;
        endcase
    end

    always @(Present_state) begin
        case (Present_state)

            Default: begin
                Clear  <= 0;
                PCout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0;
                IRout <= 0; MARout  <= 0; HIout    <= 0; LOout  <= 0;
                InPortout <= 0; Cout <= 0;
                MARin  <= 0; Zlowin <= 0; Zhighin <= 0; PCin   <= 0;
                MDRin  <= 0; IRin   <= 0; Yin     <= 0; HIin   <= 0;
                LOin   <= 0; InPortin <= 0; Cin   <= 0; OutPortin <= 0;
                CONin  <= 0; IncPC  <= 0; read   <= 0; write  <= 0;
                Gra    <= 0; Grb    <= 0; Grc    <= 0;
                Rin    <= 0; Rout   <= 0; BAout  <= 0;
					 DUT.R4.q  = 32'h000000AA;
					 DUT.R12.q = 32'h00000000;
					 DUT.PC.q  = 32'h00000010;
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
                // Preload registers:
                // R4  = target address to jump to (0x000000AA)
                // R12 = RA, will receive PC+1 after fetch (starts at 0x00)
                // PC  = 0x10 (instruction is at word address 0x10)
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

            T2: begin
                read   <= 0; MDRin <= 0;
                MDRout <= 1; IRin  <= 1;
            end

            T3: begin
                MDRout <= 0; IRin <= 0;
                PCout <= 1; Grb <= 1; Rin <= 1;
            end

            T4: begin
                PCout <= 0; Grb <= 0; Rin <= 0;
                Gra <= 1; Rout <= 1; PCin <= 1;
            end

            T5: begin
                Gra <= 0; Rout <= 0; PCin <= 0;
            end

        endcase
    end

endmodule
