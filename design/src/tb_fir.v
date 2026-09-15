`timescale 1ns/1ps

module tb_fir;

    reg clk;
    reg rst;
    reg signed [15:0] filter_in;
    wire signed [31:0] filter_out;

    // Instantiating the Unit Under Test (UUT)
    fir_filter uut (
        .clk(clk),
        .rst(rst),
        .filter_in(filter_in),
        .filter_out(filter_out)
    );

    // Clock Generation: 20 MHz Clock (50ns period)
    always #25 clk = ~clk;

    initial begin
        // Setting up Waveform Dump for GTKWave
        $dumpfile("fir_sim.vcd");
        $dumpvars(0, tb_fir);

        // Initializing Inputs
        clk = 0;
        rst = 1;
        filter_in = 0;

        // Resetting Pulse
        #100;
        rst = 0;
        #50;

        // Test 1: Impulse Response (Send a single unit pulse)
        $display("--- Starting Impulse Response Test ---");
        filter_in = 16'sd1000;
        #50;
        filter_in = 16'sd0;

        // Wait 20 clock cycles to observe tap responses
        #1000;

        // Test 2: Step Response (Send continuous value)
        $display("--- Starting Step Response Test ---");
        filter_in = 16'sd5000;
        #1000;

        $display("--- Simulation Completed ---");
        $finish;
    end

endmodule
