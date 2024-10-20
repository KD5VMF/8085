'FigTroniX 80C85 RealTime Clock 2024 VER 3

' Initialize clock
Poke $fff8, $00  'iniz clock
Poke $fff9, $00  'iniz clock
Poke $fffc, $00  'iniz clock
Poke $fffd, $00  'iniz clock
Poke $fffe, $00  'iniz clock

' Initialize 8155 ports and display colons
Put $40, $42  'iniz 8155 PORT A = INPUT, PORT B = OUTPUT, PORT C = INPUT
Put $42, $00  'clear led 8155
Put $81, $3a  'place : for clock
Put $c2, $3a  'place : for clock

' Variable declarations
Dim read As Byte
Dim write As Byte
Dim startclkupdate As Byte
Dim timeascii As Long
Dim timebin As Long
Dim sec As Byte
Dim seccheck As Byte
Dim min As Byte
Dim hr As Integer
Dim addmin As Byte
Dim addhr As Byte
Dim hrbutton As Byte
Dim minbutton As Byte
Dim incounter As Byte
Dim outcounter As Byte
Dim checkhexsw As Byte
Dim colon_state As Byte  ' Added colon_state variable

' Initialize variables
timeascii = $c000  'SET SAVE POINT FOR TIME IN ASCII
timebin = $b000    'SET SAVE POINT FOR TIME IN BIN
read = $40         'NEEDED FOR THE UPDATE OF THE RAM LOCATIONS TO ALLOW THE USER TO READ THE TIME
write = $80        'NEEDED FOR THE UPDATE OF THE RAM LOCATIONS TO ALLOW THE USER TO WRITE THE TIME
startclkupdate = $00  'NEEDED TO START THE CLOCK ON THE REALTIME CLOCK
colon_state = 1       ' Initialize colon_state to 1 (colons displayed)

' Main clock loop
clockmain:
Poke $fff8, read  'STOP RAM UPDATE TO PREVENT READING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
sec = Peek($fff9)  'SAVE SEC Data AS INTEGER
seccheck = sec     'Save SEC to loop until a new sec is detected
min = Peek($fffa)  'SAVE MIN Data AS INTEGER
hr = Peek($fffb)   'SAVE HR Data AS INTEGER

' Toggle the colon state
colon_state = 1 - colon_state  ' Switch between 1 and 0

' Display or clear the colons based on colon_state
If colon_state = 1 Then
    Put $81, $3a  'place : for clock
    Put $c2, $3a  'place : for clock
Else
    Put $81, $20  'clear : for clock (space character)
    Put $c2, $20  'clear : for clock (space character)
Endif

'*******************************************LED BINARY SEC OUTPUT*******************************************
ASM:        LXI H,sec      'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR SEC
ASM:        LXI B,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
ASM:        MOV A,M        'GET BCD
ASM:        CALL BCDBIN    'CALL BINARY-CODED-DECIMAL TO BINARY CONVERSION
ASM:        STAX B         'SAVE BINARY
ASM:        LXI H,timebin  'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY AGAIN
ASM:        MOV A,M        'GET BIN
'ASM:        CMA           'INVERT THE ACCUMULATOR (commented out as per original code)
ASM:        OUT 42H        'SEND BIN SEC OUT TO LED

'********************************CHECK SWITCH TO CHANGE BETWEEN DEC OR HEX OUT***************************
checkswitch:
checkhexsw = Get($41)  '8155 Port A

If checkhexsw > $00 Then  'OUTPUT IN DEC
    ' Display seconds
    ASM:        LXI H,sec     'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT SEC
    ASM:        CALL BINASCII 'CALL BINARY TO ASCII CONVERSION
    ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 00C1H     'SEND TO DISPLAY
    ASM:        INX H         'POINT TO NEXT ASCII CHAR
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 00C0H     'SEND TO DISPLAY

    ' Display minutes
    ASM:        LXI H,min     'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT MIN
    ASM:        CALL BINASCII 'CALL BINARY TO ASCII CONVERSION
    ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 0080H     'SEND TO DISPLAY
    ASM:        INX H         'POINT TO NEXT ASCII CHAR
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 00C3H     'SEND TO DISPLAY

    ' Display hours
    ASM:        LXI H,hr      'POINT TO MEMORY LOCATION THAT HOLDS THE CURRENT HR
    ASM:        CALL BINASCII 'CALL BINARY TO ASCII CONVERSION
    ASM:        LXI H,timeascii  'POINT TO MEMORY LOCATION THAT HOLDS THE TIME IN ASCII
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 0083H     'SEND TO DISPLAY
    ASM:        INX H         'POINT TO NEXT ASCII CHAR
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 0082H     'SEND TO DISPLAY

    Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE
Else  'OUTPUT IN HEX
    ' Display seconds in HEX
    ASM:        LXI H,sec     'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR SEC
    ASM:        LXI B,timebin 'POINT TO MEMORY LOCATION THAT WILL HOLD THE TIME IN BINARY
    ASM:        MOV A,M       'GET BCD
    ASM:        CALL BCDBIN   'CONVERT BCD TO BINARY
    ASM:        STAX B        'SAVE BINARY
    ASM:        LXI H,timebin 'POINT TO BINARY TIME
    ASM:        CALL BINASCII 'CONVERT BINARY TO ASCII
    ASM:        LXI H,timeascii  'POINT TO ASCII TIME
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 00C1H     'SEND TO DISPLAY
    ASM:        INX H         'POINT TO NEXT ASCII CHAR
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 00C0H     'SEND TO DISPLAY

    ' Display minutes in HEX
    ASM:        LXI H,min     'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR MIN
    ASM:        LXI B,timebin 'POINT TO BINARY TIME STORAGE
    ASM:        MOV A,M       'GET BCD
    ASM:        CALL BCDBIN   'CONVERT BCD TO BINARY
    ASM:        STAX B        'SAVE BINARY
    ASM:        LXI H,timebin 'POINT TO BINARY TIME
    ASM:        CALL BINASCII 'CONVERT BINARY TO ASCII
    ASM:        LXI H,timeascii  'POINT TO ASCII TIME
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 0080H     'SEND TO DISPLAY
    ASM:        INX H         'POINT TO NEXT ASCII CHAR
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 00C3H     'SEND TO DISPLAY

    ' Display hours in HEX
    ASM:        LXI H,hr      'POINT TO MEMORY LOCATION THAT HOLDS THE BCD FOR HR
    ASM:        LXI B,timebin 'POINT TO BINARY TIME STORAGE
    ASM:        MOV A,M       'GET BCD
    ASM:        CALL BCDBIN   'CONVERT BCD TO BINARY
    ASM:        STAX B        'SAVE BINARY
    ASM:        LXI H,timebin 'POINT TO BINARY TIME
    ASM:        CALL BINASCII 'CONVERT BINARY TO ASCII
    ASM:        LXI H,timeascii  'POINT TO ASCII TIME
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 0083H     'SEND TO DISPLAY
    ASM:        INX H         'POINT TO NEXT ASCII CHAR
    ASM:        MOV A,M       'GET ASCII
    ASM:        OUT 0082H     'SEND TO DISPLAY

    Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE
Endif

'CHECK HR BUTTON LOGIC
hrbutton = Get($43)  'SET VAR TO BUTTON INPUT FROM 8155 PC0
If hrbutton = $08 Then  'LOGIC, DETECT BUTTON PRESS
    Poke $fff8, write   'STOP RAM UPDATE TO PREVENT WRITING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
    addhr = Peek($fffb) 'GET HR
    addhr = addhr + 1   'INCREASE HR BY ONE
    ' Adjust for BCD overflow
    If (addhr And $0F) > $09 Then addhr = addhr + $06
    If addhr > $23 Then addhr = $00  ' Reset hour if overflow
    Poke $fffb, addhr    'PLACE NEW HR TO RAM LOCATION
    Poke $fff8, startclkupdate  'RESTART THE CLOCK
    'WAIT FOR BOUNCE PREVENTION
    For outcounter = 0 To 10
        For incounter = 0 To 10
        Next incounter
    Next outcounter
Endif

'CHECK MIN BUTTON LOGIC
minbutton = Get($43)  'SET VAR TO BUTTON INPUT FROM 8155 PC1
If minbutton = $04 Then  'LOGIC, DETECT BUTTON PRESS
    Poke $fff8, write   'STOP RAM UPDATE TO PREVENT WRITING THE TIME WHILE THE CLOCK IS UPDATING THE RAM LOCATIONS.
    Poke $fff9, $00     'WRITE 00 TO THE SEC LOCATION.
    addmin = Peek($fffa) 'GET MIN
    addmin = addmin + 1  'INCREASE MIN BY ONE
    ' Adjust for BCD overflow
    If (addmin And $0F) > $09 Then addmin = addmin + $06
    If addmin > $59 Then addmin = $00  ' Reset minute if overflow
    Poke $fffa, addmin   'PLACE NEW MIN TO RAM LOCATION
    Poke $fff8, startclkupdate  'RESTART THE CLOCK
    'WAIT FOR BOUNCE PREVENTION
    For outcounter = 0 To 10
        For incounter = 0 To 10
        Next incounter
    Next outcounter
Endif

'RESTART THE CLOCK UPDATE
Poke $fff8, startclkupdate  'START THE RAM CLOCK UPDATE

' Go to secondcheck to wait for the next second
Goto secondcheck

secondcheck:
sec = Peek($fff9)  'SAVE SEC LOCATION AS INTEGER
If sec = seccheck Then
    Goto secondcheck
Else
    Goto clockmain
Endif

'*****************************************************GLOBAL FUNCTIONS*****************************************************
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

ASM:ASCII:
ASM:        ANI 0FH          'MASK HIGH-ORDER NIBBLE
ASM:        CPI 0AH          'IS DIGIT LESS THAN 10?
ASM:        JC CODE          'IF YES GOTO CODE TO ADD 30H
ASM:        ADI 07H          'ELSE ADD 07H TO GET A - F CHAR
ASM:CODE:
ASM:        ADI 30H          'ADD 30H AS A DECIMAL OFFSET
ASM:        RET              'RETURN
