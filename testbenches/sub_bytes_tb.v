
`timescale 1ns / 1ps

module sub_bytes_tb;

    reg  [127:0] state_in;
    wire [127:0] state_out;

    sub_bytes dut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin
        state_in = 128'h00112233445566778899aabbccddeeff;

        #10;

        $display("-----------------------------------");
        $display("       AES SUBBYTES TEST");
        $display("-----------------------------------");
        $display("Input :  %032h", state_in);
        $display("Output:  %032h", state_out);

        // Check expected AES S-box output
        if (state_out === 128'h63cab7040953d051cd60e0e7ba70e18c) begin
            $display("TEST PASSED");
        end
        else begin
            $display("TEST FAILED");
            $display("Expected: %032h",
                     128'h63cab7040953d051cd60e0e7ba70e18c);
        end

        $display("-----------------------------------");
        $finish;
    end

endmodule
