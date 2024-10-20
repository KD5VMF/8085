
# FigTroniX 80C85 RealTime Clock (2024 VER 3)

## Overview
The **FigTroniX 80C85 RealTime Clock 2024 VER 3** is a hardware and software implementation of a real-time clock system built around the 80C85 microprocessor and an M48T02-70PC1 Real-Time Clock module. This project is designed to work with HDLG-2416 alphanumeric LED displays connected via an Intel 8155 I/O chip.

The clock keeps time in both hexadecimal and decimal formats, and users can interact with the system to modify hours and minutes via buttons connected to the system. The real-time clock data is maintained even when power is off using the M48T02-70PC1 RTC module, which includes battery-backed RAM.

## Hardware Components

### 1. **80C85 Microprocessor**
   - The **80C85** is an 8-bit microprocessor used to handle the main operations of this clock. It executes the assembly instructions that control the timing, display, and user interactions.

### 2. **M48T02-70PC1 Real-Time Clock**
   - The **M48T02-70PC1** module provides real-time clock (RTC) functionality with built-in battery backup. This ensures that the clock maintains accurate time even when the system is powered off.

### 3. **HDLG-2416 Alphanumeric LED Displays**
   - The **HDLG-2416** is a 4-digit alphanumeric LED display used to show the hours, minutes, and seconds. The project uses two of these displays to show time in a human-readable format.
   - The left display is mapped to the address `$80H` and the right display is mapped to `$C0H`.

### 4. **Intel 8155 I/O Chip**
   - The **Intel 8155** serves as an interface between the microprocessor and the LED displays. It also manages input buttons used for setting the time.

### 5. **Buttons and Input Circuitry**
   - Two buttons are used to set the time. One button increases the hour, while the other increases the minute. These buttons are debounced using an RC circuit to prevent unwanted state changes due to switch bounce.

## Software Description

The software for this project is written in BASIC and Assembly. It controls the clock’s operation, display output, and user interaction. Below is an overview of the key software components:

### 1. **Clock Initialization**
   The clock is initialized by writing zero to the necessary memory locations:
   ```basic
   Poke $fff8, $00  'Initialize clock
   Poke $fff9, $00  'Initialize seconds
   Poke $fffc, $00  'Initialize minutes
   Poke $fffd, $00  'Initialize hours
   Poke $fffe, $00  'Start clock
   ```

### 2. **Time Display**
   The clock displays the time using the HDLG-2416 displays. Each display is addressed using the Intel 8155 I/O chip. The colon between hours and minutes is toggled every second to mimic a typical clock behavior:
   ```basic
   Put $81, $3A  ' Place colon on left display
   Put $C2, $3A  ' Place colon on right display
   ```

### 3. **Binary-Coded Decimal (BCD) Handling**
   The 80C85 works with BCD values for timekeeping. Special assembly routines are used to convert BCD to binary and ASCII formats for display purposes:
   ```assembly
   ASM:BCDBIN:
   ASM:        PUSH B      'Save BC register
   ASM:        PUSH D      'Save DE register
   ASM:        MOV B,A     'Save BCD value
   ASM:        ANI 0FH     'Mask least significant nibble
   ASM:        MOV C,A     'Save lower BCD
   ASM:        MOV A,B     'Get upper BCD nibble
   ASM:        ANI F0H     'Mask most significant nibble
   ASM:        RRC         'Rotate to shift upper nibble into position
   ASM:        RRC
   ASM:        ADD C       'Add lower nibble
   ASM:        POP D       'Restore DE register
   ASM:        POP B       'Restore BC register
   ```

### 4. **User Interaction and Time Adjustment**
   The system allows users to adjust the hour and minute by pressing the corresponding buttons. When a button is pressed, the program increments the hour or minute, adjusts for BCD overflow, and updates the display:
   ```basic
   If hrbutton = $08 Then
      ' Increase hour by 1, handle BCD overflow
      Poke $fffb, (Peek($fffb) + 1)
   End If
   ```

### 5. **Main Loop and Timekeeping**
   The program’s main loop continually checks for changes in the second value to update the display. This ensures the time is shown in real-time while allowing for button presses to adjust the time as needed:
   ```basic
   secondcheck:
   sec = Peek($fff9)  'Read seconds from RTC
   If sec = seccheck Then
      Goto secondcheck  'Wait until the second changes
   Else
      Goto clockmain    'Update time and display
   Endif
   ```

## License
This project is licensed under the MIT License.

## Contributions
If you'd like to contribute to the FigTroniX 80C85 RealTime Clock project, please feel free to submit pull requests or report issues via the repository on GitHub.

## Acknowledgements
Special thanks to the open-source community and the creators of the 80C85, M48T02-70PC1, and HDLG-2416 components.
