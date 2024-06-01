kernel_lines=183
playfield_lines=44
playfield_line_height=4
padding_lines=2
playfield_scanlines=#playfield_lines*#playfield_line_height
remaining_lines=#kernel_lines-#playfield_scanlines-#padding_lines-2
PlayFieldHeightCounter=temp1 ; reuse temp1

.pizza_title
    ; first eat overscan
pizza_title_WaitForOverscanEnd
	lda INTIM
	bmi pizza_title_WaitForOverscanEnd
    ; do vsync
	lda #2
	sta WSYNC 
	sta VSYNC 
	sta WSYNC 
	sta WSYNC 
	lda #0
	sta WSYNC 
	sta VSYNC
    ; start vblank
    ifconst overscan_time
        lda #overscan_time+5+128
      else
	lda #42+128
      endif
	sta TIM64T

pizza_title_WaitForVblankEnd
	lda INTIM
	bmi pizza_title_WaitForVblankEnd
    lda #0
	sta WSYNC      
	sta VBLANK	       

    ldx #padding_lines
pizza_title_PaddingLoop
    sta WSYNC
    dex
    bne pizza_title_PaddingLoop
    lda #$00
    sta CTRLPF
    lda #BK_COLOR
    sta COLUBK
    lda #PLAYER_COLOR
    sta COLUPF
    ldx #playfield_lines-1
    lda #playfield_line_height
    sta PlayFieldHeightCounter

pizza_title_PlayfieldLoop
    sta WSYNC                       ; 3     (0)
    SLEEP 7
    lda TPF0DataA,x                  ; 4     (11)
    sta PF0                         ; 3     (14)
    lda TPF1DataA,x                  ; 4     (18)
    sta PF1                         ; 3     (21)
    lda TPF2DataA,x                  ; 4     (25)
    sta PF2                         ; 3     (28)
    lda TPF0DataB,x                  ; 4     (32)
    tay                             ; 2     (34)
    lda TPF1DataB,x                  ; 4     (38)
    sta PF1                         ; 3     (41)
    sty PF0                         ; 3     (44)
    lda TPF2DataB,x                  ; 4     (48)
    sta PF2                         ; 3     (51)
    dec PlayFieldHeightCounter      ; 5     (56)
    bne ____skip_new_row            ; 2     (58)
    lda #playfield_line_height      ; 2     (60)
    sta PlayFieldHeightCounter      ; 3     (63)
    dex                             ; 2     (65)
    cpx #$FF                        ; 2     (67)
    beq ____done_playfield_rows     ; 2     (69)
____skip_new_row
    jmp pizza_title_PlayfieldLoop   ; 3     (72)



____done_playfield_rows
    lda #0
    sta PF0
    sta PF1
    sta PF2
    ldx #remaining_lines
pizza_title_VisibleScreen
    sta WSYNC
    dex
    bne pizza_title_VisibleScreen

pizza_title_Overscan
 	lda #47+128
	sta TIM64T

    lda #%00000010
	sta WSYNC
	sta VBLANK
    RETURN ; return from title

   align 256

TPF0DataA
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

TPF1DataA
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000001
	.byte %00000010
	.byte %00000011
	.byte %00000010
	.byte %00000010
	.byte %00000011
	.byte %00000010
	.byte %00000010
	.byte %00000010
	.byte %00000001
	.byte %00000001
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10001011
	.byte %11001010
	.byte %10101001
	.byte %10101000
	.byte %11001011
	.byte %00000000
	.byte %00000000

TPF2DataA
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01100011
	.byte %01110010
	.byte %00110101
	.byte %01010100
	.byte %01101101
	.byte %10110110
	.byte %01110101
	.byte %01010101
	.byte %11110101
	.byte %11111110
	.byte %10111100
	.byte %01111011
	.byte %10111110
	.byte %10111111
	.byte %01010111
	.byte %11101110
	.byte %11111010
	.byte %10111100
	.byte %11101100
	.byte %10111100
	.byte %00111100
	.byte %01111000
	.byte %11010000
	.byte %01100000
	.byte %11000000
	.byte %01100000
	.byte %11100000
	.byte %11000000
	.byte %10000000
	.byte %00000000
	.byte %00000000
	.byte %01011101
	.byte %11000100
	.byte %01001000
	.byte %01010001
	.byte %10011101
	.byte %00000000
	.byte %00000000

    
      align 256

TPF0DataB
	.byte %00000000
	.byte %10000000
	.byte %01000000
	.byte %00100000
	.byte %11100000
	.byte %10100000
	.byte %01100000
	.byte %00100000
	.byte %10100000
	.byte %01100000
	.byte %10100000
	.byte %10100000
	.byte %01010000
	.byte %11100000
	.byte %11000000
	.byte %01110000
	.byte %10110000
	.byte %01010000
	.byte %10010000
	.byte %11100000
	.byte %11110000
	.byte %11110000
	.byte %11100000
	.byte %11010000
	.byte %00110000
	.byte %11110000
	.byte %11100000
	.byte %01000000
	.byte %00010000
	.byte %00010000
	.byte %00100000
	.byte %11110000
	.byte %00110000
	.byte %00010000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00010000
	.byte %00010000
	.byte %00010000
	.byte %00010000
	.byte %00000000
	.byte %00000000
	.byte %00000000

TPF1DataB
	.byte %00000000
	.byte %00000000
	.byte %10000000
	.byte %11000000
	.byte %01000000
	.byte %01000000
	.byte %01000000
	.byte %11000000
	.byte %01000000
	.byte %01000000
	.byte %01000000
	.byte %11000000
	.byte %11000000
	.byte %10000000
	.byte %10000000
	.byte %11000000
	.byte %01000000
	.byte %10000000
	.byte %01000000
	.byte %11111000
	.byte %11111100
	.byte %01101110
	.byte %11011110
	.byte %11100000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %01100010
	.byte %01010101
	.byte %01100101
	.byte %01010101
	.byte %01100010
	.byte %00000000
	.byte %00000000

TPF2DataB
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000100
	.byte %00000100
	.byte %00000100
	.byte %00001010
	.byte %00001010
	.byte %00000000
	.byte %00000000