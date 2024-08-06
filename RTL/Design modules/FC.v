`timescale 1ps/1ps
module FC #(
    parameter k = 128,            // Key size
    parameter r = 64,             // Rate
    parameter a = 12,             // Initialization round no.
    parameter b = 6,              // Intermediate round no.
    parameter l = 40,             // Length of associated data
    parameter y = 40,             // Length of Plain Text
    parameter FP = 1              // Fault Protection enabled (1) or disabled (0)
)(
    input           clk,
    input           rst,
    input  [k-1:0]  key,
    input  [127:0]  nonce,
    input  [l-1:0]  associated_data,
    input  [y-1:0]  plain_text,
    input  [y-1:0]  internal_cipher_text,  // New input for internal cipher text
    input           encryption_start,
    input           decryption_start,
    input  [127:0]  random_fault_1, random_fault_2,
    input  [y-1:0]  random_fault_3, random_fault_4,
    output [y-1:0]  cipher_text,            // Plain text converted to cipher text
    output [y-1:0]  dec_plain_text,         // Decrypted Text
    output [127:0]  tag,                    // Final Tag after Encryption
    output [127:0]  dec_tag,                // Tag after Decryption
    output          encryption_ready,       // To indicate the end of Encryption
    output          decryption_ready,       // To indicate the end of Decryption
    output          message_authentication  // Indicates whether the message is authenticated
);
   
    reg authentication_reg;
   
    //when fault protection is high
    if(FP == 1) begin
        wire [y-1:0] c1, c2, c3, p1, p2, p3;
        wire [127:0] tag1, tag2, tag3, tag4, tag5, tag6;
        wire er1, er2, er3, dr1, dr2, dr3;
        wire fault_detect;
       
        Encryption #(k,r,a,b,l,y) d1 (
            clk, rst, key, nonce, associated_data, plain_text, encryption_start,
            c1, tag1, er1
        );
       
        Encryption #(k,r,a,b,l,y) d2 (
            clk, rst, key, nonce, associated_data, plain_text, encryption_start,
            c2, tag2, er2
        );
       
        Encryption #(k,r,a,b,l,y) d3 (
            clk, rst, key, nonce, associated_data, plain_text, encryption_start,
            c3, tag3, er3
        );
       
        Decryption #(k,r,a,b,l,y) d4 (
            clk, rst, key, nonce, associated_data, internal_cipher_text, decryption_start,
            p1, tag4, dr1
        );
       
        Decryption #(k,r,a,b,l,y) d5 (
            clk, rst, key, nonce, associated_data, internal_cipher_text, decryption_start,
            p2, tag5, dr2
        );
       
        Decryption #(k,r,a,b,l,y) d6 (
            clk, rst, key, nonce, associated_data, internal_cipher_text, decryption_start,
            p3, tag6, dr3
        );
       
        assign fault_detect = (c1 == c2 || c2 == c3) ? 1 : 0;
   
        // Bitwise Majority function
        assign cipher_text = (c1 == c2 || c2 == c3) ? (c1 & c2) | (c2 & c3) | (c1 & c3) : random_fault_3;
        assign dec_plain_text = (p1 == p2 || p2 == p3) ? (p1 & p2) | (p2 & p3) | (p1 & p3) : random_fault_4;
        assign tag = (tag1 == tag2 || tag2 == tag3) ? (tag1 & tag2) | (tag2 & tag3) | (tag1 & tag3) : random_fault_1;
        assign dec_tag = (tag4 == tag5 || tag5 == tag6) ? (tag4 & tag5) | (tag5 & tag6) | (tag4 & tag6) : random_fault_2;
        assign encryption_ready = (er1 & er2) | (er2 & er3) | (er1 & er3);
        assign decryption_ready = (dr1 & dr2) | (dr2 & dr3) | (dr1 & dr3);
        
        // Handle message authentication within the FC module
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                authentication_reg <= 0;
            end else if (encryption_ready & decryption_ready) begin
                authentication_reg <= (tag == dec_tag);
            end
        end

        assign message_authentication = authentication_reg;

     
        // Debug outputs
        always @(posedge clk) begin
            if (encryption_start) begin
                $display("FC: Encryption started with plain_text=%h", plain_text);
            end
            if (encryption_ready) begin
                $display("FC: Encryption results: c1=%h, c2=%h, c3=%h", c1, c2, c3);
                $display("FC: Encryption tags: tag1=%h, tag2=%h, tag3=%h", tag1, tag2, tag3);
                $display("FC: Final cipher_text=%h, tag=%h", cipher_text, tag);
            end
            if (decryption_start) begin
                $display("FC: Decryption started with internal_cipher_text=%h", internal_cipher_text);
            end
            if (decryption_ready) begin
                $display("FC: Decryption results: p1=%h, p2=%h, p3=%h", p1, p2, p3);
                $display("FC: Decryption tags: tag4=%h, tag5=%h, tag6=%h", tag4, tag5, tag6);
                $display("FC: Final dec_plain_text=%h, dec_tag=%h", dec_plain_text, dec_tag);
            end
        end
       
    end
   
    //when fault protection is low
    else begin
        Encryption #(k,r,a,b,l,y) d1 (
            clk, rst, key, nonce, associated_data, plain_text, encryption_start,
            cipher_text, tag, encryption_ready
        );
        Decryption #(k,r,a,b,l,y) d2 (
            clk, rst, key, nonce, associated_data, internal_cipher_text, decryption_start,
            dec_plain_text, dec_tag, decryption_ready
        );
        
        // Handle message authentication within the FC module
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                authentication_reg <= 0;
            end else if (encryption_ready & decryption_ready) begin
                authentication_reg <= (tag == dec_tag);
            end
        end

        assign message_authentication = authentication_reg;
       
        // Debug outputs
        always @(posedge clk) begin
            if (encryption_ready)
                $display("Encryption result: cipher_text=%h, tag=%h", cipher_text, tag);
            if (decryption_ready)
                $display("Decryption result: dec_plain_text=%h, dec_tag=%h", dec_plain_text, dec_tag);
        end
    end
   
       
endmodule