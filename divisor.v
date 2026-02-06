module divider(
    input  wire signed [31:0] dividend,
    input  wire signed [31:0] divisor,
    output reg  signed [31:0] quotient,
    output reg  signed [31:0] remainder
);

integer i;

reg signed [63:0] A;   // partial remainder
reg signed [31:0] Q;   // quotient register
reg signed [31:0] M;   // divisor

always @(*)
    begin

    // Initialize
    A = 64'sd0;
    Q = dividend;
    M = divisor;

    // Main non-restoring division loop
    for (i = 0; i < 32; i = i + 1) begin

        // Left shift {A, Q}
        A = (A << 1) | (Q[31]);
        Q = Q << 1;

        // Non-restoring step
        if (A[63] == 0)
            A = A - M;
        else
            A = A + M;

        // Set quotient bit
        if (A[63] == 0)
            Q[0] = 1'b1;
        else
            Q[0] = 1'b0;

    end

    // Final correction step
    if (A[63] == 1)
        A = A + M;

    quotient  = Q;
    remainder = A[31:0];

end

endmodule
