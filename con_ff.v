module con_ff (
    input wire clk,
    input wire reset,
    input wire CONin,              // enable to load CON FF
    input wire [31:0] bus_data,    // value from bus, usually R[Ra]
    input wire [31:0] IR,
    output reg CON                 // latched condition result
);

    reg con_next;
    wire [1:0] c2;

    assign c2 = IR[20:19];   // use the 2 meaningful bits of the C2 field

    always @(*) begin
        case (c2)
            2'b00: con_next = (bus_data == 32'b0);   // brzr
            2'b01: con_next = (bus_data != 32'b0);   // brnz
            2'b10: con_next = (bus_data[31] == 1'b0); // brpl  (>= 0)
            2'b11: con_next = (bus_data[31] == 1'b1); // brmi  (< 0)
            default: con_next = 1'b0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            CON <= 1'b0;
        else if (CONin)
            CON <= con_next;
    end

endmodule
