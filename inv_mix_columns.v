module inv_mix_columns (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);

    // Multiply a byte by 2 in GF(2^8)
    function [7:0] xtime;
        input [7:0] a;
        begin
            xtime = (a << 1) ^ (a[7] ? 8'h1b : 8'h00);
        end
    endfunction

    // Multiply a byte by a constant in GF(2^8)
    function [7:0] gf_mul;
        input [7:0] a;
        input [7:0] b;

        reg [7:0] temp_a;
        reg [7:0] temp_b;
        reg [7:0] result;
        integer i;

        begin
            temp_a = a;
            temp_b = b;
            result = 8'h00;

            for (i = 0; i < 8; i = i + 1) begin
                if (temp_b[0])
                    result = result ^ temp_a;

                temp_a = xtime(temp_a);
                temp_b = temp_b >> 1;
            end

            gf_mul = result;
        end
    endfunction

    // Process one AES column
    function [31:0] inv_mix_column;
        input [31:0] col;

        reg [7:0] a0, a1, a2, a3;

        begin
            a0 = col[31:24];
            a1 = col[23:16];
            a2 = col[15:8];
            a3 = col[7:0];

            inv_mix_column[31:24] =
                gf_mul(a0, 8'h0e) ^
                gf_mul(a1, 8'h0b) ^
                gf_mul(a2, 8'h0d) ^
                gf_mul(a3, 8'h09);

            inv_mix_column[23:16] =
                gf_mul(a0, 8'h09) ^
                gf_mul(a1, 8'h0e) ^
                gf_mul(a2, 8'h0b) ^
                gf_mul(a3, 8'h0d);

            inv_mix_column[15:8] =
                gf_mul(a0, 8'h0d) ^
                gf_mul(a1, 8'h09) ^
                gf_mul(a2, 8'h0e) ^
                gf_mul(a3, 8'h0b);

            inv_mix_column[7:0] =
                gf_mul(a0, 8'h0b) ^
                gf_mul(a1, 8'h0d) ^
                gf_mul(a2, 8'h09) ^
                gf_mul(a3, 8'h0e);
        end
    endfunction

    assign state_out[127:96] = inv_mix_column(state_in[127:96]);
    assign state_out[95:64]  = inv_mix_column(state_in[95:64]);
    assign state_out[63:32]  = inv_mix_column(state_in[63:32]);
    assign state_out[31:0]   = inv_mix_column(state_in[31:0]);

endmodule