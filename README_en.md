# FPGA CNN Accelerator Based on Systolic Array

This project implements a convolutional neural network (CNN) accelerator
using a systolic-like array architecture on FPGA. It supports the first
convolutional layer of YOLOv3-Tiny and allows structural flexibility to
match different DSP resource constraints.

## License

Licensed under **GPL-3.0**.

## Introduction

Developed during August 2023 within approximately two weeks (after
several months of literature study), this accelerator was written
entirely in Verilog.\
The open-source project targets the **Zynq UltraScale+ MPSoC
xczu3eg-ubva530-2LV-e** platform.

The accelerator serves as one module in a larger system: HDMI image
input is processed by this FPGA module, which executes the quantized
first layer of YOLOv3-Tiny (including convolution, LeakyReLU, and max
pooling).\
The output is transferred via PCIe to a PC, where the GPU completes the
remaining inference stages for object detection.

## Architecture Overview

Due to limited hardware resources (only **87 DSPs** available on the
board), a systolic-like structure is adopted.
Two 1D convolution kernels remain fixed while feature map data flow
horizontally and accumulations flow vertically.
![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/10ae2238-bd6b-4936-9ee7-ad46464fcef3)

## Code Structure

    ├── sources/    # RTL code and IP cores
    ├── sim/        # Simulation testbenches
    ├── coe/        # .coe files for ROM initialization

All IP cores were generated using Vivado. Configuration snapshots are
included to help others reproduce the environment.

## Performance

-   Operating frequency: **148.5 MHz**, aligned with the HDMI 1080p@60Hz
    interface.
-   Processing is performed line-by-line synchronized with HDMI data
    stream.
-   The system design ensures real-time operation without frame loss.
-   Although higher frequencies are possible, they complicate HDMI
    timing integration.

## Design Details
![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/cc61ed47-8035-47d7-9df7-1be32338c7fb)  

### 1. Data Input

-   Original input: 1920×1080 image via HDMI.
-   Downsampled to 480×270, with the last 14 lines discarded → final
    480×256.
-   Resizing performed by sampling every 4th column and every 4th row.
-   Three-line FIFO buffer stores image rows for convolution; each
    buffer outputs data to nine pseudo dual-port RAMs forming the 3×3
    input window.
-   Appropriate delay chains ensure proper alignment before feeding data
    into the PE (Processing Element) array.
    
  ![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/0fd034f1-fecb-4c11-a093-a4d70bf0cd99)  

### 2. Weight Buffer Module

-   Convolution weights are stored in ROM initialized with `.dat`
    files.
-   Each compute unit processes **two kernels** in parallel (3×3×2 = 18
    coefficients).
-   After finishing one pair of kernels, new weights are loaded and
    computation resumes with reset feature map addresses.
    ![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/e7713776-fe73-48d8-ae08-7205c61f7505) 

### 3. Multiply-Accumulate Unit (Systolic Array)

-   The systolic structure replaces the traditional adder tree, reducing
    resource usage and improving scalability.
-   Feature data (F) propagate downward; weights (W) move horizontally.
-   Each PE performs:
    P = F × W + C
-   Two kernels are processed simultaneously by duplicating the signal
    paths.

### 4. Pooling Unit

-   Implements **max pooling** with kernel size 2 and stride 2.
-   Two-stage pooling process:
    1.  Horizontal reduction: compare adjacent pixels to halve width.
    2.  Vertical reduction: use line buffer to compare rows and halve
        height.
![image](https://github.com/odin2985/AI-accerator-based-on-systolic/assets/75004653/0fae9ed7-dfe7-46dc-a830-92289224820c) 

## Results

The design successfully demonstrates real-time convolution processing of
the first YOLOv3-Tiny layer.
Future optimization may include support for deeper layers, improved
memory reuse, and expansion to multi-channel convolution.

## Future Work

-   Add full YOLOv3-Tiny support.
-   Improve modularity and parameterization.
-   Enhance on-board verification with additional datasets.

## License

This project is licensed under the **GNU General Public License v3.0
(GPL-3.0)**.

## Author

**Guoning Huang**
