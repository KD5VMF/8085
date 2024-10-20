
# FigTroniX 8085 RealTime Clock 2024 VER 4

## Code Overview

This program implements a real-time clock using the 8085 microprocessor. The time is displayed across two HDLG-2416 alphanumeric LED displays. The left display begins at address `80H`, and the right display begins at `C0H`. The time is shown in the format `HH:MM:SS`, with colons that toggle on and off every second. The program also allows for adjusting the hour and minute values via button inputs.

### Initialization

The clock is initialized by setting the appropriate memory locations and configuring the 8155 I/O chip.

```basic
Poke $fff8, $00  'iniz clock
Poke $fff9, $00  'iniz clock
Poke $fffc, $00  'iniz clock
Poke $fffd, $00  'iniz clock
Poke $fffe, $00  'iniz clock
Put $40, $42  'iniz 8155 PORT A = INPUT, PORT B = OUTPUT, PORT C = INPUT
Put $42, $00  'clear led 8155
Put $81, $3a  'place : for clock
Put $c2, $3a  'place : for clock
```

### Main Loop and Display

The main clock loop reads time from memory, converts BCD values to binary, and outputs them to the LED displays. Colons between the hours, minutes, and seconds toggle on and off to create a blinking effect.


### Time Adjustment

Two buttons are used to adjust the hour and minute values. Button debounce is handled via an RC circuit. The buttons are connected to `PC0` and `PC1` of the 8155 I/O chip.

### Binary-to-ASCII Conversion

The BCD-to-ASCII conversion is handled via the following subroutine:

```assembly
ASM:BINASCII:
ASM:        LXI D,timeascii  'POINT INDEX TO WHERE ASCII CODE IS TO BE STORED
ASM:        MOV A,M          'GET BYTE
ASM:        MOV B,A          'SAVE BYTE
ASM:        RRC              'ROTATE FOUR TIMES TO PLACE THE FOUR HIGH ORDER BITS OF THE SELECTED BYTE IN THE LOW ORDER LOCATION
ASM:        RRC
ASM:        RRC
ASM:        RRC
ASM:        CALL ASCII       'CALL ASCII CONVERSION
ASM:        STAX D           'SAVE FIRST ASCII HEX
ASM:        INX D            'POINT TO NEXT MEMORY LOCATION
ASM:        MOV A,B          'GET BYTE
ASM:        CALL ASCII       'CALL ASCII CONVERSION
ASM:        STAX D           'SAVE NEXT ASCII HEX
ASM:        RET              'RETURN
```

### Hardware Requirements

- 8085 Microprocessor
- 8155 I/O Chip
- Two HDLG-2416 Alphanumeric LED Displays
- M48T02-70PC1 16Kb SRAM with RTC
- 
## Scrolling Feature

The time scrolls from the right display to the left display in a loop, then clears and repeats. This is achieved by writing to the appropriate memory locations for the displays, starting with the right display (`C0H`), followed by the left (`80H`).

## Usage

- **Hour Button:** Connected to `PC0` of 8155.
- **Minute Button:** Connected to `PC1` of 8155.
- **Scrolling:** The time will scroll from the right display to the left, showing the current time.

## License

Open to use and modify for personal or educational purposes.
