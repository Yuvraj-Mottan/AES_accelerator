
module aes128_core (
    input  wire         clk,
    input  wire         reset,
    input  wire         start,
    input  wire [127:0] plaintext,
    input  wire [127:0] key,

    output reg  [127:0] ciphertext,
    output reg          busy,
    output reg          done
);

    reg [127:0] state_reg;
    reg [3:0] round_count;

    wire [1407:0] round_keys;

    wire [127:0] initial_state;
    wire [127:0] sub_out;
    wire [127:0] shift_out;
    wire [127:0] mix_out;
    wire [127:0] round_result;

    // Generate all round keys from the input key
    key_expansion key_schedule (
        .key(key),
        .round_keys(round_keys)
    );

    // Initial AddRoundKey with K0
    assign initial_state =
        plaintext ^ round_keys[1407:1280];

    // Combinational round datapath
    sub_bytes sb (
        .state_in(state_reg),
        .state_out(sub_out)
    );

    shift_rows sr (
        .state_in(sub_out),
        .state_out(shift_out)
    );

    mix_columns mc (
        .in(shift_out),
        .out(mix_out)
    );

    // Round 10 skips MixColumns.
    // K1 is in [1279:1152], K10 is in [127:0].
    assign round_result =
        (round_count == 10)
        ? (shift_out ^ round_keys[127:0])
        : (mix_out ^ round_keys[
            1407 - round_count*128 -: 128
          ]);

    // Sequential controller and state register
    always @(posedge clk) begin
        if (reset) begin
            state_reg  <= 128'b0;
            round_count <= 4'd0;
            ciphertext <= 128'b0;
            busy       <= 1'b0;
            done       <= 1'b0;
        end else begin
            // Default: done is a one-cycle pulse
            done <= 1'b0;

            if (!busy) begin
                if (start) begin
                    // Initial AddRoundKey
                    state_reg   <= initial_state;
                    round_count <= 4'd1;
                    busy        <= 1'b1;
                end
            end else begin
                // Save the result of the current round
                state_reg <= round_result;

                if (round_count == 10) begin
                    ciphertext <= round_result;
                    busy       <= 1'b0;
                    done       <= 1'b1;
                    round_count <= 4'd0;
                end else begin
                    round_count <= round_count + 1'b1;
                end
            end
        end
    end

endmodule

