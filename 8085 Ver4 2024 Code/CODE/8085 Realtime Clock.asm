; Compiled with: 8085 Simulator IDE v4.54
; Microprocessor model: 8085
; Clock frequency: 5.0MHz
;
;       The address of 'read' (integer) (global) is FEF4H (-12)
;       The address of 'write' (integer) (global) is FEF2H (-14)
;       The address of 'startclkupdate' (integer) (global) is FEFAH (-6)
;       The address of 'timeascii' (integer) (global) is FEF8H (-8)
;       The address of 'timebin' (integer) (global) is FEF6H (-10)
;       The address of 'sec' (integer) (global) is FEE8H (-24)
;       The address of 'min' (integer) (global) is FEE6H (-26)
;       The address of 'hr' (integer) (global) is FEE4H (-28)
;       The address of 'addmin' (integer) (global) is FEFEH (-2)
;       The address of 'addhr' (integer) (global) is FEFCH (-4)
;       The address of 'hrbutton' (integer) (global) is FEE2H (-30)
;       The address of 'minbutton' (integer) (global) is FEE0H (-32)
;       The address of 'incounter' (integer) (global) is FEF0H (-16)
;       The address of 'outcounter' (integer) (global) is FEEEH (-18)
;       The address of 'checkhexsw' (integer) (global) is FEDEH (-34)
;       The address of 'intime' (integer) (global) is FEECH (-20)
;       The address of 'outtime' (integer) (global) is FEEAH (-22)
	LXI H,0FF00H
	LXI SP,0FEDEH
; User code start
; 1: 'FigTroniX 8085 RealTime Clock 2015
; 2: 
; 3: Poke $fff8, $00  'iniz clock
	LXI H,0FFF8H
	PUSH H
	LXI H,0000H
	MOV A,L
	POP D
	STAX D
; 4: Poke $fffc, $00  'iniz clock
	LXI H,0FFFCH
	PUSH H
	LXI H,0000H
	MOV A,L
	POP D
	STAX D
; 5: Poke $fff9, $00  'iniz clock
	LXI H,0FFF9H
	PUSH H
	LXI H,0000H
	MOV A,L
	POP D
	STAX D
; 6: Put $40, $42  'iniz 8155
	MVI A,42H
	OUT 40H
; 7: 
; 8: Dim read As Integer
; 9: Dim write As Integer
; 10: Dim startclkupdate As Integer
; 11: Dim timeascii As Integer
; 12: Dim timebin As Integer
; 13: Dim sec As Integer
; 14: Dim min As Integer
; 15: Dim hr As Integer
; 16: Dim addmin As Integer
; 17: Dim addhr As Integer
; 18: Dim hrbutton As Integer
; 19: Dim minbutton As Integer
; 20: Dim incounter As Integer
; 21: Dim outcounter As Integer
; 22: Dim checkhexsw As Integer
; 23: Dim intime As Integer
; 24: Dim outtime As Integer
; 25: 
; 26: Gosub clear  'Clear LED and Time Display's
	CALL L0003
; 27: 
; 28: 'Wait State
; 29: outtime = $30
	LXI H,0FEEAH
	PUSH H
	LXI H,0030H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 30: intime = $20
	LXI H,0FEECH
	PUSH H
	LXI H,0020H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 31: 
; 32: 'Setup
; 33: timeascii = $da00  'SET SAVE POINT FOR TIME IN ASCII
	LXI H,0FEF8H
	PUSH H
	LXI H,0DA00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 34: timebin = $db00  'SET SAVE POINT FOR TIME IN BIN
	LXI H,0FEF6H
	PUSH H
	LXI H,0DB00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 35: read = $40  'NEEDED FOR THE UPDATE OF THE RAM LOCATIONS TO ALLOW THE USER TO READ THE TIME
	LXI H,0FEF4H
	PUSH H
	LXI H,0040H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 36: write = $80  'NEEDED FOR THE UPDATE OF THE RAM LOCATIONS TO ALLOW THE USER TO WRITE THE TIME
	LXI H,0FEF2H
	PUSH H
	LXI H,0080H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 37: startclkupdate = $00  'NEEDED TO START / RESTART CLOCK
	LXI H,0FEFAH
	PUSH H
	LXI H,0000H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 38: 
; 39: clockmain:
L0001:	
; 40: Poke $fff8, read  'STOP RAM UPDATE TO PREVENT READING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
	LXI H,0FFF8H
	PUSH H
	LXI H,0FEF4H
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 41: sec = Peek($fff9)  'SAVE SEC DATA AS INTEGER
	LXI H,0FEE8H
	PUSH H
	LXI H,0FFF9H
	MOV A,M
	MOV L,A
	MVI H,00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 42: min = Peek($fffa)  'SAVE MIN DATA AS INTEGER
	LXI H,0FEE6H
	PUSH H
	LXI H,0FFFAH
	MOV A,M
	MOV L,A
	MVI H,00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 43: hr = Peek($fffb)  'SAVE HR DATA AS INTEGER
	LXI H,0FEE4H
	PUSH H
	LXI H,0FFFBH
	MOV A,M
	MOV L,A
	MVI H,00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 44: 
; 45: '*******************************************LED BINARY SEC OUTPUT*******************************************
; 46: ASM:        LXI H,sec  'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR SEC
	LXI H,0FEE8H
; 47: ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
	LXI B,0FEF6H
; 48: ASM:        MOV A,M  'GET BCD
	MOV A,M
; 49: ASM:        CALL BCDBIN  'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
	CALL BCDBIN
; 50: ASM:        STAX B  'SAVE BINARY
	STAX B
; 51: ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY AGAIN
	LXI H,0FEF6H
; 52: ASM:        MOV A,M  'GET BIN
	MOV A,M
; 53: 'ASM:        CMA  'INVERT THE ACCUMULATOR
; 54: ASM:        OUT 42H  'SEND BIN SEC OUT TO LED
	OUT 42H
; 55: 
; 56: '********************************CHECK SWITCH TO CHANGE BETWEEN DEC OR HEX OUT***************************
; 57: 'checkswitch:
; 58: checkhexsw = Get($41)  '8155 Port A
	LXI H,0FEDEH
	PUSH H
	IN 41H
	MOV L,A
	MVI H,00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 59: If checkhexsw >= $0001 Then  'OUTPUT IN DEC
	LXI H,0FEDEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0001H
	POP D
	CALL C004
	MOV A,H
	ORA L
	JZ L0004
; 60: ASM:        LXI H,sec  'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT SEC
	LXI H,0FEE8H
; 61: ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
	CALL BINASCII
; 62: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEF8H
; 63: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 64: ASM:        OUT 00c1H  'SEND TO DISPLAY
	OUT 00c1H
; 65: ASM:        INX H  'POINT TO NEXT ASCII CHAR
	INX H
; 66: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 67: ASM:        OUT 00c0H  'SEND TO DISPLAY
	OUT 00c0H
; 68: ASM:        LXI H,min  'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT MIN
	LXI H,0FEE6H
; 69: ASM:        MOV A,M  'GET BCD
	MOV A,M
; 70: ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
	CALL BINASCII
; 71: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEF8H
; 72: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 73: ASM:        OUT 0080H  'SEND TO DISPLAY
	OUT 0080H
; 74: ASM:        INX H  'POINT TO NEXT ASCII CHAR
	INX H
; 75: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 76: ASM:        OUT 00c3H  'SEND TO DISPLAY
	OUT 00c3H
; 77: ASM:        LXI H,hr  'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT HR
	LXI H,0FEE4H
; 78: ASM:        MOV A,M  'GET BCD
	MOV A,M
; 79: ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
	CALL BINASCII
; 80: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEF8H
; 81: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 82: ASM:        OUT 0083H  'SEND TO DISPLAY
	OUT 0083H
; 83: ASM:        INX H  'POINT TO NEXT ASCII CHAR
	INX H
; 84: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 85: ASM:        OUT 0082H  'SEND TO DISPLAY
	OUT 0082H
; 86: Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE
	LXI H,0FFF8H
	PUSH H
	LXI H,0FEFAH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 87: 
; 88: Else  'OUTPUT IN HEX
	JMP L0005
L0004:	
; 89: ASM:        LXI H,sec  'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR SEC
	LXI H,0FEE8H
; 90: ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
	LXI B,0FEF6H
; 91: ASM:        MOV A,M  'GET BCD
	MOV A,M
; 92: ASM:        CALL BCDBIN  'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
	CALL BCDBIN
; 93: ASM:        STAX B  'SAVE BINARY
	STAX B
; 94: ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT HOLDS THE BIN FOR SEC
	LXI H,0FEF6H
; 95: ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
	CALL BINASCII
; 96: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEF8H
; 97: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 98: ASM:        OUT 00c1H  'SEND TO DISPLAY
	OUT 00c1H
; 99: ASM:        INX H  'POINT TO NEXT ASCII CHAR
	INX H
; 100: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 101: ASM:        OUT 00c0H  'SEND TO DISPLAY
	OUT 00c0H
; 102: 
; 103: 
; 104: ASM:        LXI H,min  'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR MIN
	LXI H,0FEE6H
; 105: ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
	LXI B,0FEF6H
; 106: ASM:        MOV A,M  'GET BCD
	MOV A,M
; 107: ASM:        CALL BCDBIN  'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
	CALL BCDBIN
; 108: ASM:        STAX B  'SAVE BINARY
	STAX B
; 109: ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT HOLDS THE BIN FOR SEC
	LXI H,0FEF6H
; 110: ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
	CALL BINASCII
; 111: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEF8H
; 112: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 113: ASM:        OUT 0080H  'SEND TO DISPLAY
	OUT 0080H
; 114: ASM:        INX H  'POINT TO NEXT ASCII CHAR
	INX H
; 115: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 116: ASM:        OUT 00c3H  'SEND TO DISPLAY
	OUT 00c3H
; 117: 
; 118: 
; 119: ASM:        LXI H,hr  'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR HR
	LXI H,0FEE4H
; 120: ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
	LXI B,0FEF6H
; 121: ASM:        MOV A,M  'GET BCD
	MOV A,M
; 122: ASM:        CALL BCDBIN  'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
	CALL BCDBIN
; 123: ASM:        STAX B  'SAVE BINARY
	STAX B
; 124: ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT HOLDS THE BIN FOR SEC
	LXI H,0FEF6H
; 125: ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
	CALL BINASCII
; 126: ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
	LXI H,0FEF8H
; 127: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 128: ASM:        OUT 0083H  'SEND TO DISPLAY
	OUT 0083H
; 129: ASM:        INX H  'POINT TO NEXT ASCII CHAR
	INX H
; 130: ASM:        MOV A,M  'GET ASCII
	MOV A,M
; 131: ASM:        OUT 0082H  'SEND TO DISPLAY
	OUT 0082H
; 132: Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE
	LXI H,0FFF8H
	PUSH H
	LXI H,0FEFAH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 133: Endif
L0005:	
; 134: 
; 135: 'CHECK HR BUTTON LOGIC
; 136: hrbutton = Get($43)  'SET VAR TO BUTTON INPUT FROM 8155 PC0
	LXI H,0FEE2H
	PUSH H
	IN 43H
	MOV L,A
	MVI H,00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 137: If hrbutton = 208 Then  'LOGIC, DETECT BUTTON PRESS
	LXI H,0FEE2H
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,00D0H
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0006
; 138: Poke $fff8, write  'STOP RAM UPDATE TO PREVENT WRITING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
	LXI H,0FFF8H
	PUSH H
	LXI H,0FEF2H
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 139: addhr = Peek($fffb)  'GET HR
	LXI H,0FEFCH
	PUSH H
	LXI H,0FFFBH
	MOV A,M
	MOV L,A
	MVI H,00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 140: addhr = addhr + 1  'INCRESE HR BY ONE
	LXI H,0FEFCH
	PUSH H
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0001H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 141: If addhr = $000a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,000AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0007
; 142: addhr = addhr + 6
	LXI H,0FEFCH
	PUSH H
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 143: Endif
L0007:	
; 144: If addhr = $001a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,001AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0008
; 145: addhr = addhr + 6
	LXI H,0FEFCH
	PUSH H
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 146: Endif
L0008:	
; 147: If addhr = $002a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,002AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0009
; 148: addhr = addhr + 6
	LXI H,0FEFCH
	PUSH H
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 149: Endif
L0009:	
; 150: If addhr = $0024 Then  'LOGIC TO KEEP THE USER FROM SETTING THE OUTPUT TO A VALUE OUTSIDE A VALID CLOCK VALUE
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0024H
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0010
; 151: addhr = $00  'IF LOGIC ABOVE = TRUE THEN SET HR TO 00
	LXI H,0FEFCH
	PUSH H
	LXI H,0000H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 152: 'Goto clockmain
; 153: Endif
L0010:	
; 154: Poke $fffb, addhr  'PLACE NEW HR TO RAM LOCATION
	LXI H,0FFFBH
	PUSH H
	LXI H,0FEFCH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 155: Poke $fff8, startclkupdate  'RESTART THE CLOCK
	LXI H,0FFF8H
	PUSH H
	LXI H,0FEFAH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 156: 'WAIT FOR BOUNCE PREVENTION
; 157: Gosub wait
	CALL L0002
; 158: Endif
L0006:	
; 159: 
; 160: 'CHECK MIN BUTTON LOGIC
; 161: minbutton = Get($43)  'SET VAR TO BUTTON INPUT FROM 8155 PC1
	LXI H,0FEE0H
	PUSH H
	IN 43H
	MOV L,A
	MVI H,00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 162: If minbutton = 200 Then  'LOGIC, DETECT BUTTON PRESS
	LXI H,0FEE0H
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,00C8H
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0011
; 163: Poke $fff8, write  'STOP RAM UPDATE TO PREVENT WRITING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
	LXI H,0FFF8H
	PUSH H
	LXI H,0FEF2H
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 164: Poke $fff9, $0000  'WRITE 00 TO THE SEC LOCATION.
	LXI H,0FFF9H
	PUSH H
	LXI H,0000H
	MOV A,L
	POP D
	STAX D
; 165: addmin = Peek($fffa)  'GET MIN
	LXI H,0FEFEH
	PUSH H
	LXI H,0FFFAH
	MOV A,M
	MOV L,A
	MVI H,00H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 166: addmin = addmin + 1  'INCRESE MIN BY ONE
	LXI H,0FEFEH
	PUSH H
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0001H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 167: If addmin = $000a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,000AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0012
; 168: addmin = addmin + 6
	LXI H,0FEFEH
	PUSH H
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 169: Endif
L0012:	
; 170: If addmin = $001a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,001AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0013
; 171: addmin = addmin + 6
	LXI H,0FEFEH
	PUSH H
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 172: Endif
L0013:	
; 173: If addmin = $002a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,002AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0014
; 174: addmin = addmin + 6
	LXI H,0FEFEH
	PUSH H
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 175: Endif
L0014:	
; 176: If addmin = $003a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,003AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0015
; 177: addmin = addmin + 6
	LXI H,0FEFEH
	PUSH H
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 178: Endif
L0015:	
; 179: If addmin = $004a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,004AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0016
; 180: addmin = addmin + 6
	LXI H,0FEFEH
	PUSH H
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 181: Endif
L0016:	
; 182: If addmin = $005a Then  'CHECK FOR HEX AND ADJUST
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,005AH
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0017
; 183: addmin = addmin + 6
	LXI H,0FEFEH
	PUSH H
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0006H
	POP D
	DAD D
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 184: Endif
L0017:	
; 185: If addmin = $0060 Then  'LOGIC TO KEEP THE USER FROM SETTING THE OUTPUT TO A VALUE OUTSIDE A VALID CLOCK VALUE
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0060H
	POP D
	CALL C001
	MOV A,H
	ORA L
	JZ L0018
; 186: addmin = $00  'IF LOGIC ABOVE = TRUE THEN SET MIN TO 00
	LXI H,0FEFEH
	PUSH H
	LXI H,0000H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
; 187: Endif
L0018:	
; 188: Poke $fffa, addmin  'PLACE NEW MIN TO RAM LOCATION
	LXI H,0FFFAH
	PUSH H
	LXI H,0FEFEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 189: Poke $fff8, startclkupdate  'RESTART THE CLOCK UPDATING
	LXI H,0FFF8H
	PUSH H
	LXI H,0FEFAH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 190: ''WAIT FOR BOUNCE PREVENTION
; 191: Gosub wait
	CALL L0002
; 192: Endif
L0011:	
; 193: 
; 194: Poke $fff8, startclkupdate  'RESTART THE CLOCK UPDATING
	LXI H,0FFF8H
	PUSH H
	LXI H,0FEFAH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	MOV A,L
	POP D
	STAX D
; 195: Gosub wait
	CALL L0002
; 196: Goto clockmain  'goto begining
	JMP L0001
; 197: End
	HLT
; 198: 
; 199: wait:  'TIMER IS BASED OFF THE CPU CLOCK!!!!!!
L0002:	
; 200: For outcounter = 0 To outtime
	LXI H,0FEEEH
	PUSH H
	LXI H,0000H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
L0019:	
	LXI H,0FEEEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0FEEAH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	POP D
	CALL C006
	MOV A,H
	ORA L
	JZ L0020
; 201: For incounter = 0 To intime
	LXI H,0FEF0H
	PUSH H
	LXI H,0000H
	POP D
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
L0021:	
	LXI H,0FEF0H
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	PUSH H
	LXI H,0FEECH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	POP D
	CALL C006
	MOV A,H
	ORA L
	JZ L0022
; 202: Next incounter
	LXI H,0FEF0H
	PUSH H
	LXI H,0FEF0H
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	POP D
	INX H
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
	JMP L0021
L0022:	
; 203: Next outcounter
	LXI H,0FEEEH
	PUSH H
	LXI H,0FEEEH
	MOV A,M
	INX H
	MOV H,M
	MOV L,A
	POP D
	INX H
	MOV A,L
	STAX D
	INX D
	MOV A,H
	STAX D
	JMP L0019
L0020:	
; 204: Return
	RET
; 205: 
; 206: 
; 207: '*****************************************************GLOBAL FUNCTIONS*****************************************************
; 208: ASM:BCDBIN:
BCDBIN:	
; 209: ASM:        PUSH B  'SAVE BC REG
	PUSH B
; 210: ASM:        PUSH D  'SAVE DE REG
	PUSH D
; 211: ASM:        MOV B,A  'SAVE BCD
	MOV B,A
; 212: ASM:        ANI 000FH  'MASK MOST SIGNIFICANT FOUR BITS
	ANI 000FH
; 213: ASM:        MOV C,A  'SAVE UNPACKED BCD IN C REG
	MOV C,A
; 214: ASM:        MOV A,B  'GET BCD AGAIN
	MOV A,B
; 215: ASM:        ANI 00F0H  'MASK LEAST SIGNIFICANT FOUR BITS
	ANI 00F0H
; 216: ASM:        RRC  'CONVERT MOST SIGNIFICANT FOUR BITS INTO UNPACKED BCD
	RRC
; 217: ASM:        RRC
	RRC
; 218: ASM:        RRC
	RRC
; 219: ASM:        RRC
	RRC
; 220: ASM:        MOV D,A  'SAVE BCD
	MOV D,A
; 221: ASM:        XRA A  'CLEAR ACCUMULATOR
	XRA A
; 222: ASM:        MVI E,10  'SET E AS MULTIPLIER OF 10
	MVI E,10
; 223: ASM:SUM:
SUM:	
; 224: ASM:        ADD E  'ADD 10 UNTIL D = 0
	ADD E
; 225: ASM:        DCR D  'REDUCE BCD BY ONE
	DCR D
; 226: ASM:        JNZ SUM  'IS MULTIPLICATION COMPLETE?
	JNZ SUM
; 227: ASM:        ADD C  'ADD BCD
	ADD C
; 228: ASM:        POP D  'RETRIEVE PREVIOUS CONTENTS
	POP D
; 229: ASM:        POP B
	POP B
; 230: ASM:        RET  'RETURN
	RET
; 231: 
; 232: ASM:BINASCII
BINASCII:	
; 233: 'ASM:        LXI H,timebin  'POINT TO WHERE BINARY NUMBER IS STORED
; 234: ASM:        LXI D,timeascii  'POINT INDEX TO WHERE ASCII CODE IS TO BE STORED
	LXI D,0FEF8H
; 235: ASM:        MOV A,M  'GET BYTE
	MOV A,M
; 236: ASM:        MOV B,A  'SAVE BYTE
	MOV B,A
; 237: ASM:        RRC  'ROTATE FOUR TIMES TO PLACE THE FOUR HIGH ORDER BITS OF THE SELECTED BYTE IN THE LOW ORDER LOCATION
	RRC
; 238: ASM:        RRC
	RRC
; 239: ASM:        RRC
	RRC
; 240: ASM:        RRC
	RRC
; 241: ASM:        CALL ASCII  'CALL ASCII CONVERSION
	CALL ASCII
; 242: ASM:        STAX D  'SAVE FIRST ASCII HEX
	STAX D
; 243: ASM:        INX D  'POINT TO NEXT MEMORY LOCATION
	INX D
; 244: ASM:        MOV A,B  'GET BYTE
	MOV A,B
; 245: ASM:        CALL ASCII  'CALL ASCII CONVERSION
	CALL ASCII
; 246: ASM:        STAX D  'SAVE NEXT ASCII HEX
	STAX D
; 247: ASM:        RET  'RETURN
	RET
; 248: ASM:ASCII:
ASCII:	
; 249: ASM:        ANI 000FH  'MASK HIGH-ORDER NIBBLE
	ANI 000FH
; 250: ASM:        CPI 000AH  'IS DIGIT LESS THAN 10^10?
	CPI 000AH
; 251: ASM:        JC CODE  'IF YES GOTO CODE TO ADD 30H
	JC CODE
; 252: ASM:        ADI 0007H  'ELSE ADD 07H TO GET A - F CHAR
	ADI 0007H
; 253: ASM:CODE:
CODE:	
; 254: ASM:        ADI 0030H  'ADD 30H AS A DEC.
	ADI 0030H
; 255: ASM:        RET  'RETURN
	RET
; 256: 
; 257: clear:
L0003:	
; 258: Put $83, $20
	MVI A,20H
	OUT 83H
; 259: Put $82, $20
	MVI A,20H
	OUT 82H
; 260: Put $81, $20
	MVI A,20H
	OUT 81H
; 261: Put $80, $20
	MVI A,20H
	OUT 80H
; 262: Put $c3, $20
	MVI A,20H
	OUT 0C3H
; 263: Put $c2, $20
	MVI A,20H
	OUT 0C2H
; 264: Put $c1, $20
	MVI A,20H
	OUT 0C1H
; 265: Put $c0, $20
	MVI A,20H
	OUT 0C0H
; 266: Put $81, $3a  'place : for clock
	MVI A,3AH
	OUT 81H
; 267: Put $c2, $3a  'place : for clock
	MVI A,3AH
	OUT 0C2H
; 268: Put $41, $00  'clear led 8155
	MVI A,00H
	OUT 41H
; 269: Return
	RET
; End of user code
	HLT
; Integer Comparison Routine
C001:	CALL C007
	RZ
	DCX H
	RET
C002:	CALL C007
	RNZ
	DCX H
	RET
C003:	XCHG
	CALL C007
	RC
	DCX H
	RET
C004:	CALL C007
	RNC
	DCX H
	RET
C005:	CALL C007
	RC
	DCX H
	RET
C006:	CALL C007
	RZ
	RC
	DCX H
	RET
C007:	MOV A,E
	SUB L
	MOV E,A
	MOV A,D
	SBB H
	LXI H,0001H
	JM C008
	ORA E
	RET
C008:	ORA E
	STC
	RET
; End of listing
	.END
