'FigTroniX 8085 RealTime Clock 2015

Poke $fff8, $00  'iniz clock
Poke $fffc, $00  'iniz clock
Poke $fff9, $00  'iniz clock
Put $40, $42  'iniz 8155

Dim read As Integer
Dim write As Integer
Dim startclkupdate As Integer
Dim timeascii As Integer
Dim timebin As Integer
Dim sec As Integer
Dim min As Integer
Dim hr As Integer
Dim addmin As Integer
Dim addhr As Integer
Dim hrbutton As Integer
Dim minbutton As Integer
Dim incounter As Integer
Dim outcounter As Integer
Dim checkhexsw As Integer
Dim intime As Integer
Dim outtime As Integer

Gosub clear  'Clear LED and Time Display's

'Wait State
outtime = $30
intime = $20

'Setup
timeascii = $da00  'SET SAVE POINT FOR TIME IN ASCII
timebin = $db00  'SET SAVE POINT FOR TIME IN BIN
read = $40  'NEEDED FOR THE UPDATE OF THE RAM LOCATIONS TO ALLOW THE USER TO READ THE TIME
write = $80  'NEEDED FOR THE UPDATE OF THE RAM LOCATIONS TO ALLOW THE USER TO WRITE THE TIME
startclkupdate = $00  'NEEDED TO START / RESTART CLOCK

clockmain:
Poke $fff8, read  'STOP RAM UPDATE TO PREVENT READING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
sec = Peek($fff9)  'SAVE SEC DATA AS INTEGER
min = Peek($fffa)  'SAVE MIN DATA AS INTEGER
hr = Peek($fffb)  'SAVE HR DATA AS INTEGER

'*******************************************LED BINARY SEC OUTPUT*******************************************
ASM:        LXI H,sec  'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR SEC
ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
ASM:        MOV A,M  'GET BCD
ASM:        CALL BCDBIN  'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
ASM:        STAX B  'SAVE BINARY
ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY AGAIN
ASM:        MOV A,M  'GET BIN
'ASM:        CMA  'INVERT THE ACCUMULATOR
ASM:        OUT 42H  'SEND BIN SEC OUT TO LED

'********************************CHECK SWITCH TO CHANGE BETWEEN DEC OR HEX OUT***************************
'checkswitch:
checkhexsw = Get($41)  '8155 Port A
If checkhexsw >= $0001 Then  'OUTPUT IN DEC
ASM:        LXI H,sec  'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT SEC
ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 00c1H  'SEND TO DISPLAY
ASM:        INX H  'POINT TO NEXT ASCII CHAR
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 00c0H  'SEND TO DISPLAY
ASM:        LXI H,min  'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT MIN
ASM:        MOV A,M  'GET BCD
ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 0080H  'SEND TO DISPLAY
ASM:        INX H  'POINT TO NEXT ASCII CHAR
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 00c3H  'SEND TO DISPLAY
ASM:        LXI H,hr  'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT HR
ASM:        MOV A,M  'GET BCD
ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 0083H  'SEND TO DISPLAY
ASM:        INX H  'POINT TO NEXT ASCII CHAR
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 0082H  'SEND TO DISPLAY
Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE

Else  'OUTPUT IN HEX
ASM:        LXI H,sec  'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR SEC
ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
ASM:        MOV A,M  'GET BCD
ASM:        CALL BCDBIN  'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
ASM:        STAX B  'SAVE BINARY
ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT HOLDS THE BIN FOR SEC
ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 00c1H  'SEND TO DISPLAY
ASM:        INX H  'POINT TO NEXT ASCII CHAR
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 00c0H  'SEND TO DISPLAY


ASM:        LXI H,min  'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR MIN
ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
ASM:        MOV A,M  'GET BCD
ASM:        CALL BCDBIN  'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
ASM:        STAX B  'SAVE BINARY
ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT HOLDS THE BIN FOR SEC
ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 0080H  'SEND TO DISPLAY
ASM:        INX H  'POINT TO NEXT ASCII CHAR
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 00c3H  'SEND TO DISPLAY


ASM:        LXI H,hr  'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR HR
ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
ASM:        MOV A,M  'GET BCD
ASM:        CALL BCDBIN  'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
ASM:        STAX B  'SAVE BINARY
ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT HOLDS THE BIN FOR SEC
ASM:        CALL BINASCII  'CALL BINARY TO ASCII CONVERSION
ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 0083H  'SEND TO DISPLAY
ASM:        INX H  'POINT TO NEXT ASCII CHAR
ASM:        MOV A,M  'GET ASCII
ASM:        OUT 0082H  'SEND TO DISPLAY
Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE
Endif

'CHECK HR BUTTON LOGIC
hrbutton = Get($43)  'SET VAR TO BUTTON INPUT FROM 8155 PC0
If hrbutton = 208 Then  'LOGIC, DETECT BUTTON PRESS
Poke $fff8, write  'STOP RAM UPDATE TO PREVENT WRITING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
addhr = Peek($fffb)  'GET HR
addhr = addhr + 1  'INCRESE HR BY ONE
If addhr = $000a Then  'CHECK FOR HEX AND ADJUST
addhr = addhr + 6
Endif
If addhr = $001a Then  'CHECK FOR HEX AND ADJUST
addhr = addhr + 6
Endif
If addhr = $002a Then  'CHECK FOR HEX AND ADJUST
addhr = addhr + 6
Endif
If addhr = $0024 Then  'LOGIC TO KEEP THE USER FROM SETTING THE OUTPUT TO A VALUE OUTSIDE A VALID CLOCK VALUE
addhr = $00  'IF LOGIC ABOVE = TRUE THEN SET HR TO 00
'Goto clockmain
Endif
Poke $fffb, addhr  'PLACE NEW HR TO RAM LOCATION
Poke $fff8, startclkupdate  'RESTART THE CLOCK
'WAIT FOR BOUNCE PREVENTION
Gosub wait
Endif

'CHECK MIN BUTTON LOGIC
minbutton = Get($43)  'SET VAR TO BUTTON INPUT FROM 8155 PC1
If minbutton = 200 Then  'LOGIC, DETECT BUTTON PRESS
Poke $fff8, write  'STOP RAM UPDATE TO PREVENT WRITING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
Poke $fff9, $0000  'WRITE 00 TO THE SEC LOCATION.
addmin = Peek($fffa)  'GET MIN
addmin = addmin + 1  'INCRESE MIN BY ONE
If addmin = $000a Then  'CHECK FOR HEX AND ADJUST
addmin = addmin + 6
Endif
If addmin = $001a Then  'CHECK FOR HEX AND ADJUST
addmin = addmin + 6
Endif
If addmin = $002a Then  'CHECK FOR HEX AND ADJUST
addmin = addmin + 6
Endif
If addmin = $003a Then  'CHECK FOR HEX AND ADJUST
addmin = addmin + 6
Endif
If addmin = $004a Then  'CHECK FOR HEX AND ADJUST
addmin = addmin + 6
Endif
If addmin = $005a Then  'CHECK FOR HEX AND ADJUST
addmin = addmin + 6
Endif
If addmin = $0060 Then  'LOGIC TO KEEP THE USER FROM SETTING THE OUTPUT TO A VALUE OUTSIDE A VALID CLOCK VALUE
addmin = $00  'IF LOGIC ABOVE = TRUE THEN SET MIN TO 00
Endif
Poke $fffa, addmin  'PLACE NEW MIN TO RAM LOCATION
Poke $fff8, startclkupdate  'RESTART THE CLOCK UPDATING
''WAIT FOR BOUNCE PREVENTION
Gosub wait
Endif

Poke $fff8, startclkupdate  'RESTART THE CLOCK UPDATING
Gosub wait
Goto clockmain  'goto begining
End                                               

wait:  'TIMER IS BASED OFF THE CPU CLOCK!!!!!!
For outcounter = 0 To outtime
For incounter = 0 To intime
Next incounter
Next outcounter
Return                                            


'*****************************************************GLOBAL FUNCTIONS*****************************************************
ASM:BCDBIN:
ASM:        PUSH B  'SAVE BC REG
ASM:        PUSH D  'SAVE DE REG
ASM:        MOV B,A  'SAVE BCD
ASM:        ANI 000FH  'MASK MOST SIGNIFICANT FOUR BITS
ASM:        MOV C,A  'SAVE UNPACKED BCD IN C REG
ASM:        MOV A,B  'GET BCD AGAIN
ASM:        ANI 00F0H  'MASK LEAST SIGNIFICANT FOUR BITS
ASM:        RRC  'CONVERT MOST SIGNIFICANT FOUR BITS INTO UNPACKED BCD
ASM:        RRC
ASM:        RRC
ASM:        RRC
ASM:        MOV D,A  'SAVE BCD
ASM:        XRA A  'CLEAR ACCUMULATOR
ASM:        MVI E,10  'SET E AS MULTIPLIER OF 10
ASM:SUM:
ASM:        ADD E  'ADD 10 UNTIL D = 0
ASM:        DCR D  'REDUCE BCD BY ONE
ASM:        JNZ SUM  'IS MULTIPLICATION COMPLETE?
ASM:        ADD C  'ADD BCD
ASM:        POP D  'RETRIEVE PREVIOUS CONTENTS
ASM:        POP B
ASM:        RET  'RETURN

ASM:BINASCII
'ASM:        LXI H,timebin  'POINT TO WHERE BINARY NUMBER IS STORED
ASM:        LXI D,timeascii  'POINT INDEX TO WHERE ASCII CODE IS TO BE STORED
ASM:        MOV A,M  'GET BYTE
ASM:        MOV B,A  'SAVE BYTE
ASM:        RRC  'ROTATE FOUR TIMES TO PLACE THE FOUR HIGH ORDER BITS OF THE SELECTED BYTE IN THE LOW ORDER LOCATION
ASM:        RRC
ASM:        RRC
ASM:        RRC
ASM:        CALL ASCII  'CALL ASCII CONVERSION
ASM:        STAX D  'SAVE FIRST ASCII HEX
ASM:        INX D  'POINT TO NEXT MEMORY LOCATION
ASM:        MOV A,B  'GET BYTE
ASM:        CALL ASCII  'CALL ASCII CONVERSION
ASM:        STAX D  'SAVE NEXT ASCII HEX
ASM:        RET  'RETURN
ASM:ASCII:
ASM:        ANI 000FH  'MASK HIGH-ORDER NIBBLE
ASM:        CPI 000AH  'IS DIGIT LESS THAN 10^10?
ASM:        JC CODE  'IF YES GOTO CODE TO ADD 30H
ASM:        ADI 0007H  'ELSE ADD 07H TO GET A - F CHAR
ASM:CODE:
ASM:        ADI 0030H  'ADD 30H AS A DEC.
ASM:        RET  'RETURN

clear:
Put $83, $20
Put $82, $20
Put $81, $20
Put $80, $20
Put $c3, $20
Put $c2, $20
Put $c1, $20
Put $c0, $20
Put $81, $3a  'place : for clock
Put $c2, $3a  'place : for clock
Put $41, $00  'clear led 8155
Return                                            
