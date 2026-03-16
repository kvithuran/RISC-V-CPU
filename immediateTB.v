`timescale 1ns/10ps

module tb_DataPathP2_ALUImmediate;

    reg clock, clear;
    reg [4:0] opcode;
    reg HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout, IRout, MARout, OutPortout;
    reg HIin, LOin, Zhighin, Zlowin, PCin, MDRin, InPortin, Cin, IRin, Yin, MARin, OutPortin;
    reg  CONin;
    wire CON;
    reg read, write, IncPC, Grb, Gra, Grc;

    
    DataPathP2 DPTest (
        .clock(clock),      .clear(clear),
        .opcode(opcode),
        .HIout(HIout),      .LOout(LOout),      .Zhighout(Zhighout), .Zlowout(Zlowout),
        .PCout(PCout),      .MDRout(MDRout),    .InPortout(InPortout),.Cout(Cout),
        .IRout(IRout),      .MARout(MARout),    .OutPortout(OutPortout),
        .HIin(HIin),        .LOin(LOin),        .Zhighin(Zhighin),   .Zlowin(Zlowin),
        .PCin(PCin),        .MDRin(MDRin),      .InPortin(InPortin), .Cin(Cin),
        .IRin(IRin),        .Yin(Yin),          .MARin(MARin),       .OutPortin(OutPortin),
        .CONin(CONin),      .CON(CON),
        .read(read),        .write(write),      .IncPC(IncPC),
        .Grb(Grb),          .Gra(Gra),          .Grc(Grc)
    );

    initial clock = 0;
    always #5 clock = ~clock;
    task clear_signals;
    begin
        opcode     = 5'b00000;
        HIout=0;  LOout=0;  Zhighout=0; Zlowout=0;
        PCout=0;  MDRout=0; InPortout=0; Cout=0;
        IRout=0;  MARout=0; OutPortout=0;
        HIin=0;   LOin=0;   Zhighin=0;  Zlowin=0;
        PCin=0;   MDRin=0;  InPortin=0; Cin=0;
        IRin=0;   Yin=0;    MARin=0;    OutPortin=0;
        CONin=0;
        read=0;   write=0;  IncPC=0;
        Grb=0;    Gra=0;    Grc=0;
    end
    endtask

    task tick;
    begin
        @(posedge clock); #1;
        clear_signals;
    end
    endtask

    localparam ADD = 5'b00011;
    localparam AND = 5'b00100;
    localparam OR  = 5'b00101;

    // ----------------------------------------------------------------
    // Task: T0-T2  Instruction Fetch (identical for every instruction)
    //
    //   T0 : PCout, MARin, IncPC, Zin
    //        - PC drives the bus -> MAR latches the current PC value
    //        - PC+1 result captured in Zhigh/Zlow
    //   T1 : Zlowout, PCin, Read, MDRin
    //        - Incremented PC written back from Zlow
    //        - Memory read issued; MDR latches word from RAM[MAR]
    //   T2 : MDRout, IRin
    //        - MDR drives the bus -> IR latches the fetched instruction
    // ----------------------------------------------------------------
    task instruction_fetch;
    begin
        // ----- T0 -----
        @(negedge clock);
        PCout   = 1;
        MARin   = 1;
        IncPC   = 1;
        Zhighin = 1;
        Zlowin  = 1;
        $display("  T0 : PCout=1, MARin=1, IncPC=1, Zin -> PC->MAR, PC+1->Z");
        tick;

        // ----- T1 -----
        @(negedge clock);
        Zlowout = 1;
        PCin    = 1;
        read    = 1;
        MDRin   = 1;
        $display("  T1 : Zlowout=1, PCin=1, Read=1, MDRin=1 -> PC updated, RAM[MAR]->MDR");
        tick;

        // ----- T2 -----
        @(negedge clock);
        MDRout = 1;
        IRin   = 1;
        $display("  T2 : MDRout=1, IRin=1 -> MDR->IR (instruction latched)");
        tick;
    end
    endtask

    // ----------------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------------
    initial begin
        $display("=====================================================");
        $display("  TB: ALU Immediate Instructions - addi / andi / ori");
        $display("=====================================================");

        // ----- Global reset -----
        clear_signals;
        clear = 1;
        @(posedge clock); #1;
        clear = 0;
        $display("Reset released.\n");

        // =================================================================
        //  TEST 1 :  addi R7, R4, -9
        //
        //  RAM[PC] must hold the encoded addi instruction.
        //  Select_and_Encode decodes IR to drive C = sign_extend(-9) = 0xFFFFFFF7,
        //  Grb selects R4 as source, Gra selects R7 as destination.
        //  Expected: R7 = R4 + (-9)
        //  (With R4=0 after reset: R7 = 0xFFFFFFF7)
        // =================================================================
        $display("=====================================================");
        $display(" TEST 1 : addi R7, R4, -9");
        $display("=====================================================");

        $display("[Instruction Fetch]");
        instruction_fetch;

        // -- T3 : Grb, Rout (R4->bus), Yin --
        @(negedge clock);
        Grb = 1;
        Yin = 1;
        $display("  T3 : Grb=1, Yin=1 -> R4 on bus, latched into Y");
        tick;

        // -- T4 : Cout, ADD, Zin --
        @(negedge clock);
        Cout    = 1;
        opcode  = ADD;
        Zhighin = 1;
        Zlowin  = 1;
        $display("  T4 : Cout=1, opcode=ADD, Zhighin=1, Zlowin=1 -> ALU: Y+C -> Z");
        tick;

        // -- T5 : Zlowout, Gra, Rin (R7 <- Zlow) --
        @(negedge clock);
        Zlowout = 1;
        Gra     = 1;
        $display("  T5 : Zlowout=1, Gra=1 -> Zlow written to R7");
        tick;

        $display("  >> addi DONE. Expected R7 = 0xFFFFFFF7 (if R4=0)\n");

        // =================================================================
        //  TEST 2 :  andi R7, R4, 0x71
        //
        //  C = sign_extend(0x71) = 0x00000071
        //  Expected: R7 = R4 & 0x00000071
        //  (With R4=0 after reset: R7 = 0x00000000)
        // =================================================================
        $display("=====================================================");
        $display(" TEST 2 : andi R7, R4, 0x71");
        $display("=====================================================");

        $display("[Instruction Fetch]");
        instruction_fetch;

        @(negedge clock);
        Grb = 1;
        Yin = 1;
        $display("  T3 : Grb=1, Yin=1 -> R4 -> Y");
        tick;

        @(negedge clock);
        Cout    = 1;
        opcode  = AND;
        Zhighin = 1;
        Zlowin  = 1;
        $display("  T4 : Cout=1, opcode=AND, Zin -> ALU: Y & C -> Z");
        tick;

        @(negedge clock);
        Zlowout = 1;
        Gra     = 1;
        $display("  T5 : Zlowout=1, Gra=1 -> Zlow written to R7");
        tick;

        $display("  >> andi DONE. Expected R7 = R4 & 0x71\n");

        // =================================================================
        //  TEST 3 :  ori R7, R4, 0x71
        //
        //  C = sign_extend(0x71) = 0x00000071
        //  Expected: R7 = R4 | 0x00000071
        //  (With R4=0 after reset: R7 = 0x00000071)
        // =================================================================
        $display("=====================================================");
        $display(" TEST 3 : ori R7, R4, 0x71");
        $display("=====================================================");

        $display("[Instruction Fetch]");
        instruction_fetch;

        @(negedge clock);
        Grb = 1;
        Yin = 1;
        $display("  T3 : Grb=1, Yin=1 -> R4 -> Y");
        tick;

        @(negedge clock);
        Cout    = 1;
        opcode  = OR;
        Zhighin = 1;
        Zlowin  = 1;
        $display("  T4 : Cout=1, opcode=OR, Zin -> ALU: Y | C -> Z");
        tick;

        @(negedge clock);
        Zlowout = 1;
        Gra     = 1;
        $display("  T5 : Zlowout=1, Gra=1 -> Zlow written to R7");
        tick;

        $display("  >> ori DONE. Expected R7 = R4 | 0x71\n");

        // =================================================================
        $display("=====================================================");
        $display(" All tests applied. Verify results in waveform/console.");
        $display("=====================================================");
        #20;
        $finish;
    end

    // ----------------------------------------------------------------
    // Waveform dump
    // ----------------------------------------------------------------
    initial begin
        $dumpfile("tb_DataPathP2_ALUImmediate.vcd");
        $dumpvars(0, tb_DataPathP2_ALUImmediate);
    end

endmodule