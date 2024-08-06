`timescale 1ps/1ps

module Ascon_Top #(
// Parameters
    parameter k = 128,
    parameter r = 64,
    parameter a = 12,
    parameter b = 6,
    parameter l = 40,
    parameter y = 40,
    parameter FP = 1
    )(
    input clk,
    input rst,
    input start,
    output encryption_done,
    output decryption_done,
    output message_authenticated
);

    

    // Internal signals
    reg [k-1:0] key = 128'hAABBCCDDEEFF00112233445566778899;
    reg [127:0] nonce = 128'h0123456789ABCDEF0123456789ABCDEF;
    reg [l-1:0] associated_data = 40'h0123456789;
    reg [y-1:0] plain_text = 40'hABCDEF0123;

    wire [y-1:0] cipher_text;
    wire [y-1:0] dec_plain_text;
    wire [127:0] tag;
    wire [127:0] dec_tag;

    // Instantiate the Ascon module
    Ascon #(
        .k(k),
        .r(r),
        .a(a),
        .b(b),
        .l(l),
        .y(y),
        .FP(FP)
    ) uut (
        .clk(clk),
        .rst(rst),
        .key(key),
        .nonce(nonce),
        .associated_data(associated_data),
        .plain_text(plain_text),
        .start(start),
        .cipher_text(cipher_text),
        .dec_plain_text(dec_plain_text),
        .tag(tag),
        .dec_tag(dec_tag),
        .encryption_done(encryption_done),
        .decryption_done(decryption_done),
        .message_authenticated(message_authenticated)
    );

endmodule
