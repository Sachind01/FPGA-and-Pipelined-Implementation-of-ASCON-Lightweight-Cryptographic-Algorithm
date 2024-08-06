`timescale 1ps/1ps

module Ascon_Top_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg start;
    wire encryption_done;
    wire decryption_done;
    wire message_authenticated;

    // Instantiate the TopAscon module
    Ascon_Top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .encryption_done(encryption_done),
        .decryption_done(decryption_done),
        .message_authenticated(message_authenticated)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test scenario
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        start = 0;

        // Reset
        #20 rst = 0;

        // Start encryption
        #20 start = 1;
        #10 start = 0;

        // Wait for encryption and decryption to complete
        wait(decryption_done);

        // Allow some time for final state transitions
        #20;

        // Check results
        if (message_authenticated) begin
            $display("Test passed: Encryption and decryption successful");
        end else begin
            $display("Test failed");
        end

        // Finish simulation
        #100 $finish;
    end

    // Monitor important signals
    initial begin
        $monitor("Time=%t, encryption_done=%b, decryption_done=%b, message_authenticated=%b", 
                 $time, encryption_done, decryption_done, message_authenticated);
    end

endmodule
