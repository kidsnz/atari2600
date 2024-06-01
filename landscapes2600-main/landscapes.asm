    processor 6502
    include vcs.h
    include macro.h
    include macros.h
    include vcs_extra.h
    include vcs_positioning.h
    include dasm_extra.h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONSTANTS
NUM_COLORS    = 15	; number of indexed colors
NUM_BEHAVIORS = 3

MIN_ZONES   = 4		; minimum # of zones per landscape
MAX_ZONES   = 7		; max # of zones per landscape
MIN_COPIES  = 0		; min copies of object per zone
MAX_COPIES  = 3		; max copies of object per zone
MIN_ZONE_H  = 10		; min height for a zone
MAX_ZONE_H  = 24	; max height for a zone

LINES       = 192	; number of scanlines to draw

OBJ_NOMOVE  = 0		; behavior constant for stationary objects
OBJ_MOVE_R  = 1		; behavior constant for objects that move left to right
OBJ_MOVE_L  = 2		; behavior constant for objects that move right to left
; TODO: behavior 3 undefined

SPRITE_HEIGHT = 8

PLAYER_COLOR  = $a2
PLAYER_HEIGHT = 13

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RAM
    SEG.U RAM
    ORG $80

; system state variables
__STATE_SWCHB ds 1
__STATE_INPT4 ds 1
frame         ds 1	; frame counter (0-255)
rand	      ds 1	; random number value

; ldanscape variables
num_zones      ds 1	; number of zones in the landscape
landscape_data ds 8	; LSB: pixel height/2; MSB: LANDSCAPE_COLORS offset
zone_colors    ds 8	; color value for each zone
objects        ds 8	; object offsets (corresponding to landscape)
obj_colors     ds 8	; colors of each object
obj_data       ds 8	; object data (corresponds to object)
obj_x_pos      ds 8	; positions of each object
obj_speed      ds 8	; hi nybble: speed of object, lo nybble: countdown
obj_frame      ds 8	; low nybble: frame #, hi nybble: # of frames

; player variables
player_x      ds 1	; player's x coordinate
player_y      ds 1	; player's y coordinate
player_orient ds 1	; player's direction (left-0 or right-1)

tmp	      ds 1	; temporary storage
lut	      ds 2	; temporary storage
height        ds 1	; height of sprite during rendering
sprite        ds 2
landscape     ds 1	; ID of active landscape
landscapeadd  ds 1      ; random # to add to landscape colors

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OBJ_DATA
; Object data is stored in the following format
;  - Bits 0-1: number of copies
;  - Bits 2-3: behavior constant
;  - Bit 4: reflection (1 = reflected, 0 = not reflected)
;
;  |----------------------------------------------|
;  |   unused  |     4      |  3 - 2   |   1 - 0  |
;  |----------------------------------------------|
;  |   xxxxxx  |   reflect  | behavior |  copies  |
;  |----------------------------------------------|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CODE
	SEG
	ORG $F000

; NUSIZ0 table
nusiz0_tab:
	.byte $00 ; 1 copy
	.byte $03 ; 2 copies, wide
	.byte $06 ; 3 copies, wide

ZONE_COLORS:
	.byte $0c
	.byte $d8
	.byte $c6
	.byte $d6
	.byte $a4
	.byte $9c
	.byte $ae

	.byte $1a,$2a,$3a,$4a,$5a,$6a,$7a,$8a
	.byte $9a,$aa,$ba,$ca,$da,$ea,$fa

SPRITE_GFX:
	.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

SPRITE_COLORS:
	.byte $14,$24,$34,$44,$54,$64,$74,$84

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	include "sprites.asm"
	include "config.asm"
	include "landscapes_data.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GENZONES
; Generates the zone data for a landscape. This includes:
;  - objects
;  - obj_data
;  - landscape_data
genzones
	jsr random
	and #$03
	clc
	sta landscape

	jsr random
	and #$0f
	sta landscapeadd

	jsr random
	and #MAX_ZONES
	cmp #MIN_ZONES
	bcs .setnum
	lda #MIN_ZONES
.setnum
	ldx #$07
	stx num_zones

.l1
; randomize object's position
	jsr random
	and #$7f
	sta obj_x_pos-1,x

; get the sprite to use for the object
	lda ZoneSpritesLo,x
	sta lut
	lda ZoneSpritesHi,x
	sta lut+1
	lda NumZoneSprites,x
	jsr select_from_lut
	tay			; .Y = sprite ID
	sta objects-1,x

; randomize the color of the object
	lda SpriteColorsLo,y
	sta lut
	lda SpriteColorsHi,y
	sta lut+1
	lda NumColors,y
	jsr select_from_lut
	sta obj_colors-1,x

; randomize size and copies for object
	lda SpriteNUSIZLo,y
	sta lut
	lda SpriteNUSIZHi,y
	sta lut+1
	lda NumNUSIZs,y
	jsr select_from_lut
	sta obj_data-1,x	; set NUSIZ for the object

; OR the behavior
	lda SpriteBehaviorsLo,y
	sta lut
	lda SpriteBehaviorsHi,y
	sta lut+1
	lda NumBehaviors,y
	jsr select_from_lut
	asl
	asl
	ora obj_data-1,x
	sta obj_data-1,x

; randomize the speed for the object
	jsr random
.setspeed
	sta obj_speed-1,x

	dex
	bne .l1			; repeat for each object

	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SELECT FROM LUT
; Selects an object from the look up table in lut and wraps its value so
; that it is in the given range
; IN:
;  lut: the list to select an item from
;  .A: the number of items in the list
; OUT:
;  .A: the selection from the list
select_from_lut
	sta tmp
	tya
	pha
	jsr random
.l0	cmp tmp
	bcc .sel
	sbc tmp
	jmp .l0

.sel	tay
	lda (lut),y
	sta tmp
	pla
	tay
	lda tmp
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RANDOM
; Returns a random value
; OUT:
;  - .A: a random number between 0 and 255
random
	lda rand
	lsr
	bcc .skip
	eor #$B4
.skip	sta rand
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; INIT
; Program entrypoint
init
	CLEAN_START
	lda #50
	sta player_x
	sta player_y
	lda #$00
        sta SWACNT

	LDA #$01|$04	; reflect PF, playfield in front of sprites
	STA CTRLPF

	lda #$ac
	sta rand

	jsr genzones

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MAIN
; Main game loop
main SUBROUTINE main_loop
.vsync
	VSYNC_KERNEL_BASIC
	VBLANK_KERNEL_BASIC
	DISPLAY_KERNEL_SETUP
	inc frame
	ldx num_zones
	dex

.do_zone
	; reset GRP data
	lda #$00
	sta GRP0
	sta GRP1

	; get the color of the zone
	ldy landscape
	lda LandscapeColorsLo,y
	sta tmp
	lda LandscapeColorsHi,y
	sta tmp+1
	txa
	tay
	lda (tmp),y
	clc
	adc landscapeadd
	sta WSYNC
	sta COLUBK

	; position sprites
	lda obj_x_pos,x
	ldy #$00
	jsr move_player_h
	sta WSYNC
	sta HMOVE

	; set NUSIZ according to nusiz table
	lda obj_data,x
	and #$02
	tay
	lda nusiz0_tab,y
	sta NUSIZ0

	; set REFP0 according to sprite's current direction
	lda obj_data,x
	and #$10
	beq .sp_addr
	lda #$08
.sp_addr
	sta REFP0

	; get the address of the sprite data
	ldy objects,x
	lda SpriteGFXLo,y
	sta sprite
	lda SpriteGFXHi,y
	sta sprite+1

	; get sprite's height
	ldy #$00
	lda (sprite),y
	sta height
	inc sprite
	bne .0
	inc sprite+1
.0	inc sprite
	bne .1
	inc sprite+1

.1	; get the pixel height of the zone
	ldy landscape
	lda LandscapeHeightsLo,y
	sta tmp
	lda LandscapeHeightsHi,y
	sta tmp+1
	txa
	tay
	lda (tmp),y
	tay

	lda obj_colors,x
	sta COLUP0
.zoneloop
	cpy height
	bcs .spritesdone	; if sprite isn't visible yet, skip
	lda (sprite),y
	sta GRP0

.spritesdone:
	sta WSYNC
	dey
	bpl .zoneloop

	dex
	bpl .do_zone
	sta WSYNC

	lda #$00
	sta GRP0
	sta NUSIZ0

.check_player
	lda player_x
	ldy #$00
	jsr move_player_h
	sta WSYNC
	sta HMOVE
	lda player_orient
	sta REFP0

	ldy #PLAYER_HEIGHT-1
.player_loop
	sta WSYNC
	lda player_colors,y
	sta COLUP0
	lda PLAYER_GFX,y
	sta GRP0
	dey
	bpl .player_loop

	; clear sprite state
	lda #$00
	sta GRP0
	sta GRP1
	sta REFP0

;--------------------------------------
; post-render game logic
;--------------------------------------
	jsr read_joy

; update sprite frames
	lda frame
	cmp #100
	bne behaviors
frames
	ldx num_zones
.frameloop
	lda obj_frame-1,x
	and #$f0
	cmp #$80
	beq .next		; if only 1 frame, skip
	lsr
	lsr
	lsr
	lsr
	sta tmp

	ldy obj_frame-1,x
	iny
	cpy tmp
	bcc .advance

	ldy #$00		; reset frame #
.advance
	sty tmp
	lda obj_frame-1,x
	and #$f0
	ora tmp
	sta obj_frame-1,x
.next	dex
	bne .frameloop

behaviors
; update sprite positions
	ldx num_zones
.behaviorloop
	lda obj_speed-1,x
	and #$0f
	dey
	tya
	sta obj_speed-1,x
	beq .update

.update
	lda frame
	and #$01
	beq .overscan
	; reset countdown
	lda obj_speed-1,x
	lsr
	lsr
	lsr
	lsr
	ora obj_speed-1,x
	sta obj_speed-1,x

	; get the behavior of the sprite from its obj_data
	lda obj_data-1,x
	and #$0c
	beq .next_behavior	; 0 = stationary
	cmp #(1 << 2)
	bne .move_left
.move_right
	lda #$7f
	and obj_data-1,x	; reflection off
	sta obj_data-1,x

	inc obj_x_pos-1,x
	lda obj_x_pos-1,x
	cmp #160
	bcc .next_behavior
	lda #$00
	sta obj_x_pos-1,x
	beq .next_behavior
.move_left
	lda #$10		; reflection on
	ora obj_data-1,x
	sta obj_data-1,x

	dec obj_x_pos-1,x
	bne .next_behavior
	lda #159
	sta obj_x_pos-1,x
.next_behavior
	dex
	bne .behaviorloop

.overscan
	DISPLAY_KERNEL_END
	OVERSCAN_KERNEL_BASIC
	jmp .vsync

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; READ_JOY
; Reads the joystick and updates player position
read_joy
.left
	lda SWCHA
	and #$40 ; was the joystick moved left?
	bne .right
	dec player_x
	bne .orientate_l

	lda #159
	sta player_x
	jsr genzones
	jmp .done

.orientate_l
	lda #$08
	sta player_orient
.right
	lda SWCHA
	and #$80
	bne .up
	inc player_x
	lda player_x
	cmp #160
	bcc .orientate_r

	lda #$00
	sta player_x
	jsr genzones
	jmp .done

.orientate_r
	lda #$00
	sta player_orient
.up
	lda SWCHA
	and #$20
	bne .down
	dec player_y
.down
	lda SWCHA
	and #$10
	bne .done
	inc player_y
.done
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MOVE_H
move_player_h
SetHorizPos
	cmp #135
	bcs .cont	; will take >1 scanline if > 134
	sta WSYNC
.cont
	cpy #2
	adc #0
	sec		; set carry flag
	sta WSYNC	; start a new line
.l0
	sbc #15		; subtract 15
	bcs .l0		; branch until negative
	eor #7		; calculate fine offset
	asl
	asl
	asl
	asl
	sta.a HMP0,y	; set fine offset
	sta RESP0,y	; fix coarse position
	rts

move_player2_h
	sta WSYNC	; start a new line
	bit 0		; waste 3 cycles
	sec		; set carry flag
.l1
	sbc #15		; subtract 15
	bcs .l1		; branch until negative
	eor #7		; calculate fine offset
	asl
	asl
	asl
	asl
	sta RESP1	; fix coarse position
	sta HMP1	; set fine offset

	sta WSYNC
	sta HMOVE
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DATA
player_sprite:
	.byte $ff
	.byte $ff
	.byte $ff
	.byte $ff
	.byte $ff
	.byte $ff
	.byte $ff
	.byte $ff
player_colors:
	.byte $16
	.byte $26
	.byte $36
	.byte $46
	.byte $56
	.byte $66
	.byte $76
	.byte $86

; player sprite
PLAYER_GFX:
	.byte %10001010
	.byte %01000100
	.byte %10100100
	.byte %01101110
	.byte %11011110
	.byte %00111110
	.byte %11110100
	.byte %00010100
	.byte %11101111
	.byte %00001010
	.byte %00001100
	.byte %00001000
	.byte %00010100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 6502 Vectors
	ORG $FFFA
	.word init	; NMI
	.word init	; RESET
	.word init	; IRQ
