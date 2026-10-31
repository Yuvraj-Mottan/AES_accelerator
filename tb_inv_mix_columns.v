`timescale 1ns / 1ps

module tb_inv_mix_columns;

    reg  [127:0] state_in;
    wire [127:0] state_out;

    inv_mix_columns dut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        $dumpfile("inv_mix_columns.vcd");
        $dumpvars(0, tb_inv_mix_columns);

        state_in = 128'h8e4da1bc9fdc589d01010101c6c6c6c6;
        #10;

        if (state_out === 128'hdb135345f20a225c01010101c6c6c6c6)
            $display("PASS: InvMixColumns");
        else
            $display("FAIL: InvMixColumns");

        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        $finish;
    end

endmodule