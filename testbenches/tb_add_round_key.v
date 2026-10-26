`timescale 1ns / 1ps

module tb_add_round_key;
    reg [127:0] state_in;
    reg [127:0] round_key;
    wire [127:0] state_out;

    add_round_key dut (
        .state_in(state_in),
        .round_key(round_key),
        .state_out(state_out)
    );

    initial begin
        $dumpfile("add_round_key.vcd");
        $dumpvars(0, tb_add_round_key);

        state_in  = 128'h00112233445566778899aabbccddeeff;
        round_key = 128'h000102030405060708090a0b0c0d0e0f;

        #10;

        $display("Output: %032h", state_out);

        if (state_out === 128'h00102030405060708090a0b0c0d0e0f0)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $finish;
    end
endmodule