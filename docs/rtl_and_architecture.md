# Chapter 1: Micro-architecture and Verilog RTL Specification

## 1.1 Functional Description
The `fir_filter` module is a 15-tap signed low-pass finite impulse response (FIR) designed for digital signal processing applications.
* **Sampling & Frequency Specs:** Designed with a sampling frequency of 48kHz, passband frequency of 2.4kHz, and stopband frequency of 9.6 kHz.
* **Input Stream:** 16-bit signed vector (`filter_in[15:0]`).
* **Output Stream:** Positive-edge clock (`clk`) and asynchronous high-active reset (`rst').
* **Control:** Positive-edge clock (`clk`) and asynchronous high-active reset (`rst`).

## 1.2 Transposed Direct-Form MAC Architecture
The design employs a **Transposed Direct-Form Multiply-Accumulate (MAC)** configuration to optimize critical path delays and maximize performance.
* Delay elements ($z^{-1}$) are placed between accumulator nodes rather than the input line, streamlining high-speed arithmetic operations.
* **Coefficients:** Uses 15 predetermined signed 16-bit coefficients (`b[0]` through `b[14]`) with a symmetrical profile with a peak tap at `b[7]` (`16h2310`).
