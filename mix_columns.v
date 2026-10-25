module mix_columns(
    input [127:0] in,
    output [127:0] out
);
    function [7:0] xtime;
        input [7:0] a;
        begin
            if(a[7]) xtime=(a<<1)^8'h1b;
            else xtime=a<<1;
        end
    endfunction

    function [31:0] mix_column;
        input [31:0] column;
        reg [7:0] a0,a1,a2,a3;
        reg [7:0] x0,x1,x2,x3;

        begin
            a0=column[31:24];
            a1=column[23:16];
            a2=column[15:8];
            a3=column[7:0];
            x0=xtime(a0);
            x1=xtime(a1);
            x2=xtime(a2);
            x3=xtime(a3);
            
            mix_column[31:24] =
                x0 ^ (x1 ^ a1) ^ a2 ^ a3;

            mix_column[23:16] =
                a0 ^ x1 ^ (x2 ^ a2) ^ a3;

            mix_column[15:8] =
                a0 ^ a1 ^ x2 ^ (x3 ^ a3);

            mix_column[7:0] =
                (x0 ^ a0) ^ a1 ^ a2 ^ x3;
        end
    endfunction

    assign out[127:96] = mix_column(in[127:96]);
    assign out[95:64]  = mix_column(in[95:64]);
    assign out[63:32]  = mix_column(in[63:32]);
    assign out[31:0]   = mix_column(in[31:0]);
endmodule