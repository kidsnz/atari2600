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
;; カラーコード
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PLAYER_GFX_HEIGHT   = 14  ; プレイヤーの高さ
CLOUD_GFX_HEIGHT    = 16  ; 雲の高さ
MAX_NUMBER_OF_ZONES = 8   ; ゾーンの最大数
MIN_NUMBER_OF_ZONES = 3   ; ゾーンの最小数
MASK_NUMBER_OF_ZONES = %0011 ; ゾーン数のマスク
MAX_LINES           = 192 ; スキャンライン数 
MIN_ZONE_HEIGHT     = 16
MAX_ZONE_HEIGHT     = 64
PLAYER_ZONE_HEIGHT  = 32  ; プレイヤーのゾーンの高さ
LANDSCAPE_ZONE_HEIGHT = MAX_LINES - PLAYER_ZONE_HEIGHT ; 風景ゾーンの高さ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg.u Variables
    org $80

FrameCounter        byte ; フレームカウンタ
RandomCounter       byte ; 乱数カウンタ
RandomValue         byte ; 乱数値
NumberOfZones       byte ; ゾーン数
ZoneIndex           byte ; ゾーンインデックス(ゾーン描画中のカウンタ)
PlayerXPos          byte ; プレイヤーのX座標
PlayerYPos          byte ; プレイヤーのY座標
ZoneBgColors        ds MAX_NUMBER_OF_ZONES ; 各ゾーンの色
ZoneSpriteColors    ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトの色
ZoneHeights         ds MAX_NUMBER_OF_ZONES ; 各ゾーンの高さ
Tmp                 byte ; 一時変数
UsingHeight         byte ; 使用した高さ(ゾーンの生成時に使用)
Log1         byte ; 使用した高さ(ゾーンの生成時に使用)

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

    ; プレイヤー座標の初期化
    lda #60
    sta PlayerXPos
    lda #2
    sta PlayerYPos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; シーンの生成
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jsr ResetScene

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartFrame:
    inc FrameCounter

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
    
    ; 風景ゾーンの描画
    ldx #0
LandscapeZoneLoopStart:
    stx ZoneIndex
    jmp LandscapeZone
LandscapeZoneReturn:
    ldx ZoneIndex
    inx
    cpx NumberOfZones
    bcc LandscapeZoneLoopStart

    ; プレイヤーゾーンの描画
    jmp PlayerZone
PlayerZoneReturn:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ジョイスティックの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #%00010000
    bit SWCHA
    bne SkipMoveUp
    jsr ResetScene
SkipMoveUp:
    lda #%00100000
    bit SWCHA
    bne SkipMoveDown
    ; TODO
SkipMoveDown:
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
;; ゾーンの実装
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 風景ゾーンの実装
LandscapeZone:
    ldx ZoneIndex
    ; 背景色のセット
    lda ZoneBgColors,x
    sta WSYNC
    sta COLUBK
    ; スプライト色のセット
    lda ZoneSpriteColors,x
    sta COLUP0
    ; 横位置の補正
    ; ldx ZoneP0XPosAddr
    lda $00,X
    ldy #0
    jsr SetObjectXPos
    sta WSYNC
    sta HMOVE
    ; ゾーンの高さ分のループ
    ldx ZoneIndex
    ldy ZoneHeights,x
    dey ; 最初のWSYNC2つ+最初の1つ分を飛ばす
    dey
    dey
.LandscapeZoneLoop
    sta WSYNC
    tya
    sbc #0
    cmp #CLOUD_GFX_HEIGHT
    bcc .DrawCloud
    lda #0
.DrawCloud
    tax
    lda CloudGfx,x
    sta GRP0
    ; lda #COLOR_CLOUD
    ; sta COLUP0
    
    dey
    bne .LandscapeZoneLoop
    jmp LandscapeZoneReturn

; プレイヤーゾーンの実装
PlayerZone:
    lda #%00000101
    sta NUSIZ0
    ; 横位置の補正
    lda PlayerXPos
    ldy #0
    jsr SetObjectXPos
    sta WSYNC
    sta HMOVE
    ; 背景色のセット
    lda #COLOR_ROAD
    sta COLUBK
    ldx #PLAYER_ZONE_HEIGHT-2
.PlayerZoneLoop
    sta WSYNC
    txa
    sbc PlayerYPos
    cmp #PLAYER_GFX_HEIGHT
    bcc .DrawPlayer
    lda #0
.DrawPlayer
    tay
    lda PlayerGfx,Y
    sta GRP0
    lda PlayerGfxColor,Y
    sta COLUP0
    dex
    bpl .PlayerZoneLoop
    lda #%00000000
    sta NUSIZ0
    lda #0
    sta WSYNC
    sta COLUBK
    jmp PlayerZoneReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; サブルーチン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 左側にプレイヤーのX座標をリセット
ResetPlayerXPosToLeft subroutine
    lda #0
    sta PlayerXPos
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 右側にプレイヤーのX座標をリセット
ResetPlayerXPosToRight subroutine
    lda #134
    sta PlayerXPos
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; シーンをリセットする(ゾーンを再生成するなど)
ResetScene subroutine
    ldx #0
    stx UsingHeight
.InitializeZoneLoop
    ; ゾーンの高さは32~64の間でランダム
    jsr NextRandomValue
    lda RandomValue
    and #%00011111
    clc
    adc #32
    sta ZoneHeights,x

    ; ゾーンの色を決定
    lda RandomValue
    sta ZoneBgColors,x

    ; スプライトの色を決定
    jsr NextRandomValue
    lda RandomValue
    sta ZoneSpriteColors,x

    ; 使用した高さを保持
    lda UsingHeight
    adc ZoneHeights,x
    sta UsingHeight

    ; 使用した高さが風景に使える高さを超えていないかチェック
    clc
    sbc #LANDSCAPE_ZONE_HEIGHT

    ; 超えていなければ次のゾーンを作成へ
    bmi .InitializeNext

    ; 超えていたら終わり
    jmp .InitializeEnd
.InitializeNext
    inx
    jmp .InitializeZoneLoop
.InitializeEnd
    ; はみ出した分を最後のゾーンから引いておく
    lda UsingHeight
    sec
    sbc #LANDSCAPE_ZONE_HEIGHT
    sta Tmp
    lda ZoneHeights,x
    sec
    sbc Tmp
    sta ZoneHeights,x

    ; もし最後のゾーンが小さすぎたら手前のゾーンに結合
    lda ZoneHeights,x
    cmp #MIN_ZONE_HEIGHT
    bmi .CombineZone
    jmp .SkipCombineZone
.CombineZone
    lda ZoneHeights,x
    dex
    clc
    adc ZoneHeights,x
    sta ZoneHeights,x
.SkipCombineZone

    ; ゾーン数を計算してセット
    txa
    clc
    adc #1
    sta NumberOfZones

    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 次の乱数値をセットする
NextRandomValue subroutine
    pha
    txa
    pha
    inc RandomCounter
    ldx RandomCounter
    lda RandomTable,X
    sta RandomValue
    pla
    tax
    pla
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
    .byte %00000000
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

; プレイヤースプライトカラー
PlayerGfxColor:
    .byte $00
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38
    .byte $38

CloudGfx:
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00010000 ; |   X    |
    .byte %00111100 ; |  XXXX  |
    .byte %01111110 ; | XXXXXX |
    .byte %11111110 ; |XXXXXXX |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %01111111 ; | XXXXXXX|
    .byte %00111110 ; |  XXXXX |
    .byte %00011100 ; |   XXX  |
    .byte %00011100 ; |   XXX  |
    .byte %00001000 ; |    X   |
    .byte %00000000 ; |        |

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
