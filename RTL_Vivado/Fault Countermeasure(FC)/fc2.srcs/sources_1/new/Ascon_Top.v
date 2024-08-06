`timescale 1ps/1ps

module Ascon_Top (
    input clk,
    input rst,
    input start,
    output wire encryption_ready,
    output wire decryption_ready,
    output wire message_authentication
);

    // Internal signals for Ascon module
    reg [127:0] key;
    reg [127:0] nonce;
    reg [31:0] associated_data;
    reg [31:0] plain_text;
    wire [31:0] cipher_text;
    wire [31:0] dec_plain_text;
    wire [127:0] tag;
    wire [127:0] dec_tag;

    // Instantiate the Ascon module
    Ascon ascon_inst (
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
        .encryption_ready(encryption_ready),
        .decryption_ready(decryption_ready),
        .message_authentication(message_authentication)
    );

    // Initialization of the internal signals
    initial begin
        key = 128'h0123456789ABCDEF0123456789ABCDEF;
        nonce = 128'hFEDCBA9876543210FEDCBA9876543210;
        associated_data = 32'h12345678;
        plain_text = 32'hABCDEF01;
    end

endmodule
