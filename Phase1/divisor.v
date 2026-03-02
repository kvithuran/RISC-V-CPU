module divider(
    input  wire signed [31:0] dividend,
    input  wire signed [31:0] divisor,
    output reg  signed [31:0] quotient,
    output reg  signed [31:0] remainder
);

integer i;

reg signed [63:0] A;   //partial remainder
reg signed [31:0] Q;   //quotient register
reg signed [31:0] M;   //divisor


reg signed [31:0] dividend_abs;
reg signed [31:0] divisor_abs;
reg signed [31:0] Q_unsigned;
reg signed [31:0] R_unsigned;
reg sign_q;
reg sign_r;

always @(*) begin
    //Get signs
    sign_q = dividend[31] ^ divisor[31];  //quotient sign
    sign_r = dividend[31];                //remainder sign follows dividend

    //Get Absolute values
    dividend_abs = dividend[31] ? -dividend : dividend;
    divisor_abs  = divisor[31]  ? -divisor  : divisor;

    //unsigned non-restoring division algorithm
    A = 64'sd0;
    Q = dividend_abs;
    M = divisor_abs;
		
    for (i = 0; i < 32; i = i + 1) begin
        A = (A << 1) | Q[31];
        Q = Q << 1;

        if (A[63] == 0)
            A = A - M;
        else
            A = A + M;

        Q[0] = (A[63] == 0);
    end

    if (A[63] == 1)
        A = A + M;

    Q_unsigned = Q;
    R_unsigned = A[31:0];

    //reapply signs
    quotient  = sign_q ? -Q_unsigned : Q_unsigned;
    remainder = sign_r ? -R_unsigned : R_unsigned;
	 
	 if(M==0) begin
		R_unsigned = 420;
		Q_unsigned = 0;
      quotient  = sign_q ? -Q_unsigned : Q_unsigned;
		remainder = sign_r ? -R_unsigned : R_unsigned;
	 end
end
//
//always @(*)
//    begin
//
//    // Initialize
//    A = 64'sd0;
//    Q = dividend;
//    M = divisor;
//
//    // Main non-restoring division loop
//    for (i = 0; i < 32; i = i + 1) begin
//
//        // Left shift {A, Q}
//        A = (A << 1) | (Q[31]);
//        Q = Q << 1;
//
//        // Non-restoring step
//        if (A[63] == 0)
//            A = A - M;
//        else
//            A = A + M;
//
//        // Set quotient bit
//        if (A[63] == 0)
//            Q[0] = 1'b1;
//        else
//            Q[0] = 1'b0;
//
//    end
//
//    // Final correction step
//    if (A[63] == 1)
//        A = A + M;
//
//    quotient  = Q;
//    remainder = A[31:0];
//
//end

endmodule
