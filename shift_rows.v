
module shift_rows (
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);

    // AES uses column-major state ordering.
    // Row 0: no shift
    // Row 1: left shift by 1 byte
    // Row 2: left shift by 2 bytes
    // Row 3: left shift by 3 bytes

    assign state_out = {
        state_in[127:120], // Row 0, column 0
        state_in[87:80],   // Row 1, column 0
        state_in[47:40],   // Row 2, column 0
        state_in[7:0],     // Row 3, column 0

        state_in[95:88],   // Row 0, column 1
        state_in[55:48],   // Row 1, column 1
        state_in[15:8],    // Row 2, column 1
        state_in[103:96],  // Row 3, column 1

        state_in[63:56],   // Row 0, column 2
        state_in[23:16],   // Row 1, column 2
        state_in[111:104], // Row 2, column 2
        state_in[71:64],   // Row 3, column 2

        state_in[31:24],   // Row 0, column 3
        state_in[119:112],// Row 1, column 3
        state_in[79:72],   // Row 2, column 3
        state_in[39:32]    // Row 3, column 3
    };

endmodule
