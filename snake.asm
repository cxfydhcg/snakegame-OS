.ORIG x3000
;snake game
;Author: Xufeng Ce
;Completion Data: 07/26/2021
;Description: This program is a snake game
;Honor Pledge: I have neither given nor received unauthorized aid on this assignment

; This inclue score traking and spped up part


; ------------------------------- MAIN ROUTINE ------------------------------- ;

MAIN
        ; draw first part of snake
        LD R6, SNAKE_PTR
        LDR R0, R6, #6  ; load x coordinate
        LDR R1, R6, #7  ; load y coordinate
        LDR R2, R6, #5  ; load snake color
        TRAP x40        ; DRAW_PIXEL

        ; place an apple
        JSR PLACE_RANDOM_APPLE

GAME_LOOP
        ; *** INSERT CODE HERE ***
        ;; ~15 lines of code or so

        ADD R1, R0, #7
        ADD R2, R0, #5


LOOP_0  LD R0, SNAKE_PTR
        TRAP x42
        ADD R4, R5, #0
        BRn END_0
        BRz JU2
        ADD R4, R4, #-1
        STR R4, R0, #4
        BR LOOP_0

JU2     JSR ADVANCE_SNAKE
        BR LOOP_0
END_0   LEA R0, YOUR
        PUTS
        LD R0, SCORE
        LDR R0, R0, #0
        LD R1, OFF1
        ADD R0, R0, R1
        OUT
        HALT
OFF1    .FILL x0030
SCORE   .FILL x6000
YOUR    .STRINGZ "Your Score is "
; -------------------------------- ENQUEUE_POS ------------------------------- ;
; Description: enqueues x and y coordinate to snake queue
; Input
;   r0: address of snake variable
;   r5: x coordinate (column number)
;   r6: y coordinate (row number)
; Output
;   none
ENQUEUE_POS
        ; save registers
        ST R0, EQ_R0
        ST R1, EQ_R1
        ST R2, EQ_R2
        ST R3, EQ_R3
        ST R4, EQ_R4
        ST R5, EQ_R5
        ST R6, EQ_R6
        ST R7, EQ_R7

        ; *** INSERT CODE HERE ***
        ;; ~15 lines of code or so


        LDR R1, R0, #1
        ADD R1, R1, #2
        LD R2, SNAKE_MAX_MASK
        AND R1, R1, R2
        STR R1, R0, #1

        ADD R1, R0, #6
        LDR R2, R0, #1
        ADD R1, R1, R2
        STR R5, R1, #0

        ADD R1, R1, #1
        STR R6, R1, #0

        LDR R1, R0, #2
        ADD R1, R1, #2
        STR R1, R0, #2


        ; restore registers
        LD R0, EQ_R0
        LD R1, EQ_R1
        LD R2, EQ_R2
        LD R3, EQ_R3
        LD R4, EQ_R4
        LD R5, EQ_R5
        LD R6, EQ_R6
        LD R7, EQ_R7

        RET

EQ_R0   .BLKW 1
EQ_R1   .BLKW 1
EQ_R2   .BLKW 1
EQ_R3   .BLKW 1
EQ_R4   .BLKW 1
EQ_R5   .BLKW 1
EQ_R6   .BLKW 1
EQ_R7   .BLKW 1


; -------------------------------- DEQUEUE_POS ------------------------------- ;
; Description: dequeues x and y coordinate to snake queue
; Input
;   r0: address of snake variable
; Output
;   r5: x coordinate (column number)
;   r6: y coordinate (row number)
DEQUEUE_POS
        ; save registers
        ST R0, DQ_R0
        ST R1, DQ_R1
        ST R2, DQ_R2
        ST R3, DQ_R3
        ST R4, DQ_R4
        ; don't save outputs r5/r6
        ST R7, DQ_R7

        ; *** INSERT CODE HERE ***
        ;; ~15 lines of code or so

        ADD R1, R0, #6
        LDR R2, R0, #0
        ADD R1, R1, R2
        LDR R5, R1, #0

        ADD R1, R1, #1
        LDR R6, R1, #0

        ADD R2, R2, #2
        LD R1, SNAKE_MAX_MASK
        AND R2, R2, R1
        STR R2, R0, #0

        LDR R1, R0, #2
        ADD R1, R1, #-2
        STR R1, R0, #2

        ; restore registers
        LD R0, DQ_R0
        LD R1, DQ_R1
        LD R2, DQ_R2
        LD R3, DQ_R3
        LD R4, DQ_R4
        ; don't restore outputs R5, R6
        LD R7, DQ_R7

        RET

DQ_R0   .BLKW 1
DQ_R1   .BLKW 1
DQ_R2   .BLKW 1
DQ_R3   .BLKW 1
DQ_R4   .BLKW 1
; no R5, R6
DQ_R7   .BLKW 1


; ------------------------- GLOBAL CONSTANTS/VALUES -------------------------- ;
Q_SIZE          .FILL #256      ; queue size
NEG_Q_SIZE      .FILL #-256     ; negated queue size
SNAKE_MAX_MASK  .FILL x00FF     ; queue wraparound mask
BACKGROUND_COLOR .FILL x0000    ; background color - black
APPLE_COLOR     .FILL x7C00     ; apple color - red
SNAKE_PTR       .FILL SNAKE     ; pointer to snake

; ------------------------------ CHECK_COLLISION ----------------------------- ;
; Description: checks for collision
; Input
;   r0: address of snake variable
; Output
;   r5: 1 if collision, 0 if no collision, -1 if apple
CHECK_COLLISION
        ; save registers
        ST R0, CC_R0
        ST R1, CC_R1
        ST R2, CC_R2
        ST R3, CC_R3
        ST R4, CC_R4
        ; dont save output R5
        ST R6, CC_R6
        ST R7, CC_R7

        ; *** INSERT CODE HERE ***
        ;; ~15 lines of code or so

        JSR GET_NEXT
        ADD R0, R5, #0
        ADD R1, R6, #0
        TRAP x41
        LD R1, BACKGROUND_COLOR
        ADD R4, R5, #0                 ;color value now is in R4
        AND R5, R5, #0

        ADD R3, R4, R1
        BRnp JUMP0

        BR JUMP2
JUMP0   LD R1, APPLE_COLOR
        NOT R1, R1
        ADD R1, R1, #1
        ADD R3, R4, R1
        BRnp JUMP1
        ADD R5, R5, #-1
        BR JUMP2
JUMP1  ADD, R5, R5, #1
JUMP2



        ; restore registers
CC_END  LD R0, CC_R0
        LD R1, CC_R1
        LD R2, CC_R2
        LD R3, CC_R3
        LD R4, CC_R4
        ; don't restore output R5
        LD R6, CC_R6
        LD R7, CC_R7

        RET

CC_R0   .BLKW 1
CC_R1   .BLKW 1
CC_R2   .BLKW 1
CC_R3   .BLKW 1
CC_R4   .BLKW 1
; no R5
CC_R6   .BLKW 1
CC_R7   .BLKW 1

; --------------------------------- GET_NEXT --------------------------------- ;
; Description: gets the next position for the snake's head
; Input
;   r0: address of snake variable
; Output
;   r5: next x position (column number)
;   r6: next y position (row number)
GET_NEXT
        ; save registers
        ST R0, GN_R0
        ST R1, GN_R1
        ST R2, GN_R2
        ST R3, GN_R3
        ST R4, GN_R4
        ; don't save outputs R5, R6
        ST R7, GN_R7

        ; *** INSERT CODE HERE ***
        ;; ~25 lines of code or so

        LDR R4, R0, #4     ;R4 has the direction value now
        ADD R1, R0, #6

        LDR R2, R0, #1
        ADD R3, R1, R2
        LDR R5, R3, #0

        ADD R3, R3, #1
        LDR R6, R3, #0

        ADD R3, R4, #0
        BRnp NEXT0
        ADD R5, R5, #-1

NEXT0   ADD R3, R4, #-1
        BRnp NEXT2
        ADD R6, R6, #-1

NEXT2   ADD R3, R4, #-2
        BRnp NEXT3
        ADD R5, R5, #1

NEXT3   ADD R3, R4, #-3
        BRnp NEXT4
        ADD R6, R6, #1
NEXT4


        ; restore registers
        LD R0, GN_R0
        LD R1, GN_R1
        LD R2, GN_R2
        LD R3, GN_R3
        LD R4, GN_R4
        ; don't restore outputs R5, R6
        LD R7, GN_R7

        RET

GN_R0   .BLKW 1
GN_R1   .BLKW 1
GN_R2   .BLKW 1
GN_R3   .BLKW 1
GN_R4   .BLKW 1
GN_R5   .BLKW 1
GN_R6   .BLKW 1
GN_R7   .BLKW 1


; ---------------------------- PLACE_RANDOM_APPLE ---------------------------- ;
; Description: places the next random apple on the screen
; Input
;   None
; Output
;   None
PLACE_RANDOM_APPLE
        ; save registers
        ST R0, PA_R0
        ST R1, PA_R1
        ST R2, PA_R2
        ST R3, PA_R3
        ST R4, PA_R4
        ST R5, PA_R5
        ST R6, PA_R6
        ST R7, PA_R7

        ; *** INSERT CODE HERE ***
        ;; ~15 lines of code or so

REPEAT  LD R6, LEVEL_MASK
        TRAP x43
        AND R0, R5, R6
        TRAP x43
        AND R1, R5, R6

        LD R3, MAX_Y
        ADD R3, R1, R3
        BRzp REPEAT

        TRAP x41
        LD R6, BACKGROUND_COLOR
        ADD R6, R5, R6
        BRnp REPEAT

        LD R2, APPLE_COLOR
        TRAP x40

        ; restore registers
        LD R0, PA_R0
        LD R1, PA_R1
        LD R2, PA_R2
        LD R3, PA_R3
        LD R4, PA_R4
        LD R5, PA_R5
        LD R6, PA_R6
        LD R7, PA_R7

        RET

PA_R0  .BLKW 1
PA_R1  .BLKW 1
PA_R2  .BLKW 1
PA_R3  .BLKW 1
PA_R4  .BLKW 1
PA_R5  .BLKW 1
PA_R6  .BLKW 1
PA_R7  .BLKW 1

; PLACE_RANDOM_APPLE local "variables"
LEVEL_MASK  .FILL x007F ; mask to perform modulo on random number
MAX_Y       .FILL #-124 ; negated height to limit random number

; ------------------------------- ADVANCE_SNAKE ------------------------------ ;
; Description: advances the snake to the next position
; Input
;   r0: address of snake variable
; Output
;   None
ADVANCE_SNAKE
        ; save registers
        ST R0, AS_R0
        ST R1, AS_R1
        ST R2, AS_R2
        ST R3, AS_R3
        ST R4, AS_R4
        ST R5, AS_R5
        ST R6, AS_R6
        ST R7, AS_R7

        ; *** INSERT CODE HERE ***
        ;; ~40 lines of code or so

        JSR CHECK_COLLISION
        ADD R5, R5, #0
        BRp END_0             ;END_0 is in main routine
        BRz JU0

        LDR R1, R0, #3
        ADD R1, R1, #4
        STR R1, R0, #3

        LD R1, SCORE
        LDR R2, R1, #0
        ADD R2, R2, #1
        STR R2, R1, #0

        TRAP x50
        JSR PLACE_RANDOM_APPLE

JU0     JSR GET_NEXT
        JSR ENQUEUE_POS
        LDR R2, R0, #5
        ADD R3, R0, #0
        ADD R0, R5, #0
        ADD R1, R6, #0

        TRAP x40

        ADD R0, R3, #0
        LDR R1, R0, #3
        BRnz JU1
        LDR R2, R0, #2
        LD R3, NEG_Q_SIZE
        ADD R2, R2, R3
        BRz JU1
        ADD R1, R1, #-1
        STR R1, R0, #3
        BR END_1

JU1     JSR DEQUEUE_POS
        ADD R0, R5, #0
        ADD R1, R6, #0
        LD R2, BACKGROUND_COLOR
        TRAP x40
END_1

        ; restore registers
END_ADV LD R0, AS_R0
        LD R1, AS_R1
        LD R2, AS_R2
        LD R3, AS_R3
        LD R4, AS_R4
        LD R5, AS_R5
        LD R6, AS_R6
        LD R7, AS_R7

        RET

AS_R0   .BLKW 1
AS_R1   .BLKW 1
AS_R2   .BLKW 1
AS_R3   .BLKW 1
AS_R4   .BLKW 1
AS_R5   .BLKW 1
AS_R6   .BLKW 1
AS_R7   .BLKW 1

; ----------------------------- snake "variables" ---------------------------- ;
SNAKE
        .FILL x0000     ; (+0) HeadOffset - offset to head position
        .FILL x0000     ; (+1) TailOffset - offset to tail position
        .FILL x0002     ; (+2) QueueSize - current size of queue
        .FILL #4        ; (+3) GrowCount - number of segments left to grow
        .FILL #3        ; (+4) Direction - 0=left,1=up,2=right,3=down
        .FILL x8AA8     ; (+5) Color - green
        ; Queue start - (+6) start of position queue
        .FILL #20       ; start position - first x value
        .FILL #10       ; start position - first y value
        .BLKW #254      ; space for the rest of queue -> 2x128-2
