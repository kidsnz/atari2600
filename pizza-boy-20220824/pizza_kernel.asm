; Provided under the CC0 license. See the included LICENSE.txt for details.

FineAdjustTableBegin
	.byte %01100000		;left 6
	.byte %01010000
	.byte %01000000
	.byte %00110000
	.byte %00100000
	.byte %00010000
	.byte %00000000		;left 0
	.byte %11110000
	.byte %11100000
	.byte %11010000
	.byte %11000000
	.byte %10110000
	.byte %10100000
	.byte %10010000
	.byte %10000000		;right 8
FineAdjustTableEnd	=	FineAdjustTableBegin - 241

PFStart
 .byte 87,39,0,21,0,0,0,10
blank_pf
 .byte 0,0,0,0,0,0,0,5
; .byte 43,21,0,10,0,0,0,5
 ifconst screenheight
pfsub
 .byte 8,0,2,2,1,0,0,1,0
 endif
	;--set initial P1 positions
multisprite_setup
    lda #15
    sta pfheight
	ldx #4
SetCopyHeight
	txa
	sta SpriteGfxIndex,X
	sta spritesort,X
	dex
	bpl SetCopyHeight
    rts

drawscreen
 ifconst debugscore
 jsr debugcycles
 endif

WaitForOverscanEnd
	lda INTIM
	bmi WaitForOverscanEnd

	lda #2
	sta WSYNC
	sta VSYNC
	sta WSYNC
	sta WSYNC
	lsr
	sta VDELBL
	sta VDELP0
	sta WSYNC
	sta VSYNC	;turn off VSYNC
      ifconst overscan_time
        lda #overscan_time+5+128
      else
	lda #42+128
      endif
	sta TIM64T

; run possible vblank bB code
 ifconst vblank_bB_code
   jsr vblank_bB_code
 endif

 	jsr setscorepointers
	jsr SetupP1Subroutine

	;-------------

	;--position P0, M0, M1, BL

	jsr PrePositionAllObjects

	;--set up player 0 pointer

    dec player0y
	lda player0pointer ; player0: must be run every frame!
	sec
	sbc player0y
	clc
	adc player0height
	sta player0pointer

	lda player0y
	sta P0Top
	sec
	sbc player0height
	clc
	adc #$80
	sta P0Bottom

	;--some final setup

    ldx #4
    lda #$80
cycle74_HMCLR
    sta HMP0,X
    dex
    bpl cycle74_HMCLR
;	sta HMCLR

	lda #0
	sta PF1
	sta PF2
	sta GRP0
	sta GRP1

	jsr KernelSetupSubroutine

WaitForVblankEnd
	lda INTIM
	bmi WaitForVblankEnd
    lda #0
	sta WSYNC      
	sta VBLANK	        ;3   3 ;turn off VBLANK - it was turned on by overscan
	sta CXCLR           ;3   6


	jmp KernelRoutine   ;3   9


PositionASpriteSubroutine	;call this function with A == horizontal position (0-159)
				;and X == the object to be positioned (0=P0, 1=P1, 2=M0, etc.)
				;if you do not wish to write to P1 during this function, make
				;sure Y==0 before you call it.  This function will change Y, and A
				;will be the value put into HMxx when returned.
				;Call this function with at least 11 cycles left in the scanline 
				;(jsr + sec + sta WSYNC = 11); it will return 9 cycles
				;into the second scanline
	sec
	sta WSYNC			;begin line 1
	sta.w HMCLR			;+4	 4
DivideBy15Loop
	sbc #15
	bcs DivideBy15Loop			;+4/5	8/13.../58

	tay				;+2	10/15/...60
	lda FineAdjustTableEnd,Y	;+5	15/20/...65

			;	15
	sta HMP0,X	;+4	19/24/...69
	sta RESP0,X	;+4	23/28/33/38/43/48/53/58/63/68/73
	sta WSYNC	;+3	 0	begin line 2
	sta HMOVE	;+3
	rts		;+6	 9

;-------------------------------------------------------------------------

PrePositionAllObjects

	ldx #4
	lda ballx
	jsr PositionASpriteSubroutine
	
	dex
	lda missile1x
	jsr PositionASpriteSubroutine
	
	dex
	lda missile0x
	jsr PositionASpriteSubroutine

	dex
	dex
	lda player0x
	jsr PositionASpriteSubroutine

	rts


;-------------------------------------------------------------------------








;-------------------------------------------------------------------------


KernelSetupSubroutine
    ; go repeat
	lda #0
	sta CTRLPF

	ldx #4
AdjustYValuesUpLoop
	lda NewSpriteY,X
	clc
	adc #2
	sta NewSpriteY,X
	dex
	bpl AdjustYValuesUpLoop


	ldx temp3 ; first sprite displayed

	lda SpriteGfxIndex,x
	tay
	lda NewSpriteY,y
	sta RepoLine

	lda SpriteGfxIndex-1,x
	tay
	lda NewSpriteY,y
	sta temp6

	stx SpriteIndex



	lda #255
	sta P1Bottom

	lda player0y
 ifconst screenheight
	cmp #screenheight+1
 else
	cmp #$59
 endif
	bcc nottoohigh
	lda P0Bottom
	sta P0Top		

       

nottoohigh
	rts

;-------------------------------------------------------------------------





;*************************************************************************

;-------------------------------------------------------------------------
;-------------------------Data Below--------------------------------------
;-------------------------------------------------------------------------

MaskTable
	.byte 1,3,7,15,31

 ; shove 6-digit score routine here

sixdigscore
	lda #0
;	sta COLUBK
	sta PF0
	sta PF1
	sta PF2
	sta ENABL
	sta ENAM0
	sta ENAM1
	;end of kernel here


 ; 6 digit score routine
; lda #0
; sta PF1
; sta PF2
; tax

   sta WSYNC;,x

;                STA WSYNC ;first one, need one more
 sta REFP0
 sta REFP1
                STA GRP0
                STA GRP1
 sta HMCLR

 ; restore P0pointer

	lda player0pointer
	clc
	adc player0y
	sec
	sbc player0height
	sta player0pointer
 inc player0y

 ifconst vblank_time
 ifconst screenheight
 if screenheight == 84
	lda  #vblank_time+9+128+10
 else
	lda  #vblank_time+9+128+19
 endif
 else
	lda  #vblank_time+9+128
 endif
 else
 ifconst screenheight
 if screenheight == 84
	lda  #52+128+10
 else
	lda  #52+128+19
 endif
 else
	lda  #52+128
 endif
 endif

	sta  TIM64T
 ifconst minikernel
 jsr minikernel
 endif
 ifconst noscore
 pla
 pla
 jmp skipscore
 endif

; score pointers contain:
; score1-5: lo1,lo2,lo3,lo4,lo5,lo6
; swap lo2->temp1
; swap lo4->temp3
; swap lo6->temp5

 lda scorepointers+5
 sta temp5
 lda scorepointers+1
 sta temp1
 lda scorepointers+3
 sta temp3

 lda #>scoretable
 sta scorepointers+1
 sta scorepointers+3
 sta scorepointers+5
 sta temp2
 sta temp4
 sta temp6

 rts



;-------------------------------------------------------------------------
;----------------------Kernel Routine-------------------------------------
;-------------------------------------------------------------------------


;-------------------------------------------------------------------------
; repeat $f147-*
; brk
; repend
;	org $F240

SwitchDrawP0K1				;	72
	lda P0Bottom
	sta P0Top			;+6	 2
	jmp BackFromSwitchDrawP0K1	;+3	 5

WaitDrawP0K1				;	74
	SLEEP 4				;+4	 2
	jmp BackFromSwitchDrawP0K1	;+3	 5

SkipDrawP1K1				;	11
	lda #0
	sta GRP1			;+5	16	so Ball gets drawn
	jmp BackFromSkipDrawP1		;+3	19

;-------------------------------------------------------------------------

KernelRoutine
 ifnconst screenheight
    sleep 8
 ; jsr wastetime ; waste 12 cycles
 else
    sleep 2                 ;6   11
 endif
	tsx                     ;2   13
	stx stack1              ;3   16
	ldx #ENABL              ;2   18
	txs			            ;2   20

    ldx #0                  ;2   22
    lda pfheight            ;3   23
    bpl asdhj               ;2   27
    .byte $24
asdhj
    tax                     ;3   30

    lda PFStart,x           ;4   34 ; get pf pixel resolution for heights 15,7,3,1,0

 ifconst screenheight
     sec                    ;2   36
 if screenheight == 84
     sbc pfsub+1,x
 else
     sbc pfsub,x            ;4   40
 endif
 endif
 
    sta pfpixelheight       ;3   43

 ifconst screenheight
    ldy #screenheight       ;2   45
 else
	ldy #88
 endif

KernelLoopA			       
	SLEEP 7			        ;5   52 
KernelLoopB			        
	cpy P0Top		        ;3   55
	beq SwitchDrawP0K1	    ;2	 57
	bpl WaitDrawP0K1	    ;2	 59
	lda (player0pointer),y	;5   64
	sta GRP0	         	;3	 67 VDEL because of repokernel
BackFromSwitchDrawP0K1
	cpy P1Bottom	     	;3   70 unless we mean to draw immediately, this should be set
				            ;       to a value greater than maximum Y value initially
	bcc SkipDrawP1K1	    ;2   72
	lda (P1display),y	    ;5    1
	sta.w GRP1		        ;4    5
BackFromSkipDrawP1

    ; PF no repo
    sty temp1               ;3    8
    ldy pfpixelheight       ;3   11
	ldx PF0DataA,y          ;4   15
	stx PF0			        ;3   18
	ldx PF1DataA,y          ;4   22
	stx PF1			        ;3   25
	lda PF2DataA,y          ;4   29
	sta PF2			        ;3   32
    ldy temp1               ;3   35

	; ball/missile business
    ldx #ENABL              ;2   37
    txs                     ;2   39
	cpy bally               ;3   42
	php	                    ;3   45 VDEL ball
	cpy missile1y           ;3   48
	php                     ;3   51
	cpy missile0y           ;3   54
	php                     ;3   57
	
	dey                     ;2   59

	cpy RepoLine            ;3   62 << orig kernel should be 15
	beq RepoKernel          ;2   64

    ; since we have time here, store next repoline
    ldx SpriteIndex         ;3   67
	bne NextSpriteIndex     ;2   69
	sleep 6                 ;6   75
	lda #255                ;2    1
	jmp SetNextLine         ;3    4
NextSpriteIndex
    lda SpriteGfxIndex-1,x  ;4   74
    tax                     ;2   76
    lda NewSpriteY,x        ;4    4
SetNextLine ; 4
    sta temp6               ;3    7
    sleep 30                ;30  37

BackFromRepoKernel ; 37
	tya                     ;2   39
	and pfheight            ;3   42
	bne KernelLoopA         ;2   44
	dec pfpixelheight       ;5   49
	bpl KernelLoopB         ;2   51
	jmp DoneWithKernel      ;3   54

;-------------------------------------------------------------------------
 
 ; room here for score?
 ; KLUDGE : force 6 digit score to 3-digit with $

setscorepointers
 lax score+2
 jsr scorepointerset
 sty scorepointers+5
 stx scorepointers+2
 lax score+1
 jsr scorepointerset
 ldx #<scoretable + 88
 sty scorepointers+4
 stx scorepointers+1
 ldy #<scoretable + 80
 sty scorepointers+3
 sty scorepointers
wastetime
 rts

scorepointerset
 and #$0F
 asl
 asl
 asl
 adc #<scoretable
 tay
 txa
 and #$F0
 lsr
 adc #<scoretable
 tax
 rts
;	align 256

SwitchDrawP0KR				;	45
	lda P0Bottom
	sta P0Top			;+6	51
	jmp BackFromSwitchDrawP0KR	;+3	54

WaitDrawP0KR                    ; 44
	SLEEP 4                     ;4  48
	jmp BackFromSwitchDrawP0KR	;3  51

;-----------------------------------------------------------

RepoKernel                  ; 65... 66 if crossing page before next line
	tya                     ;2   68
	and pfheight            ;3   71
	bne RepoKernelA         ;2   73
	dec pfpixelheight       ;5    2
    jmp RepoKernelB         ;3    5

RepoKernelA ; 73
	sleep 7                 ;7    5   
RepoKernelB
    cpy P0Top               ;3    8
	beq SwitchDrawP0KR      ;2   10
	bpl WaitDrawP0KR        ;2   12
	lda (player0pointer),Y  ;5   17
	sta GRP0                ;3   20 VDEL
BackFromSwitchDrawP0KR
	lda #0                  ;2   22
	sta GRP1                ;3   25	to display player 0

	ldx SpriteIndex	        ;3   28
	lda SpriteGfxIndex,x    ;4   32
	tax                     ;2   34

	sleep 12                ;12  46 ; push PF setting to right edge

	sty temp1               ;3   49
    ldy pfpixelheight       ;3   52
	lda PF0DataA,y          ;4   56
	sta PF0			        ;3   59
	lda PF1DataA,y          ;4   63
	sta PF1			        ;3   66
	lda PF2DataA,y          ;4   70
	sta PF2			        ;3   73
	ldy temp1               ;3   76 restore y

	; critical: divide loop for P1
	lda NewSpriteX,x        ;4    4
	sec                     ;2    6 ; set carry for Divide loop 
DivideBy15LoopK
	sbc #15
	bcs DivideBy15LoopK      ;+4/5 10/15.../60
	tax				         ;+2   12/17/...62
	lda FineAdjustTableEnd,X ;+5   17/22/...67
	sta HMP1                 ;+3   20/25/...70
	sta RESP1                ;+3   23/28/33/38/43/48/53/58/63/68/73
	sta WSYNC                ;+3   0

	; ball and missile business
	ldx #ENABL               ;2    2
	txs	                     ;2    4
	cpy bally                ;3    7
	php                      ;3   10 VDEL ball
	cpy missile1y            ;3   13
	php                      ;3   16
	cpy missile0y            ;3   19
	php	                     ;3   22
    ; grp0
	dey                      ;2   24

	tya                      ;2   26
	and pfheight             ;3   29
	bne RepoKernelA2         ;2   31
	dec pfpixelheight        ;5   36
    jmp RepoKernelB2         ;3   39

RepoKernelA2
    sleep 7                  ;7   39
RepoKernelB2 ; 39

	cpy P0Top			     ;3	  42
	beq SwitchDrawP0KV       ;2   44
	bpl WaitDrawP0KV         ;2   46
	lda (player0pointer),y   ;5   51
	sta GRP0                 ;3   54 VDEL
BackFromSwitchDrawP0KV

; BUGBUG need to decrement pfpixheight
	sty temp1                ;3   57
    ldy pfpixelheight        ;3   60
	lda PF0DataA,y           ;4   64
	sta PF0			         ;3   67
	lda PF1DataA,y           ;4   71
    sta HMOVE                ;3   74; early HMOVE
	sta PF1			         ;3    1
	lda PF2DataA,y           ;4    5
	sta PF2			         ;3    8
	ldy temp1                ;3   11


	lda #0
	sta GRP1			;+5	10	to display GRP0

	ldx #ENABL
	txs			;+4	 8

	ldx SpriteIndex	;+3	13	restore index into new sprite vars
	;--now, set all new variables and return to main kernel loop


;
	lda SpriteGfxIndex,X	;+4	31
	tax				;+2	33
;



	lda NewNUSIZ,X
	sta NUSIZ1			;+7	20
    sta REFP1
	lda NewCOLUP1,X
	sta COLUP1			;+7	27

;	lda SpriteGfxIndex,X	;+4	31
;	tax				;+2	33
	lda NewSpriteY,X		;+4	46
	sec				;+2	38
	sbc spriteheight,X	;+4	42
	sta P1Bottom		;+3	45

 ;sleep 6
	lda player1pointerlo,X	;+4	49
	sbc P1Bottom		;+3	52	carry should still be set
	sta P1display		;+3	55
	lda player1pointerhi,X
	sta P1display+1		;+7	62


	cpy bally
	php			;+6	68	VDELed

	cpy missile1y
	php			;+6	74

	cpy missile0y
	php			;+6	 4

; lda SpriteGfxIndex-1,x
; sleep 3
	dec SpriteIndex	;+5	13
; tax
; lda NewSpriteY,x
; sta RepoLine

	lda temp6
	sta RepoLine	   ;3   26 

	dey			       ;2   40
    sleep 3
	jmp BackFromRepoKernel	;+3	43


;-------------------------------------------------------------------------


SwitchDrawP0KV				;	69
	lda P0Bottom
	sta P0Top			;+6	75
	jmp BackFromSwitchDrawP0KV	;+3	 2

WaitDrawP0KV				;	71
	SLEEP 4				;+4	75
	jmp BackFromSwitchDrawP0KV	;+3	 2

;-------------------------------------------------------------------------

DoneWithKernel

BottomOfKernelLoop

		sta WSYNC
		ldx stack1
		txs
		jsr sixdigscore ; set up score

		sta WSYNC
		LDA #$00
		sta GRP0
		sta GRP1

		LDY #7
        STy VDELP0
        STy VDELP1
		lda #$d0
		sta HMP0
        LDA #$e0
        STA HMP1
		LDA scorecolor 
		STA COLUP0
		STA COLUP1
 
		STA RESP0
		STA RESP1; ^ up 6
		LDA #$03
        STA NUSIZ0
        STA NUSIZ1

		sleep 8
		lda  (scorepointers),y
		sta  GRP0

		lda  (scorepointers+8),y
		STA HMOVE
		; sta WSYNC
		;sleep 2
		jmp beginscore


loop2
	lda  (scorepointers),y     ;+5  68  204
	sta  GRP0            ;+3  71  213      D1     --      --     --
	sleep 7
	lda  (scorepointers+$8),y  ;+5   5   15
beginscore
	sta  GRP1            ;+3   8   24      D1     D1      D2     --
	lda  (scorepointers+$6),y  ;+5  13   39
	sta  GRP0            ;+3  16   48      D3     D1      D2     D2
	lax  (scorepointers+$2),y  ;+5  29   87
	txs
	lax  (scorepointers+$4),y  ;+5  36  108
	sleep 9
	lda  (scorepointers+$A),y  ;+5  21   63
	stx  GRP1            ;+3  44  132      D3     D3      D4     D2!
	tsx
	stx  GRP0            ;+3  47  141      D5     D3!     D4     D4
	sta  GRP1            ;+3  50  150      D5     D5      D6     D4!
	sty  GRP0            ;+3  53  159      D4*    D5!     D6     D6
	dey
	bpl  loop2           ;+2  60  180
 	ldx stack1
	txs


; lda scorepointers+1
 ldy temp1
; sta temp1
 sty scorepointers+1

                LDA #0   
               STA GRP0
                STA GRP1
 sta PF1 
       STA VDELP0
        STA VDELP1;do we need these
        STA NUSIZ0
        STA NUSIZ1

; lda scorepointers+3
 ldy temp3
; sta temp3
 sty scorepointers+3

; lda scorepointers+5
 ldy temp5
; sta temp5
 sty scorepointers+5


;-------------------------------------------------------------------------
;------------------------Overscan Routine---------------------------------
;-------------------------------------------------------------------------

OverscanRoutine



skipscore
    ifconst qtcontroller
        lda qtcontroller
        lsr    ; bit 0 in carry
        lda #4
        ror    ; carry into top of A
    else
        lda #2
    endif ; qtcontroller
	sta WSYNC
	sta VBLANK	;turn on VBLANK


	


;-------------------------------------------------------------------------
;----------------------------End Main Routines----------------------------
;-------------------------------------------------------------------------


;*************************************************************************

;-------------------------------------------------------------------------
;----------------------Begin Subroutines----------------------------------
;-------------------------------------------------------------------------




KernelCleanupSubroutine

	ldx #4
AdjustYValuesDownLoop
	lda NewSpriteY,X
	sec
	sbc #2
	sta NewSpriteY,X
	dex
	bpl AdjustYValuesDownLoop


 RETURN
	;rts

SetupP1Subroutine
; flickersort algorithm
; count 4-0
; table2=table1 (?)
; detect overlap of sprites in table 2
; if overlap, do regular sort in table2, then place one sprite at top of table 1, decrement # displayed
; if no overlap, do regular sort in table 2 and table 1
fsstart
 ldx #255
copytable
 inx
 lda spritesort,x
 sta SpriteGfxIndex,x
 cpx #4
 bne copytable

 stx temp3 ; highest displayed sprite
 dex
 stx temp2
sortloop
 ldx temp2
 lda spritesort,x
 tax
 lda NewSpriteY,x
 sta temp1

 ldx temp2
 lda spritesort+1,x
 tax
 lda NewSpriteY,x
 sec
 clc
 sbc temp1
 bcc largerXislower

; larger x is higher (A>=temp1)
 cmp spriteheight,x
 bcs countdown
; overlap with x+1>x
; 
; stick x at end of gfxtable, dec counter
overlapping
 dec temp3
 ldx temp2
; inx
 jsr shiftnumbers
 jmp skipswapGfxtable

largerXislower ; (temp1>A)
 tay
 ldx temp2
 lda spritesort,x
 tax
 tya
 eor #$FF
 sbc #1
 bcc overlapping
 cmp spriteheight,x
 bcs notoverlapping

 dec temp3
 ldx temp2
; inx
 jsr shiftnumbers
 jmp skipswapGfxtable 
notoverlapping
; ldx temp2 ; swap display table
; ldy SpriteGfxIndex+1,x
; lda SpriteGfxIndex,x
; sty SpriteGfxIndex,x
; sta SpriteGfxIndex+1,x 

skipswapGfxtable
 ldx temp2 ; swap sort table
 ldy spritesort+1,x
 lda spritesort,x
 sty spritesort,x
 sta spritesort+1,x 

countdown
 dec temp2
 bpl sortloop

checktoohigh
 ldx temp3
 lda SpriteGfxIndex,x
 tax
 lda NewSpriteY,x
 ifconst screenheight
 cmp #screenheight-3
 else
 cmp #$55
 endif
 bcc nonetoohigh
 dec temp3
 bne checktoohigh

nonetoohigh
 rts


shiftnumbers
 ; stick current x at end, shift others down
 ; if x=4: don't do anything
 ; if x=3: swap 3 and 4
 ; if x=2: 2=3, 3=4, 4=2
 ; if x=1: 1=2, 2=3, 3=4, 4=1
 ; if x=0: 0=1, 1=2, 2=3, 3=4, 4=0
; ldy SpriteGfxIndex,x
swaploop
 cpx #4
 beq shiftdone 
 lda SpriteGfxIndex+1,x
 sta SpriteGfxIndex,x
 inx
 jmp swaploop
shiftdone
; sty SpriteGfxIndex,x
 rts

 ifconst debugscore
debugcycles
   ldx #14
   lda INTIM ; display # cycles left in the score

 ifconst mincycles
 lda mincycles 
 cmp INTIM
 lda mincycles
 bcc nochange
 lda INTIM
 sta mincycles
nochange
 endif

;   cmp #$2B
;   bcs no_cycles_left
   bmi cycles_left
   ldx #64
   eor #$ff ;make negative
cycles_left
   stx scorecolor
   and #$7f ; clear sign bit
   tax
   lda scorebcd,x
   sta score+2
   lda scorebcd1,x
   sta score+1
   rts
scorebcd
 .byte $00, $64, $28, $92, $56, $20, $84, $48, $12, $76, $40
 .byte $04, $68, $32, $96, $60, $24, $88, $52, $16, $80, $44
 .byte $08, $72, $36, $00, $64, $28, $92, $56, $20, $84, $48
 .byte $12, $76, $40, $04, $68, $32, $96, $60, $24, $88
scorebcd1
 .byte 0, 0, 1, 1, 2, 3, 3, 4, 5, 5, 6
 .byte 7, 7, 8, 8, 9, $10, $10, $11, $12, $12, $13
 .byte $14, $14, $15, $16, $16, $17, $17, $18, $19, $19, $20
 .byte $21, $21, $22, $23, $23, $24, $24, $25, $26, $26
 endif
