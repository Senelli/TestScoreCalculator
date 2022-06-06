.ORIG x3000	; origin

; clear registers
AND R0, R0, x0	
AND R1, R1, x0	
AND R2, R2, x0
AND R3, R3, x0
AND R4, R4, x0
AND R5, R5, x0
AND R6, R6, x0                                                                                     

; count keeping track of the number of test score inputs by the user                                                                                   
ADD R3, R3, #5

; welcome prompts and error prompts
WELCOME	.STRINGZ	"                         TEST SCORE CALCULATOR\n"
LINE1 .STRINGZ		"Enter each test score one digit at a time (ex: 98 = enter 0, then 9, then 8).\n"
NEW_TEST .STRINGZ	"\nEnter test score:\n"
FIRST_NEG .STRINGZ	"\nPlease Enter a Value between 0 - 1. Re-Enter Score.\n"	
SECOND_NEG .STRINGZ	"\nPlease Enter a Value between 0 - 9. Re-Enter Score.\n"

LEA R0, WELCOME
PUTS
LEA R0, LINE1
PUTS

; initializing test_score array that will store test scores
LEA R1, TEST_SCORES

; branch getting user input (test scores)
GET_INPUT
	LEA R0, NEW_TEST
	PUTS
	AND R0, R0, x0
	IN 
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-3
	BRn INPUT_VALUE_FIRST_NEGATIVE
	ADD R0, R0, #-1
	BRp INPUT_VALUE_GREATER_THAN_ONE
	ADD R0, R0, #1
	JSR MULT
	AND R6, R6, x0
	LD R6, SaveReg1
	IN
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-3
	BRn INPUT_VALUE_NEGATIVE
	ADD R0, R0, #-9
	BRp INPUT_VALUE_GREATER_THAN_NINE
	ADD R0, R0, #9
	JSR MULT1
	AND R2, R2, x0
	LD R2, SaveReg2
	IN
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-15
	ADD R0, R0, #-3
	BRn INPUT_VALUE_NEGATIVE
	ADD R0, R0, #-9
	BRp INPUT_VALUE_GREATER_THAN_NINE
	ADD R0, R0, #9	
	ADD R6, R6, R2
	ADD R6, R6, R0
	ST R6, SaveReg3
	JSR GRADEA
	JSR GRADEB
	JSR GRADEC
	JSR GRADED
	JSR GRADEF
	LD R0, TEST_GRADE
	OUT
	AND R0, R0, x0
	LD R6, SaveReg3
	STR R6, R1, #0
	ADD R1, R1, #1
	ADD R3, R3, #-1
	BRp GET_INPUT
	BRnz DONE 

; branches validating user input
INPUT_VALUE_FIRST_NEGATIVE
	LEA R0, FIRST_NEG
	PUTS
	BR GET_INPUT

INPUT_VALUE_NEGATIVE
	LEA R0, SECOND_NEG
	PUTS
	BR GET_INPUT

INPUT_VALUE_GREATER_THAN_ONE
	LEA R0, FIRST_NEG
	PUTS
	BR GET_INPUT

INPUT_VALUE_GREATER_THAN_NINE
	LEA R0, SECOND_NEG
	PUTS
	BR GET_INPUT

; once user inputs all the test scores, the program branches to the DONE branch
; which call other subroutines to do calculations for, min, max, avg, avg grade
DONE
	AND R5, R5, x0	
	JSR MINIMUM
	JSR MAXIMUM
	JSR SUMMATION
	JSR DIVISION
	LD R6, AVG
	ADD R6, R6, x0
	ST R6, SaveReg3
	JSR GRADEA
	JSR GRADEB
	JSR GRADEC
	JSR GRADED
	JSR GRADEF 
	
	AND R6, R6, x0
	LD R6, BASE
	LD R3, ASCII
	
	LEA R0, LINE
	PUTS

; prompts displayed explaining the data user is seeing
NEW_LINE .STRINGZ	"\n"  
LINE .STRINGZ "\n\nMinimum Score, Maximum Score, Average Score, Average Grade"

; stacking min, max, avg score before displaying them to user
STACK	
	JSR ISMAX
	AND R0, R0, x0
	LD R0, AVG
	ADD R0, R0, x0
	JSR PUSH	
	JSR ISMAX
	AND R0, R0, x0
	LD R0, MAX_VAL
	ADD R0, R0, x0
	JSR PUSH	
	JSR ISMAX
	AND R0, R0, x0
	LD R0, MIN_VAL
	ADD R0, R0, x0
	JSR PUSH
	
	LEA R0, NEW_LINE
	PUTS

; unstacking min, max, avg scores in order to diplay it onto the console	
UNSTACK
	AND R0, R0, x0
	JSR ISEMPTY
	BRp END_UNSTACK
	AND R0, R0, x0
	JSR POP
	ST R0, NUM
	JSR DECODE
	LD R0, NUM1
	OUT
	AND R0, R0, x0
	LD R0, NUM2
	OUT
	AND R0, R0, x0
	LD R0, NUM3
	OUT
	LEA R0, NEW_LINE
	PUTS
	BR UNSTACK
END_UNSTACK	
	AND R0, R0, x0	
	LD R0, TEST_GRADE
	OUT
	HALT

; data
; initializing areas in memory to store the array of test scores
; and other temporary data values to assist with user input and 
; displaying grades
TEST_SCORES .BLKW #5 
SaveReg1 .FILL x0
SaveReg2 .FILL x0
SaveReg3 .FILL x0                                                   

; subroutine digitizing min, max, avg values and converting them onto ASCII
; in order for them to be displayed onto the console 
DECODE
	AND R2, R2, x0
	LD R2, NUM 
	AND R4, R4, x0
	AND R1, R1, x0
	AND R5, R5, x0	
	AND R3, R3, x0
	LD R3, ASCII	
	ADD R1, R1, xA
	NOT R1, R1
	ADD R1, R1, #1
DLOOP
	ADD R2, R2, R1
	BRn DLOOP_END
	ADD R4, R4, #1
	BRp DLOOP
DLOOP_END
	ADD R5, R5, R4
	ADD R5, R5, R1
	BRzp DLOOP_END2
	AND R5, R5, x0
	ADD R5, R5, R3
	ST R5, NUM1
	ADD R4, R4, x0
	ST R4, NUM2
	NOT R1, R1
	ADD R1, R1, #1
	ADD R2, R2, R1
	;ADD R0, R0, R4
	ADD R2, R2, R3
	ST R2, NUM3
	AND R4, R4, x0
	LD R4, NUM2
	ADD R4, R4, R3
	ST R4, NUM2
	RET
DLOOP_END2
	ADD R2, R2, #10
	ADD R2, R2, R3
	ST R2, NUM3
	ADD R4, R4, #-10
	ADD R4, R4, R3
	ST R4, NUM2
	AND R5, R5, x0
	ADD R5, R5, #1
	ADD R5, R5, R3
	ST R5, NUM1
	RET

; subroutine pushing values onto the stack
PUSH	
	ADD R6, R6, #-1
	STR R0, R6, #0
	RET

; subroutine popping values off the stack
POP	
	LDR R0, R6, #0
	ADD R6, R6, #1
	RET

; subroutine detecting underflow in the stack
ISEMPTY	
	LD R0, EMPTY
	ADD R0, R6, R0
	BRz FAIL
	ADD R0, R0, #0
	RET

; subroutine detecting underflow in the stack
ISMAX	
	LD R0, MAX_STACK
	ADD R0, R6, R0
	BRz FAIL
	ADD R0, R0, #0
	RET

; subroutine that flags overflow or underflow
FAIL	
	AND R0, R0, #0
	ADD R6, R6, #1
	RET

; data
EMPTY .FILL xC000	; negate the base value of the stack, so negate x4000
MAX_STACK .FILL xC003	; negate max value of the stack, so negate x3FFD	
BASE .FILL x4000	; base of the stack
TEST_GRADE .FILL x0	; allocated area in memory (label) to store test grade

; subroutine converting user input into test score values
MULT
	AND R2, R2, x0
	AND R6, R6, x0
	AND R5, R5, x0
	ADD R5, R5, xA
	AND R4, R4, x0
	ADD R4, R4, xA	

MLOOP
	ADD R2, R2, R0
	ADD R5, R5, #-1
	BRp MLOOP
	;STI R2, SaveReg1
	;RET
	BRnz MLOOP2
MLOOP2
	ADD R6, R6, R2
	ADD R4, R4, #-1
	BRp MLOOP2
	BRnz ENDLOOP
ENDLOOP	ST R6, SaveReg1
	RET

MULT1
	AND R2, R2, x0
	AND R4, R4, x0
	ADD R4, R4, xA	

MLOOP1
	ADD R2, R2, R0
	ADD R4, R4, #-1
	BRp MLOOP1	
	BRnz ENDLOOP2
ENDLOOP2 ST R2, SaveReg2
	RET

; data
; memory allocation required for min, max, avg, and avg grade calculation and display
NUM .FILL x0
NUM1 .FILL x0
NUM2 .FILL x0
NUM3 .FILL x0
MIN_VAL .FILL x0
MAX_VAL .FILL x0
SUM .FILL x0
AVG .FILL x0
ASCII .FILL x30
GRADE_A .FILL #-90
GRADE_B .FILL #-80
GRADE_C .FILL #-70
GRADE_D .FILL #-60
CHAR_A .FILL x41
CHAR_B .FILL x42
CHAR_C .FILL x43
CHAR_D .FILL x44
CHAR_F .FILL x46

; subroutine that determines the min test score value (in the test_scores array)
MINIMUM
	AND R1, R1, x0
	LEA R1, TEST_SCORES
	AND R2, R2, x0
	AND R3, R3, x0
	ADD R3, R3, #5
	AND R4, R4, x0
	LDR R4, R1, #0
	ST R4, MIN_VAL 
MIN_LOOP
	LDR R2, R1, #0
	LD R4, MIN_VAL
	NOT R4, R4
	ADD R4, R4, #1
	ADD R2, R2, R4
	BRnz MIN_REASSIGN
	ADD R3, R3, #-1	
	BRnz MIN_END
	ADD R1, R1, #1
	BR MIN_LOOP
MIN_REASSIGN
	NOT R4, R4
	ADD R4, R4, #1
	ADD R2, R2, R4
	ST R2, MIN_VAL
	ADD R3, R3, #-1	
	BRnz MIN_END
	ADD R1, R1, #1
	BR MIN_LOOP
MIN_END
	RET

; subroutine that determines the max test score value (in the test_scores array)
MAXIMUM
	AND R1, R1, x0
	LEA R1, TEST_SCORES
	AND R2, R2, x0
	AND R3, R3, x0
	ADD R3, R3, #5
	AND R4, R4, x0
	LDR R4, R1, #0
	ST R4, MAX_VAL 
MAX_LOOP
	LDR R2, R1, #0
	LD R4, MAX_VAL
	NOT R4, R4
	ADD R4, R4, #1
	ADD R2, R2, R4
	BRzp MAX_REASSIGN	
	ADD R3, R3, #-1	
	BRnz MAX_END
	ADD R1, R1, #1
	BR MAX_LOOP
MAX_REASSIGN
	NOT R4, R4
	ADD R4, R4, #1
	ADD R2, R2, R4
	ST R2, MAX_VAL
	ADD R3, R3, #-1	
	BRnz MAX_END
	ADD R1, R1, #1
	BR MAX_LOOP
MAX_END
	RET

; subroutine summing all test score values together (values in the test_scores array)
SUMMATION
	AND R1, R1, x0
	LEA R1, TEST_SCORES
	AND R2, R2, x0
	AND R3, R3, x0
	ADD R3, R3, #4
	AND R4, R4, #0
	LDR R4, R1, #0
	ST R4, SUM
ADD_LOOP
	ADD R1, R1, #1
	LDR R2, R1, #0
	LD R4, SUM
	ADD R4, R4, R2
	ST R4, SUM
	ADD R3, R3, #-1	
	BRnz SUM_END
	BR ADD_LOOP
SUM_END
	RET

; subroutine determining the avg test score 
; (dividing the sum of the values in the test_scores previously determined by 
; the summation subroutine the test_scores array by the number of values in the test_scores array)
DIVISION
	AND R1, R1, x0
	LD R1, SUM
	AND R2, R2, x0
DIVLOOP
	ADD R1, R1, #-5
	BRn DIVEND
	ADD R2, R2, #1
	BR DIVLOOP
DIVEND
	ST R2, AVG
	RET
GRADEA
	AND R6, R6, x0
	LD R6, SaveReg3
	AND R4, R4, x0
	LD R4, GRADE_A
	ADD R6, R6, R4
	BRzp LETTER_A
	RET

; subroutines that determines the letter grade to be displayed onto the console for 
; each test score and the avg test score (the avg test grade)
LETTER_A
	LD R0, CHAR_A
	ADD R0, R0, x0
	ST R0, TEST_GRADE
	RET

GRADEB
	AND R6, R6, x0
	LD R6, SaveReg3
	AND R4, R4, x0
	LD R4, GRADE_B
	ADD R6, R6, R4
	BRzp GRADEB2
	RET
GRADEB2
	ADD R6, R6, #-10
	BRn LETTER_B
	RET
LETTER_B
	LD R0, CHAR_B
	ADD R0, R0, x0
	ST R0, TEST_GRADE
	RET

GRADEC
	AND R6, R6, x0
	LD R6, SaveReg3
	AND R4, R4, x0
	LD R4, GRADE_C
	ADD R6, R6, R4
	BRzp GRADEC2
	RET
GRADEC2
	ADD R6, R6, #-10
	BRn LETTER_C
	RET
LETTER_C
	LD R0, CHAR_C
	ADD R0, R0, x0
	ST R0, TEST_GRADE
	RET

GRADED
	AND R6, R6, x0
	LD R6, SaveReg3
	AND R4, R4, x0
	LD R4, GRADE_D
	ADD R6, R6, R4
	BRzp GRADED2
	RET
GRADED2
	ADD R6, R6, #-10
	BRn LETTER_D
	RET
LETTER_D
	LD R0, CHAR_D
	ADD R0, R0, x0
	ST R0, TEST_GRADE
	RET

GRADEF
	AND R6, R6, x0
	LD R6, SaveReg3
	AND R4, R4, x0
	LD R4, GRADE_D
	ADD R6, R6, R4
	BRn LETTER_F
	RET
LETTER_F
	LD R0, CHAR_F
	ADD R0, R0, x0
	ST R0, TEST_GRADE
	RET

.END
