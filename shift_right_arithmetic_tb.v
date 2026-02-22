`timescale 1ns / 10ps
module shra_tb;

    // (Same declarations as shift_right_tb)
    reg PCout, Zlowout, Zhighout, MDRout;
    reg MARin, Zlowin, Zhighin, PCin, MDRin, IRin, Yin;
    reg IncPC, Read;
    reg Clock, Clear;
    reg [31:0] Mdatain;
    reg [4:0] opcode;

    reg R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;
    reg HIout, LOout, InPortout, Cout, IRout, MARout;
    reg R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
    reg HIin, LOin, InPortin, Cin;

    parameter Default    = 5'b00000,
              Reg_load1a = 5'b00001, Reg_load1b = 5'b00010,
              Reg_load2a = 5'b00011, Reg_load2b = 5'b00100,
              T0         = 5'b01000, T1         = 5'b01001,
              T2         = 5'b01010, T3         = 5'b01011,
              T4         = 5'b01100, T5         = 5'b01101;

    reg [4:0] Present_state = Default;

    DataPath DPTest(
        .clock(Clock), .clear(Clear), .opcode(opcode),
        .R0out(R0out), .R1out(R1out), .R2out(R2out), .R3out(R3out), .R4out(R4out), .R5out(R5out), .R6out(R6out), .R7out(R7out), .R8out(R8out),
        .R9out(R9out), .R10out(R10out), .R11out(R11out), .R12out(R12out), .R13out(R13out), .R14out(R14out), .R15out(R15out),
        .R0in(R0in), .R1in(R1in), .R2in(R2in), .R3in(R3in), .R4in(R4in), .R5in(R5in), .R6in(R6in), .R7in(R7in), .R8in(R8in),
        .R9in(R9in), .R10in(R10in), .R11in(R11in), .R12in(R12in), .R13in(R13in), .R14in(R14in), .R15in(R15in),
        .Yin(Yin), .Zlowin(Zlowin), .Zhighin(Zhighin), .Zlowout(Zlowout), .Zhighout(Zhighout),
        .HIout(HIout), .LOout(LOout), .InPortout(InPortout), .Cout(Cout), .IRout(IRout), .MARout(MARout),
        .HIin(HIin), .LOin(LOin), .InPortin(InPortin), .Cin(Cin),
        .PCout(PCout), .MDRout(MDRout), .PCin(PCin), .MDRin(MDRin), .IRin(IRin), .MARin(MARin),
        .Mdatain(Mdatain)
    );

    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

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

    reg [31:0] A_val, shamt, expected;

    task zero_signals;
    begin
        PCout=0; Zlowout=0; Zhighout=0; MDRout=0;
        MARin=0; Zlowin=0; Zhighin=0; PCin=0; MDRin=0; IRin=0; Yin=0;
        IncPC=0; Read=0; opcode=0; Mdatain=0;

        R0out=0; R1out=0; R2out=0; R3out=0; R4out=0; R5out=0; R6out=0; R7out=0; R8out=0; R9out=0; R10out=0; R11out=0; R12out=0; R13out=0; R14out=0; R15out=0;
        HIout=0; LOout=0; InPortout=0; Cout=0; IRout=0; MARout=0;

        R0in=0; R1in=0; R2in=0; R3in=0; R4in=0; R5in=0; R6in=0; R7in=0; R8in=0; R9in=0; R10in=0; R11in=0; R12in=0; R13in=0; R14in=0; R15in=0;
        HIin=0; LOin=0; InPortin=0; Cin=0;
    end
    endtask

    always @(Present_state) begin
        case (Present_state)

            Default: begin
                zero_signals();
                Clear = 1;

                // SHRA test (arithmetic shift right)
                A_val    = 32'hF000_0000;
                shamt    = 32'd4;
                expected = 32'hFF00_0000;
            end

            Reg_load1a: begin
                Clear = 0;
                Mdatain = A_val;
                MDRin = 1;
            end
            Reg_load1b: begin
                MDRin = 0;
                MDRout = 1; R0in = 1;
            end

            Reg_load2a: begin
                MDRout = 0; R0in = 0;
                Mdatain = shamt;
                MDRin = 1;
            end
            Reg_load2b: begin
                MDRin = 0;
                MDRout = 1; R4in = 1;
            end

            // T0..T5 sequence
            T0: begin
                MDRout = 0; R4in = 0;
                PCout = 1; MARin = 1;
                IncPC = 1;
                Zlowin = 1;
            end
            T1: begin
                IncPC = 0; Zlowin = 0;
                PCout = 0; MARin = 0;

                Zlowout = 1;
                PCin = 1;
                Read = 1;
                MDRin = 1;
            end
            T2: begin
                Zlowout = 0; PCin = 0; Read = 0; MDRin = 0;
                MDRout = 1;
                IRin = 1;
            end
            T3: begin
                MDRout = 0; IRin = 0;
                R0out = 1;
                Yin = 1;
            end
            T4: begin
                R0out = 0; Yin = 0;
                R4out = 1;
                opcode = 5'b00101; // SHRA (only difference vs SHR)
                Zlowin = 1;
                Zhighin = 1;
            end
            T5: begin
                R4out = 0;
                Zlowin = 0; Zhighin = 0;

                Zlowout = 1;
                R7in = 1;

                #20 $finish;
            end

        endcase
    end

endmodule