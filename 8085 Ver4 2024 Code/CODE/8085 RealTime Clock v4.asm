; Compiled with: 8085 Simulator IDE v6.67
; Microprocessor model: 8085
; Clock frequency: 4.0MHz
;
;       The address of 'read' (ushort) (global) is 0xFEF6 (-10)
;       The address of 'write' (ushort) (global) is 0xFEF9 (-7)
;       The address of 'startclkupdate' (ushort) (global) is 0xFEF8 (-8)
;       The address of 'timeascii' (long) (global) is 0xFEEE (-18)
;       The address of 'timebin' (long) (global) is 0xFEEA (-22)
;       The address of 'sec' (ushort) (global) is 0xFEFB (-5)
;       The address of 'seccheck' (ushort) (global) is 0xFEF7 (-9)
;       The address of 'min' (ushort) (global) is 0xFEF5 (-11)
;       The address of 'hr' (integer) (global) is 0xFEE8 (-24)
;       The address of 'addmin' (ushort) (global) is 0xFEFF (-1)
;       The address of 'addhr' (ushort) (global) is 0xFEFE (-2)
;       The address of 'hrbutton' (ushort) (global) is 0xFEF4 (-12)
;       The address of 'minbutton' (ushort) (global) is 0xFEF3 (-13)
;       The address of 'incounter' (ushort) (global) is 0xFEFD (-3)
;       The address of 'outcounter' (ushort) (global) is 0xFEFC (-4)
;       The address of 'checkhexsw' (ushort) (global) is 0xFEF2 (-14)
;       The address of 'colon_state' (ushort) (global) is 0xFEFA (-6)
	EXX_BC .EQU 0xFF02
	EXX_DE .EQU 0xFF04
	EXX_HL .EQU 0xFF06
	EXX_TEMP .EQU 0xFF08
	EXX_TEMPHL .EQU 0xFF0A
	A_TEMP .EQU 0xFF0C
	REG_R3 .EQU 0xFEE7
	REG_R2 .EQU 0xFEE6
	REG_R1 .EQU 0xFEE5
	REG_R0 .EQU 0xFEE4
	.ORG 0000H
	LXI H,0FF00H
	LXI SP,0FEE2H
; User code start
; 1: 'FigTroniX 80C85 RealTime Clock 2024 VER 3
; 2: 
; 3: ' Initialize clock
; 4: Poke $fff8, $00  'iniz clock
	XRA A
	STA 0FFF8H
; 5: Poke $fff9, $00  'iniz clock
	XRA A
	STA 0FFF9H
; 6: Poke $fffc, $00  'iniz clock
	XRA A
	STA 0FFFCH
; 7: Poke $fffd, $00  'iniz clock
	XRA A
	STA 0FFFDH
; 8: Poke $fffe, $00  'iniz clock
	XRA A
	STA 0FFFEH
; 9: 
; 10: ' Initialize 8155 ports and display colons
; 11: Put $40, $42  'iniz 8155 PORT A = INPUT, PORT B = OUTPUT, PORT C = INPUT
	MVI A,42H
	OUT 40H
; 12: Put $42, $00  'clear led 8155
	XRA A
	OUT 42H
; 13: Put $81, $3a  'place : for clock
	MVI A,3AH
	OUT 81H
; 14: Put $c2, $3a  'place : for clock
	MVI A,3AH
	OUT 0C2H
; 15: 
; 16: ' Variable declarations
; 17: Dim read As Byte
; 18: Dim write As Byte
; 19: Dim startclkupdate As Byte
; 20: Dim timeascii As Long
; 21: Dim timebin As Long
; 22: Dim sec As Byte
; 23: Dim seccheck As Byte
; 24: Dim min As Byte
; 25: Dim hr As Integer
; 26: Dim addmin As Byte
; 27: Dim addhr As Byte
; 28: Dim hrbutton As Byte
; 29: Dim minbutton As Byte
; 30: Dim incounter As Byte
; 31: Dim outcounter As Byte
; 32: Dim checkhexsw As Byte
; 33: Dim colon_state As Byte  ' Added colon_state variable
; 34: 
; 35: ' Initialize variables
; 36: timeascii = $c000  'SET SAVE POINT FOR TIME IN ASCII
	LXI B,0000H
	LXI D,0C000H
	XCHG
	SHLD 0FEEEH
	MOV H,B
	MOV L,C
	SHLD 0FEF0H
; 37: timebin = $b000    'SET SAVE POINT FOR TIME IN BIN
	LXI B,0000H
	LXI D,0B000H
	XCHG
	SHLD 0FEEAH
	MOV H,B
	MOV L,C
	SHLD 0FEECH
; 38: read = $40         'NEEDED FOR THE UPDATE OF THE RAM LOCATIONS TO ALLOW THE USER TO READ THE TIME
	MVI A,40H
	STA 0FEF6H
; 39: write = $80        'NEEDED FOR THE UPDATE OF THE RAM LOCATIONS TO ALLOW THE USER TO WRITE THE TIME
	MVI A,80H
	STA 0FEF9H
; 40: startclkupdate = $00  'NEEDED TO START THE CLOCK ON THE REALTIME CLOCK
	XRA A
	STA 0FEF8H
; 41: colon_state = 1       ' Initialize colon_state to 1 (colons displayed)
	MVI A,01H
	STA 0FEFAH
; 42: 
; 43: ' Main clock loop
; 44: clockmain:
L0001:	
; 45: Poke $fff8, read  'STOP RAM UPDATE TO PREVENT READING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
	LDA 0FEF6H
	STA 0FFF8H
; 46: sec = Peek($fff9)  'SAVE SEC Data AS INTEGER
	LDA 0FFF9H
	STA 0FEFBH
; 47: seccheck = sec     'Save SEC to loop until a new sec is detected
	LDA 0FEFBH
	STA 0FEF7H
; 48: min = Peek($fffa)  'SAVE MIN Data AS INTEGER
	LDA 0FFFAH
	STA 0FEF5H
; 49: hr = Peek($fffb)   'SAVE HR Data AS INTEGER
	LDA 0FFFBH
	MOV E,A
	MVI D,00H
	XCHG
	SHLD 0FEE8H
; 50: 
; 51: ' Toggle the colon state
; 52: colon_state = 1 - colon_state  ' Switch between 1 and 0
	MVI A,01H
	LXI H,0FEFAH
	MOV L,M
	SUB L
	STA 0FEFAH
; 53: 
; 54: ' Display or clear the colons based on colon_state
; 55: If colon_state = 1 Then
	LDA 0FEFAH
	MVI L,01H
	CMP L
	JNZ L0010
; 56: Put $81, $3a  'place : for clock
	MVI A,3AH
	OUT 81H
; 57: Put $c2, $3a  'place : for clock
	MVI A,3AH
	OUT 0C2H
; 58: Else
	JMP L0011
L0010:	
; 59: Put $81, $3a  'clear : for clock $20 (space character)
	MVI A,3AH
	OUT 81H
; 60: Put $c2, $3a  'clear : for clock $20 (space character)
	MVI A,3AH
	OUT 0C2H
; 61: Endif
L0011:	
; 62: 
; 63: '*******************************************LED BINARY SEC OUTPUT*******************************************
; 64: ASM:        LXI H,sec      'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR SEC
	LXI H,0FEFBh
; 65: ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
	LXI B,0FEEAh
; 66: ASM:        MOV A,M        'GET BCD
	MOV A,M
; 67: ASM:        CALL BCDBIN    'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
	CALL L0004
; 68: ASM:        STAX B         'SAVE BINARY
	STAX B
; 69: ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY AGAIN
	LXI H,0FEEAh
; 70: ASM:        MOV A,M        'GET BIN
	MOV A,M
; 71: 'ASM:        CMA           'INVERT THE ACCUMULATOR (commented out as per original code)
; 72: ASM:        OUT 42H        'SEND BIN SEC OUT TO LED
	OUT 42H
; 73: 
; 74: '********************************CHECK SWITCH TO CHANGE BETWEEN DEC OR HEX OUT***************************
; 75: checkswitch:
L0002:	
; 76: checkhexsw = Get($41)  '8155 Port A
	IN 41H
	STA 0FEF2H
; 77: 
; 78: If checkhexsw > $00 Then  'OUTPUT IN DEC
	LDA 0FEF2H
	MVI L,00H
	STC
	SBB L
	JC L0012
; 79: ' Display seconds
; 80: ASM:        LXI H,sec     'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT SEC
	LXI H,0FEFBh
; 81: ASM:        CALL BINASCII 'CALL BINARY TO ASCII CONVERSION
	CALL L0007
; 82: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEEEh
; 83: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 84: ASM:        OUT 00C1H     'SEND TO DISPLAY
	OUT 00C1H
; 85: ASM:        INX H         'POINT TO NEXT ASCII CHAR
	INX H
; 86: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 87: ASM:        OUT 00C0H     'SEND TO DISPLAY
	OUT 00C0H
; 88: 
; 89: ' Display minutes
; 90: ASM:        LXI H,min     'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT MIN
	LXI H,0FEF5h
; 91: ASM:        CALL BINASCII 'CALL BINARY TO ASCII CONVERSION
	CALL L0007
; 92: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEEEh
; 93: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 94: ASM:        OUT 0080H     'SEND TO DISPLAY
	OUT 0080H
; 95: ASM:        INX H         'POINT TO NEXT ASCII CHAR
	INX H
; 96: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 97: ASM:        OUT 00C3H     'SEND TO DISPLAY
	OUT 00C3H
; 98: 
; 99: ' Display hours
; 100: ASM:        LXI H,hr      'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT HR
	LXI H,0FEE8h
; 101: ASM:        CALL BINASCII 'CALL BINARY TO ASCII CONVERSION
	CALL L0007
; 102: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEEEh
; 103: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 104: ASM:        OUT 0083H     'SEND TO DISPLAY
	OUT 0083H
; 105: ASM:        INX H         'POINT TO NEXT ASCII CHAR
	INX H
; 106: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 107: ASM:        OUT 0082H     'SEND TO DISPLAY
	OUT 0082H
; 108: 
; 109: Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE
	LDA 0FEF8H
	STA 0FFF8H
; 110: Else  'OUTPUT IN HEX
	JMP L0013
L0012:	
; 111: ' Display seconds in HEX
; 112: ASM:        LXI H,sec     'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR SEC
	LXI H,0FEFBh
; 113: ASM:        LXI B,timebin 'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
	LXI B,0FEEAh
; 114: ASM:        MOV A,M       'GET BCD
	MOV A,M
; 115: ASM:        CALL BCDBIN   'CONVERT BCD TO BINARY
	CALL L0004
; 116: ASM:        STAX B        'SAVE BINARY
	STAX B
; 117: ASM:        LXI H,timebin 'POINT TO BINARY TIME
	LXI H,0FEEAh
; 118: ASM:        CALL BINASCII 'CONVERT BINARY TO ASCII
	CALL L0007
; 119: ASM:        LXI H,timeascii  'POINT TO ASCII TIME
	LXI H,0FEEEh
; 120: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 121: ASM:        OUT 00C1H     'SEND TO DISPLAY
	OUT 00C1H
; 122: ASM:        INX H         'POINT TO NEXT ASCII CHAR
	INX H
; 123: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 124: ASM:        OUT 00C0H     'SEND TO DISPLAY
	OUT 00C0H
; 125: 
; 126: ' Display minutes in HEX
; 127: ASM:        LXI H,min     'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR MIN
	LXI H,0FEF5h
; 128: ASM:        LXI B,timebin 'POINT TO BINARY TIME STORAGE
	LXI B,0FEEAh
; 129: ASM:        MOV A,M       'GET BCD
	MOV A,M
; 130: ASM:        CALL BCDBIN   'CONVERT BCD TO BINARY
	CALL L0004
; 131: ASM:        STAX B        'SAVE BINARY
	STAX B
; 132: ASM:        LXI H,timebin 'POINT TO BINARY TIME
	LXI H,0FEEAh
; 133: ASM:        CALL BINASCII 'CONVERT BINARY TO ASCII
	CALL L0007
; 134: ASM:        LXI H,timeascii  'POINT TO ASCII TIME
	LXI H,0FEEEh
; 135: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 136: ASM:        OUT 0080H     'SEND TO DISPLAY
	OUT 0080H
; 137: ASM:        INX H         'POINT TO NEXT ASCII CHAR
	INX H
; 138: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 139: ASM:        OUT 00C3H     'SEND TO DISPLAY
	OUT 00C3H
; 140: 
; 141: ' Display hours in HEX
; 142: ASM:        LXI H,hr      'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR HR
	LXI H,0FEE8h
; 143: ASM:        LXI B,timebin 'POINT TO BINARY TIME STORAGE
	LXI B,0FEEAh
; 144: ASM:        MOV A,M       'GET BCD
	MOV A,M
; 145: ASM:        CALL BCDBIN   'CONVERT BCD TO BINARY
	CALL L0004
; 146: ASM:        STAX B        'SAVE BINARY
	STAX B
; 147: ASM:        LXI H,timebin 'POINT TO BINARY TIME
	LXI H,0FEEAh
; 148: ASM:        CALL BINASCII 'CONVERT BINARY TO ASCII
	CALL L0007
; 149: ASM:        LXI H,timeascii  'POINT TO ASCII TIME
	LXI H,0FEEEh
; 150: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 151: ASM:        OUT 0083H     'SEND TO DISPLAY
	OUT 0083H
; 152: ASM:        INX H         'POINT TO NEXT ASCII CHAR
	INX H
; 153: ASM:        MOV A,M       'GET ASCII
	MOV A,M
; 154: ASM:        OUT 0082H     'SEND TO DISPLAY
	OUT 0082H
; 155: 
; 156: Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE
	LDA 0FEF8H
	STA 0FFF8H
; 157: Endif
L0013:	
; 158: 
; 159: 'CHECK HR BUTTON LOGIC
; 160: hrbutton = Get($43)  'SET VAR TO BUTTON INPUT FROM 8155 PC0
	IN 43H
	STA 0FEF4H
; 161: If hrbutton = $08 Then  'LOGIC, DETECT BUTTON PRESS
	LDA 0FEF4H
	MVI L,08H
	CMP L
	JNZ L0014
; 162: Poke $fff8, write   'STOP RAM UPDATE TO PREVENT WRITING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
	LDA 0FEF9H
	STA 0FFF8H
; 163: addhr = Peek($fffb) 'GET HR
	LDA 0FFFBH
	STA 0FEFEH
; 164: addhr = addhr + 1   'INCREASE HR BY ONE
	LDA 0FEFEH
	MVI L,01H
	ADD L
	STA 0FEFEH
; 165: ' Adjust for BCD overflow
; 166: If (addhr And $0f) > $09 Then addhr = addhr + $06
	oshonsoft_temp_ushort_1 .EQU 0xFEE3
	MVI C,0FH
	LDA 0FEFEH
	ANA C
	STA 0FEE3H
	oshonsoft_temp_boolean_2 .EQU 0xFEE2
	XRA A
	STA 0FEE2H
	LDA 0FEE3H
	MVI L,09H
	STC
	SBB L
	JC L0016
	MVI A,0FFH
	STA 0FEE2H
L0016:	
	LDA 0FEE2H
	MVI L,0FFH
	SUB L
	JNZ L0015
	LDA 0FEFEH
	MVI L,06H
	ADD L
	STA 0FEFEH
L0015:	
; 167: If addhr > $23 Then addhr = $00  ' Reset hour if overflow
	LDA 0FEFEH
	MVI L,23H
	STC
	SBB L
	JC L0017
	XRA A
	STA 0FEFEH
L0017:	
; 168: Poke $fffb, addhr    'PLACE NEW HR TO RAM LOCATION
	LDA 0FEFEH
	STA 0FFFBH
; 169: Poke $fff8, startclkupdate  'RESTART THE CLOCK
	LDA 0FEF8H
	STA 0FFF8H
; 170: 'WAIT FOR BOUNCE PREVENTION
; 171: For outcounter = 0 To 10
	XRA A
	STA 0FEFCH
L0018:	
	LDA 0FEFCH
	MVI L,0AH
	STC
	SBB L
	JNC L0019
; 172: For incounter = 0 To 10
	XRA A
	STA 0FEFDH
L0020:	
	LDA 0FEFDH
	MVI L,0AH
	STC
	SBB L
	JNC L0021
; 173: Next incounter
	LDA 0FEFDH
	MVI L,01H
	ADD L
	STA 0FEFDH
	JC L0021
	JMP L0020
L0021:	
; 174: Next outcounter
	LDA 0FEFCH
	MVI L,01H
	ADD L
	STA 0FEFCH
	JC L0019
	JMP L0018
L0019:	
; 175: Endif
L0014:	
; 176: 
; 177: 'CHECK MIN BUTTON LOGIC
; 178: minbutton = Get($43)  'SET VAR TO BUTTON INPUT FROM 8155 PC1
	IN 43H
	STA 0FEF3H
; 179: If minbutton = $04 Then  'LOGIC, DETECT BUTTON PRESS
	LDA 0FEF3H
	MVI L,04H
	CMP L
	JNZ L0022
; 180: Poke $fff8, write   'STOP RAM UPDATE TO PREVENT WRITING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
	LDA 0FEF9H
	STA 0FFF8H
; 181: Poke $fff9, $00     'WRITE 00 TO THE SEC LOCATION.
	XRA A
	STA 0FFF9H
; 182: addmin = Peek($fffa) 'GET MIN
	LDA 0FFFAH
	STA 0FEFFH
; 183: addmin = addmin + 1  'INCREASE MIN BY ONE
	LDA 0FEFFH
	MVI L,01H
	ADD L
	STA 0FEFFH
; 184: ' Adjust for BCD overflow
; 185: If (addmin And $0f) > $09 Then addmin = addmin + $06
	MVI C,0FH
	LDA 0FEFFH
	ANA C
	STA 0FEE3H
	XRA A
	STA 0FEE2H
	LDA 0FEE3H
	MVI L,09H
	STC
	SBB L
	JC L0024
	MVI A,0FFH
	STA 0FEE2H
L0024:	
	LDA 0FEE2H
	MVI L,0FFH
	SUB L
	JNZ L0023
	LDA 0FEFFH
	MVI L,06H
	ADD L
	STA 0FEFFH
L0023:	
; 186: If addmin > $59 Then addmin = $00  ' Reset minute if overflow
	LDA 0FEFFH
	MVI L,59H
	STC
	SBB L
	JC L0025
	XRA A
	STA 0FEFFH
L0025:	
; 187: Poke $fffa, addmin   'PLACE NEW MIN TO RAM LOCATION
	LDA 0FEFFH
	STA 0FFFAH
; 188: Poke $fff8, startclkupdate  'RESTART THE CLOCK
	LDA 0FEF8H
	STA 0FFF8H
; 189: 'WAIT FOR BOUNCE PREVENTION
; 190: For outcounter = 0 To 10
	XRA A
	STA 0FEFCH
L0026:	
	LDA 0FEFCH
	MVI L,0AH
	STC
	SBB L
	JNC L0027
; 191: For incounter = 0 To 10
	XRA A
	STA 0FEFDH
L0028:	
	LDA 0FEFDH
	MVI L,0AH
	STC
	SBB L
	JNC L0029
; 192: Next incounter
	LDA 0FEFDH
	MVI L,01H
	ADD L
	STA 0FEFDH
	JC L0029
	JMP L0028
L0029:	
; 193: Next outcounter
	LDA 0FEFCH
	MVI L,01H
	ADD L
	STA 0FEFCH
	JC L0027
	JMP L0026
L0027:	
; 194: Endif
L0022:	
; 195: 
; 196: 'RESTART THE CLOCK UPDATE
; 197: Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE
	LDA 0FEF8H
	STA 0FFF8H
; 198: 
; 199: ' Go to secondcheck to wait for the next second
; 200: Goto secondcheck
	JMP L0003
; 201: 
; 202: secondcheck:
L0003:	
; 203: sec = Peek($fff9)  'SAVE SEC LOCATION AS INTEGER
	LDA 0FFF9H
	STA 0FEFBH
; 204: If sec = seccheck Then
	LDA 0FEFBH
	LXI H,0FEF7H
	MOV L,M
	CMP L
	JNZ L0030
; 205: Goto secondcheck
	JMP L0003
; 206: Else
	JMP L0031
L0030:	
; 207: Goto clockmain
	JMP L0001
; 208: Endif
L0031:	
; 209: 
; 210: '*****************************************************GLOBAL FUNCTIONS*****************************************************
; 211: ASM:BCDBIN:
L0004:	
; 212: ASM:        PUSH B      'SAVE BC REG
	PUSH B
; 213: ASM:        PUSH D      'SAVE DE REG
	PUSH D
; 214: ASM:        MOV B,A     'SAVE BCD
	MOV B,A
; 215: ASM:        ANI 0FH     'MASK LEAST SIGNIFICANT FOUR BITS
	ANI 0FH
; 216: ASM:        MOV C,A     'SAVE UNPACKED BCD IN C REG
	MOV C,A
; 217: ASM:        MOV A,B     'GET BCD AGAIN
	MOV A,B
; 218: ASM:        ANI F0H     'MASK MOST SIGNIFICANT FOUR BITS
	ANI F0H
; 219: ASM:        RRC         'SHIFT FOUR TIMES TO GET UPPER NIBBLE
	RRC
; 220: ASM:        RRC
	RRC
; 221: ASM:        RRC
	RRC
; 222: ASM:        RRC
	RRC
; 223: ASM:        MOV D,A     'SAVE UPPER NIBBLE
	MOV D,A
; 224: ASM:        MVI E,10    'SET E AS MULTIPLIER OF 10
	MVI E,10
; 225: ASM:SUM:
L0005:	
; 226: ASM:        DCR D       'DECREMENT D
	DCR D
; 227: ASM:        JZ SUM_END  'IF D=0, EXIT LOOP
	JZ L0006
; 228: ASM:        ADD E       'ADD 10 TO A
	ADD E
; 229: ASM:        JMP SUM     'REPEAT LOOP
	JMP L0005
; 230: ASM:SUM_END:
L0006:	
; 231: ASM:        ADD C       'ADD LOWER NIBBLE
	ADD C
; 232: ASM:        POP D       'RETRIEVE PREVIOUS CONTENTS
	POP D
; 233: ASM:        POP B
	POP B
; 234: ASM:        RET         'RETURN
	RET
; 235: 
; 236: ASM:BINASCII:
L0007:	
; 237: ASM:        LXI D,timeascii  'POINT INDEX TO WHERE ASCII CODE IS TO BE STORED
	LXI D,0FEEEh
; 238: ASM:        MOV A,M          'GET BYTE
	MOV A,M
; 239: ASM:        MOV B,A          'SAVE BYTE
	MOV B,A
; 240: ASM:        RRC              'ROTATE FOUR TIMES TO PLACE THE FOUR HIGH ORDER BITS OF THE SELECTED BYTE IN THE LOW ORDER LOCATION
	RRC
; 241: ASM:        RRC
	RRC
; 242: ASM:        RRC
	RRC
; 243: ASM:        RRC
	RRC
; 244: ASM:        CALL ASCII       'CALL ASCII CONVERSION
	CALL L0008
; 245: ASM:        STAX D           'SAVE FIRST ASCII HEX
	STAX D
; 246: ASM:        INX D            'POINT TO NEXT MEMORY LOCATION
	INX D
; 247: ASM:        MOV A,B          'GET BYTE
	MOV A,B
; 248: ASM:        CALL ASCII       'CALL ASCII CONVERSION
	CALL L0008
; 249: ASM:        STAX D           'SAVE NEXT ASCII HEX
	STAX D
; 250: ASM:        RET              'RETURN
	RET
; 251: 
; 252: ASM:ASCII:
L0008:	
; 253: ASM:        ANI 0FH          'MASK HIGH-ORDER NIBBLE
	ANI 0FH
; 254: ASM:        CPI 0AH          'IS DIGIT LESS THAN 10?
	CPI 0AH
; 255: ASM:        JC CODE          'IF YES GOTO CODE TO ADD 30H
	JC L0009
; 256: ASM:        ADI 07H          'ELSE ADD 07H TO GET A - F CHAR
	ADI 07H
; 257: ASM:CODE:
L0009:	
; 258: ASM:        ADI 30H          'ADD 30H AS A DECIMAL OFFSET
	ADI 30H
; 259: ASM:        RET              'RETURN
	RET
; End of user code
	HLT
; End of listing
	.END
