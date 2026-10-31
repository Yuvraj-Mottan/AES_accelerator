`timescale 1ns / 1ps

module tb_inv_sub_bytes;

    reg  [127:0] state_in;
    wire [127:0] state_out;

    inv_sub_bytes dut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        $dumpfile("inv_sub_bytes.vcd");
        $dumpvars(0, tb_inv_sub_bytes);

        // Test 1: inverse of the AES SubBytes example
        state_in = 128'h63636363636363636363636363636363;
        #10;

        if (state_out === 128'h00000000000000000000000000000000)
            $display("PASS: InvSubBytes test 1");
        else
            $display("FAIL: Got %h", state_out);

        // Test 2: inverse S-box mapping
        state_in = 128'hedededededededededededededededed;
        #10;

        if (state_out === 128'h53535353535353535353535353535353)
            $display("PASS: InvSubBytes test 2");
        else
            $display("FAIL: Got %h", state_out);

        $finish;
    end

endmodule