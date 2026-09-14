# Chapter 3: Local Simulation Setup & Execution Guide

## 1. Local Simulation Setup & Execution Commands (`iverilog`)
Before running physical layout synthesis, performed functional verification locally using an open-source HDL simulator (Icarus Verilog) and a waveform viewer (GTKWave).

### Step 1: Install Simulation Tools
Executed the following commands to install the required open-source toolchain on Linux.
```bash
sudo apt update
sudo apt install iverilog gtkwave -y
```

### Step 2: Compile the Design and Testbench Files
Compiled Verilog source (`fir_filter.v`) along with testbench wrapper (`tb_fir.v`), ensuring testbench instance uses the standard identifier **`uut`**
```bash
iverilog -o simulation/sim_out.vvp design/src/fir_filter.v design/src/tb_fir.v
```

### Step 3: Execute the Simulation Binary
Ran the compiled simulation file using `vvp` to generate the Value Change Dump (`.vcd`) waveform telemetry file.
```bash
vvp simulation/sim_out.vvp
```

### Step 4: Open and Verify Waveforms in GTKWave
Loaded the generated simulation output into your graphical viewer to inspect signal behavior.
