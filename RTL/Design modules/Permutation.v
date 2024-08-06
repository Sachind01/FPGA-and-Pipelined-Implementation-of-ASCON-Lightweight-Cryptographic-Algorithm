`timescale 1ps/1ps
module Permutation (
    input           clk,
    input           reset,
    input   [4:0]   ctr,
    input   [319:0] S,
    input   [4:0]   rounds,
    input           start,
    output  [319:0] out,
    output          done
);
    reg [63:0] x0_q, x1_q, x2_q, x3_q, x4_q;
    wire [63:0] x0_d, x1_d, x2_d, x3_d, x4_d;
    reg Done;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            {x0_q, x1_q, x2_q, x3_q, x4_q, Done} <= 321'b0;
        end else if(start) begin
            if(ctr == 0)
                {x0_q, x1_q, x2_q, x3_q, x4_q} <= S;
            else begin
                x0_q <= x0_d;
                x1_q <= x1_d;
                x2_q <= x2_d;
                x3_q <= x3_d;
                x4_q <= x4_d;
            end
            Done <= (ctr == rounds - 1);
        end
    end

    assign done = Done;
    assign out = {x0_q, x1_q, x2_q, x3_q, x4_q};

    wire [63:0] rc_out;
    roundconstant u0(
        .x2(x2_q),
        .ctr(ctr),
        .out(rc_out),
        .rounds(rounds)
    );

    wire [63:0] sl0, sl1, sl2, sl3, sl4;
    sub_layer u1(
        .x0(x0_q), .x1(x1_q), .x2(rc_out), .x3(x3_q), .x4(x4_q),
        .sl0(sl0), .sl1(sl1), .sl2(sl2), .sl3(sl3), .sl4(sl4) 
    );

    linear_layer u2(
        .X0(sl0), .X1(sl1), .X2(sl2), .X3(sl3), .X4(sl4),
        .Y0(x0_d), .Y1(x1_d), .Y2(x2_d), .Y3(x3_d), .Y4(x4_d) 
    );
endmodule
