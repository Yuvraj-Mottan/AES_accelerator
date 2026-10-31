module aes128_decrypt_core (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,

    input  wire [127:0] ciphertext,
    input  wire [127:0] key,

    output reg  [127:0] plaintext,
    output reg          busy,
    output reg          done
);

    // FSM states
    localparam IDLE       = 3'd0;
    localparam INIT       = 3'd1;
    localparam INV_SHIFT  = 3'd2;
    localparam INV_SUB    = 3'd3;
    localparam ADD_KEY    = 3'd4;
    localparam INV_MIX    = 3'd5;
    localparam FINAL      = 3'd6;

    reg [2:0] state;
    reg [3:0] round;

    reg [127:0] data_reg;

    // Generate all 11 round keys
    wire [1407:0] round_keys;

    key_expansion key_gen (
        .key(key),
        .round_keys(round_keys)
    );

    // Select round key
    reg [127:0] selected_key;

    always @(*) begin
        selected_key = round_keys[1407-round*128 -: 128];
    end

    // Inverse transformation wires
    wire [127:0] inv_shift_out;
    wire [127:0] inv_sub_out;
    wire [127:0] add_key_out;
    wire [127:0] inv_mix_out;

    inv_shift_rows inv_shift (
        .state_in(data_reg),
        .state_out(inv_shift_out)
    );

    inv_sub_bytes inv_sub (
        .state_in(inv_shift_out),
        .state_out(inv_sub_out)
    );

    add_round_key add_key (
        .state_in(data_reg),
        .round_key(selected_key),
        .state_out(add_key_out)
    );

    inv_mix_columns inv_mix (
        .state_in(data_reg),
        .state_out(inv_mix_out)
    );

    // FSM
    always @(posedge clk) begin

        if (rst) begin
            state     <= IDLE;
            round     <= 4'd0;
            data_reg  <= 128'd0;
            plaintext <= 128'd0;
            busy      <= 1'b0;
            done      <= 1'b0;
        end

        else begin

            done <= 1'b0;

            case (state)

                // Wait for start
                IDLE: begin
                    busy <= 1'b0;

                    if (start) begin
                        data_reg <= ciphertext;
                        busy <= 1'b1;
                        state <= INIT;
                    end
                end

                // Initial AddRoundKey with K10
                INIT: begin
                    data_reg <= data_reg ^ round_keys[127:0];

                    round <= 4'd9;
                    state <= INV_SHIFT;
                end

                // InvShiftRows followed by InvSubBytes
                INV_SHIFT: begin
                    data_reg <= inv_sub_out;
                    state <= ADD_KEY;
                end

                // AddRoundKey with K9 through K1
                ADD_KEY: begin
                    data_reg <= add_key_out;
                    state <= INV_MIX;
                end

                // InvMixColumns
                INV_MIX: begin
                    data_reg <= inv_mix_out;

                    if (round == 4'd1) begin
                        state <= FINAL;
                    end
                    else begin
                        round <= round - 1'b1;
                        state <= INV_SHIFT;
                    end
                end

                // Final round with K0
                FINAL: begin
                    data_reg <= inv_sub_out ^ round_keys[1407:1280];

                    plaintext <= inv_sub_out ^ round_keys[1407:1280];

                    busy <= 1'b0;
                    done <= 1'b1;
                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                    busy <= 1'b0;
                end

            endcase
        end
    end

endmodule