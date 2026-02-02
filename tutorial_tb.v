`timescale 1ns/10ps

module tutorial_tb();
    reg clock, clear, RZout, RAout, RBout, R1out, R2out, RAin, RBin, RZin, R1in, R2in;
    reg [31:0] AddImmediate;
    reg [31:0] RegisterAImmediate;
	 reg [31:0] Register1Immediate;
	 reg [31:0] Register2Immediate;

    reg [3:0] present_state;

    DataPath DP(
        clock, clear,
        AddImmediate,
        RegisterAImmediate,
		  Register1Immediate,
		  Register2Immediate,
        RZout, RAout, RBout, R1out, R2out,
        RAin, RBin, RZin, R1in, R2in
    );

    parameter init = 4'd1, T0 = 4'd2, T1 = 4'd3, T2 = 4'd4;

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
                AddImmediate <= 32'h0;
                RegisterAImmediate <= 32'h0;
					 Register1Immediate <= 32'h0;
                RZout <= 0;RAout <= 0;RBout <= 0;RAin  <= 0;RBin  <= 0;RZin  <= 0;
                #15 clear <= 0;
            end

            // ldi A, 5
            T0: begin
                RegisterAImmediate <= 32'h5; RAin <= 1;
					 
                #15 RegisterAImmediate <= 32'h00; RAin <= 0;
					 Register1Immediate <= 32'h1; R1in <= 1;
					 #15 RegisterAImmediate <= 32'h00; R1in <= 0;
            end

            // add B, A, 5 - 2 steps
            // add value in register A and immediate 5 and then save in Z
            T1: begin
                RAout <= 1;
                AddImmediate <= 32'h5; RZin <= 1;
                #15 RAout <= 0; RZin <= 0;
            end

            // mv B, Z - move value in Z to B
            T2: begin
                RZout <= 1; RBin <= 1;
                #15 RZout <= 0; RBin <= 0;
					 
					 
            end
                

        endcase
    end

endmodule