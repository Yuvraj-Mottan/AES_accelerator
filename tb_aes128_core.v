
`timescale 1ns / 1ps

module tb_aes128_core;

    reg clk;
    reg reset;
    reg start;
    reg [127:0] plaintext;
    reg [127:0] key;

    wire [127:0] ciphertext;
    wire busy;
    wire done;

    aes128_core dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .busy(busy),
        .done(done)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("aes128_core.vcd");
        $dumpvars(0, tb_aes128_core);

        clk = 0;
        reset = 1;
        start = 0;
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key = 128'h000102030405060708090a0b0c0d0e0f;

        // Release reset on a falling edge
        @(negedge clk);
        reset = 0;

        // Request encryption
        start = 1;
        @(negedge clk);
        start = 0;

        // Wait for completion, with a timeout
        fork
            begin
                wait (done === 1'b1);
                $display("Ciphertext: %032h", ciphertext);

                if (ciphertext ===
                    128'h69c4e0d86a7b0430d8cdb78070b4c55a)
                    $display("AES-128 TEST PASSED");
                else
                    $display("AES-128 TEST FAILED");

                $finish;
            end

            begin
                repeat (20) @(negedge clk);
                $display("ERROR: Timeout waiting for done");
                $finish;
            end
        join_any
    end

    always @(posedge clk) begin
        $display(
            "time=%0t round=%0d busy=%b done=%b",
            $time, dut.round_count, busy, done
        );
    end

endmodule
