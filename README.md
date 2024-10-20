
# 80C85 Real-Time Clock with Scrolling Display

This project implements a real-time clock using the 80C85 microprocessor, featuring a scrolling time display across two HDLG-2416 alphanumeric displays. The clock reads the current time from the system's real-time clock and displays it in a scrolling fashion from right to left.

## Table of Contents

- [Overview](#overview)
- [Hardware Components](#hardware-components)
- [Software Components](#software-components)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Schematics and PCB Layout](#schematics-and-pcb-layout)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Overview

This project is a digital clock built around the 80C85 microprocessor. It displays the current time in hours, minutes, and seconds, scrolling across two HDLG-2416 displays. The clock supports setting the time using hour and minute buttons.

## Hardware Components

- **80C85 Microprocessor**
- **8155 Programmable Peripheral Interface**
- **Two HDLG-2416 Alphanumeric Displays**
- **Memory Modules (RAM/ROM)**
- **Real-Time Clock Module**
- **Input Buttons** for setting hours and minutes
- **Power Supply**
- **Miscellaneous Components**: Resistors, capacitors, connectors, etc.

## Software Components

The software is written in assembly language for the 8085 microprocessor and includes routines for:

- Reading time from the real-time clock
- Converting BCD values to binary and ASCII
- Scrolling the time display across the HDLG-2416 displays
- Handling button inputs for setting hours and minutes

### Key Files

- `clock.asm` - The main assembly code for the clock
- `makefile` - Makefile for assembling and linking the code (if applicable)
- `clock.hex` - The assembled machine code ready for programming into memory

## Getting Started

### Prerequisites

- **Assembler**: An 8085 assembler (e.g., [ASxxxx](https://shop-pdp.net/ashtml/asxxxx.htm))
- **Programmer**: For programming the memory modules
- **Hardware Components**: As listed above

### Assembly Instructions

1. **Assemble the Code**:

   Use your assembler to compile `clock.asm` into a hex file:

   ```bash
   as80 clock.asm -o clock.hex
   ```

   Replace `as80` with your assembler's command if different.

2. **Program the Memory Module**:

   Use a suitable programmer to load `clock.hex` into your ROM or EEPROM.

3. **Set Up the Hardware**:

   - Assemble the circuit according to the schematics provided.
   - Ensure all connections are secure and components are properly oriented.

4. **Power On**:

   Apply power to the system. The display should initialize and begin scrolling the current time.

## Usage

- **Scrolling Time Display**:

  The time scrolls from right to left across the two HDLG-2416 displays, starting from blank, showing the time, and then blanking before repeating.

- **Setting the Time**:

  - **Set Hours**: Press the **Hours** button connected to the 8155's PC0 port to increment the hour.
  - **Set Minutes**: Press the **Minutes** button connected to the 8155's PC1 port to increment the minute.

  The buttons include a simple debounce delay in the software to prevent multiple increments from a single press.

## Schematics and PCB Layout

The schematics and PCB layouts are available in the following directories:

- `schematics/` - Contains the circuit diagrams in PDF format
- `gerber/` - Contains the Gerber files for PCB manufacturing

Please refer to these files for detailed hardware setup.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

- **FigTroniX** - Original design inspiration
- **Community Contributors** - For support and code optimization
