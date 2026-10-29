
`timescale 1ns / 1ps

module tb_key_expansion;

    reg  [127:0] key;
    wire [1407:0] round_keys;

    key_expansion dut (
        .key(key),
        .round_keys(round_keys)
    );

    initial begin
        $dumpfile("key_expansion.vcd");
        $dumpvars(0, tb_key_expansion);

        key = 128'h000102030405060708090a0b0c0d0e0f;

        #10;

        $display("K0  = %032h", round_keys[1407:1280]);
        $display("K1  = %032h", round_keys[1279:1152]);
        $display("K2  = %032h", round_keys[1151:1024]);
        $display("K10 = %032h", round_keys[127:0]);

        if (
            round_keys[1407:1280] ===
                128'h000102030405060708090a0b0c0d0e0f &&
            round_keys[1279:1152] ===
                128'hd6aa74fdd2af72fadaa678f1d6ab76fe &&
            round_keys[1151:1024] ===
                128'hb692cf0b643dbdf1be9bc5006830b3fe &&
            round_keys[127:0] ===
                128'h13111d7fe3944a17f307a78b4d2b30c5
        )
            $display("KEY EXPANSION TEST PASSED");
        else
            $display("KEY EXPANSION TEST FAILED");

        $finish;
    end

endmodule
