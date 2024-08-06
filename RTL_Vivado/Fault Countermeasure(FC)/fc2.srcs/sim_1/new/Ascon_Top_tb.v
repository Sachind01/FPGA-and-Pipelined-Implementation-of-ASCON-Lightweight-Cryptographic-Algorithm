`timescale 1ns/1ps

module ASCON_Top_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // 100 MHz clock

    // Inputs
    reg clk;
    reg rst;
    reg [127:0] key;
    reg [127:0] nonce;
    reg [31:0] associated_data;
    reg [31:0] plain_text;
    reg start;

    // Outputs
    wire [31:0] cipher_text;
    wire [31:0] dec_plain_text;
    wire [127:0] tag;
    wire [127:0] dec_tag;
    wire encryption_ready;
    wire decryption_ready;
    wire message_authentication;

    // Instantiate the Unit Under Test (UUT)
    ASCON_Top uut (
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

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Test procedure
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        key = 128'h0123456789ABCDEF0123456789ABCDEF;
        nonce = 128'hFEDCBA9876543210FEDCBA9876543210;
        associated_data = 32'h12345678;
        plain_text = 32'hABCDEF01;
        start = 0;

        // Reset
        #(CLK_PERIOD*10);
        rst = 0;
        #(CLK_PERIOD*10);

        // Start the process
        start = 1;
        #(CLK_PERIOD*2);
        start = 0;

        // Wait for encryption and decryption to complete
        wait(uut.state == uut.DONE);
        #(CLK_PERIOD*10);

        // Display results
        $display("Encryption/Decryption completed");
        $display("Plain Text:    %h", plain_text);
        $display("Cipher Text:   %h", cipher_text);
        $display("Decrypted Text:%h", dec_plain_text);
        $display("Tag:           %h", tag);
        $display("Decrypted Tag: %h", dec_tag);
        $display("Message Authentication: %b", message_authentication);

        // Check results
        if (plain_text == dec_plain_text)
            $display("SUCCESS: Decryption successful - Original and decrypted plaintext match");
        else
            $display("FAILURE: Decryption failed - Original and decrypted plaintext do not match");

        if (message_authentication)
            $display("SUCCESS: Message authenticated successfully");
        else
            $display("FAILURE: Message authentication failed");

        // End simulation
        #(CLK_PERIOD*100);
        $finish;
    end

    // Monitor changes
    always @(posedge clk) begin
        if (encryption_ready)
            $display("Encryption ready at %t", $time);
        if (decryption_ready)
            $display("Decryption ready at %t", $time);
    end

endmodule