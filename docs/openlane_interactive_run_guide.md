# Chapter 5: OpenLane Environment Setup & Interactive ASIC Flow Guide

## 1. Overview

This chapter provides a complete, step-by-step operational guide for setting up the host environment, cloning and mounting OpenLane via Docker, launching the interactive Tcl shell, preparing the 15-tap FIR filter design (`fir_new`), and sequentially executing each physical implementation stage targeting the SkyWater 130nm (`sky130A`) process node.

## 2. Host Prerequisites & Docker Environment Setup

As OpenLane relies on strict open-source EDA dependencies (Yosys, OpenROAD, Magic, Netgen), it runs inside an isolated Docker container.

### Step 1: Install Docker & Build Essentials

Open Linux terminal and install Docker Engine and build utilities on host machine:

```bash
sudo apt update
sudo apt install build-essential git python3 python3-pip make -y
```

### Step 2: Grant Docker Permissions

Add current user to the Docker user group so you can execute container commands without root (`sudo`) privileges:

```bash
sudo usermod -aG docker $USER
```

## 3. Cloning OpenLane & Mounting the Container

### Step 1: Clone the Official Repository

Clone the OpenLane repository into local workspace directory:

```bash
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane
```

### Step 2: Mount the Docker Container

Run the automated Makefile target to pull the required container image and configure the SkyWater 130nm (`sky130A`) process design kit:

```bash
make mount
```
This command starts the Docker container, mounts your local workspace inside it, and opens the interactive container shell prompt.

## 4. Step-by-Step Interactive ASIC Flow Execution

Inside the container prompt (`/openlane #`), execute the flow through the following sequential stages.

### Step 1: Entering the Interactive Tcl Shell

Use the OpenLane interactive execution engine:

```bash
./flow.tcl -interactive
```

### Step 2: Loading Packages and Preparing the Design

Initialize the OpenLane environment packages and prepare design workspace.

```tcl
package require openlane
prep -design fir_new -tag run_01 -overwrite
```
**Explanation:** Maps design files from `design/src/`, reads `design/config.json`, and sets up the active run directory (`run_01`).

### Step 3: Synthesis Exploration (Area & Delay Tradeoffs)

Before locking down a single configuration, evaluate how varying your clock constraints and mapping strategies impact silicon area and timing performance:

```tcl
run_synthesis_exploration
```

**Explanation:** Automatically runs synthesis across multiple target clock periods and optimization scripts. It generates comparative trade-off reports highlighting how tightening the clock period increases standard cell area and buffer count, whereas relaxing the clock reduces cell count at the cost of longer propagation delays.

Use these metrics to finalize your `CLOCK_PERIOD` and optimization parameters inside `design/config.json`.

### Step 4: Logic Synthesis & Technology Mapping

Translates the Verilog RTL source code into a gate-level netlist using standard library cells.

```tcl
run_synthesis
```
**Explanation:** Invokes Yosys for logic synthesis and OpenSTA for preliminary static timing analysis against target clock constraints.

### Step 5: Floorplanning & Power Distribution Network (PDN) Generation

Establishes physical die boundaries, core utilization margins, tap cells, and the metal power grid network (`VDD`/`VSS`):

```tcl
run_floorplan
```
**Explanation:** Allocates core rows, inserts well-tap cells to prevent latch-up, and routes global power lines across metal layers.

### Step 6: Standard Cell Placement

Distributes and places standard cells uniformly across the core floorplan area:

```tcl
run_placement
```
**Explanation:** Executes global and detailed placement algorithms to optimize wire length and minimize routing congestion.

### Step 7: Clock Tree Synthesis (CTS)

Synthesizes and balances the clock distribution network to minimize skew across sequential registers.

```tcl
run_cts
```
**Explanation:** Inserts clock buffers along the clock tree paths for the master clock signal (`clk`).

### Step 8: Global and Detailed Routing

Routes all standard cell pin connections using available metal layers according to process design rules.

```tcl
run_routing
```

### Step 9: Physical Signoff Verification (DRC & LVS)

Extracts layout geometries and verifies design rule compliance and netlist connectivity:

```tcl
run_magic
run_magic_drc
run_lvs
```
**Explanation:** Uses Magic to perform Design Rule Checking (DRC) and Netgen to verify Layout Versus Schematic (LVS) equivalence.
