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

NUM_ZONES = 7

; ----------------------------------
; variables

  SEG.U variables

    ORG $80

frame          ds 1 ; フレーム数

; zones
zone_pattern   ds NUM_ZONES ; ゾーンのパターン番号を保存する領域

    SEG

; ----------------------------------
; code

  SEG
    ORG $F000

Reset

    ; do the clean start macro
            CLEAN_START ; メモリとレジスタをクリアするマクロ

            ldx #NUM_ZONES - 1 ; ゾーン数 - 1 分ループするための値を X に入れる
_zone_setup_loop ; ゾーン初期化ループ
            txa ; X -> A
            sta zone_pattern,x ; ゾーン番号を入れる
            dex ; ループカウントを減算
            bpl _zone_setup_loop ; プラスの値なら続ける

newFrame
    ; VSYNC処理
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
; VBLANK処理
            lda #%10000010
            sta VBLANK

            lda #42    ; vblank timer will land us ~ on scanline 34
            sta TIM64T ; 42x64クロック待つ(それが34ライン？) ※スキャンラインあたり76クロックらしい

            inc frame ; new frame

;--------------------
; update


;--------------------
; VBlank end

            ldx #$00
waitOnVBlank            
            cpx INTIM
            bmi waitOnVBlank
            sta WSYNC
            stx VBLANK

;--------------------
; Screen start

            ldx #NUM_ZONES - 1
zone_loop
            ldy zone_pattern,x
            lda PATTERN_BK,y
            sta COLUBK
            lda PATTERN_FG,y
            sta COLUPF
            ldy ZONE_HEIGHTS,x
_intrazone_loop
            sta WSYNC
            ; end zone
            dey
            bpl _intrazone_loop
            ; next zones
            dex
            bpl zone_loop

;--------------------
; Overscan start

            lda #0
            sta COLUBK
            ldx #30
waitOnOverscan
            sta WSYNC
            dex
            bne waitOnOverscan

            jmp newFrame

    ORG $FE00


ZONE_HEIGHTS
    byte 30
    byte 30
    byte 15
    byte 30
    byte 20
    byte 30
    byte 30

PATTERN_BK
    byte GRAY
    byte GREEN_BEIGE
    byte YELLOW
    byte GREEN
    byte GREEN_YELLOW
    byte BLUE_CYAN
    byte BLUE

PATTERN_FG
    byte RED
    byte BLUE
    byte BLACK
    byte YELLOW
    byte GRAY
    byte CYAN_GREEN
    byte CYAN

    ORG $FFFA

    .word Reset          ; NMI
    .word Reset          ; RESET
    .word Reset          ; IRQ

    END