    processor 6502
    include "vcs.h"
    include "macro.h"

NTSC = 0
PAL60 = 1

    IFNCONST SYSTEM
SYSTEM = NTSC
    ENDIF

; ----------------------------------
; constants

#if SYSTEM = NTSC
; NTSC Colors
BLACK            = $00
GRAY             = $08
WHITE            = $0f
YELLOW           = $10
BROWN            = $20
ORANGE           = $30
RED              = $40
MAUVE            = $50
VIOLET           = $60
PURPLE           = $70
BLUE             = $80
BLUE_CYAN        = $90
CYAN             = $a0
CYAN_GREEN       = $b0
GREEN            = $c0
GREEN_YELLOW     = $d0
GREEN_BEIGE      = $e0
BEIGE            = $f0
#else
; PAL Colors BUGBUG: fix
BLACK            = $00
GRAY             = $08
WHITE            = $0f
YELLOW           = $10
BROWN            = $20
ORANGE           = $30
RED              = $40
MAUVE            = $50
VIOLET           = $60
PURPLE           = $70
BLUE             = $80
BLUE_CYAN        = $90
CYAN             = $a0
CYAN_GREEN       = $b0
GREEN            = $c0
GREEN_YELLOW     = $d0
GREEN_BEIGE      = $e0
BEIGE            = $f0
#endif

NUM_ZONES = 10

; ----------------------------------
; variables

  SEG.U variables

    ORG $80

frame          ds 1 

; zones
zone_pattern   ds NUM_ZONES
player0_x      ds NUM_ZONES
player0_y      ds NUM_ZONES
player0_tile   ds NUM_ZONES
player1_x      ds NUM_ZONES
player1_y      ds NUM_ZONES
player1_tile   ds NUM_ZONES

dl_zone_index  ds 1
dl_line_index  ds 1
dl_grp0_index  ds 1
dl_grp1_index  ds 1
dl_grp0_delay  ds 1
dl_grp1_delay  ds 1
dl_grp0_addr   ds 2
dl_grp1_addr   ds 2
dl_colp0_addr  ds 2
dl_colp1_addr  ds 2

; ----------------------------------
; code

  SEG
    ORG $F000

Reset

    ; do the clean start macro
            CLEAN_START

            ldx #NUM_ZONES - 1
_zone_setup_loop
            txa
            sta zone_pattern,x
            asl
            sta player0_x,x
            asl
            sta player1_x,x
            dex
            bpl _zone_setup_loop

newFrame

    ; 3 scanlines of vertical sync signal to follow

`           lda #0
            ldx #%00000010
            stx VSYNC               ; turn ON VSYNC bit 1

            sta WSYNC               ; wait a scanline
            sta WSYNC               ; another
            sta WSYNC               ; another = 3 lines total

            sta VSYNC               ; turn OFF VSYNC bit 1

    ; 37 scanlines of vertical blank to follow

;--------------------
; VBlank start

            lda #%10000010
            sta VBLANK

            lda #42    ; vblank timer will land us ~ on scanline 34
            sta TIM64T

            inc frame ; new frame

;--------------------
; update

            ldx #NUM_ZONES - 1
_zone_update_loop
            lda player0_x,x
            clc
            adc #1
            and #$7f
            sta player0_x,x
            lda player1_x,x
            sec
            sbc #1
            and #$7f
            sta player1_x,x
            lda frame
            lsr
            lsr
            lsr
            and #3
            clc
            adc #SPRITE_HEIGHT
            sta player0_y,x
            sta player1_y,x
            dex
            bpl _zone_update_loop

;--------------------
; VBlank end

            ldx #$00
waitOnVBlank            
            cpx INTIM
            bmi waitOnVBlank
            sta WSYNC
            stx VBLANK
            jmp zones

;--------------------
; Screen start

    align 256

zones
            ldx #NUM_ZONES - 1
zone_loop
            stx dl_zone_index
            ldy zone_pattern,x
            ; BKGND
            lda PATTERN_BK,y         ;4
            sta COLUBK               ;3
            lda PATTERN_FG,y         ;4
            sta COLUPF               ;3
            lda #0                   ;2  
            sta GRP0
            sta GRP1
            sta dl_grp0_delay        ;3  
            sta dl_grp1_delay        ;3  
            lda player0_y,x          ;4  
            sta dl_grp0_index        ;3  
            lda player1_y,x          ;4  
            sta dl_grp1_index        ;3  
            ; LOCATE PLAYER 0
            sta WSYNC                ;-
            lda player0_x,x          ;4   4
            sec                      ;2   6
_zone_resp0
            sbc #15                  ;2   8
            sbcs _zone_resp0         ;2* 10
            tay                      ;2  12
            lda LOOKUP_STD_HMOVE,y   ;4  16
            sta HMP0                 ;3  19
            sta RESP0                ;3  22

            ; LOCATE PLAYER 1
            sta WSYNC
            lda player1_x,x
            sec
_zone_resp1
            sbc #15
            sbcs _zone_resp1
            tay 
            lda LOOKUP_STD_HMOVE,y
            sta HMP1
            sta RESP1

            sta WSYNC             ;-
            ; PLAYER 0 GX
            ldy player0_tile,x    ;4   4
            lda TILE_SPRITE_LO,y  ;4   8
            sta dl_grp0_addr      ;3  11
            lda TILE_SPRITE_HI,y  ;4  15
            sta dl_grp0_addr+1    ;3  18
            lda TILE_COLOR_LO,y   ;4  22
            sta dl_colp0_addr     ;3  25
            lda TILE_COLOR_HI,y   ;4  29
            sta dl_colp0_addr+1   ;3  32
            ; PLAYER 1 GX
            ldy player1_tile,x    ;4  36
            lda TILE_SPRITE_LO,y  ;4  40
            sta dl_grp1_addr      ;3  43
            lda TILE_SPRITE_HI,y  ;4  47
            sta dl_grp1_addr+1    ;3  50
            lda TILE_COLOR_LO,y   ;4  54
            sta dl_colp1_addr     ;3  57
            lda TILE_COLOR_HI,y   ;4  61
            sta dl_colp1_addr+1   ;3  64
            lda ZONE_HEIGHTS,x    ;4  68
            tax                   ;2  70
            sta HMOVE             ;3  73
_zone_inner_loop
            sta WSYNC
            lda dl_grp0_delay
            sta GRP0
            lda dl_grp1_delay
            sta GRP1

            GX_GRPX 0,dl_grp0_delay,COLUP0
            GX_GRPX 1,dl_grp1_delay,COLUP1

            ; end zone
            dex
            bpl _zone_inner_loop
GX_LEN = . - _zone_inner_loop
            ; next zones
            ldx dl_zone_index
            dex
            bmi overscan
            jmp zone_loop

;--------------------
; Overscan start

overscan
            lda #0
            sta COLUBK
            sta GRP0
            sta GRP1
            ldx #30
waitOnOverscan
            sta WSYNC
            dex
            bne waitOnOverscan

            jmp newFrame

;--------------------
; Graphics draw routine

    ; save player graphics to designated register
    MAC GX_GRPX ;25/27
            ldy dl_grp{1}_index     ;3   3
            lda (dl_grp{1}_addr),y  ;5   8 ; we load a here to keep timing more stable
            cpy #SPRITE_HEIGHT      ;2  10
            bcs .sub_gx_player_no   ;2* 12
            sta {2}                 ;3  15
.sub_gx_player_no
            lda (dl_colp{1}_addr),y ;4  17/19
            sta {3}                 ;3  20/22
            dey                     ;2  22/24
            sty dl_grp{1}_index     ;3  25/27
    ENDM

    ORG $FE00

STD_HMOVE_BEGIN
    byte $80, $70, $60, $50, $40, $30, $20, $10, $00, $f0, $e0, $d0, $c0, $b0, $a0, $90
STD_HMOVE_END
LOOKUP_STD_HMOVE = STD_HMOVE_END - 256

ZONE_HEIGHTS
    byte 15
    byte 12
    byte 15
    byte 15
    byte 15
    byte 15
    byte 12
    byte 12
    byte 12
    byte 20

PATTERN_BK
    byte GRAY
    byte GREEN_BEIGE
    byte YELLOW
    byte GREEN
    byte GREEN_YELLOW
    byte BLUE_CYAN
    byte BLUE
    byte BLUE
    byte BLUE
    byte BLUE

PATTERN_FG
    byte RED
    byte BLUE
    byte BLACK
    byte YELLOW
    byte GRAY
    byte CYAN_GREEN
    byte CYAN
    byte CYAN
    byte CYAN
    byte CYAN

SPRITE_0
    byte %00000000
    byte %00111100
    byte %00011000
    byte %00011000
    byte %01111110
    byte %10011001
    byte %10011001
    byte %11011011
SPRITE_HEIGHT = . - SPRITE_0

SPRITE_COLOR_0
    byte RED
    byte RED
    byte RED
    byte RED
    byte RED
    byte RED
    byte RED
    byte RED

TILE_SPRITE_LO
    byte #<SPRITE_0

TILE_SPRITE_HI
    byte #>SPRITE_0

TILE_COLOR_LO
    byte #<SPRITE_COLOR_0

TILE_COLOR_HI
    byte #>SPRITE_COLOR_0

    ORG $FFFA

    .word Reset          ; NMI
    .word Reset          ; RESET
    .word Reset          ; IRQ

    END