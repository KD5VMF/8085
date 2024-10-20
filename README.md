
# FigTroniX 8085 RealTime Clock 2024 VER 4

## Project Overview

This project implements a Real-Time Clock (RTC) using an 8085 microprocessor and two HDLG-2416 alphanumeric LED displays. The project relies on the **M48T02-70PC1** timekeeper chip for maintaining accurate time, with user interaction provided via buttons to adjust hours and minutes. The time is displayed in a standard HH:MM:SS format on the alphanumeric displays, with optional hexadecimal or decimal output for seconds, minutes, and hours.

### Hardware

- **8085 microprocessor**
- **M48T02-70PC1** timekeeper chip
- **Two HDLG-2416 alphanumeric LED displays**:
  - Left display starting at address `80H`
  - Right display starting at address `C0H`
- **8155 I/O chip** for port and switch control
- **Button inputs** for adjusting the hour and minute settings
- **RC circuit** for button debounce to ensure stable user input

### Key Features

- Displays time in HH:MM:SS format with colons between the hour, minute, and second values.
- Button inputs allow users to manually adjust the hour and minute values.
- The seconds are displayed in binary format on the LED display.
- Supports switching between decimal and hexadecimal output for the time.
- Uses the **M48T02-70PC1** chip to maintain the time accurately, even when powered off.
- Provides clear colon display functionality for better visual separation of hours, minutes, and seconds.
