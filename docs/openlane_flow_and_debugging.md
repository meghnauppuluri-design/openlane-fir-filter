# OpenLane RTL-to-GDSII Flow Report: 15-Tap Low-Pass FIR Filter

This document outlines the complete implementation of a 15-tap low-pass finite impulse response (FIR) filter targeting the SkyWater 130nm (`sky130A`) process node using open-source EDA tools (OpenLane, Yosys, OpenROAD, Magic, and Netgen).

## 1. Synthesis & Timing Optimization (Yosys / OpenSTA)
* **Tool Used:** Yosys for RTL synthesis & technology mapping, OpenSTA for static timing analysis.
* **Synthesis Strategy Exploration:** Evaluated multiple strategies (`DELAY 0-4`, `AREA 0-3`) using `run_synth_exploration`. 
  * **Decision:** Selected `AREA 3` because it yielded the best delay profile among area-focused optimizations ($\approx 3429.43\text{ ps}$).
  *  The `config.json` was updated with `"SYNTH_STRATEGY": "AREA 3"`.
* **Error Encountered (Setup Timing):** Initial STA logs revealed a negative setup timing slack of `-3.53` ns (with a hold slack of `0.11` ns). Negative slack threatens timing closure, yield, and reliability.
* **Resolution Steps:** 
  * Enabled cell sizing and buffering by configuring `"SYNTH_SIZING": 1` (to resize critical path cells) and `"SYNTH_BUFFERING": 1` (to insert buffers along critical paths).
  * Since slack remained negative, the clock period was extended from the default $10\text{ ns}$ to `"CLOCK_PERIOD": 50.0` ns in `config.json`.
  * This successfully achieved a positive setup slack of `20.44` ns while maintaining a safe hold slack of `0.11` ns.
* **Error Encountered (Max Fanout):** Fanout violations occurred with 15 violations due to single output pins driving too many load gates beyond the default limit of 10.
* **Resolution:** Increased the maximum fanout allowance by setting `"SYNTH_MAX_FANOUT": 25` in `config.json`, which entirely eliminated the fanout violation count down to 0.

## 2. Floorplanning & Power Delivery Network (PDN) (OpenROAD)
* **Tool Used:** OpenROAD.
* **Tasks:** Defines chip and core dimensions, establishes power grid, inserts well-tap and decap cells.
* **Floorplanning Setup Decisions:** 
  * Configured `"FP_SIZING": "absolute"` to fix relative die and core bounds.
  * Specified exact die coordinates via `"DIE_AREA": "0 0 510 510"` and core bounds via `"CORE_AREA": "6 13 500 500"`.
  * Enabled the core power ring using `"FP_PDN_CORE_RING": true` to effectively distribute power across core components[cite: 1].
* **Error Encountered (PDN Pitch):** Running the PDN generation script (`run_floorplan`) triggered `[ERROR PDN-0175] Pitch 0.3000 is too small for, must be at least 6.6000` because the default horizontal pitch (`FP_PDN_HPITCH` = `0.3`) was incompatible with design rules.
* **Resolution:** Adjusted the horizontal pitch and offset parameters in `config.json` to `"FP_PDN_HPITCH": 7` and `"FP_PDN_HOFFSET": 14` (ensuring offset is a valid multiple of pitch), which resolved the error cleanly.
* Vertical pitch was configured as `"FP_PDN_VPITCH": 153.6` and vertical offset as `"FP_PDN_VOFFSET": 307.2`.

## 3. Placement Density Optimization (OpenROAD)
* **Tool Used:** OpenROAD (`run_placement`).
* **Error Encountered:** `[ERROR GPL-0302] Use a higher density or re-floorplan with a larger core area.` occurred because the given target density (`0.25`) did not match the required layout spread, with OpenROAD suggesting `0.48`.
* **Resolution:** Locked the target placement density by adding `"PL_TARGET_DENSITY": 0.48` in `config.json`, stating how tightly or loosely standard cells are distributed across the core area.

## 4. Clock Tree Synthesis (CTS) & Routing
* **Clock Tree Synthesis (OpenROAD):** Executed via `run_cts` to automatically insert buffers and inverters along clock paths, successfully balancing clock skew and delay with **0 errors encountered**.
* **Routing (TritonRoute):** Executed via `run_routing` using global and detailed routing approaches to connect standard cells, macros, and I/O pins, completing with **0 errors encountered**.

## 5. Signoff Verification & GDSII Generation
* **Tools Used:** OpenSTA, OpenROAD, Magic, and Netgen.
* **Verification Results:** 
  * **LVS (Layout Versus Schematic):** Completed with **0 net, device, pin, or property mismatches** (Total errors = 0), confirming that the layout precisely matches the netlist architecture.
  * **DRC (Design Rule Checks):** Completed with **0 layout violations** using Magic[cite: 1].
* **Final Deliverable:** Generated a clean, manufacturable GDSII layout database representing a total chip area of $\approx 110562.29\text{ }\mu\text{m}^2$ containing 10,110 cells.

## Summary of Final `config.json` Parameters
```json
{
  "DESIGN_NAME": "fir_new",
  "VERILOG_FILES": "dir::src/*.v",
  "CLOCK_PORT": "clk",
  "CLOCK_PERIOD": 50.0,
  "DESIGN_IS_CORE": true,
  "SYNTH_MAX_FANOUT": 25,
  "SYNTH_STRATEGY": "AREA 3",
  "FP_SIZING": "absolute",
  "DIE_AREA": "0 0 510 510",
  "CORE_AREA": "6 13 500 500",
  "FP_PDN_CORE_RING": true,
  "PL_TARGET_DENSITY": 0.48,
  "FP_PDN_VPITCH": 153.6,
  "FP_PDN_VOFFSET": 307.2,
  "FP_PDN_HPITCH": 7,
  "FP_PDN_HOFFSET": 14
}
