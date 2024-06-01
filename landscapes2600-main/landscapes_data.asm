NumLandscapes = 5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LANDSCAPE 0
LS_Heights
	.byte 17
	.byte 21
	.byte 21
	.byte 20
	.byte 19
	.byte 10
	.byte 9
LS0_Colors
	.byte $0c
	.byte $d8
	.byte $c6
	.byte $d6
	.byte $a4
	.byte $9c
	.byte $ae

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LANDSCAPE 1
LS1_Colors
	.byte $1c
	.byte $22
	.byte $44
	.byte $32
	.byte $44
	.byte $3c
	.byte $19

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LANDSCAPE 2
LS2_Colors
	.byte $4c
	.byte $72
	.byte $54
	.byte $92
	.byte $84
	.byte $2c
	.byte $f9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LANDSCAPE 3
LS3_Colors
	.byte $8c
	.byte $92
	.byte $a4
	.byte $b2
	.byte $34
	.byte $4c
	.byte $59

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LANDSCAPE 4
LS4_Colors
	.byte $9c
	.byte $a3
	.byte $b4
	.byte $c2
	.byte $44
	.byte $5c
	.byte $69

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LANDSCAPE 5
LS5_Colors
	.byte $2c
	.byte $42
	.byte $54
	.byte $62
	.byte $14
	.byte $2c
	.byte $49

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MAC LANDSCAPE_COLOR_VECTORS
		; usage : {1} is < or >
		.byte {1} LS0_Colors
		.byte {1} LS1_Colors
		.byte {1} LS2_Colors
		.byte {1} LS3_Colors
		.byte {1} LS4_Colors
		.byte {1} LS5_Colors
	ENDM

	MAC LANDSCAPE_HEIGHT_VECTORS
		; usage : {1} is < or >
		.byte {1} LS_Heights
		.byte {1} LS_Heights
		.byte {1} LS_Heights
		.byte {1} LS_Heights
		.byte {1} LS_Heights
		.byte {1} LS_Heights
	ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LandscapeColorsLo LANDSCAPE_COLOR_VECTORS <
LandscapeColorsHi LANDSCAPE_COLOR_VECTORS >

LandscapeHeightsLo LANDSCAPE_HEIGHT_VECTORS <
LandscapeHeightsHi LANDSCAPE_HEIGHT_VECTORS >

