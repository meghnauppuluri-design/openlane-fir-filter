// 15-Tap Transposed Direct-Form FIR Filter
module fir_filter (
    input wire clk,
    input wire rst,
    input wire signed [15:0] filter_in,
    output reg signed [31:0] filter_out
);

    // 15 Signed filter coefficients
    wire signed [15:0] b [0:14];
    assign b[0]  = 16'h0050;
    assign b[1]  = 16'h01A0;
    assign b[2]  = 16'h05B0;
    assign b[3]  = 16'h0CA0;
    assign b[4]  = 16'h1510;
    assign b[5]  = 16'h1CD0;
    assign b[6]  = 16'h2170;
    assign b[7]  = 16'h2310; // Peak tap
    assign b[8]  = 16'h2170;
    assign b[9]  = 16'h1CD0;
    assign b[10] = 16'h1510;
    assign b[11] = 16'h0CA0;
    assign b[12] = 16'h05B0;
    assign b[13] = 16'h01A0;
    assign b[14] = 16'h0050;

    // Accumulator Registers
    reg signed [31:0] acc [0:14];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 15; i = i + 1) begin
                acc[i] <= 32'sd0;
            end
            filter_out <= 32'sd0;
        end else begin
            // Transposed Form MAC Architecture
            acc[0] <= filter_in * b[0];
            for (i = 1; i < 15; i = i + 1) begin
                acc[i] <= acc[i-1] + (filter_in * b[i]);
            end
            filter_out <= acc[14];
        end
    end

endmodule
