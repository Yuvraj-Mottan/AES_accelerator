`timescale 1ns / 1ps

module tb_aes_inv_sbox;

    reg [7:0] in;
    wire [7:0] out;

    aes_inv_sbox dut (
        .in(in),
        .out(out)
    );

    initial begin
        $dumpfile("aes_inv_sbox.vcd");
        $dumpvars(0, tb_aes_inv_sbox);

        in = 8'h63;
        #10;
        if (out !== 8'h00)
            $display("FAIL: 63 -> %h", out);
        else
            $display("PASS: 63 -> 00");

        in = 8'h7c;
        #10;
        if (out !== 8'h01)
            $display("FAIL: 7c -> %h", out);
        else
            $display("PASS: 7c -> 01");

        in = 8'hed;
        #10;
        if (out !== 8'h53)
            $display("FAIL: ed -> %h", out);
        else
            $display("PASS: ed -> 53");

        in = 8'h16;
        #10;
        if (out !== 8'hff)
            $display("FAIL: 16 -> %h", out);
        else
            $display("PASS: 16 -> ff");

        $finish;
    end

endmodule