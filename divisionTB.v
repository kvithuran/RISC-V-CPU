`timescale 1ns/10ps

module division_tb();

    reg clock, clear;
    reg RZout, RAout, RBout, R1out, R2out, RYout;
    reg RAin, RBin, RZin, R1in, R2in, RYin;

    reg [31:0] RegisterAImmediate;
    reg [31:0] RegisterBImmediate;

    reg [3:0] present_state;

    DataPath DP(
    .clock(clock),
    .clear(clear),

    .RegisterAImmediate(RegisterAImmediate),
    .RegisterBImmediate(RegisterBImmediate),

    .RAout(RAout),
    .RBout(RBout),
    .RZout(RZout),
    .R1out(R1out),
    .R2out(R2out),
    .RYout(RYout),

    .RAin(RAin),
    .RBin(RBin),
    .RZin(RZin),
    .R1in(R1in),
    .R2in(R2in),
    .RYin(RYin)
);


    parameter init = 4'd1, 
              T0   = 4'd2, 
              T1   = 4'd3, 
              T2   = 4'd4, 
              T3   = 4'd5, 
              T4   = 4'd6;

    initial begin
        clock = 0;
		  clear = 0;
		  RZout = 0; RAout = 0; RBout = 0;
		  R1out = 0; R2out = 0; RYout = 0;
		  RAin = 0; RBin = 0; RZin = 0;
		  R1in = 0; R2in = 0; RYin = 0;
		  
		  RegisterAImmediate = 0;
		  RegisterBImmediate = 0;
        present_state = 4'd0;
    end

    always #10 clock = ~clock;
    always @(negedge clock) present_state = present_state + 1;

    always @(present_state) begin
        case (present_state)

            init: begin
                clear <= 1;
                RegisterAImmediate <= 32'd0;
                RegisterBImmediate <= 32'd0;

                RAout <= 0; RBout <= 0; R1out <= 0; R2out <= 0; RZout <= 0; RYout <= 0;
                RAin  <= 0; RBin  <= 0; R1in  <= 0; R2in  <= 0; RZin  <= 0; RYin  <= 0;

                #15 clear <= 0;
            end

            // ldi A, 20
            T0: begin
                RegisterAImmediate <= 32'd20; 
                RAin <= 1;
                #15 RAin <= 0;
            end

            // ldi B, 4
            T1: begin
                RegisterBImmediate <= 32'd4; 
                RBin <= 1;
                #15 RBin <= 0;
            end

            // div Z, A, B
            T2: begin
                RAout <= 1;
                RBout <= 1;
                RZin  <= 1;   // quotient
                RYin  <= 1;   // remainder
                #15 RAout <= 0; RBout <= 0; RZin <= 0; RYin <= 0;
            end

            // mv C, Z  (save quotient)
            T3: begin
                RZout <= 1; 
                R1in  <= 1;
                #15 RZout <= 0; R1in <= 0;
            end

            // mv D, Y (save remainder)
            T4: begin
                RYout <= 1; 
                R2in  <= 1;
                #15 RYout <= 0; R2in <= 0;
            end

        endcase
    end

endmodule
