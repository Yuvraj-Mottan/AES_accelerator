`timescale 1ns/1ps

module tb_aes_sbox;
    reg [7:0] in;
    wire [7:0] out;

    integer errors;
    aes_sbox uut(.in(in),.out(out));

    initial begin
        $dumpfile("aes_sbox.vcd");
        $dumpvars(0,tb_aes_sbox);
        errors=0;

        in = 8'h01;
        #10;
        if (out !== 8'h7c) errors = errors + 1;

        in = 8'h53;
        #10;
        if (out !== 8'hed) errors = errors + 1;

        in = 8'hff;
        #10;
        if (out !== 8'h16) errors = errors + 1;

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);

        $finish;
    end
    
    initial begin
        $monitor("Time=%0t | in=%02h | out=%02h", $time, in, out);
    end
endmodule