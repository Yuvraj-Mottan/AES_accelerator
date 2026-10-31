`timescale 1ns / 1ps

module tb_inv_shift_rows;

    reg  [127:0] state_in;
    wire [127:0] state_out;

    inv_shift_rows dut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        $dumpfile("inv_shift_rows.vcd");
        $dumpvars(0, tb_inv_shift_rows);

        state_in = 128'h0055aaff4499ee3388dd2277cc1166bb;
        #10;

        if (state_out === 128'h00112233445566778899aabbccddeeff)
            $display("PASS: InvShiftRows");
        else
            $display("FAIL: Expected 00112233445566778899aabbccddeeff");

        $display("Actual: %h", state_out);

        $finish;
    end

endmodule