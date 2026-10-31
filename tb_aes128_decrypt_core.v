`timescale 1ns / 1ps

module tb_aes128_decrypt_core;

    reg clk;
    reg rst;
    reg start;

    reg [127:0] ciphertext;
    reg [127:0] key;

    wire [127:0] plaintext;
    wire busy;
    wire done;

    aes128_decrypt_core dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .ciphertext(ciphertext),
        .key(key),
        .plaintext(plaintext),
        .busy(busy),
        .done(done)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        $dumpfile("aes128_decrypt_core.vcd");
        $dumpvars(0, tb_aes128_decrypt_core);

        clk = 0;
        rst = 1;
        start = 0;

        ciphertext = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
        key        = 128'h000102030405060708090a0b0c0d0e0f;

        #20;
        rst = 0;

        // Start decryption
        @(negedge clk);
        start = 1;

        @(negedge clk);
        start = 0;

        // Wait for completion
        wait(done == 1);

        #1;

        $display("Ciphertext: %h", ciphertext);
        $display("Key       : %h", key);
        $display("Plaintext : %h", plaintext);

        if (plaintext === 128'h00112233445566778899aabbccddeeff)
            $display("PASS: AES-128 Decryption");
        else
            $display("FAIL: AES-128 Decryption");

        #20;
        $finish;

    end

endmodule