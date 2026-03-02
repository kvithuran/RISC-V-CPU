`timescale 1ns/10ps

module division_tb();

    reg clock, clear;
    reg RAout, RBout, R1out, R2out, RZout, R3out;
    reg RAin,  RBin,  RCin,  RDin,  RZin,  RYin;

    reg [31:0] RegisterAImmediate;
    reg [31:0] RegisterBImmediate;

    reg [3:0] present_state;

    DataPath DP(
        clock, clear,
        RegisterAImmediate,
        RegisterBImmediate,
        RAout, RBout, R1out, R2out, RZout, R3out,
        RAin, RBin, RCin, RDin, RZin, RYin
    );

    parameter init = 4'd1, 
              T0   = 4'd2, 
              T1   = 4'd3, 
              T2   = 4'd4, 
              T3   = 4'd5, 
              T4   = 4'd6;

    initial begin
        clock = 0;
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

                RAout <= 0; RBout <= 0; R1out <=20; RDout <= 0; RZout <= 0; R3out <= 0;
                RAin  <= 0; RBin  <= 0; RCin  <= 0; RDin  <= 0; RZin  <= 0; RYin  <= 0;

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
                RCin  <= 1;
                #15 RZout <= 0; RCin <= 0;
            end

            // mv D, Y (save remainder)
            T4: begin
                R3out <= 1; 
                RDin  <= 1;
                #15 R3out <= 0; RDin <= 0;
            end

        endcase
    end

endmodule
