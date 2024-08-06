`timescale 1ps/1ps

module Ascon #(
    parameter k = 128,  // Key size
    parameter r = 64,   // Rate
    parameter a = 12,   // Initialization round no.
    parameter b = 6,    // Intermediate round no.
    parameter l = 40,   // Length of associated data
    parameter y = 40,   // Length of Plain Text
    parameter FP = 1    // Fault Protection enabled
)(
    input clk,
    input rst,
    input [k-1:0] key,
    input [127:0] nonce,
    input [l-1:0] associated_data,
    input [y-1:0] plain_text,
    input start,
    output reg [y-1:0] cipher_text,
    output reg [y-1:0] dec_plain_text,
    output reg [127:0] tag,
    output reg [127:0] dec_tag,
    output reg encryption_done,
    output reg decryption_done,
    output reg message_authenticated
);

    // Internal signals
    reg encryption_start, decryption_start;
    wire encryption_ready, decryption_ready;
    reg [127:0] random_fault_1, random_fault_2;
    reg [y-1:0] random_fault_3, random_fault_4;
    wire message_authentication;
    reg [y-1:0] internal_cipher_text;
    wire [y-1:0] fc_cipher_text, fc_dec_plain_text;
    wire [127:0] fc_tag, fc_dec_tag;

    // State machine
    reg [1:0] state;
    localparam IDLE = 2'd0, ENCRYPTING = 2'd1, DECRYPTING = 2'd2, AUTHENTICATING = 2'd3;

    // FC instance
    FC #(k, r, a, b, l, y, FP) fc_inst (
        .clk(clk),
        .rst(rst),
        .key(key),
        .nonce(nonce),
        .associated_data(associated_data),
        .plain_text(plain_text),
        .internal_cipher_text(internal_cipher_text),
        .encryption_start(encryption_start),
        .decryption_start(decryption_start),
        .random_fault_1(random_fault_1),
        .random_fault_2(random_fault_2),
        .random_fault_3(random_fault_3),
        .random_fault_4(random_fault_4),
        .cipher_text(fc_cipher_text),
        .dec_plain_text(fc_dec_plain_text),
        .tag(fc_tag),
        .dec_tag(fc_dec_tag),
        .encryption_ready(encryption_ready),
        .decryption_ready(decryption_ready),
        .message_authentication(message_authentication)
    );

    // Control logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            encryption_start <= 0;
            decryption_start <= 0;
            random_fault_1 <= 0;
            random_fault_2 <= 0;
            random_fault_3 <= 0;
            random_fault_4 <= 0;
            internal_cipher_text <= 0;
            cipher_text <= 0;
            dec_plain_text <= 0;
            tag <= 0;
            dec_tag <= 0;
            encryption_done <= 0;
            decryption_done <= 0;
            message_authenticated <= 0;
        end else begin
            case (state)
                IDLE: 
                    if (start) begin
                        state <= ENCRYPTING;
                        encryption_start <= 1;
                    end
                ENCRYPTING:
                    if (encryption_ready) begin
                        state <= DECRYPTING;
                        encryption_start <= 0;
                        decryption_start <= 1;
                        internal_cipher_text <= fc_cipher_text;
                        cipher_text <= fc_cipher_text;
                        tag <= fc_tag;
                        encryption_done <= 1;
                    end
                DECRYPTING:
                    if (decryption_ready) begin
                        state <= AUTHENTICATING;
                        decryption_start <= 0;
                        dec_plain_text <= fc_dec_plain_text;
                        dec_tag <= fc_dec_tag;
                        decryption_done <= 1;
                    end
                AUTHENTICATING:
                    begin
                        state <= IDLE;
                        message_authenticated <= (tag == dec_tag);
                    end
            endcase
        end
    end

    // Debug outputs
    always @(posedge clk) begin
        if (encryption_start) begin
            $display("Ascon: Encryption started with plain_text=%h", plain_text);
        end
        if (encryption_done) begin
            $display("Ascon: Encryption completed. Cipher text=%h", cipher_text);
        end
        if (decryption_start) begin
            $display("Ascon: Decryption started with cipher_text=%h", internal_cipher_text);
        end
        if (decryption_done) begin
            $display("Ascon: Decryption completed. Decrypted text=%h", dec_plain_text);
        end
        if (state == AUTHENTICATING) begin
            $display("Ascon: Authentication result - message_authenticated=%b", message_authenticated);
        end
    end

endmodule
