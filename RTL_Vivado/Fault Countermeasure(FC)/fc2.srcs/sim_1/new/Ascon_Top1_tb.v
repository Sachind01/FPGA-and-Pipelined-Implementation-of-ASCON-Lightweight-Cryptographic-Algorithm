`timescale 1ps/1ps

module Ascon_Top_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // 100 MHz clock

    // Inputs
    reg clk;
    reg rst;
    reg start;

    // Outputs
    wire encryption_ready;
    wire decryption_ready;
    wire message_authentication;

    // Instantiate the Unit Under Test (UUT)
    Ascon_Top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
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
        wait(uut.ascon_inst.state == uut.ascon_inst.DONE);
        #(CLK_PERIOD*10);

        // Display results
        $display("Encryption/Decryption completed");
        $display("Plain Text:    %h", uut.ascon_inst.plain_text);
        $display("Cipher Text:   %h", uut.ascon_inst.cipher_text);
        $display("Decrypted Text:%h", uut.ascon_inst.dec_plain_text);
        $display("Tag:           %h", uut.ascon_inst.tag);
        $display("Decrypted Tag: %h", uut.ascon_inst.dec_tag);
        $display("Message Authentication: %b", message_authentication);

        // Check results
        if (uut.ascon_inst.plain_text == uut.ascon_inst.dec_plain_text)
            $display("SUCCESS: Decryption successful - Original and decrypted plaintext match");
        else
            $display("FAILURE: Decryption failed - Original and decrypted plaintext do not match");

        if (message_authentication)
            $display("SUCCESS: Message authenticated successfully");
        else
            $display("FAILURE: Message authentication failed");

        // End simulation
        #(CLK_PERIOD*250);
        $finish;
    end

    // Monitor changes
    always @(posedge clk) begin
        if (uut.ascon_inst.state == uut.ascon_inst.ENCRYPT)
            $display("Encryption in progress at %t", $time);
        if (uut.ascon_inst.state == uut.ascon_inst.DECRYPT)
            $display("Decryption in progress at %t", $time);
        if (encryption_ready)
            $display("Encryption ready at %t", $time);
        if (decryption_ready)
            $display("Decryption ready at %t", $time);
    end

endmodule
