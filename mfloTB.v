`timescale 1ns / 10ps



module mfloTB;


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
        Default   = 5'd0,

        
        PRE_LO    = 5'd1,

        
        T0        = 5'd2,
        T1        = 5'd3,
        T1b       = 5'd4,
        T2        = 5'd5,
        
        T3        = 5'd6,
        T3_done   = 5'd7,

        DONE      = 5'd8;

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
            Default   : Present_state <= PRE_LO;
            PRE_LO    : Present_state <= T0;

            T0        : Present_state <= T1;
            T1        : Present_state <= T1b;
            T1b       : Present_state <= T2;
            T2        : Present_state <= T3;
            T3        : Present_state <= T3_done;
            T3_done   : Present_state <= DONE;

            DONE      : Present_state <= DONE;
        endcase
    end

 
    task all_zero;
    begin
        PCout<=0; Zlowout<=0; Zhighout<=0; MDRout<=0;
        IRout<=0; MARout<=0;  HIout<=0;    LOout<=0;
        InPortout<=0; Cout<=0;
        MARin<=0;  Zlowin<=0; Zhighin<=0; PCin<=0;
        MDRin<=0;  IRin<=0;   Yin<=0;     HIin<=0;
        LOin<=0;   InPortin<=0; Cin<=0;   OutPortin<=0;
        CONin<=0;  IncPC<=0;  read<=0;    write<=0;
        Gra<=0;    Grb<=0;    Grc<=0;
        Rin<=0;    Rout<=0;   BAout<=0;
    end
    endtask

   
    always @(Present_state) begin
        case (Present_state)

            
            Default: begin
                Clear <= 1;
                all_zero;
            end

            
            PRE_LO: begin
                all_zero;
                Clear <= 0;
                force DUT.BusMuxOut = 32'hCAFE_BABE;
                LOin <= 1;
            end

         
            T0: begin
                release DUT.BusMuxOut;   
                all_zero;
           
                PCout <= 1; MARin <= 1; IncPC <= 1;
            end

            T1: begin
                all_zero;
                
                read <= 1; MDRin <= 1;
            end

            T1b: begin
                // hold read high one extra cycle (RAM latency)
                read <= 1; MDRin <= 1;
            end

            T2: begin
                all_zero;
                
                MDRout <= 1; IRin <= 1;
            end

            
            T3: begin
                all_zero;
                LOout <= 1;   // LO -> bus
                Gra   <= 1;   // select Ra (R1) from IR
                Rin   <= 1;   // R1 <- bus
            end

            T3_done: begin
                all_zero;
                $display("=== mflo R1 ===");
                $display("LO preloaded : 0xCAFEBABE");
                $display("R1 after mflo: 0x%08h", DUT.BusMuxInR1);
                if (DUT.BusMuxInR1 === 32'hCAFE_BABE)
                    $display("PASS: R1 == 0xCAFEBABE");
                else
                    $display("FAIL: R1 = 0x%08h (expected 0xCAFEBABE)", DUT.BusMuxInR1);
            end

            DONE: begin
                all_zero;
                $display("-------------------------------");
                $display("Simulation complete.");
            end

        endcase
    end

endmodule