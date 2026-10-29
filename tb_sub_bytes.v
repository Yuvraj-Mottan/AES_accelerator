
`timescale 1ns / 1ps

module tb_sub_bytes;

    reg  [127:0] state_in;
    wire [127:0] state_out;

    sub_bytes dut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        $dumpfile("sub_bytes.vcd");
        $dumpvars(0, tb_sub_bytes);

        // Each byte is checked against known AES S-box mappings.
        state_in = {
            8'h00, 8'h01, 8'h53, 8'hff,
            8'h10, 8'h20, 8'h30, 8'h40,
            8'h50, 8'h60, 8'h70, 8'h80,
            8'h90, 8'ha0, 8'hb0, 8'hc0
        };

        #10;

        $display("Input : %032h", state_in);
        $display("Output: %032h", state_out);

        if (state_out === {
            8'h63, 8'h7c, 8'hed, 8'h16,
            8'hca, 8'hb7, 8'h04, 8'h09,
            8'h53, 8'hd0, 8'h51, 8'hcd,
            8'h60, 8'he0, 8'he7, 8'hba
        })
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $finish;
    end

endmodule
