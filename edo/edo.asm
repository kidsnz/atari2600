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

PLAYER_GFX_HEIGHT      = 14  ; プレイヤーの高さ
MAX_LINES              = 192 ; スキャンライン数 
MIN_ZONE_HEIGHT        = 16  ; ゾーンの最小の高さ
MAX_ZONE_HEIGHT        = 64  ; ゾーンの最大の高さ
PLAYER_ZONE_HEIGHT     = 32  ; プレイヤーのゾーンの高さ
MAX_X                  = 160 ; X座標の最大値
MIN_X                  = 0   ; X座標の最小値
LANDSCAPE_ZONE_HEIGHT  = MAX_LINES - PLAYER_ZONE_HEIGHT ; 風景ゾーンの高さ
NUMBER_OF_SPRITES_MASK = %00011111 ; スプライトの数のマスク
ORIENT_LEFT            = %00001000 ; 左向き
ORIENT_RIGHT           = %00000000 ; 右向き

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; スプライト設定用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 各スプライトの先頭バイトは以下を示す
;  7bit: 移動可能かどうか
;  6bit: アニメーション可能かどうか
;  5bit: 方向づけ可能かどうか
;  4~0bit: 高さ
SPRITE_HEIGHT_MASK  = %00011111 ; スプライトの高さを取得するマスク
SPRITE_MOVABLE      = %10000000 ; スプライトを動かすことが可能
SPRITE_UNMOVABLE    = %00000000 ; スプライトを動かすことがなし
SPRITE_ANIMATABLE   = %01000000 ; スプライトアニメーション可能
SPRITE_UNANIMATABLE = %00000000 ; スプライトアニメーションなし
SPRITE_ORIENTABLE   = %00100000 ; スプライト方向可能
SPRITE_UNORIENTABLE = %00000000 ; スプライト方向なし

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg.u Variables
    org $80

FrameCounter        byte ; フレームカウンタ
AnimFrameCounter    byte ; アニメーション用フレームカウンター
RandomCounter       byte ; 乱数カウンタ
RandomValue         byte ; 乱数値
Tmp                 byte ; 一時変数
Tmp2                byte ; 一時変数2
ZoneIndex           byte ; ゾーンインデックス(ゾーン描画中のカウンタ)
UsingHeight         byte ; 使用した高さ(ゾーンの生成時に使用)
NeedMoreWsync       byte ; 追加のWSYNCが必要かどうか
SpriteInfo          byte ; スプライト情報
SpriteHeight        byte ; スプライトの高さを保持
SpriteGfx           word ; スプライトのアドレス
TmpX                byte ; Xの一時変数

NumberOfZones       byte  ; ゾーン数
PlayerXPos          byte  ; プレイヤーのX座標
PlayerYPos          byte  ; プレイヤーのY座標
PlayerOrient        byte  ; プレイヤーの向き
ZoneBgColors        ds 8  ; 各ゾーンの色
ZoneSpriteColors    ds 8  ; 各ゾーンのスプライトの色
ZoneHeights         ds 8  ; 各ゾーンの高さ
ZoneSpriteXPos      ds 8  ; 各ゾーンのスプライトのX座標
ZoneSpriteOrients   ds 8  ; 各ゾーンのスプライトの向き
ZoneSpriteSpeeds    ds 8  ; 各ゾーンのスプライトの速さ
ZoneSpriteNusiz     ds 8  ; 各ゾーンのスプライトのNUSIZ
ZoneSpriteGfx       ds 16 ; 各ゾーンのスプライトのアドレス

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
    lda #1
    sta PlayerOrient
    lda #2
    sta PlayerYPos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; シーンの生成
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #$10
    sta RandomCounter
    jsr ResetScene

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartFrame:
    inc FrameCounter

    ; 32フレームに1回AnimFrameCounterをトグルする
    lda FrameCounter
    and #%00011111
    cmp #%00011111
    bne .SkipToggleAnimFrameCounter
    lda AnimFrameCounter
    eor #%00000001
    sta AnimFrameCounter
.SkipToggleAnimFrameCounter

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
;; 風景ゾーンの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ldx #0
RenderLandscapeZoneLoopStart:
    stx ZoneIndex
    jmp RenderLandscapeZone
RenderLandscapeZoneReturn:
    ldx ZoneIndex
    inx
    cpx NumberOfZones
    bcc RenderLandscapeZoneLoopStart

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイヤーゾーンの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp RenderPlayerZone
RenderPlayerZoneReturn:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイヤーの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp ProcPlayer
ProcPlayerReturn:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 風景ゾーンの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldx #0
ProcLandscapeZoneLoopStart:
    stx ZoneIndex
    jmp ProcLandscapeZone
ProcLandscapeZoneReturn:
    ldx ZoneIndex
    inx
    cpx NumberOfZones
    bcc ProcLandscapeZoneLoopStart

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
;; 風景ゾーンの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RenderLandscapeZone:
    ; X座標を取得
    ldx ZoneIndex
    lda ZoneSpriteXPos,x
    ; 右端にいる場合にWSYNCを挟む
    cmp #135
    bcs .SkipLandscapeWsync    ; will take >1 scanline if > 134
    sta WSYNC
.SkipLandscapeWsync
    ; 横位置の補正
    ldy #0 ; プレイヤー0スプライト
    jsr SetObjectXPos
    sta WSYNC
    sta HMOVE
    ; 背景色のセット
    ldx ZoneIndex
    lda ZoneBgColors,x
    sta COLUBK
    ; スプライト情報を取得してSpriteInfoにセット
    ldx ZoneIndex
    txa
    asl
    tax
    lda ZoneSpriteGfx,x
    sta SpriteGfx
    lda ZoneSpriteGfx,x+1
    ldy #1
    sta SpriteGfx,y
    ldy #0
    lda (SpriteGfx),y
    sta SpriteInfo
    ; スプライトの高さを取得してSpriteHeightにセット
    lda SpriteInfo
    and #SPRITE_HEIGHT_MASK
    sta SpriteHeight
    ; SpriteGfxがスプライトのアドレスを指すようにする
    inc SpriteGfx
    ; スプライトのアニメーション情報を取得してスプライトのアドレスをずらす
    lda SpriteInfo
    and #SPRITE_ANIMATABLE
    beq .SkipSpriteAnimation
    lda AnimFrameCounter
    and #%00000001
    ; アニメーションカウンタが1の場合はアドレスをずらす
    beq .SkipSpriteAnimation
    lda SpriteGfx
    clc
    adc SpriteHeight
    sta SpriteGfx
.SkipSpriteAnimation
    ; スプライト色のセット
    ldx ZoneIndex
    lda ZoneSpriteColors,x
    sta COLUP0
    ; スプライトのNUSIZのセット
    lda ZoneSpriteNusiz,x
    sta NUSIZ0
    ; スプライトの向きのセット
    lda SpriteInfo
    and #SPRITE_ORIENTABLE
    bne .SetOrient
    lda #0
.SetOrient
    lda ZoneSpriteOrients,x
    sta REFP0
    ; ゾーンの高さ分のループ
    ldy ZoneIndex
    ldx ZoneHeights,y
    dex ; 最初のWSYNC2つを飛ばす
    dex
.RenderLandscapeZoneLoop
    sta WSYNC
    txa
    sec
    sbc #1 ; Y座標は一旦固定で1
    cmp SpriteHeight
    bcc .DrawCloud
    lda #0
.DrawCloud
    tay
    lda (SpriteGfx),y
    sta GRP0
    
    dex
    bne .RenderLandscapeZoneLoop

    jmp RenderLandscapeZoneReturn


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイヤーゾーンの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RenderPlayerZone:
    ; X座標を取得
    lda PlayerXPos
    ; 右端にいる場合にWSYNCを挟む
    cmp #135
    bcs .SkipPlayerWsync
    sta WSYNC
.SkipPlayerWsync
    ; プレイヤーを伸ばす
    lda #%00000101
    sta NUSIZ0
    ; 横位置の補正
    lda PlayerXPos
    ldy #0 ; プレイヤー0スプライト
    jsr SetObjectXPos
    sta WSYNC
    sta HMOVE
    ; 向きのセット
    lda PlayerOrient
    sta REFP0
    ; 背景色のセット
    lda #COLOR_ROAD
    sta COLUBK
    ldx #PLAYER_ZONE_HEIGHT-2
.RenderPlayerZoneLoop
    sta WSYNC
    txa
    sec
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
    bpl .RenderPlayerZoneLoop
    lda #%00000000
    sta NUSIZ0
    lda #0
    sta WSYNC
    sta COLUBK

    jmp RenderPlayerZoneReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 風景ゾーンの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcLandscapeZone
    ; SPRITE_MOVABLE       でなければ移動処理はスキップ
    lda ZoneIndex
    asl
    tax
    lda ZoneSpriteGfx,x
    sta SpriteGfx
    lda ZoneSpriteGfx,x+1
    ldy #1
    sta SpriteGfx,y
    ldy #0
    lda (SpriteGfx),y
    and #SPRITE_MOVABLE       
    beq .EndMove
.StartMove
    ldx ZoneIndex
    lda FrameCounter
    and ZoneSpriteSpeeds,x
    bne .EndMove
    lda ZoneSpriteOrients,x
    cmp #ORIENT_RIGHT
    beq .MoveRight
    jmp .MoveLeft
.MoveRight
    inc ZoneSpriteXPos,x
    lda ZoneSpriteXPos,x
    cmp #MAX_X
    bcc .EndMove
.ResetSpriteXPosToLeft
    lda #MIN_X
    sta ZoneSpriteXPos,x
    jmp .EndMove
.MoveLeft
    dec ZoneSpriteXPos,x
    lda ZoneSpriteXPos,x
    cmp #MAX_X
    bcc .EndMove
.ResetSpriteXPosToRight
    lda #MAX_X
    sta ZoneSpriteXPos,x
.EndMove
    jmp ProcLandscapeZoneReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイヤーの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcPlayer:
    lda #%00010000
    bit SWCHA
    bne .SkipMoveUp
    jsr ResetScene
.SkipMoveUp:
    lda #%00100000
    bit SWCHA
    bne .SkipMoveDown
    ; TODO
.SkipMoveDown:
    lda #%01000000
    bit SWCHA
    bne .SkipMoveLeft
    jsr LeftPlayerXPos
.SkipMoveLeft:
    lda #%10000000
    bit SWCHA
    bne .SkipMoveRight
    jsr RightPlayerXPos
.SkipMoveRight:
    jmp ProcPlayerReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; サブルーチン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; シーンをリセットする(ゾーンを再生成するなど)
ResetScene subroutine
    ldx #0
    stx UsingHeight
.InitializeZoneLoop
    ; ゾーンの高さはランダム
    jsr NextRandomValue
    lda RandomValue
    and #MAX_ZONE_HEIGHT - #MIN_ZONE_HEIGHT - #1
    clc
    adc #MIN_ZONE_HEIGHT
    sta ZoneHeights,x

    ; ゾーンの色を決定
    lda RandomValue
    sta ZoneBgColors,x

    ; スプライトを決定
    jsr NextRandomValue
    lda RandomValue
    ; yはランダムなスプライトの先頭アドレスを指すようにする
    and #NUMBER_OF_SPRITES_MASK
    asl ; SpriteGfxsのアドレスは2バイトなので2倍にする
    tay
    ; xはZoneSpriteGfxのアドレスの先頭を指すようにする
    stx Tmp2
    txa
    asl
    tax
    ; スプライトのアドレスを取得してセット
    lda SpriteGfxs,y
    sta ZoneSpriteGfx,x
    lda SpriteGfxs,y+1
    sta ZoneSpriteGfx,x+1
    ldx Tmp2

    ; スプライトの色を決定
    jsr NextRandomValue
    lda RandomValue
    sta ZoneSpriteColors,x

    ; スプライトのX座標を決定
    jsr NextRandomValue
    lda RandomValue
    and #%01111111
    sta ZoneSpriteXPos,x

    ; スプライトの向きを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000001
    bne .SetZoneSpriteOrientRight
    lda #ORIENT_LEFT
    jmp .SetZoneSpriteOrientEnd
.SetZoneSpriteOrientRight
    lda #ORIENT_RIGHT
.SetZoneSpriteOrientEnd
    sta ZoneSpriteOrients,x

    ; スプライトの速さを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000011
    tay
    lda SpeedTable,y
    sta ZoneSpriteSpeeds,x

    ; スプライトのNUSIZを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000111
    tay
    sta ZoneSpriteNusiz,x

    ; 使用した高さを保持
    lda UsingHeight
    adc ZoneHeights,x
    sta UsingHeight

    ; 使用した高さが風景に使える高さを超えていないかチェック
    lda #LANDSCAPE_ZONE_HEIGHT
    sec
    sbc UsingHeight

    ; 超えていなければ次のゾーンを作成へ
    bcs .InitializeNext

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
.StartMove
    lda #%00001000
    sta PlayerOrient
    dec PlayerXPos
    lda PlayerXPos
    cmp #MAX_X
    bcc .EndMove
.ResetPlayerXPosToRight
    lda #MAX_X-#20
    sta PlayerXPos
    jsr ResetScene
.EndMove
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; プレイヤーを右に動かす
RightPlayerXPos subroutine
.StartMove
    lda #%00000000
    sta PlayerOrient
    inc PlayerXPos
    lda PlayerXPos
    cmp #MAX_X-#20
    bcc .EndMove
.ResetPlayerXPosToLeft
    lda #MIN_X
    sta PlayerXPos
    jsr ResetScene
.EndMove
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

SpriteGfxs:
    ; 0 ~ 7
    .word CloudGfx
    .word TreeGfx
    .word Tree2Gfx
    .word BirdGfx
    .word FishGfx
    .word HouseGfx
    .word BuildingGfx
    .word Building2Gfx
    ; 8~15
    .word BoxGfx
    .word TreeGfx
    .word Tree2Gfx
    .word BoxGfx
    .word BirdGfx
    .word HouseGfx
    .word BuildingGfx
    .word Building2Gfx
    ; 16~23
    .word CloudGfx
    .word TreeGfx
    .word Tree2Gfx
    .word BirdGfx
    .word FishGfx
    .word HouseGfx
    .word BuildingGfx
    .word Building2Gfx
    ; 24~31
    .word CloudGfx
    .word TreeGfx
    .word Tree2Gfx
    .word BirdGfx
    .word FishGfx
    .word HouseGfx
    .word BuildingGfx
    .word Building2Gfx

CloudGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #13
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

TreeGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #14
    .byte %00000000 ; |        |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %11111110 ; |XXXXXXX |
    .byte %01111100 ; | XXXXX  |
    .byte %00111000 ; |  XXX   |
    .byte %11111110 ; |XXXXXXX |
    .byte %01111100 ; | XXXXX  |
    .byte %00111000 ; |  XXX   |
    .byte %01111100 ; | XXXXX  |
    .byte %00111000 ; |  XXX   |
    .byte %00111000 ; |  XXX   |
    .byte %00010000 ; |   X    |

Tree2Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #18
    .byte %00000000 ; |        |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00111000 ; |  XXX   |
    .byte %01011100 ; | X XXX  |
    .byte %01111100 ; | XXXXX  |
    .byte %01110100 ; | XXX X  |
    .byte %11111110 ; |XXXXXXX |
    .byte %11111100 ; |XXXXXX  |
    .byte %10111010 ; |X XXX X |
    .byte %11101110 ; |XXX XXX |
    .byte %11111110 ; |XXXXXXX |
    .byte %01110100 ; | XXX X  |
    .byte %01011100 ; | X XXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00010000 ; |   X    |

BirdGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #8
    .byte %00000000 ; |        |
    .byte %11000000 ; |XX      |
    .byte %01100000 ; | XX     |
    .byte %00110000 ; |  XX    |
    .byte %01111000 ; | XXXX   |
    .byte %11111100 ; |XXXXXX  |
    .byte %00000111 ; |     XXX|
    .byte %00000010 ; |      X |

    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %11100000 ; |XXX     |
    .byte %00110000 ; |  XX    |
    .byte %01111000 ; | XXXX   |
    .byte %11111100 ; |XXXXXX  |
    .byte %00000111 ; |     XXX|
    .byte %00000000 ; |      X |

FishGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #11
    .byte %00000000 ; |        |
    .byte %10000000 ; |X       |
    .byte %11000000 ; |XX      |
    .byte %01001100 ; | X  XX  |
    .byte %01011110 ; | X XXXX |
    .byte %00111111 ; |  XXXXXX|
    .byte %00111101 ; |  XXXX X|
    .byte %01011110 ; | X XXXX |
    .byte %01001100 ; | X  XX  |
    .byte %11000000 ; |XX      |
    .byte %10000000 ; |X       |

    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %11001100 ; |XX  XX  |
    .byte %01011110 ; | X XXXX |
    .byte %00111111 ; |  XXXXXX|
    .byte %00111101 ; |  XXXX X|
    .byte %01011110 ; | X XXXX |
    .byte %11001100 ; |XX  XX  |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |

HouseGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #9
    .byte %00000000 ; |        |
    .byte %01011100 ; | X XXX  |
    .byte %01011100 ; | X XXX  |
    .byte %01010100 ; | X X X  |
    .byte %01111100 ; | XXXXX  |
    .byte %11111110 ; |XXXXXXX |
    .byte %01111100 ; | XXXXX  |
    .byte %00111000 ; |  XXX   |
    .byte %00010000 ; |   X    |

BuildingGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #11
    .byte %00000000 ; |        |
    .byte %01001100 ; | X  XX  |
    .byte %01001100 ; | X  XX  |
    .byte %01111100 ; | XXXXX  |
    .byte %01110100 ; | XXX X  |
    .byte %01011100 ; | X XXX  |
    .byte %01111100 ; | XXXXX  |
    .byte %11110110 ; |XXXX XX |
    .byte %11111110 ; |XXXXXXX |
    .byte %10101010 ; |X X X X |
    .byte %10101010 ; |X X X X |

Building2Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #15
    .byte %00000000 ; |        |
    .byte %11111110 ; |XXXXXXX |
    .byte %10101010 ; |X X X X |
    .byte %10101010 ; |X X X X |
    .byte %10101010 ; |X X X X |
    .byte %10101010 ; |X X X X |
    .byte %10101010 ; |X X X X |
    .byte %10101010 ; |X X X X |
    .byte %10101010 ; |X X X X |
    .byte %11111110 ; |XXXXXXX |
    .byte %10111010 ; |X XXX X |
    .byte %11010110 ; |XX X XX |
    .byte %01101100 ; | XX XX  |
    .byte %00111000 ; |  XXX   |
    .byte %00010000 ; |   X    |

BoxGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #10
    .byte %00000000 ; |        |
    .byte %11111110 ; |XXXXXXX |
    .byte %10101010 ; |X X X X |
    .byte %11111110 ; |XXXXXXX |
    .byte %10101010 ; |X X X X |
    .byte %11111110 ; |XXXXXXX |
    .byte %10101010 ; |X X X X |
    .byte %11111110 ; |XXXXXXX |
    .byte %10101010 ; |X X X X |
    .byte %11111110 ; |XXXXXXX |

SpeedTable:
    .byte %00000011
    .byte %00000111
    .byte %00001111
    .byte %00011111

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
