
`timescale 1ns / 1ps

module tb_shift_rows;

    reg  [127:0] state_in;
    wire [127:0] state_out;

    shift_rows dut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        $dumpfile("shift_rows.vcd");
        $dumpvars(0, tb_shift_rows);

        state_in =
            128'h00112233445566778899aabbccddeeff;

        #10;

        $display("Input : %032h", state_in);
        $display("Output: %032h", state_out);

        if (state_out ===
            128'h0055aaff4499ee3388dd2277cc1166bb)
            $display("SHIFT ROWS TEST PASSED");
        else
            $display("SHIFT ROWS TEST FAILED");

        $finish;
    end

endmodule
