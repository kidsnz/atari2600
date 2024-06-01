;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Program Information
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Program:      Random Emoticons
    ; Program by:   Shinji Murakami, https://www.instagram.com/kid_snz/
    ; Last Update:  July 20, 2023
    ;
    ; My first program is based on the idea I got while taking the online lessons
    ; to study assembly by Gustavo Pezzi at PIKUMA.
    ;
    ; Concepts based on
    ;   - "Atari 2600 Programming with 6502 Assembly" at PIKUMA by Gustavo Pezzi
    ;   - "5 Painting on the CRT" at 8bitworkshop by Steven Hugg
    ;   - Collect.asm by Darrell Spice, Jr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize dasm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    processor 6502
    include "vcs.h"
    include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Declare the variables starting from memory address $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    seg.u Variables
    org $80

P0XPos          word        ; player0 x-position
P0YPos          byte        ; player0 y-position
P0Dir_x         byte        ; player0 x-direction, 0 = right, 1 = left
P0Dir_y         byte        ; player0 y-direction, 0 = top, 1 = bottom
P0Offset        byte        ; player0 frame offset
P1XPos          word        ; player1 x-position
P1YPos          byte        ; player1 y-position
P1Dir_x         byte        ; player1 x-direction, 0 = right, 1 = left
P1Dir_y         byte        ; player1 y-direction, 0 = top, 1 = bottom
P1Offset        byte        ; player1 frame offset
BGColor         byte        ; BG color
SFX_0:          ds 1        ; Sound

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
P0_HEIGHT = 15              ; player0 sprite height (# rows in lookup table)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start our ROM code at memory address $F000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    seg Code
    org $F000

Reset:
    CLEAN_START             ; call macro to reset memory and registers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize RAM variables and TIA registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #60
    sta P0YPos              ; P0YPos = 60
    lda #0
    sta P0XPos              ; P0XPos = 0
    lda #0
    sta P0Dir_x             ; P0Dir_x = 0, set to right
    lda #0
    sta P0Dir_y             ; P0Dir_y = 0, set to top

    lda #20
    sta P1YPos              ; P0YPos = 20
    lda #50
    sta P1XPos              ; P0XPos = 50
    lda #1
    sta P1Dir_x             ; P0Dir_x = 1, set to left
    lda #1
    sta P1Dir_y             ; P0Dir_y = 1, set to bottom

    lda $1E                 ; load player color
    sta COLUP0              ; set color for player 0  
    sta COLUP1              ; set color for player 1
    lda #%00000111
    sta NUSIZ0              ; stretch player 0 sprite
    sta NUSIZ1              ; stretch player 1 sprite

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start the main display loop and frame rendering
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
StartFrame:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calculations and tasks performed in the pre-VBlank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda P0XPos
    ldx #0                  ; laod player0 to X register
    jsr SetObjectXPos       ; set player0 horizontal position

    lda P1XPos
    ldx #1                  ; load player1 to X register
    jsr SetObjectXPos       ; set player1 horizontal position

    sta WSYNC
    sta HMOVE               ; apply the horizontal offsets previously set

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Updating sound effects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jsr SFX_UPDATE          ; update sound effects

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display VSYNC and VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #2
    sta VBLANK              ; turn on VBLANK
    sta VSYNC               ; turn on VSYNC
    REPEAT 3
        sta WSYNC           ; display 3 recommended lines of VSYNC
    REPEND
    lda #0
    sta VSYNC               ; turn off VSYNC
    REPEAT 37
        sta WSYNC           ; display the 37 recommended lines of VBLANK
    REPEND
    sta VBLANK              ; turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display the 192 visible scanlines of our main game
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GameVisibleLine:
    ldx #96                 ; X counts the number of remaining scanlines

.GameLineLoop:              ; main loop starts here
.AreWeInsideP0Sprite:       ; check if should render sprite player0
    txa                     ; transfer X to A
    sec                     ; make sure carry flag is set
    sbc P0YPos              ; subtract sprite Y coordinate
    cmp P0_HEIGHT           ; are we inside the sprite height bounds?
    bcc .DrawSpriteP0       ; if result < SpriteHeight, call subroutine
    lda #0                  ; else, set lookup index to 0
.DrawSpriteP0:
    clc                     ; clear carry flag before addition
    adc P0Offset            ; jump to correct sprite frame address in memory
    tay                     ; load Y so we can work with pointer
    lda P0Sprite,Y          ; load player bitmap slice of data
    sta GRP0                ; set graphics for player0
    sta WSYNC               ; wait for next scanline

.AreWeInsideP1Sprite:       ; check if should render sprite player1
    txa                     ; transfer X to A
    sec                     ; make sure carry flag is set
    sbc P1YPos              ; subtract sprite Y coordinate
    cmp P0_HEIGHT           ; are we inside the sprite height bounds?
    bcc .DrawSpriteP1       ; if result < SpriteHeight, call subroutine
    lda #0                  ; else, set lookup index to 0
.DrawSpriteP1:
    clc                     ; clear carry flag before addition
    adc P1Offset            ; jump to correct sprite frame address in memory
    tay                     ; load Y so we can work with pointer
    lda P0Sprite,Y          ; load player bitmap slice of data
    sta GRP1                ; set graphics for player1
    sta WSYNC               ; wait for next scanline

    lda BGColor             ; load current variable of BG counter to A
    tay                     ; transfer A to Y
    lda BG_Gradation,Y      ; load BG color code to A
    sta COLUBK              ; set background color
    inc BGColor             ; increase BG counter
    lda BGColor             ; load current BG counter
    cmp #96                 ; to check if it's more than max of 96 lines of BG_Gradation
    bne .GameLineLoop_End   ; else, jump to .GameLineLoop_End
    lda #0                  ; if so,
    sta BGColor             ; reset BG counter to 0

.GameLineLoop_End
    dex                     ; X--
    bne .GameLineLoop       ; repeat next main game scanline while X != 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display Overscan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #2
    sta VBLANK              ; turn on VBLANK again
    REPEAT 30
        sta WSYNC           ; display 30 recommended lines of VBlank Overscan
    REPEND
    lda #0
    sta VBLANK              ; turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; P0 Position and Direction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckP0Direction_x:
    lda P0Dir_x             ; load x direction of P0
    cmp #0                  ; branch to which direction P0 to move
    bne .P0Dir_Left         ; if player0 moves to the left, jump
.P0Dir_Right
    lda #0
    sta P0Dir_x             ; set direction of P0 to the right
    inc P0XPos              ; move P0 a pixel to the right
    lda P0XPos              ; check the P0 x-position
    cmp #134                ; the limit of x-position on the right
    bcs .P0Dir_x_Change     ; if P0 x-position is more than the number, change the direction
    jmp CheckP0Direction_y  ; else, go checking y-position
.P0Dir_Left
    lda #1
    sta P0Dir_x             ; set direction of P0 to the left
    dec P0XPos              ; move P0 a pixel to the left
    lda P0XPos              ; check the P0 x-position
;    cmp #0                  ; the limit of x-position on the left
    beq .P0Dir_x_Change     ; ff P0 y-position is less than the number, change the direction
    jmp CheckP0Direction_y  ; else, go checking y-position
    
.P0Dir_x_Change

    lda SFX_0               ; load current position of SFX loop to A
    cmp #0                  ; check if SFX loop is finished
    bne SFX_Next_P0_x       ; else, jump to make next sound of the current part
    ldy #72                 ; and reset SFX loop to the beginning
    jsr SFX_TRIGGER         ; and trigger the loop to start
    jmp SFX_End_P0_x
SFX_Next_P0_x:
    dec SFX_0               ; let the position of the melody goes to the next part
SFX_End_P0_x:               ; SFX check ends here

    lda P0Offset            ; load current position of the face
    cmp #60                 ; check if it's the last face
    beq .P0Offset_Reset     ; then go reseting to the first face
.P0Offset_15
    lda P0_HEIGHT           ; load offset size of each face
    clc
    adc P0Offset            ; change the face to the next one
    sta P0Offset            ; set the current position of the face
    jmp .P0Offset_End
.P0Offset_Reset
    lda #0
    sta P0Offset            ; reset the face to the first one
.P0Offset_End
    lda P0Dir_x
    cmp #0                  ; branch to which direction P0 to move
    bne .P0Dir_Right        ; change the direction to the right
    jmp .P0Dir_Left         ; chnage the direction to the left

CheckP0Direction_y:
    lda P0Dir_y             ; load y direction of P0
    cmp #0                  ; branch to which direction P0 to move
    bne .P0Dir_Bottom       ; if player0 moves to the bottom, jump
.P0Dir_Top
    lda #0
    sta P0Dir_y             ; set direction of P0 to the top
    inc P0YPos              ; move P0 a pixel to the top
    lda P0YPos              ; check the P0 y-position
    cmp #82                 ; the limit of y-position on the top
    bpl .P0Dir_y_Change     ; if P0 y-position is more than the number, change the direction
    jmp CheckP0DirectionEnd ; else, go checking P1
.P0Dir_Bottom
    lda #1
    sta P0Dir_y             ; set direction of P0 to the bottom
    dec P0YPos              ; move P0 a pixel to the bottom
    lda P0YPos              ; check the P0 y-position
    cmp #2                  ; the limit of y-position on the bottom
    bmi .P0Dir_y_Change     ; if P0 y-position is less than the number, change the direction
    jmp CheckP0DirectionEnd

.P0Dir_y_Change

    lda SFX_0               ; load current position of SFX loop to A
    cmp #0                  ; check if SFX loop is finished
    bne SFX_Next_P0_y       ; else, jump to make next sound of the current part
    ldy #72                 ; and reset SFX loop to the beginning
    jsr SFX_TRIGGER         ; and trigger the loop to start
    jmp SFX_End_P0_y
SFX_Next_P0_y:
    dec SFX_0               ; let the position of the melody goes to the next part
SFX_End_P0_y:               ; SFX check ends here
         
    lda P0Offset            ; load current position of the face
    cmp #60                 ; check if it's the last face
    beq .P0Offset_Reset_2   ; then go reseting to the first face
.P0Offset_15_2
    lda P0_HEIGHT           ; load offset size of each face
    clc
    adc P0Offset            ; change the face to the next one
    sta P0Offset            ; set the current position of the face
    jmp .P0Offset_End_2
.P0Offset_Reset_2
    lda #0
    sta P0Offset            ; reset the face to the first one
.P0Offset_End_2
    lda P0Dir_y
    cmp #0                  ; branch to which direction P0 to move
    bne .P0Dir_Top          ; change the direction to the top
    jmp .P0Dir_Bottom       ; chnage the direction to the bottom    

CheckP0DirectionEnd:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; P1 Position and Direction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckP1Direction_x:
    lda P1Dir_x
    cmp #0                  ; they are all same with the setting of P0, but for P1
    bne .P1Dir_Left
.P1Dir_Right
    lda #0
    sta P1Dir_x
    inc P1XPos
    lda P1XPos
    cmp #134
    bcs .P1Dir_x_Change
    jmp CheckP1Direction_y
.P1Dir_Left
    lda #1
    sta P1Dir_x
    dec P1XPos
    lda P1XPos
;    cmp #0
    beq .P1Dir_x_Change
    jmp CheckP1Direction_y
    
.P1Dir_x_Change

    lda SFX_0
    cmp #0
    bne SFX_Next_P1_x
    ldy #72
    jsr SFX_TRIGGER
    jmp SFX_End_P1_x
SFX_Next_P1_x:
    dec SFX_0
SFX_End_P1_x:

    lda P1Offset
    cmp #60
    beq .P1Offset_Reset
.P1Offset_15
    lda P0_HEIGHT
    clc
    adc P1Offset
    sta P1Offset
    jmp .P1Offset_End
.P1Offset_Reset
    lda #0
    sta P1Offset
.P1Offset_End
    lda P1Dir_x
    cmp #0
    bne .P1Dir_Right
    jmp .P1Dir_Left

CheckP1Direction_y:
    lda P1Dir_y
    cmp #0
    bne .P1Dir_Bottom
.P1Dir_Top
    lda #0
    sta P1Dir_y
    inc P1YPos
    lda P1YPos
    cmp #82
    bpl .P1Dir_y_Change
    jmp CheckP1DirectionEnd
.P1Dir_Bottom
    lda #1
    sta P1Dir_y
    dec P1YPos
    lda P1YPos
    cmp #2
    bmi .P1Dir_y_Change
    jmp CheckP1DirectionEnd

.P1Dir_y_Change

    lda SFX_0
    cmp #0
    bne SFX_Next_P1_y
    ldy #72
    jsr SFX_TRIGGER
    jmp SFX_End_P1_y
SFX_Next_P1_y:
    dec SFX_0
SFX_End_P1_y:

    lda P1Offset
    cmp #60
    beq .P1Offset_Reset_2
.P1Offset_15_2
    lda P0_HEIGHT
    clc
    adc P1Offset
    sta P1Offset
    jmp .P1Offset_End_2
.P1Offset_Reset_2
    lda #0
    sta P1Offset
.P1Offset_End_2
    lda P1Dir_y
    cmp #0
    bne .P1Dir_Top
    jmp .P1Dir_Bottom

CheckP1DirectionEnd:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Joystick input test for P0 and P1 up/down/left/right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckP0Up:
    lda #%00010000
    bit SWCHA
    bne CheckP0Down         ; check if the up is pressed
    lda #0
    sta P0Dir_y             ; set direction of P0 to the top
CheckP0Down:
    lda #%00100000
    bit SWCHA
    bne CheckP0Right        ; check if the down is pressed
    lda #1
    sta P0Dir_y             ; set directionn of P0 to the bottom
CheckP0Right:
    lda #%10000000
    bit SWCHA
    bne CheckP0Left         ; check if the right is pressed
    lda #0
    sta P0Dir_x             ; Set direction of P0 to the right
CheckP0Left:
    lda #%01000000
    bit SWCHA
    bne P0NoInput             ; check if the left is pressed
    lda #1
    sta P0Dir_x             ; set direction of P0 to the right
P0NoInput:

CheckP1Up:
    lda #%00000001
    bit SWCHA
    bne CheckP1Down         ; check if the up is pressed
    lda #0
    sta P1Dir_y             ; set direction of P0 to the top
CheckP1Down:
    lda #%00000010
    bit SWCHA
    bne CheckP1Right        ; check if the down is pressed
    lda #1
    sta P1Dir_y             ; set directionn of P0 to the bottom
CheckP1Right:
    lda #%00001000
    bit SWCHA
    bne CheckP1Left         ; check if the right is pressed
    lda #0
    sta P1Dir_x             ; Set direction of P0 to the right
CheckP1Left:
    lda #%00000100
    bit SWCHA
    bne P1NoInput             ; check if the left is pressed
    lda #1
    sta P1Dir_x             ; set direction of P0 to the right
P1NoInput:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Check for object collision
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckCollisionP0P1:
    lda #%10000000          ; CXPPMM bit 7 detects P0 and P1 collision
    bit CXPPMM              ; check CXPPMM bit 7 with the above pattern
    bne .P0P1Collided       ; if collision between P0 and P1 happened, branch
    jmp EndCollisionCheck   ; else, skip to next check
.P0P1Collided:
    jsr ThingHappens        ; call ThingHappens subroutine

EndCollisionCheck:          ; fallback
    sta CXCLR               ; clear all collision flags before the next frame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Scroll the BGColor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    dec BGColor             ; The next frame will start with current color value - 1
                            ; to get a downwards scrolling effect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Loop back to start a brand new frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jmp StartFrame          ; continue to display the next frame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Subroutine to handle object horizontal position with fine offset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A is the target x-coordinate position in pixels of our object
;; X is the object type (0:player0, 1:player1, 2:missile0, 3:missile1, 4:ball)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetObjectXPos subroutine
    sec                      ; move the sec above WSYNC to get 2 cycles back
    sta WSYNC                ;
.Div15Loop
    sbc #15                  ;2   2 
    bcs .Div15Loop           ;2/3 4 
    eor #7                   ;2   6 
    asl                      ;2   8
    asl                      ;2  10
    asl                      ;2  12
    asl                      ;2  14 
    sta.a HMP0,X             ;5  19 sta in absolute (wide) mode = 5 cycles - note, using x not y
    sta.d RESP0,X            ;4  23 sta in zeropage mode (must use x, not y)= 4 cycles  
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Thing Happens subroutine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ThingHappens subroutine

SFX_Start:
    lda SFX_0               ; load current position of SFX loop to A
    cmp #0                  ; check if SFX loop is finished
    bne SFX_Next            ; else, jump to make next sound of the current part
    ldy #72                 ; and reset SFX loop to the beginning
    jsr SFX_TRIGGER         ; and trigger the loop to start
    jmp SFX_End
SFX_Next:
    dec SFX_0               ; let the position of the melody goes to the next part
SFX_End:

ThingHappensP0_x:
    lda P0Dir_x
    cmp #0                  ; check which direciton P0 moves
    bne .ThingHappensP0_Left
.ThingHappensP0_Right
    dec P0XPos
    dec P0XPos
    inc P1XPos
    inc P1XPos
    lda #1
    sta P0Dir_x             ; change the direciton of P0
    jmp ThingHappensP0_y
.ThingHappensP0_Left
    inc P0XPos
    inc P0XPos
    dec P1XPos
    dec P1XPos              ; move away the position of P0 from P1 to avoid glitch
    lda #0
    sta P0Dir_x             ; change the direciton of P0
ThingHappensP0_y:
    lda P0Dir_y
    cmp #0                  ; check which direciton P0 moves
    bne .ThingHappensP0_Bottom
.ThingHappensP0_Top
    dec P0YPos
    dec P0YPos
    inc P1YPos
    inc P1YPos
    lda #1
    sta P0Dir_y             ; change the direciton of P0
    jmp ThingHappensP0_End
.ThingHappensP0_Bottom
    inc P0YPos
    inc P0YPos
    dec P1YPos
    dec P1YPos              ; move away the position of P0 from P1 to avoid glitch
    lda #0
    sta P0Dir_y             ; change the direciton of P0
ThingHappensP0_End:

ThingHappensP1:             ; do the same things to P1
    lda P1Dir_x
    cmp #0
    bne .ThingHappensP1_Left
.ThingHappensP1_Right
    lda #1
    sta P1Dir_x
    jmp ThingHappensP1_y
.ThingHappensP1_Left
    lda #0
    sta P1Dir_x
ThingHappensP1_y:
    lda P1Dir_y
    cmp #0
    bne .ThingHappensP1_Bottom
.ThingHappensP1_Top
    lda #1
    sta P1Dir_y
    jmp ThingHappensP1_End
.ThingHappensP1_Bottom
    lda #0
    sta P1Dir_y
ThingHappensP1_End:

    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BG_Gradation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BG_Gradation:
    .byte #$30
    .byte #$30
    .byte #$32
    .byte #$32
    .byte #$34
    .byte #$34
    .byte #$36
    .byte #$36
    .byte #$38
    .byte #$38
    .byte #$3A
    .byte #$3A
    .byte #$3C
    .byte #$3C
    .byte #$3E
    .byte #$3E
    .byte #$40
    .byte #$40
    .byte #$42
    .byte #$42
    .byte #$44
    .byte #$44
    .byte #$46
    .byte #$46
    .byte #$48
    .byte #$48
    .byte #$4A
    .byte #$4A
    .byte #$4C
    .byte #$4C
    .byte #$4E
    .byte #$4E
    .byte #$50
    .byte #$50
    .byte #$52
    .byte #$52
    .byte #$54
    .byte #$54
    .byte #$56
    .byte #$56
    .byte #$58
    .byte #$58
    .byte #$5A
    .byte #$5A
    .byte #$5C
    .byte #$5C
    .byte #$5E
    .byte #$5E
    .byte #$80
    .byte #$80
    .byte #$82
    .byte #$82
    .byte #$84
    .byte #$84
    .byte #$86
    .byte #$86
    .byte #$88
    .byte #$88
    .byte #$8A
    .byte #$8A
    .byte #$8C
    .byte #$8C
    .byte #$8E
    .byte #$8E
    .byte #$A0
    .byte #$A0
    .byte #$A2
    .byte #$A2
    .byte #$A4
    .byte #$A4
    .byte #$A6
    .byte #$A6
    .byte #$A8
    .byte #$A8
    .byte #$AA
    .byte #$AA
    .byte #$AC
    .byte #$AC
    .byte #$AE
    .byte #$AE
    .byte #$B0
    .byte #$B0
    .byte #$B2
    .byte #$B2
    .byte #$B4
    .byte #$B4
    .byte #$B6
    .byte #$B6
    .byte #$B8
    .byte #$B8
    .byte #$BA
    .byte #$BA
    .byte #$BC
    .byte #$BC
    .byte #$BE
    .byte #$BE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Declare ROM lookup tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
P0Sprite:
    .byte #%00000000        ;
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####
    .byte #%11101100        ;### ##
    .byte #%11101100        ;### ##
    .byte #%10110100        ;# ## #
    .byte #%10110100        ;# ## #
    .byte #%11110100        ;#### #
    .byte #%11110100        ;#### #
    .byte #%10110100        ;# ## #
    .byte #%10110100        ;# ## #
    .byte #%11101100        ;### ##
    .byte #%11101100        ;### ##
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####

P0Sprite_2:
    .byte #%00000000        ;
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####
    .byte #%11110100        ;#### #
    .byte #%11110100        ;#### #
    .byte #%10101100        ;# # ##
    .byte #%10101100        ;# # ##
    .byte #%11101100        ;### ##
    .byte #%11101100        ;### ##
    .byte #%10101100        ;# # ##
    .byte #%10101100        ;# # ##
    .byte #%11110100        ;#### #
    .byte #%11110100        ;#### #
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####

P0Sprite_3:
    .byte #%00000000        ;
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####
    .byte #%11101100        ;### ##
    .byte #%11101100        ;### ##
    .byte #%10101100        ;# # ##
    .byte #%10101100        ;# # ##
    .byte #%11100100        ;###  #
    .byte #%11100100        ;###  #
    .byte #%10101000        ;# # # 
    .byte #%10101000        ;# # # 
    .byte #%11100100        ;###  #
    .byte #%11100100        ;###  #
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####

P0Sprite_4:
    .byte #%00000000        ;
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####
    .byte #%11111100        ;######
    .byte #%11111100        ;######
    .byte #%10110100        ;# ## #
    .byte #%10110100        ;# ## #
    .byte #%11101000        ;### # 
    .byte #%11101000        ;### # 
    .byte #%10110100        ;# ## #
    .byte #%10110100        ;# ## #
    .byte #%11111100        ;######
    .byte #%11111100        ;######
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####

P0Sprite_5:
    .byte #%00000000        ;
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####
    .byte #%11101100        ;### ##
    .byte #%11101100        ;### ##
    .byte #%10101100        ;# # ##
    .byte #%10101100        ;# # ##
    .byte #%11101100        ;### ##
    .byte #%11101100        ;### ##
    .byte #%10110100        ;# ## #
    .byte #%10110100        ;# ## #
    .byte #%11110100        ;#### #
    .byte #%11110100        ;#### #
    .byte #%01111000        ; ####
    .byte #%01111000        ; ####

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sound Effects *a melody from the beginning part of "For Elise" by Beethoven
;; This part is arranged from Collect.asm by Darrell Spice, Jr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SFX_F:
    .byte 0
    .byte 15
    .byte 15
    .byte 15
    .byte 0
    .byte 29
    .byte 29
    .byte 29
    .byte 0
    .byte 31
    .byte 31
    .byte 31
    .byte 0
    .byte 13
    .byte 13
    .byte 13
    .byte 0
    .byte 15
    .byte 15
    .byte 15
    .byte 0
    .byte 31
    .byte 31
    .byte 31
    .byte 0
    .byte 11
    .byte 11
    .byte 11
    .byte 0
    .byte 15
    .byte 15
    .byte 15
    .byte 0
    .byte 19
    .byte 19
    .byte 19
    .byte 0
    .byte 11
    .byte 11
    .byte 11
    .byte 0
    .byte 29
    .byte 29
    .byte 29
    .byte 0
    .byte 26
    .byte 26
    .byte 26
    .byte 0
    .byte 31
    .byte 31
    .byte 31
    .byte 0
    .byte 23
    .byte 23
    .byte 23
    .byte 0
    .byte 24
    .byte 24
    .byte 24
    .byte 0
    .byte 23
    .byte 23
    .byte 23
    .byte 0
    .byte 24
    .byte 24
    .byte 24
    .byte 0
    .byte 23
    .byte 23
    .byte 23

SFX_CV:
    .byte 0
    .byte $c4
    .byte $c6
    .byte $c8
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $c4
    .byte $c6
    .byte $c8
    .byte 0
    .byte $c4
    .byte $c6
    .byte $c8
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $c4
    .byte $c6
    .byte $c8
    .byte 0
    .byte $c4
    .byte $c6
    .byte $c8
    .byte 0
    .byte $c4
    .byte $c6
    .byte $c8
    .byte 0
    .byte $c4
    .byte $c6
    .byte $c8
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $44
    .byte $46
    .byte $48
    .byte 0
    .byte $44
    .byte $46
    .byte $48

SFX_TRIGGER:
         ldx SFX_0          ; I don't know why but ldy #36 (-1) on the line 489 is loaded to SFX_0
         lda SFX_CV,x       ; CV value will be 0 if channel is idle 
         bne .leftnotfree   ; if not 0 then skip ahead
         sty SFX_0          ; channel is idle, use it
         rts                ; all done
.leftnotfree:
         cpy SFX_0          ; test sfx priority with left channel
         bcc .leftnotlower  ; skip ahead if new sfx has lower priority than active sfx
         sty SFX_0          ; new sfx has higher priority so use left channel
         rts                ; all done
.leftnotlower:
         rts
 
SFX_UPDATE:
         ldx SFX_0          ; get the pointer for the left channel
         lda SFX_F,x        ; get the Frequency value
         sta AUDF0          ; update the Frequency register
         lda SFX_CV,x       ; get the combined Control and Volume value
         sta AUDV0          ; update the Volume register
         lsr                ; prep the Control value,
         lsr                ;   it's stored in the upper nybble
         lsr                ;   but must be in the lower nybble
         lsr                ;   when Control is updated
         sta AUDC0          ; update the Control register
         beq .skipleftdec   ; skip ahead if Control = 0
         dec SFX_0          ; update pointer for left channel
.skipleftdec: 
         rts                ; all done

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete ROM size with exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC                ; move to position $FFFC
    word Reset               ; write 2 bytes with the program reset address
    word Reset               ; write 2 bytes with the interruption vector
