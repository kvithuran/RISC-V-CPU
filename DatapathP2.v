module DatapathP2(
    input wire clock, clear,
    input wire HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout, IRout, MARout, OutPortout,
    input wire HIin, LOin, Zhighin, Zlowin, PCin, MDRin, InPortin, Cin, IRin, Yin, MARin, OutPortin,
	 input wire CONin,
	output wire CON,
	 input wire read, write, IncPC, Grb, Gra, Grc
	 input wire Rout, Rin, BAout
);

wire R0in,R1in,R2in,R3in,R4in,R5in,R6in,R7in,R8in,R9in,R10in,R11in,R12in,R13in,R14in,R15in;
wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out;

wire [31:0] Mdatain;

//Outputs from each register to go to bus multiplexer.
wire [31:0] BusMuxOut;
wire [31:0] BusMuxInR0;
wire [31:0] BusMuxInR1;
wire [31:0] BusMuxInR2;
wire [31:0] BusMuxInR3;
wire [31:0] BusMuxInR4;
wire [31:0] BusMuxInR5;
wire [31:0] BusMuxInR6;
wire [31:0] BusMuxInR7;
wire [31:0] BusMuxInR8;
wire [31:0] BusMuxInR9;
wire [31:0] BusMuxInR10;
wire [31:0] BusMuxInR11;
wire [31:0] BusMuxInR12;
wire [31:0] BusMuxInR13;
wire [31:0] BusMuxInR14;
wire [31:0] BusMuxInR15;
wire [31:0] BusMuxInHI;
wire [31:0] BusMuxInLO;
wire [31:0] BusMuxInZHI;
wire [31:0] BusMuxInZLO;
wire [31:0] BusMuxInPC; 
wire [31:0] BusMuxInMDR;
wire [31:0] BusMuxInInPort;
wire [31:0] BusMuxInCSignExtended;
wire [31:0] BusMuxInIR;
wire [31:0] BusMuxInMAR;

wire [31:0] YtoALU;

wire [31:0] zhiresult;
wire [31:0] zlowresult;

wire [31:0] AddrToMem;

wire [31:0] DataFromRAM;

wire [31:0] Instruction;
wire [31:0] ToOutputUnit;
wire [31:0] FromInputUnit;

//The registers themselves. Feed in clear to clear anytime, clock for synchronization, R in to allow register to latch value, BusMuxOut to feed into the register (input to register) and BusMuxIn signals defined above to feed to bus multiplexer.
register R0(clear, clock, R0in, BusMuxOut, BusMuxInR0);
register R1(clear, clock, R1in, BusMuxOut, BusMuxInR1);
register R2(clear, clock, R2in, BusMuxOut, BusMuxInR2);
register R3(clear, clock, R3in, BusMuxOut, BusMuxInR3);
register R4(clear, clock, R4in, BusMuxOut, BusMuxInR4);
register R5(clear, clock, R5in, BusMuxOut, BusMuxInR5);
register R6(clear, clock, R6in, BusMuxOut, BusMuxInR6);
register R7(clear, clock, R7in, BusMuxOut, BusMuxInR7);
register R8(clear, clock, R8in, BusMuxOut, BusMuxInR8);
register R9(clear, clock, R9in, BusMuxOut, BusMuxInR9);
register R10(clear, clock, R10in, BusMuxOut, BusMuxInR10);
register R11(clear, clock, R11in, BusMuxOut, BusMuxInR11);
register R12(clear, clock, R12in, BusMuxOut, BusMuxInR12);
register R13(clear, clock, R13in, BusMuxOut, BusMuxInR13);
register R14(clear, clock, R14in, BusMuxOut, BusMuxInR14);
register R15(clear, clock, R15in, BusMuxOut, BusMuxInR15);
register HI(clear, clock, HIin, BusMuxOut, BusMuxInHI);
register LO(clear, clock, LOin, BusMuxOut, BusMuxInLO);
register Zhigh(clear, clock, Zhighin, zhiresult, BusMuxInZHI);
register Zlow(clear, clock, Zlowin, zlowresult, BusMuxInZLO);
register PC(clear, clock, PCin, BusMuxOut, BusMuxInPC);
registerMDR registerMDR(clear, clock, MDRin, read, DataFromRAM, BusMuxOut, BusMuxInMDR);
register InPort(clear, clock, 1'b1, FromInputUnit, BusMuxInInPort);
register OutPort(clear, clock, OutPortin, BusMuxOut, ToOutputUnit);
register CSignExtended(clear, clock, Cin, BusMuxOut, BusMuxInCSignExtended);
register IR(clear, clock, IRin, BusMuxOut, BusMuxInIR);
register Y(clear, clock, Yin, BusMuxOut, YtoALU);
register MAR(clear, clock, MARin, BusMuxOut, AddrToMem);

RAM ram(clock, read, write, AddrToMem[8:0], BusMuxInMDR, DataFromRAM);


//ALU

alu alu(YtoALU, BusMuxOut, BusMuxInIR[31:27], zhiresult, zlowresult);

//CONFF
con_ff CONFF(
    .clk(clock),
    .reset(clear),
    .CONin(CONin),
    .bus_data(BusMuxOut),
    .IR(BusMuxInIR),
    .CON(CON)
);
	
Bus bus( //Mux
    BusMuxInR0, BusMuxInR1, BusMuxInR2, BusMuxInR3, BusMuxInR4, BusMuxInR5, BusMuxInR6, BusMuxInR7, BusMuxInR8, BusMuxInR9, BusMuxInR10, BusMuxInR11, BusMuxInR12, BusMuxInR13, BusMuxInR14, BusMuxInR15, BusMuxInHI, BusMuxInLO, BusMuxInZHI, BusMuxInZLO, BusMuxInPC, BusMuxInMDR, BusMuxInInPort, ignExtended, BusMuxInIR, BusMuxInMAR,
    
	 //Encoder
    R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout, IRout, MARout,

    BusMuxOut);

Select_and_Encode Select_and_Encode(BuxMuxInIR, Gra, Grb, Grc, Rin, Rout, BAout, Cout, 
												R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
												R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, BusMuxInCSignExtended);

endmodule
