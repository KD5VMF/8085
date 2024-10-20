
# FigTroniX 8085 RealTime Clock 2024 Ver 4

## Overview

This project, **FigTroniX 8085 RealTime Clock (2024 Ver 4)**, is designed to work with an Intel 8085 microprocessor-based system. It includes a RealTime Clock (RTC) using the M48T02-70PC1, an STMicroelectronics Timekeeper, for timekeeping and utilizes dual HDLG-2416 alphanumeric LED displays. The purpose of this system is to maintain and display the current time in BCD format, allowing user input via buttons to adjust the time, all while operating through assembly and BASIC code.

## Hardware Components

### Core Processor
- **Intel 8085 Microprocessor**: A classic 8-bit CPU used for controlling the real-time clock and managing data in the system.

### RTC
- **M48T02-70PC1 RealTime Clock (RTC)**: A 2K x 8 non-volatile static RAM and Timekeeper, capable of maintaining accurate timekeeping, even with power off, thanks to an embedded lithium energy source. This RTC stores seconds, minutes, and hours in BCD format, supporting real-time clock operations for long-term timekeeping.

### Memory & I/O
- **8155 I/O Chip**: Used for controlling the input and output operations, as well as the LED displays. The chip has built-in ports and timer capabilities.
- **Memory Mapped I/O**: The system uses memory addresses for interacting with the I/O peripherals and RTC, including display memory.

### LED Display
- **Dual HDLG-2416 Alphanumeric Displays**: Each display contains four 5x7 dot matrix alphanumeric characters. Two displays are used in this design, with addresses starting from 0x80 for the right display and 0xC0 for the left display. These displays show the time in BCD format and allow for visual feedback during user input.

### Buttons
- **Hour and Minute Adjust Buttons**: Two physical buttons are included, allowing the user to increment the hours and minutes displayed on the LED screens. Each button is debounced using an RC circuit for more reliable input.

### Power Supply and Clock
- **Oscillator Circuit**: A stable oscillator is implemented using the onboard clock for real-time timekeeping.

### Schematic Details
The schematic, titled **Mini (Ver 4 2024) Schematic**, provides a complete diagram of the hardware connections, including the 8085 CPU, M48T02-70PC1 RTC, dual HDLG-2416 displays, the 8155 I/O chip, and supporting components like resistors and capacitors for signal stability.

## Software Implementation

The project is programmed using a combination of **Assembly** and **BASIC** for the 8085 system. Below is a breakdown of the key functionalities:

### Code Functions
1. **Time Management**:
   - The system reads and writes time from/to the M48T02-70PC1 RTC, converting BCD time data to binary for internal calculations and ASCII for display purposes.
   
2. **User Input**:
   - The system allows users to adjust hours and minutes using two input buttons, interfacing with the 8155 I/O chip. The input buttons are debounced using an RC circuit.

3. **Display Control**:
   - The time is displayed on two HDLG-2416 alphanumeric LED displays. The right display starts at address `0x80` and the left display starts at address `0xC0`.

4. **Colon Blink**:
   - A blinking colon separates hours and minutes on the LED displays. The colon is controlled via a simple toggle logic that switches every second.

### Assembly Functions
- **BCDBIN**: Converts BCD (Binary Coded Decimal) time data into a binary format for internal processing.
- **BINASCII**: Converts binary values into their ASCII equivalents for display on the alphanumeric LEDs.

### Clock Update Logic
- The system reads the seconds, minutes, and hours from the M48T02-70PC1 RTC and updates the LED display.
- User input is processed to modify the hours and minutes, with changes reflected in both the RTC and the display.

### Example Code Snippet
```basic
Poke $fff8, $00  ' Initialize clock
Poke $fff9, $00  ' Initialize clock
Poke $fffc, $00  ' Initialize clock
Put $40, $42     ' Initialize 8155 ports (PORT A = INPUT, PORT B = OUTPUT, PORT C = INPUT)
Put $81, $3a     ' Place colon in display
Put $c2, $3a     ' Place colon in display
```

### Detailed Code Logic
The main loop in the code continually checks the seconds value from the RTC, and once a new second is detected, it updates the display. User inputs are checked for changes in hours and minutes, and the time is adjusted accordingly.

## Usage Instructions

1. **Starting the System**:
   - Power on the system. The LED displays will show the current time stored in the M48T02-70PC1 RTC.
   
2. **Adjusting Time**:
   - Use the two buttons to increment hours and minutes. The changes will be immediately reflected on the display.

3. **Viewing Time**:
   - The time will always be displayed on the alphanumeric LED displays in BCD format.

## Files Included

- **Source Code**: Assembly and BASIC files for the 8085 CPU and RTC interface.
- **Schematic**: Mini (Ver 4 2024) Schematic for the hardware layout.
- **README.md**: This file provides detailed information on hardware and software functionality.

## Conclusion

This project demonstrates how to build a fully functioning RealTime Clock using the Intel 8085 microprocessor, M48T02-70PC1 RTC, 8155 I/O, and dual HDLG-2416 displays. It showcases how both hardware and software work in unison to provide accurate timekeeping and user input handling for real-time clock adjustments.
