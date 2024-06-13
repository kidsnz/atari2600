    processor 6502

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; インクルード文
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    include "vcs.h"
    include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; マクロ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
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

NUM_ZONES        = #5
ZONE_HEIGHT      = #33
ROAD_ZONE_HEIGHT = #58

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg.u Variables
    org $80

FrameCounter byte     ; フレームカウンタ
RandomCounter byte    ; 乱数カウンタ
RandomValue byte      ; 乱数
CurrentZoneIndex byte ; ゾーン番号
Zone1AddrLow byte     ; 1つめのゾーンの下位バイト
Zone1AddrHigh byte    ; 1つめのゾーンの上位バイト
Zone2AddrLow byte     ; 2つめのゾーンの下位バイト
Zone2AddrHigh byte    ; 2つめのゾーンの上位バイト
Zone3AddrLow byte     ; 3つめのゾーンの下位バイト
Zone3AddrHigh byte    ; 3つめのゾーンの上位バイト
Zone4AddrLow byte     ; 4つめのゾーンの下位バイト
Zone4AddrHigh byte    ; 4つめのゾーンの上位バイト

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プログラム
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    seg Code
    org $F000

Reset:
    CLEAN_START ; メモリとレジスタをクリアするマクロ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 初期化
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;s
    
    lda #0
    sta FrameCounter
    sta RandomCounter
    sta RandomValue

    lda #<SkyZone
    sta Zone1AddrLow
    lda #>SkyZone
    sta Zone1AddrHigh

    lda #<SeaZone
    sta Zone2AddrLow
    lda #>SeaZone
    sta Zone2AddrHigh

    lda #<SandZone
    sta Zone3AddrLow
    lda #>SandZone
    sta Zone3AddrHigh
    
    lda #<GrasslandZone
    sta Zone4AddrLow
    lda #>GrasslandZone
    sta Zone4AddrHigh

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartFrame:
    inc FrameCounter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  垂直同期前
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    sta WSYNC ; 水平同期を待つ
    sta HMOVE ; 水平位置を反映する

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 垂直同期の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #%00000010
    sta VSYNC
    REPEAT 3
        sta WSYNC
    REPEND
    lda #%00000000
    sta VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 垂直ブランクの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #%00000010
    sta VBLANK
    REPEAT 37
        sta WSYNC
    REPEND
    lda #%00000000
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ゾーンの描画処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #0
    sta CurrentZoneIndex
    
.ZoneLoop
    lda CurrentZoneIndex
    cmp #0
    beq .JmpZone1
    cmp #1
    beq .JmpZone2
    cmp #2
    beq .JmpZone3
    cmp #3
    beq .JmpZone4
    cmp #4
    jmp RoadZone
.JmpZone1
    jmp (Zone1AddrLow)
.JmpZone2
    jmp (Zone2AddrLow)
.JmpZone3
    jmp (Zone3AddrLow)
.JmpZone4
    jmp (Zone4AddrLow)
.ZoneEnd
    sta WSYNC
    inc CurrentZoneIndex
    lda CurrentZoneIndex
    cmp #NUM_ZONES
    bmi .ZoneLoop
.ZoneLoopEnd
    lda BLACK
    sta COLUBK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; オーバースキャン中の処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    sta WSYNC
    lda #%00000010
    sta VBLANK
    REPEAT 30
        sta WSYNC
    REPEND
    lda #%00000000
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ジョイスティックの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveJoystick:
    lda #%00010000
    bit SWCHA
    bne SkipMoveUp
    jsr NextRandomValue
SkipMoveUp:
    lda #%00100000
    bit SWCHA
    bne SkipMoveDown
    jsr PrevRandomValue
SkipMoveDown:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの終了処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    jmp StartFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ゾーンの描画命令郡
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 空ゾーン
SkyZone:
    sta WSYNC
    lda #BLUE_CYAN
    sta COLUBK
    ldx #ZONE_HEIGHT-1
.SkyZoneLoop
    sta WSYNC
    dex
    bpl .SkyZoneLoop
    jmp .ZoneEnd
    
; 海ゾーン
SeaZone:
    sta WSYNC
    lda #BLUE
    sta COLUBK
    ldx #ZONE_HEIGHT-1
.SeaZoneLoop
    sta WSYNC
    dex
    bpl .SeaZoneLoop
    jmp .ZoneEnd

; 砂ゾーン
SandZone:
    sta WSYNC
    lda #BEIGE
    sta COLUBK
    ldx #ZONE_HEIGHT-1
.SandZoneLoop
    sta WSYNC
    dex
    bpl .SandZoneLoop
    jmp .ZoneEnd

; 草原ゾーン
GrasslandZone:
    sta WSYNC
    lda #GREEN
    sta COLUBK
    ldx #ZONE_HEIGHT-1
.GrasslandZoneLoop
    sta WSYNC
    dex
    bpl .GrasslandZoneLoop
    jmp .ZoneEnd
    
; 道ゾーン
RoadZone:
    ;lda #%01010000
    ;sta PF0
    ;lda #%10101010
    ;sta PF1
    ;lda #%01010101
    ;sta PF2
    ;lda #YELLOW
    ;sta COLUPF
    sta WSYNC
    lda #GRAY
    sta COLUBK
    ldx #ROAD_ZONE_HEIGHT-1
.RoadZoneLoop
    sta WSYNC
    dex
    bpl .RoadZoneLoop
    ;lda #0
    ;sta PF0
    ;sta PF1
    ;sta PF2
    jmp .ZoneEnd
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ジョイスティックの操作によって機体の座標を動かすサブルーチン群
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; サブルーチン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 次の乱数値をセットする
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NextRandomValue subroutine
    inc RandomCounter
    ldx RandomCounter
    lda RandomTable,X
    sta RandomValue
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 前の乱数値をセットする
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrevRandomValue subroutine
    dec RandomCounter
    ldx RandomCounter
    lda RandomTable,X
    sta RandomValue
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; データ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 乱数テーブル
RandomTable:
    .byte $24, $3A, $0D, $C3, $56, $AF, $4E, $97
    .byte $1C, $78, $FA, $D5, $09, $B2, $6E, $8C
    .byte $3F, $40, $B9, $E6, $2D, $51, $A8, $C7
    .byte $15, $67, $EB, $90, $22, $4F, $BD, $73
    .byte $11, $AD, $5C, $84, $29, $D2, $38, $FF
    .byte $43, $B6, $7A, $09, $E1, $53, $DC, $16
    .byte $64, $F3, $8B, $27, $59, $C4, $0A, $E7
    .byte $35, $6A, $D1, $8F, $48, $B0, $23, $CA
    .byte $54, $AB, $3B, $9D, $F0, $28, $71, $E2
    .byte $0E, $95, $42, $BA, $69, $1F, $D3, $4C
    .byte $A4, $58, $31, $FB, $80, $17, $EE, $62
    .byte $5A, $C1, $29, $93, $47, $DB, $7F, $B2
    .byte $38, $ED, $5E, $A6, $1B, $C9, $74, $02
    .byte $6D, $8A, $F4, $51, $14, $BC, $3E, $97
    .byte $25, $CB, $60, $DD, $43, $89, $2F, $E0
    .byte $5B, $A7, $12, $6E, $94, $3C, $01, $F8
    .byte $D4, $6F, $50, $09, $1A, $8C, $23, $5B
    .byte $BB, $E5, $34, $A2, $ED, $C1, $78, $46
    .byte $9E, $35, $C2, $70, $26, $8A, $E1, $4F
    .byte $DF, $6B, $32, $92, $AE, $75, $4D, $1E
    .byte $83, $A7, $52, $EA, $1C, $49, $B6, $09
    .byte $F3, $5D, $2A, $E8, $7C, $0F, $9A, $67
    .byte $AC, $62, $D0, $81, $1D, $BA, $3A, $E4
    .byte $69, $0B, $C7, $59, $F4, $4A, $D8, $15
    .byte $70, $39, $A8, $DE, $0C, $5E, $BC, $24
    .byte $92, $5A, $F6, $7E, $1B, $A0, $4E, $F9
    .byte $68, $C3, $29, $90, $0D, $4B, $AD, $E3
    .byte $77, $2F, $D7, $86, $1F, $B5, $44, $F0
    .byte $5C, $04, $9B, $30, $EA, $B2, $12, $7D
    .byte $3E, $CB, $58, $A1, $6D, $1A, $E6, $95
    .byte $28, $6C, $DF, $53, $8B, $09, $F2, $7A
    .byte $49, $36, $AA, $FC, $17, $82, $67, $D6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 末尾
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC
    word Reset
    word Reset
