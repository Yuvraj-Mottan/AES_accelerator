
`timescale 1ns / 1ps

module tb_mix_columns;

    reg  [127:0] state_in;
    wire [127:0] state_out;

    mix_columns dut (
        .in(state_in),
        .out(state_out)
    );

    initial begin
        $dumpfile("mix_columns.vcd");
        $dumpvars(0, tb_mix_columns);

        // Known AES MixColumns test column: d4 bf 5d 30
        state_in = {
            32'hd4bf5d30,
            96'h000000000000000000000000
        };

        #10;

        $display("Input : %032h", state_in);
        $display("Output: %032h", state_out);

        if (state_out[127:96] === 32'h046681e5)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $finish;
    end

endmodule
