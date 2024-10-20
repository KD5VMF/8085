
# FigTroniX 8085 RealTime Clock 2024 VER 4

## Project Overview

This project is a real-time clock using the 80C85 microprocessor, interfaced with two HDLG-2416 alphanumeric LED displays to show the current time. The time is displayed in hours, minutes, and seconds, and it scrolls from right to left across both displays. The clock can be configured to display time in either decimal or hexadecimal format, and buttons are used to adjust the hours and minutes.

## Features

- **Real-Time Clock:** Displays hours, minutes, and seconds on two HDLG-2416 alphanumeric displays.
- **Scrolling Display:** The time scrolls from the right display to the left and then blanks before repeating.
- **Switchable Display Format:** The clock can display time in either decimal or hexadecimal format.
- **Button Input:** Two buttons are used to increment hours and minutes, with an added RC circuit for debounce to ensure smooth operation.
- **Colon Blinking:** The colon between hours and minutes blinks every second.
- **Automatic Time Updating:** The clock updates its internal RAM storage of time, preventing errors during button presses.

## Hardware

- **Microprocessor:** 80C85
- **Display:** 2 x HDLG-2416 alphanumeric LED displays
  - Left display: starts at address 80H
  - Right display: starts at address C0H
- **Button Input:** 2 buttons (hour and minute adjust)
- **Debounce Circuit:** RC circuit added to buttons to prevent bouncing.

## Memory Mapping

- **Display Addressing:**
  - Left Display (4 characters): Address range 80H - 83H
  - Right Display (4 characters): Address range C0H - C3H
- **Time Storage:**
  - Time in ASCII: $C000
  - Time in Binary: $B000

## Code Highlights

The clock is programmed to toggle between displaying time in decimal and hexadecimal formats, and it handles binary-coded decimal (BCD) conversions. Here are some key parts of the code:

- **BCD to Binary Conversion:**
  ```assembly
  ASM:BCDBIN:
  ASM:        PUSH B      'SAVE BC REG
  ASM:        PUSH D      'SAVE DE REG
  ASM:        MOV B,A     'SAVE BCD
  ASM:        ANI 0FH     'MASK LEAST SIGNIFICANT FOUR BITS
  ASM:        MOV C,A     'SAVE UNPACKED BCD IN C REG
  ASM:        MOV A,B     'GET BCD AGAIN
  ASM:        ANI F0H     'MASK MOST SIGNIFICANT FOUR BITS
  ASM:        RRC         'SHIFT FOUR TIMES TO GET UPPER NIBBLE
  ASM:        RRC
  ASM:        RRC
  ASM:        RRC
  ASM:        MOV D,A     'SAVE UPPER NIBBLE
  ASM:        MVI E,10    'SET E AS MULTIPLIER OF 10
  ASM:SUM:
  ASM:        DCR D       'DECREMENT D
  ASM:        JZ SUM_END  'IF D=0, EXIT LOOP
  ASM:        ADD E       'ADD 10 TO A
  ASM:        JMP SUM     'REPEAT LOOP
  ASM:SUM_END:
  ASM:        ADD C       'ADD LOWER NIBBLE
  ASM:        POP D       'RETRIEVE PREVIOUS CONTENTS
  ASM:        POP B
  ASM:        RET         'RETURN
  ```

- **Scrolling Time Display:** 
  The code scrolls the time from the right display to the left, with proper addressing of each character slot on the HDLG-2416 displays.

## Schematic and Gerber Files

Please refer to the included schematic and Gerber files for the complete hardware design. These files detail the connections between the 80C85, the HDLG-2416 displays, the buttons, and the supporting components like the debounce RC circuits.

## Usage Instructions

1. Power on the system and the real-time clock will start automatically.
2. To adjust the time:
   - Press the **hour button** to increment the hours.
   - Press the **minute button** to increment the minutes.
3. The time will scroll continuously from the right display to the left.
4. Switch between decimal and hexadecimal display using the designated input switch.

## Future Improvements

- **Improved Scrolling Speed:** Adjust the delay between display updates for smoother scrolling.
- **Custom Character Display:** Add support for custom characters or animations on the LED displays.
- **Time Syncing:** Integrate an external time source for automatic synchronization.

## License

This project is open-source and licensed under the MIT License.

## Credits

- Designed by FigTroniX
- 2024 Version 3, incorporating improved scrolling and RC debounce circuits.
