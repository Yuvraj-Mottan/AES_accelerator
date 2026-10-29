
module key_expansion (
    input  wire [127:0] key,
    output wire [1407:0] round_keys
);

    wire [31:0] words [0:43];
    wire [31:0] transformed [1:10];

    // Round constants
    function [7:0] rcon;
        input integer r;
        begin
            case (r)
                1:  rcon = 8'h01;
                2:  rcon = 8'h02;
                3:  rcon = 8'h04;
                4:  rcon = 8'h08;
                5:  rcon = 8'h10;
                6:  rcon = 8'h20;
                7:  rcon = 8'h40;
                8:  rcon = 8'h80;
                9:  rcon = 8'h1b;
                10: rcon = 8'h36;
                default: rcon = 8'h00;
            endcase
        end
    endfunction

    // Original key becomes W0, W1, W2, W3
    assign words[0] = key[127:96];
    assign words[1] = key[95:64];
    assign words[2] = key[63:32];
    assign words[3] = key[31:0];

    genvar r, b;

    generate
        for (r = 1; r <= 10; r = r + 1) begin : round_gen

            wire [31:0] rotated;

            // RotWord: rotate previous word left by one byte
            assign rotated = {
                words[4*r-1][23:0],
                words[4*r-1][31:24]
            };

            // SubWord: apply four S-boxes
            for (b = 0; b < 4; b = b + 1) begin : sbox_gen
                aes_sbox sbox (
                    .in  (rotated[31-b*8 -: 8]),
                    .out (transformed[r][31-b*8 -: 8])
                );
            end

            // Generate the first word of this round
            assign words[4*r] =
                words[4*r-4] ^
                transformed[r] ^
                {rcon(r), 24'h000000};

            // Generate the remaining three words
            assign words[4*r+1] =
                words[4*r-3] ^ words[4*r];

            assign words[4*r+2] =
                words[4*r-2] ^ words[4*r+1];

            assign words[4*r+3] =
                words[4*r-1] ^ words[4*r+2];

        end

        // Pack K0 through K10 into one 1408-bit output.
        // K0 occupies the most-significant 128 bits.
        for (r = 0; r <= 10; r = r + 1) begin : pack_keys
            assign round_keys[1407-r*128 -: 128] = {
                words[4*r],
                words[4*r+1],
                words[4*r+2],
                words[4*r+3]
            };
        end
    endgenerate

endmodule
