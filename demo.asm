; demo.asm
; Produces a demo to test each of the different modes for the new peripheral:
; 	Switches are used for input
;	LEDs and Hex0 are used to show the value returned by the peripheral
; 	Hex1 is used to show the register number of the current mode
; Team L03_3
; ECE 2031

ORG 0
; Reset displays
LOADI 0
OUT LEDs
OUT Hex0
OUT Hex1

; Check what mode we're testing for
Check:
	IN Switches
	STORE I_Mode

	JZERO Regular
	
	SUB One
	JZERO Inverse
	
	LOAD I_Mode
	SUB Two
	JZERO SignE
	
	LOAD I_Mode
	SUB Three
	JZERO NumA

JUMP Check


; Regular Test - Mode 0
Regular:
	
	LOADI 0
	OUT Hex1
	
	IN S_Regular
	OUT LEDs ; lights up LEDs for switches that are up
	
	JUMP Regular ; stay in this mode

; Inverse Test - Mode 1
Inverse: 

	LOADI 1
	OUT Hex1

	IN S_Inverse
	OUT LEDs ; lights up LEDs for switches that are down
	
	JUMP Inverse ; stay in this mode

; Sign Extension Test - Mode 2
SignE:

	LOADI 2
	OUT Hex1
	

	IN S_SignE
	OUT Hex0 ; lights up right display with value currently on SW 8-0, sign extended based on SW9 (-256 to 255)

	JUMP SignE ; stay in this mode

; Number Active Test - Mode 3
NumA:

	LOADI 3
	OUT Hex1
	
	
	IN S_NumA
	OUT Hex0 ; lights up left display with number of switches up (0 to 10)
	
	JUMP NumA ; stay in this mode
	
	
	

I_Mode: DW 0;
One: DW 1; 
Two: DW 2; 
Three: DW 3;

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004 ; 4 digit, right display
Hex1:      EQU 005 ; 2 digit, left display

S_Regular: EQU &H60 ; Regular Mode
S_Inverse: EQU &H61 ; Inverse Mode
S_SignE:   EQU &H62 ; Sign Extension Mode
S_NumA:    EQU &H63 ; Number Active Mode