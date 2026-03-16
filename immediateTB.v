//// =============================================================================
//// immediateTB.v
////
//// Testbench for Section 3.3 – ALU Immediate Instructions
////   Test 1:  addi R7, R4, -9       expected R7 = R4 + (-9)  = 91
////   Test 2:  andi R7, R4, 0x71     expected R7 = R4 & 0x71  = 96  (0x60)
////   Test 3:  ori  R7, R4, 0x71     expected R7 = R4 | 0x71  = 117 (0x75)
////
//// How it works:
////   - The instruction word is pre-loaded into RAM[0] via $deposit.
////   - T0-T2 fetch it: RAM -> MDR -> IR.
////   - IR[31:27] feeds the ALU opcode directly (alu alu(YtoALU, BusMuxOut, BusMuxInIR[31:27], ...))
////   - Select_and_Encode decodes Ra/Rb from IR[26:23] / IR[22:19].
////   - Cout puts the sign-extended IR[18:0] immediate onto the bus in T4.
////   - No external opcode driving needed at all.
////
//// Instruction word layout: { opcode[4:0], Ra[3:0], Rb[3:0], C[18:0] }
////
//// ALU opcodes (from alu.v):
////   addi = 5'b01001   (Add immediate)
////   andi = 5'b01010   (And immediate)
////   ori  = 5'b01011   (OR  immediate)
////
//// Control sequence (lab spec):
////   T0 : PCout, MARin, IncPC, Zin
////   T1 : Zlowout, PCin, Read, MDRin
////   T2 : MDRout, IRin
////   T3 : Grb, Rout, Yin
////   T4 : Cout, Zin
////   T5 : Zlowout, Gra, Rin
////
//// Required change to DatapathP2.v (if not done already):
////   1. Add  input wire Rin, Rout, BAout  to the port list.
////   2. Pass them into the Select_and_Encode instantiation.
////   3. Fix the alu line to:
////        alu alu(YtoALU, BusMuxOut, BusMuxInIR[31:27], zhiresult, zlowresult);
////   4. Fix  ignExtended  ->  BusMuxInCSignExtended  in the Bus instantiation.
//// =============================================================================
//
//`timescale 1ns/1ps
//
//module immediateTB;
//
//    // ------------------------------------------------------------------ //
//    //  DUT port signals
//    // ------------------------------------------------------------------ //
//    reg  clock, clear;
//
//    // Bus output enables
//    reg  HIout, LOout, Zhighout, Zlowout, PCout, MDRout;
//    reg  InPortout, Cout, IRout, MARout, OutPortout;
//
//    // Register load enables
//    reg  HIin, LOin, Zhighin, Zlowin, PCin, MDRin;
//    reg  InPortin, Cin, IRin, Yin, MARin, OutPortin;
//
//    // CON FF
//    reg  CONin;
//    wire CON;
//
//    // Memory / PC
//    reg  read, write, IncPC;
//
//    // Select-and-Encode controls
//    reg  Gra, Grb, Grc;
//    reg  Rin, Rout, BAout;
//
//    // ------------------------------------------------------------------ //
//    //  Instruction word encoding:  { opcode[4:0], Ra[3:0], Rb[3:0], C[18:0] }
//    //
//    //  ALU opcodes from alu.v:
//    //    5'b01001 = Add immediate (addi)
//    //    5'b01010 = And immediate (andi)
//    //    5'b01011 = OR  immediate (ori)
//    // ------------------------------------------------------------------ //
//    localparam [4:0] OP_ADDI = 5'b01001;
//    localparam [4:0] OP_ANDI = 5'b01010;
//    localparam [4:0] OP_ORI  = 5'b01011;
//
//    localparam [3:0] REG_R7 = 4'd7;   // Ra = R7  (destination)
//    localparam [3:0] REG_R4 = 4'd4;   // Rb = R4  (source)
//
//    // -9 in 19-bit two's complement
//    localparam [18:0] IMM_NEG9 = 19'h7FFF7;
//    // 0x71 fits directly in 19 bits
//    localparam [18:0] IMM_71   = 19'h00071;
//
//    localparam [31:0] INSTR_ADDI = {OP_ADDI, REG_R7, REG_R4, IMM_NEG9};
//    localparam [31:0] INSTR_ANDI = {OP_ANDI, REG_R7, REG_R4, IMM_71};
//    localparam [31:0] INSTR_ORI  = {OP_ORI,  REG_R7, REG_R4, IMM_71};
//
//    // ------------------------------------------------------------------ //
//    //  DUT instantiation
//    // ------------------------------------------------------------------ //
//    DatapathP2 DUT (
//        .clock      (clock),
//        .clear      (clear),
//        .HIout      (HIout),      .LOout      (LOout),
//        .Zhighout   (Zhighout),   .Zlowout    (Zlowout),
//        .PCout      (PCout),      .MDRout     (MDRout),
//        .InPortout  (InPortout),  .Cout       (Cout),
//        .IRout      (IRout),      .MARout     (MARout),
//        .OutPortout (OutPortout),
//        .HIin       (HIin),       .LOin       (LOin),
//        .Zhighin    (Zhighin),    .Zlowin     (Zlowin),
//        .PCin       (PCin),       .MDRin      (MDRin),
//        .InPortin   (InPortin),   .Cin        (Cin),
//        .IRin       (IRin),       .Yin        (Yin),
//        .MARin      (MARin),      .OutPortin  (OutPortin),
//        .CONin      (CONin),      .CON        (CON),
//        .read       (read),       .write      (write),
//        .IncPC      (IncPC),
//        .Gra        (Gra),        .Grb        (Grb),        .Grc    (Grc),
//        .Rin        (Rin),        .Rout       (Rout),       .BAout  (BAout)
//    );
//
//    // ------------------------------------------------------------------ //
//    //  Clock: 10 ns period
//    // ------------------------------------------------------------------ //
//    initial clock = 0;
//    always #5 clock = ~clock;
//
//    // ------------------------------------------------------------------ //
//    //  Task: de-assert every control signal
//    // ------------------------------------------------------------------ //
//    task all_off;
//        begin
//            HIout=0; LOout=0; Zhighout=0; Zlowout=0; PCout=0; MDRout=0;
//            InPortout=0; Cout=0; IRout=0; MARout=0; OutPortout=0;
//            HIin=0; LOin=0; Zhighin=0; Zlowin=0; PCin=0; MDRin=0;
//            InPortin=0; Cin=0; IRin=0; Yin=0; MARin=0; OutPortin=0;
//            CONin=0; read=0; write=0; IncPC=0;
//            Gra=0; Grb=0; Grc=0;
//            Rin=0; Rout=0; BAout=0;
//        end
//    endtask
//
//    // ------------------------------------------------------------------ //
//    //  Task: advance one clock cycle
//    // ------------------------------------------------------------------ //
//    task tick;
//        begin
//            @(posedge clock); #1;
//        end
//    endtask
//
//    // ------------------------------------------------------------------ //
//    //  Task: T0-T2 instruction fetch
//    //    T0: PCout, MARin, IncPC, Zin
//    //    T1: Zlowout, PCin, Read, MDRin
//    //    T2: MDRout, IRin
//    // ------------------------------------------------------------------ //
//    task instruction_fetch;
//        begin
//            // T0
//            all_off;
//            PCout=1; MARin=1; IncPC=1; Zhighin=1; Zlowin=1;
//            tick;
//
//            // T1
//            all_off;
//            Zlowout=1; PCin=1; read=1; MDRin=1;
//            tick;
//
//            // T2
//            all_off;
//            MDRout=1; IRin=1;
//            tick;
//
//            all_off;
//        end
//    endtask
//
//    // ------------------------------------------------------------------ //
//    //  Task: T3-T5 execute for addi / andi / ori
//    //    T3: Grb, Rout, Yin        -- Rb (R4) -> bus -> Y
//    //    T4: Cout, Zin             -- sign-ext(C) -> bus; ALU(Y op C) -> Z
//    //    T5: Zlowout, Gra, Rin     -- Zlow -> bus -> Ra (R7)
//    //
//    //  IR[31:27] drives the ALU opcode automatically.
//    //  Select_and_Encode uses IR[26:23]/IR[22:19] for Ra/Rb automatically.
//    // ------------------------------------------------------------------ //
//    task execute_alu_imm;
//        begin
//            // T3: Grb, Rout, Yin
//            all_off;
//            Grb=1; Rout=1; Yin=1;
//            tick;
//
//            // T4: Cout, Zin
//            all_off;
//            Cout=1; Zhighin=1; Zlowin=1;
//            tick;
//
//            // T5: Zlowout, Gra, Rin
//            all_off;
//            Zlowout=1; Gra=1; Rin=1;
//            tick;
//
//            all_off;
//        end
//    endtask
//
//    // ------------------------------------------------------------------ //
//    //  MAIN TEST SEQUENCE
//    // ------------------------------------------------------------------ //
//    initial begin
//        $dumpfile("immediateTB.vcd");
//        $dumpvars(0, immediateTB);
//
//        // Reset
//        all_off;
//        clear = 1;
//        repeat(2) @(posedge clock); #1;
//        clear = 0;
//
//        // Pre-load R4 = 100 (0x64) as the source register value
//        $deposit(DUT.R4.q, 32'd100);
//        // Start PC at address 0
//        $deposit(DUT.PC.q, 32'd0);
//        @(posedge clock); #1;
//
//        // ==============================================================
//        // TEST 1: addi R7, R4, -9
//        //   IR[31:27] = 5'b01001  ->  ALU does Add immediate
//        //   Y = R4 = 100
//        //   Bus = sign_ext(-9) = 0xFFFFFFF7
//        //   Z = 100 + (-9) = 91
//        //   expected R7 = 91
//        // ==============================================================
//        $display("==============================================");
//        $display("TEST 1: addi R7, R4, -9");
//        $display("  Encoded instruction = 0x%08h", INSTR_ADDI);
//        $display("  IR[31:27] will be   = 5'b%05b (Add immediate)", OP_ADDI);
//        $display("  R4 = %0d,  immediate = -9", $signed(DUT.BusMuxInR4));
//
//        $deposit(DUT.ram.RAM1[0], INSTR_ADDI);
//        $deposit(DUT.PC.q, 32'd0);
//
//        instruction_fetch;
//        execute_alu_imm;
//
//        @(posedge clock); #1;
//        $display("  R7 = %0d  (expected 91)", $signed(DUT.BusMuxInR7));
//        if ($signed(DUT.BusMuxInR7) === 32'sd91)
//            $display("  >> PASS");
//        else
//            $display("  >> FAIL (got 0x%08h = %0d)",
//                     DUT.BusMuxInR7, $signed(DUT.BusMuxInR7));
//
//        // ==============================================================
//        // TEST 2: andi R7, R4, 0x71
//        //   IR[31:27] = 5'b01010  ->  ALU does And immediate
//        //   Y = R4 = 100 = 0x64
//        //   Bus = sign_ext(0x71) = 0x00000071
//        //   Z = 0x64 & 0x71 = 0x60 = 96
//        //   expected R7 = 96
//        // ==============================================================
//        $display("==============================================");
//        $display("TEST 2: andi R7, R4, 0x71");
//        $display("  Encoded instruction = 0x%08h", INSTR_ANDI);
//        $display("  IR[31:27] will be   = 5'b%05b (And immediate)", OP_ANDI);
//        $display("  R4 = 0x%h = %0d,  immediate = 0x71",
//                 DUT.BusMuxInR4, DUT.BusMuxInR4);
//
//        $deposit(DUT.ram.RAM1[0], INSTR_ANDI);
//        $deposit(DUT.PC.q, 32'd0);
//
//        instruction_fetch;
//        execute_alu_imm;
//
//        @(posedge clock); #1;
//        $display("  R7 = 0x%h = %0d  (expected 0x60 = 96)",
//                 DUT.BusMuxInR7, DUT.BusMuxInR7);
//        if (DUT.BusMuxInR7 === 32'h60)
//            $display("  >> PASS");
//        else
//            $display("  >> FAIL (got 0x%08h)", DUT.BusMuxInR7);
//
//        // ==============================================================
//        // TEST 3: ori R7, R4, 0x71
//        //   IR[31:27] = 5'b01011  ->  ALU does OR immediate
//        //   Y = R4 = 100 = 0x64
//        //   Bus = sign_ext(0x71) = 0x00000071
//        //   Z = 0x64 | 0x71 = 0x75 = 117
//        //   expected R7 = 117
//        // ==============================================================
//        $display("==============================================");
//        $display("TEST 3: ori R7, R4, 0x71");
//        $display("  Encoded instruction = 0x%08h", INSTR_ORI);
//        $display("  IR[31:27] will be   = 5'b%05b (OR immediate)", OP_ORI);
//        $display("  R4 = 0x%h = %0d,  immediate = 0x71",
//                 DUT.BusMuxInR4, DUT.BusMuxInR4);
//
//        $deposit(DUT.ram.RAM1[0], INSTR_ORI);
//        $deposit(DUT.PC.q, 32'd0);
//
//        instruction_fetch;
//        execute_alu_imm;
//
//        @(posedge clock); #1;
//        $display("  R7 = 0x%h = %0d  (expected 0x75 = 117)",
//                 DUT.BusMuxInR7, DUT.BusMuxInR7);
//        if (DUT.BusMuxInR7 === 32'h75)
//            $display("  >> PASS");
//        else
//            $display("  >> FAIL (got 0x%08h)", DUT.BusMuxInR7);
//
//        $display("==============================================");
//        $display("Simulation complete.");
//        #20;
//        $finish;
//    end
//
//    // ------------------------------------------------------------------ //
//    //  Cycle-by-cycle monitor
//    // ------------------------------------------------------------------ //
//    always @(posedge clock) begin
//        $display("[t=%4t] PC=%0d MAR=%0d MDR=%08h IR=%08h | Y=%0d ZLO=%0d | R4=%0d R7=%0d",
//            $time,
//            DUT.BusMuxInPC,
//            DUT.AddrToMem,
//            DUT.BusMuxInMDR,
//            DUT.BusMuxInIR,
//            $signed(DUT.YtoALU),
//            $signed(DUT.BusMuxInZLO),
//            $signed(DUT.BusMuxInR4),
//            $signed(DUT.BusMuxInR7));
//    end
//
//endmodule
