# Chapter 2: Verification Strategy and Waveform Analysis

## 2.1 Testbench Environment (`tb_fir.v`)
The verification wrapper (`tb_fir`) tests the core filter behaviour under dynamic functional profiles.
* **CLock Generation:** Implement a 20Mhz master clock running on a 50 ns period.
* **Reset Sequence** Asserts active-high reset (`rst`) for the initial100 ns window to clear pipeline registers before release.
* **Stimulus Vectors:**
  * **Impulse Response:** Injects a single unit magnitude pulse (`16'sd1000`) followed by continuous zeros to verify tap propogatiopn across 20 cycles.
  * **Step Response:** Drives a steady step input to confirm arithmetic stability and check for bit growth.

## 2.2 Waveform Signal Analysis (`fir_sim.vcd`)
Simulation telemetry is recorded via a Value Change Dump.
* `tb_fir.clk` — Master 20 MHz clock
* `tb_fir.rst` — Active reset window
* `tb_fir.uut.filter_in` — 16-bit signed input vector
* `tb_fir.uut.filter_out` — 32-bit signed accumulator output vector

* Inspection via GTKWave confirms correct vector accumulation without truncation or overflow anomalies upon data propagation.
