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

COLOR_BG         = $00 ; デフォルトの背景色
COLOR_SKY        = $9e ; 空の背景色
COLOR_SEA        = $80 ; 海の背景色
COLOR_SAND       = $fc ; 砂の背景色
COLOR_ROAD       = $08 ; 道の背景色
COLOR_GRASS      = $c0 ; 草の背景色

NUM_ZONES        = #5  ; 描画するゾーン数(4+1つの道)
ZONE_HEIGHT      = #33 ; ゾーンの高さ
ROAD_ZONE_HEIGHT = #58 ; 道ゾーンの高さ

BIOME_NUMBER = 0                ; 選択されたバイオーム番号 TODO: 乱数で決定する
BIOME_OFFSET = BIOME_NUMBER * 2 ; バイオームを指すアドレスのオフセット(ゾーン番号 * word分ずらす)

ZONE_COMB_NUMBER = 0                    ; ゾーン組み合わせ番号 TODO: 乱数で決定する
ZONE_COMB_OFFSET = ZONE_COMB_NUMBER * 8 ; ゾーン組み合わせを指すアドレスのオフセット(1つの組み合わせに含まれるゾーンが4つなので4 * word分ずらす)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg.u Variables
    org $80

FrameCounter        byte ; フレームカウンタ
RandomCounter       byte ; 乱数カウンタ
RandomValue         byte ; 乱数値
ZoneCounter         byte ; ゾーンカウンタ
Zone1Addr           word ; 1つめのゾーンのアドレス
Zone2Addr           word ; 2つめのゾーンのアドレス
Zone3Addr           word ; 3つめのゾーンのアドレス
Zone4Addr           word ; 4つめのゾーンのアドレス
SelectedBiomeAddr   word ; 選択したバイオームのアドレス
SelectedCombAddr    word ; 選択したゾーン組み合わせのアドレス

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プログラム
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    seg Code
    org $F000

Reset:
    CLEAN_START ; メモリとレジスタをクリアするマクロ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 初期化
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #0
    sta FrameCounter
    sta RandomCounter
    sta RandomValue

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; シーンのリセット
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ResetScene:
    jsr ChangeScene

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
    sta ZoneCounter
    
.ZoneLoop
    lda ZoneCounter
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
    jmp (Zone1Addr)
.JmpZone2
    jmp (Zone2Addr)
.JmpZone3
    jmp (Zone3Addr)
.JmpZone4
    jmp (Zone4Addr)
.ZoneEnd
    sta WSYNC
    inc ZoneCounter
    lda ZoneCounter
    cmp #NUM_ZONES
    bmi .ZoneLoop
.ZoneLoopEnd
    lda #COLOR_BG
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
    jsr NextRandomValue
SkipMoveDown:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの終了処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    jmp StartFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ゾーンの実装
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 空ゾーン
SkyZone:
    sta WSYNC
    lda #COLOR_SKY
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
    lda #COLOR_SEA
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
    lda #COLOR_SAND
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
    lda #COLOR_GRASS
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
    lda #COLOR_ROAD
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

; シーンを変更する
ChangeScene subroutine
    ; バイオームを選択 TODO: 乱数により決定する
    lda Biomes + BIOME_OFFSET
    sta SelectedBiomeAddr
    lda Biomes + BIOME_OFFSET + 1
    sta SelectedBiomeAddr+1

    ; ゾーンの組み合わせを選択 TODO: 乱数により決定する
    lda SelectedBiomeAddr
    clc
    adc 1+ZONE_COMB_OFFSET
    sta SelectedCombAddr
    lda SelectedBiomeAddr+1
    sta SelectedCombAddr+1

    ; ゾーンの組み合わせからZone1Addrを設定
    ldy #0
    lda (SelectedCombAddr),y
    sta Zone1Addr
    iny
    lda (SelectedCombAddr),y
    sta Zone1Addr+1

    ; ゾーンの組み合わせからZone2Addrを設定
    iny
    lda (SelectedCombAddr),y
    sta Zone2Addr
    iny
    lda (SelectedCombAddr),y
    sta Zone2Addr+1

    ; ゾーンの組み合わせからZone3Addrを設定
    iny
    lda (SelectedCombAddr),y
    sta Zone3Addr
    iny
    lda (SelectedCombAddr),y
    sta Zone3Addr+1

    ; ゾーンの組み合わせからZone4Addrを設定
    iny
    lda (SelectedCombAddr),y
    sta Zone4Addr
    iny
    lda (SelectedCombAddr),y
    sta Zone4Addr+1

    rts
    
; 次の乱数値をセットする
NextRandomValue subroutine
    inc RandomCounter
    ldx RandomCounter
    lda RandomTable,X
    sta RandomValue
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; データ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NUMBER_OF_BIOMES = 2

; バイオーム一覧
Biomes:
    .word SeaBiome
    .word GrasslandBiome
    .word SandBiome

; 海バイオーム
SeaBiome:
    .byte #2 ; 組み合わせ数
    .word SkyZone, SeaZone, SeaZone, SandZone
    .word SkyZone, SeaZone, SeaZone, SeaZone

; 草原バイオーム
GrasslandBiome:
    .byte #2 ; 組み合わせ数
    .word SkyZone, SkyZone, GrasslandZone, GrasslandZone
    .word SkyZone, GrasslandZone, GrasslandZone, GrasslandZone

; 砂バイオーム
SandBiome:
    .byte #2 ; 組み合わせ数
    .word SkyZone, SandZone, SandZone, SandZone
    .word SkyZone, SandZone, SeaZone, SandZone

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
