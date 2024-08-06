`timescale 1ps/1ps
module Ascon (
    input clk,
    input rst,
    input [127:0] key,
    input [127:0] nonce,
    input [31:0] associated_data,
    input [31:0] plain_text,
    input start,
    output wire [31:0] cipher_text,
    output wire [31:0] dec_plain_text,
    output wire [127:0] tag,
    output wire [127:0] dec_tag,
    output wire encryption_ready,
    output wire decryption_ready,
    output wire message_authentication
);
    // Parameters
    parameter k = 128;  // Key size
    parameter r = 128;   // Rate
    parameter a = 12;   // Initialization round no.
    parameter b = 6;    // Intermediate round no.
    parameter l = 40;   // Length of associated data
    parameter y = 40;   // Length of Plain Text
    parameter FP = 1;   // Fault Protection enabled

    // Internal signals
    reg encryption_start, decryption_start;
    reg [127:0] random_fault_1, random_fault_2;
    reg [31:0] random_fault_3, random_fault_4;

    // State machine
    reg [1:0] state;
    localparam IDLE = 2'd0, ENCRYPT = 2'd1, DECRYPT = 2'd2, DONE = 2'd3;

    // FC instance
    FC #(k, r, a, b, l, y, FP) fc_inst (
        .clk(clk),
        .rst(rst),
        .key(key),
        .nonce(nonce),
        .associated_data(associated_data),
        .plain_text(plain_text),
        .encryption_start(encryption_start),
        .decryption_start(decryption_start),
        .random_fault_1(random_fault_1),
        .random_fault_2(random_fault_2),
        .random_fault_3(random_fault_3),
        .random_fault_4(random_fault_4),
        .cipher_text(cipher_text),
        .dec_plain_text(dec_plain_text),
        .tag(tag),
        .dec_tag(dec_tag),
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
            $display("Reset at %t", $time);
        end else begin
            case (state)
                IDLE: 
                    if (start) begin
                        state <= ENCRYPT;
                        encryption_start <= 1;
                        $display("Starting encryption at %t", $time);
                    end
                ENCRYPT:
                    if (encryption_ready) begin
                        state <= DECRYPT;
                        encryption_start <= 0;
                        decryption_start <= 1;
                        $display("Encryption completed, starting decryption at %t", $time);
                        $display("Cipher text: %h", cipher_text);
                        $display("Tag: %h", tag);
                    end
                DECRYPT:
                    if (decryption_ready) begin
                        state <= DONE;
                        decryption_start <= 0;
                        $display("Decryption completed at %t", $time);
                        $display("Decrypted plain text: %h", dec_plain_text);
                        $display("Decrypted tag: %h", dec_tag);
                    end
                DONE:
                    if (!start) begin
                        state <= IDLE;
                        $display("Returning to IDLE state at %t", $time);
                        $display("Message authentication: %b", message_authentication);
                    end
            endcase
        end
    end

endmodule
