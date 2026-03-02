`timescale 1ns / 10ps
module shift_right_tb;

    // Control signals
    reg PCout, Zlowout, Zhighout, MDRout;
    reg MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
    reg IncPC, Read;
    reg Clock, Clear;
    reg [31:0] Mdatain;
    reg [4:0] opcode;

    // Register controls
    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out;
    reg R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg HIout, LOout, InPortout, Cout, IRout, MARout;

    reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in;
    reg R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    reg HIin, LOin, InPortin, Cin;

    localparam [4:0] SRL_OPCODE = 5'b00100;

    // States
    parameter Default    = 5'd0,
              Reg_load1a = 5'd1, Reg_load1b = 5'd2,
              Reg_load2a = 5'd3, Reg_load2b = 5'd4,
              T0         = 5'd8, T1         = 5'd9,
              T2         = 5'd10, T3        = 5'd11,
              T4         = 5'd12, T5        = 5'd13;

    reg [4:0] Present_state = Default;

    // Datapath instance
    DataPath DPTest(
        .clock(Clock), .clear(Clear), .opcode(opcode),

        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out),
        .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out),
        .R8out(R8out), .R9out(R9out), .R10out(R10out), .R11out(R11out),
        .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),

        .HIout(HIout), .LOout(LOout), .Zhighout(Zhighout), .Zlowout(Zlowout),
        .PCout(PCout), .MDRout(MDRout), .InPortout(InPortout),
        .Cout(Cout), .IRout(IRout), .MARout(MARout),

        .R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in),
        .R4in(R4in), .R5in(R5in), .R6in(R6in), .R7in(R7in),
        .R8in(R8in), .R9in(R9in), .R10in(R10in), .R11in(R11in),
        .R12in(R12in), .R13in(R13in), .R14in(R14in), .R15in(R15in),

        .HIin(HIin), .LOin(LOin), .Zhighin(Zhighin), .Zlowin(Zlowin),
        .PCin(PCin), .MDRin(MDRin), .InPortin(InPortin),
        .Cin(Cin), .IRin(IRin), .Yin(Yin), .MARin(MARin),

        .Mdatain(Mdatain)
    );

    // Clock
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // State progression
    always @(posedge Clock) begin
        case (Present_state)
            Default    : Present_state <= Reg_load1a;
            Reg_load1a : Present_state <= Reg_load1b;
            Reg_load1b : Present_state <= Reg_load2a;
            Reg_load2a : Present_state <= Reg_load2b;
            Reg_load2b : Present_state <= T0;
            T0         : Present_state <= T1;
            T1         : Present_state <= T2;
            T2         : Present_state <= T3;
            T3         : Present_state <= T4;
            T4         : Present_state <= T5;
            T5         : Present_state <= T5;
        endcase
    end

    task zero_signals;
    begin
        PCout=0; Zlowout=0; Zhighout=0; MDRout=0;
        MARin=0; Zlowin=0; Zhighin=0; PCin=0; MDRin=0; IRin=0; Yin=0;
        IncPC=0; Read=0; opcode=0; Mdatain=0;

        R0out=0; R4out=0; R7out=0;
        R0in=0; R4in=0; R7in=0;
    end
    endtask

    // Control logic (drive on negedge so registers latch properly)
    always @(negedge Clock) begin
        zero_signals();

        case (Present_state)

            Default: begin
                Clear = 1;
            end

            // Load R0 with 0x80000000
            Reg_load1a: begin
                Clear   = 0;
                Mdatain = 32'h80000000;
                MDRin   = 1;
            end
            Reg_load1b: begin
                MDRout = 1; 
                R0in   = 1;
            end

            // Load R4 with shift amount 1
            Reg_load2a: begin
                Mdatain = 32'd1;
                MDRin   = 1;
            end
            Reg_load2b: begin
                MDRout = 1;
                R4in   = 1;
            end

            // T0
            T0: begin
                PCout = 1; 
                MARin = 1;
                IncPC = 1;
                Zlowin = 1;
            end

            // T1
            T1: begin
                Zlowout = 1;
                PCin    = 1;
                Read    = 1;
                MDRin   = 1;
                Mdatain = 32'h00000000;
            end

            // T2
            T2: begin
                MDRout = 1;
                IRin   = 1;
            end

            // T3
            T3: begin
                R0out = 1;
                Yin   = 1;
            end

            // T4: SRL
            T4: begin
                R4out   = 1;
                opcode  = SRL_OPCODE;
                Zlowin  = 1;
                Zhighin = 1;
            end

            // T5: write result to R7
            T5: begin
                Zlowout = 1;
                R7in    = 1;
            end

        endcase
    end

endmodule
