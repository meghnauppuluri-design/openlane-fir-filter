# 15-Tap Transposed FIR Filter: ASIC Implementation & Verification Using OpenLane

> **Process Node:** SkyWater 130nm CMOS (`sky130A`)

## 1. Overview

This repository contains a complete, production-grade implementation of a **15-tap low-pass finite impulse response (FIR) filter**.

- RTL micro-architecture design
- HDL testbench verification 
- Local Icarus Verilog simulation
- GTKWave waveform analysis
- Automated ASIC physical implementation via OpenLane
- Synthesis area/delay trade-off exploration
- Structured debugging and engineering resolution logs

The complete implementation targets the **SkyWater 130nm CMOS (`sky130A`)** process node.

## 2. Documentation Navigation Hub

The complete project documentation is organized into six chapters.

### [Chapter 1: Micro-Architecture & Verilog RTL Specification](https://github.com/meghnauppuluri-design/openlane-fir-filter/blob/main/docs/rtl_and_architecture.md)

Details the FIR filter architecture, including the **16-bit signed input vector**, **32-bit output vector**, coefficient organization, pipeline structure, and transposed direct-form multiply-accumulate (MAC) topology.

---

### [Chapter 2: Verification Strategy & Waveform Analysis](https://github.com/meghnauppuluri-design/openlane-fir-filter/blob/main/docs/verification_and_simulation.md)

Describes the HDL verification environment, including the `tb_fir` testbench wrapper, explicit `uut` hierarchy, clock/reset generation, impulse and step-response stimulus vectors, VCD generation, and GTKWave signal inspection.

---

### [Chapter 3: Chapter 3: Local Simulation Setup & Execution Guide](https://github.com/meghnauppuluri-design/openlane-fir-filter/blob/main/docs/setup_and_simulation.md)

Provides instructions for compiling and simulating the FIR filter locally using **Icarus Verilog**, `vvp`, and **GTKWave**.

---

### [Chapter 4: OpenLane Environment Setup & Interactive ASIC Flow Guide](https://github.com/meghnauppuluri-design/openlane-fir-filter/blob/main/docs/openlane_interactive_run_guide.md)

Provides a high-level overview of the complete **RTL-to-GDSII ASIC implementation flow**, including synthesis, floorplanning, placement, clock tree synthesis, routing, and physical verification.

---

### [Chapter 5: OpenLane RTL-to-GDSII Flow Report: 15-Tap Low-Pass FIR Filter](https://github.com/meghnauppuluri-design/openlane-fir-filter/blob/main/docs/openlane_flow_and_debugging.md)

Contains detailed debugging records and engineering resolutions encountered during physical implementation.

### [Logs](https://github.com/meghnauppuluri-design/openlane-fir-filter/tree/main/logs)

### [Reports](https://github.com/meghnauppuluri-design/openlane-fir-filter/tree/main/reports)

---

## 3. Design Sources

The synthesizable FIR filter implementation is located at:

```text
/design/src/fir_filter.v
```

The verification testbench is located at:

```text
design/src/tb_fir.v
```

---

## 4. OpenLane Configuration

The primary OpenLane configuration is located at:

```text
design/config.json
```

The target process is:

```text
sky130A
```

---

## 5. ASIC Implementation Flow

The physical implementation flow follows the standard RTL-to-GDSII sequence:

```text
RTL Design
    │
    ▼
Functional Simulation
    │
    ▼
Synthesis Exploration
    │
    ▼
Logic Synthesis
    │
    ▼
Floorplanning
    │
    ▼
PDN Generation
    │
    ▼
Standard Cell Placement
    │
    ▼
Clock Tree Synthesis
    │
    ▼
Global & Detailed Routing
    │
    ▼
Static Timing Analysis
    │
    ▼
DRC
    │
    ▼
LVS
    │
    ▼
GDSII
```

## 6. External Resources

### OpenLane

Official repository:

https://github.com/The-OpenROAD-Project/OpenLane
