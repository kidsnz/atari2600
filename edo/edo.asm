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
;; デバッグ用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; デバッグ動作にする場合は1を指定する
DEBUG = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

COLOR_BG          = $00 ; デフォルトの背景色
COLOR_SKY         = $9e ; 空の背景色
COLOR_DARK_SKY    = $04 ; 暗い空の背景色
COLOR_SEA         = $80 ; 海の背景色
COLOR_SAND        = $fc ; 砂の背景色
COLOR_ROAD        = $08 ; 道の背景色
COLOR_GRASS       = $c0 ; 草の背景色
COLOR_BUILDING_BG = $0c ; ビルの背景色
COLOR_BUILDING    = $03 ; ビルの色
COLOR_CLOUD       = $0e ; 雲の色

PLAYER_GFX_HEIGHT   = 16 ; プレイヤーの高さ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg.u Variables
    org $80

FrameCounter        byte ; フレームカウンタ
RandomCounter       byte ; 乱数カウンタ
RandomValue         byte ; 乱数値
ZoneCounter         byte ; ゾーンカウンタ
BiomeNumber         byte ; バイオーム番号
ZoneCombNumber      byte ; ゾーン組み合わせ番号
Zone1Addr           word ; 1つめのゾーンのアドレス
Zone2Addr           word ; 2つめのゾーンのアドレス
Zone3Addr           word ; 3つめのゾーンのアドレス
Zone4Addr           word ; 4つめのゾーンのアドレス
SelectedBiomeAddr   word ; 選択したバイオームのアドレス
SelectedCombAddr    word ; 選択したゾーン組み合わせのアドレス
PlayerXPos          byte ; プレイヤーのX座標
PlayerYPos          byte ; プレイヤーのY座標
ZoneP0XPosAddr      byte ; プレイヤー0のX座標のアドレス
Zone1P0XPos         byte ; ゾーン1のプレイヤー0のX座標
Zone2P0XPos         byte ; ゾーン2のプレイヤー0のX座標
Zone3P0XPos         byte ; ゾーン3のプレイヤー0のX座標
Zone4P0XPos         byte ; ゾーン4のプレイヤー0のX座標
Tmp                 byte ; 一時領域

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
    lda #60
    sta PlayerXPos
    lda #120
    sta Zone1P0XPos
    lda #120
    sta Zone3P0XPos
    lda #2
    sta PlayerYPos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; シーンの生成
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; ゾーン数を計算
    ; ゾーン毎の高さを計算
    ; ゾーン毎の背景色を決定

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartFrame:
    inc FrameCounter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  垂直同期前
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; sta WSYNC

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

    lda #%10000010
    sta VBLANK
    REPEAT 37
        sta WSYNC
    REPEND
    lda #%00000000
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ゾーンの描画処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    REPEAT 192
        sta WSYNC
    REPEND

; ジョイスティックの処理
    lda #%01000000
    bit SWCHA
    bne SkipMoveLeft
    jsr LeftPlayerXPos
SkipMoveLeft:
    lda #%10000000
    bit SWCHA
    bne SkipMoveRight
    jsr RightPlayerXPos
SkipMoveRight:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; オーバースキャン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; タイマー版
;     lda #%00000010
;     sta VBLANK
; .WaitOnOverScan
;     cpx INTIM
;     bmi .WaitOnOverScan
;     lda #%00000000
;     sta VBLANK

    ; REPEAT版
    sta WSYNC
    lda #%00000010
    sta VBLANK
    REPEAT 30
      sta WSYNC
    REPEND
    lda #%00000000
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの終了処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    jmp StartFrame

  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; サブルーチン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 左側にプレイヤーのX座標をリセット
ResetPlayerXPosToLeft subroutine
    lda #0
    sta PlayerXPos
    rts
    
; 右側にプレイヤーのX座標をリセット
ResetPlayerXPosToRight subroutine
    lda #134
    sta PlayerXPos
    rts

; シーンを生成する
ResetScene subroutine
    ; TODO
    rts
    
; 次の乱数値をセットする
NextRandomValue subroutine
    inc RandomCounter
    ldx RandomCounter
    lda RandomTable,X
    sta RandomValue
    rts

; プレイヤーを左に動かす
LeftPlayerXPos subroutine
    ldx PlayerXPos
    cpx #0
    beq .LeftEnd
    dex
    stx PlayerXPos
    jmp .Return
.LeftEnd
    jsr ResetPlayerXPosToRight
    jsr ResetScene
.Return
    rts

; プレイヤーを右に動かす
RightPlayerXPos subroutine
    ldx PlayerXPos
    cpx #128
    bpl .RightEnd
    inx
    stx PlayerXPos
    jmp .Return
.RightEnd
    jsr ResetPlayerXPosToLeft
    jsr ResetScene
.Return
    rts

; 対象のX座標の位置をセットする
;  A は対象のピクセル単位のX座標
;  Y は対象の種類 (0:player0, 1:player1, 2:missile0, 3:missile1, 4:ball)
SetObjectXPos subroutine
    tax
    sec
    sta WSYNC
.Div15Loop
    sbc #15
    bcs .Div15Loop
    eor #%0111
    asl
    asl
    asl
    asl
    sta HMP0,Y
    sta RESP0,Y
    rts
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; データ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; プレイヤースプライト
PlayerGfx:
    .byte %00000000 ; |        |
    .byte %10000001 ; |X      X|
    .byte %01000001 ; | X     X|
    .byte %00100010 ; |  X   X |
    .byte %00010100 ; |   X X  |
    .byte %00011000 ; |   XX   |
    .byte %10011000 ; |X  XX   |
    .byte %01011000 ; | X XX   |
    .byte %00111000 ; |  XXX   |
    .byte %00011100 ; |   XXX  |
    .byte %00011010 ; |   XX X |
    .byte %00011001 ; |   XX  X|
    .byte %00111100 ; |  XXXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00111100 ; |  XXXX  |

; プレイヤースプライトカラー
PlayerGfxColor:
    .byte $38
    .byte $38
    .byte $80
    .byte $80
    .byte $80
    .byte $80
    .byte $FF
    .byte $FF
    .byte $FF
    .byte $FF
    .byte $FF
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $00

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
