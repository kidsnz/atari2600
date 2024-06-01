;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; behavior ID's
OBJ_NOMOVE = 0
OBJ_MOVE_R = 1
OBJ_MOVE_L = 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sprite ID's
BEAR       = 0
SNAKE      = 1
LYNX       = 2
DEER       = 3
BIRD       = 4
FISH       = 5
TREE1      = 6
TREE2      = 7
TREE3      = 8
HOUSE      = 9
BUILDING1  = 10
BUILDING2  = 11
APPLE      = 12
NONE       = $ff

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZONE SPRITE TABLES
Zone0Sprites
	.byte BUILDING1, BUILDING2, HOUSE
Zone1Sprites
	.byte BUILDING1, BUILDING2, HOUSE
Zone2Sprites
	.byte BUILDING1, BUILDING2, HOUSE
Zone3Sprites
	.byte BUILDING1, HOUSE, TREE1, TREE2, APPLE, SNAKE
Zone4Sprites
	.byte TREE2,BEAR,TREE1,TREE3
Zone5Sprites
	.byte TREE1, TREE2, TREE3, BEAR
Zone6Sprites
	.byte BIRD
Zone7Sprites
	.byte BIRD
Zone8Sprites
	.byte BIRD
ZoneSpritesEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; BEHAVIOR LISTS
; To make one behavior more common, put it into the list more times.
; e.g.
;  .byte OBJ_NOMOVE, OBJ_NOMOVE, MOVE_LEFT
SpriteBehaviors
Sprite0Behaviors		; bear
	.byte OBJ_MOVE_L, OBJ_MOVE_R
Sprite1Behaviors		; snake
	.byte OBJ_MOVE_L, OBJ_MOVE_R
Sprite2Behaviors		; lynx
	.byte OBJ_MOVE_L, OBJ_MOVE_R
Sprite3Behaviors		; deer
	.byte OBJ_MOVE_L, OBJ_MOVE_R
Sprite4Behaviors		; bird
	.byte OBJ_MOVE_L, OBJ_MOVE_R
Sprite5Behaviors		; fish
	.byte OBJ_MOVE_L, OBJ_MOVE_R
Sprite6Behaviors		; tree 1
	.byte OBJ_NOMOVE
Sprite7Behaviors		; tree 2
	.byte OBJ_NOMOVE
Sprite8Behaviors		; tree 3
	.byte OBJ_NOMOVE
Sprite9Behaviors		; house
	.byte OBJ_NOMOVE
Sprite10Behaviors		; building 1
	.byte OBJ_NOMOVE
Sprite11Behaviors		; building 2
	.byte OBJ_NOMOVE
Sprite12Behaviors		; apple
	.byte OBJ_NOMOVE
SpriteBehaviorsEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SPRITE COLORS LISTS
SpriteColors
Sprite0Colors		; bear
	.byte $e2,$e0
Sprite1Colors		; snake
	.byte $b0,$fa,$ca
Sprite2Colors		; lynx
	.byte $f8,$ea,$fc
Sprite3Colors		; deer
	.byte $fe
Sprite4Colors		; bird
	.byte $1a,$2a
Sprite5Colors		; fish
	.byte $7c,$5a,$3a
Sprite6Colors		; tree 1
	.byte $ba
Sprite7Colors		; tree 2
	.byte $bc
Sprite8Colors		; tree 3
	.byte $1a,$2a
Sprite9Colors		; house
	.byte $e4
Sprite10Colors		; building 1
	.byte $12,06
Sprite11Colors		; building 2
	.byte $04,14
Sprite12Colors		; APPLE
	.byte $36
SpriteColorsEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NUSIZ LISTS
; Each list contains the possible "NUSIZ" values for each sprite
; To make one NUSIZ value more common, add it to the list multiple times
SpriteNUSIZ
	.byte 0
Sprite0NUSIZ
	.byte 0
Sprite1NUSIZ
	.byte 0
Sprite2NUSIZ
	.byte 0
Sprite3NUSIZ
	.byte 0
Sprite4NUSIZ
	.byte 0
Sprite5NUSIZ
	.byte 0
Sprite6NUSIZ
	.byte 0
Sprite7NUSIZ
	.byte 0
Sprite8NUSIZ
	.byte 0
Sprite9NUSIZ
	.byte 0
Sprite10NUSIZ
	.byte 0
Sprite11NUSIZ
	.byte 0
Sprite12NUSIZ
	.byte 0
SpriteNUSIZEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; addresses of each sprites's graphics data
; there are 4 tables that each sprite ID corresponds to:
;  - graphics (the sprite graphic data)
;  - behaviors (the ways the sprites may move)
;  - colors (the possible colors for the sprite)
;  - NUSIZ (the # of and size of the sprites)
	MAC SPRITE_GFX_VECTORS
		.byte {1}GFX_Bear
		.byte {1}GFX_Snake
		.byte {1}GFX_Lynx
		.byte {1}GFX_Deer01
		.byte {1}GFX_Bird
		.byte {1}GFX_Fish01
		.byte {1}GFX_Tree1
		.byte {1}GFX_Tree2
		.byte {1}GFX_Tree3
		.byte {1}GFX_House
		.byte {1}GFX_Building1
		.byte {1}GFX_Building2
		.byte {1}GFX_Apple
	ENDM

; addresses of each sprite's behavior list
	MAC BEHAVIOR_VECTORS
		; usage : {1} is < or >
		.byte {1} Sprite0Behaviors
		.byte {1} Sprite1Behaviors
		.byte {1} Sprite2Behaviors
		.byte {1} Sprite3Behaviors
		.byte {1} Sprite4Behaviors
		.byte {1} Sprite5Behaviors
		.byte {1} Sprite6Behaviors
		.byte {1} Sprite7Behaviors
		.byte {1} Sprite8Behaviors
		.byte {1} Sprite9Behaviors
		.byte {1} Sprite10Behaviors
		.byte {1} Sprite11Behaviors
		.byte {1} Sprite12Behaviors
	ENDM

; addresses of each sprite's color list
	MAC SPRITE_COLOR_VECTORS
		; usage : {1} is < or >
		.byte {1} Sprite0Colors
		.byte {1} Sprite1Colors
		.byte {1} Sprite2Colors
		.byte {1} Sprite3Colors
		.byte {1} Sprite4Colors
		.byte {1} Sprite5Colors
		.byte {1} Sprite6Colors
		.byte {1} Sprite7Colors
		.byte {1} Sprite8Colors
		.byte {1} Sprite9Colors
		.byte {1} Sprite10Colors
		.byte {1} Sprite11Colors
		.byte {1} Sprite12Colors
	ENDM

; addresses of each sprite's NUSIZ list
	MAC SPRITE_NUSIZ_VECTORS
		; usage : {1} is < or >
		.byte {1} Sprite0NUSIZ
		.byte {1} Sprite1NUSIZ
		.byte {1} Sprite2NUSIZ
		.byte {1} Sprite3NUSIZ
		.byte {1} Sprite4NUSIZ
		.byte {1} Sprite5NUSIZ
		.byte {1} Sprite6NUSIZ
		.byte {1} Sprite7NUSIZ
		.byte {1} Sprite8NUSIZ
		.byte {1} Sprite9NUSIZ
		.byte {1} Sprite10NUSIZ
		.byte {1} Sprite11NUSIZ
		.byte {1} Sprite12NUSIZ
	ENDM


; addresses of each zone's sprite table
	MAC SPRITE_VECTORS
		; usage : {1} is < or >
		.byte {1} Zone0Sprites
		.byte {1} Zone1Sprites
		.byte {1} Zone2Sprites
		.byte {1} Zone3Sprites
		.byte {1} Zone4Sprites
		.byte {1} Zone5Sprites
		.byte {1} Zone6Sprites
		.byte {1} Zone7Sprites
		.byte {1} Zone8Sprites
	ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; edit only upon adding or removing a sprite
NumZoneSprites
	.byte Zone1Sprites-Zone0Sprites
	.byte Zone2Sprites-Zone1Sprites
	.byte Zone3Sprites-Zone2Sprites
	.byte Zone4Sprites-Zone3Sprites
	.byte Zone5Sprites-Zone4Sprites
	.byte Zone6Sprites-Zone5Sprites
	.byte Zone7Sprites-Zone6Sprites
	.byte Zone8Sprites-Zone7Sprites
	.byte ZoneSpritesEnd-Zone8Sprites

NumBehaviors
	.byte Sprite1Behaviors-Sprite0Behaviors
	.byte Sprite2Behaviors-Sprite1Behaviors
	.byte Sprite3Behaviors-Sprite2Behaviors
	.byte Sprite4Behaviors-Sprite3Behaviors
	.byte Sprite5Behaviors-Sprite4Behaviors
	.byte Sprite6Behaviors-Sprite5Behaviors
	.byte Sprite7Behaviors-Sprite6Behaviors
	.byte Sprite8Behaviors-Sprite7Behaviors
	.byte Sprite9Behaviors-Sprite8Behaviors
	.byte Sprite10Behaviors-Sprite9Behaviors
	.byte Sprite11Behaviors-Sprite10Behaviors
	.byte Sprite12Behaviors-Sprite11Behaviors
	.byte SpriteBehaviorsEnd-Sprite12Behaviors

NumNUSIZs
	.byte Sprite1NUSIZ-Sprite0NUSIZ
	.byte Sprite2NUSIZ-Sprite1NUSIZ
	.byte Sprite3NUSIZ-Sprite2NUSIZ
	.byte Sprite4NUSIZ-Sprite3NUSIZ
	.byte Sprite5NUSIZ-Sprite4NUSIZ
	.byte Sprite6NUSIZ-Sprite5NUSIZ
	.byte Sprite7NUSIZ-Sprite6NUSIZ
	.byte Sprite8NUSIZ-Sprite7NUSIZ
	.byte Sprite9NUSIZ-Sprite8NUSIZ
	.byte Sprite10NUSIZ-Sprite9NUSIZ
	.byte Sprite11NUSIZ-Sprite10NUSIZ
	.byte Sprite12NUSIZ-Sprite11NUSIZ
	.byte SpriteNUSIZEnd-Sprite12NUSIZ

NumColors
	.byte Sprite1Colors-Sprite0Colors
	.byte Sprite2Colors-Sprite1Colors
	.byte Sprite3Colors-Sprite2Colors
	.byte Sprite4Colors-Sprite3Colors
	.byte Sprite5Colors-Sprite4Colors
	.byte Sprite6Colors-Sprite5Colors
	.byte Sprite7Colors-Sprite6Colors
	.byte Sprite8Colors-Sprite7Colors
	.byte Sprite9Colors-Sprite8Colors
	.byte Sprite10Colors-Sprite9Colors
	.byte Sprite11Colors-Sprite10Colors
	.byte Sprite12Colors-Sprite11Colors
	.byte SpriteColorsEnd-Sprite12Colors


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DO NOT EDIT
ZoneSpritesLo SPRITE_VECTORS <
ZoneSpritesHi SPRITE_VECTORS >

SpriteBehaviorsLo BEHAVIOR_VECTORS <
SpriteBehaviorsHi BEHAVIOR_VECTORS >

SpriteGFXLo SPRITE_GFX_VECTORS <
SpriteGFXHi SPRITE_GFX_VECTORS >

SpriteColorsLo SPRITE_COLOR_VECTORS <
SpriteColorsHi SPRITE_COLOR_VECTORS >

SpriteNUSIZLo SPRITE_NUSIZ_VECTORS <
SpriteNUSIZHi SPRITE_NUSIZ_VECTORS >
