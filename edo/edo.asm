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

; スプライト2を使う
USE_SPRITE_2 = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; カラーコード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

COLOR_ROAD        = $08 ; 道の背景色
COLOR_BUILDING    = $03 ; ビルの色

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PLAYER_GFX_HEIGHT      = 14  ; プレイヤーの高さ
MAX_LINES              = 192 ; スキャンライン数 
MAX_NUMBER_OF_ZONES    = 6   ; ゾーンの最大数
MIN_ZONE_HEIGHT        = 16  ; ゾーンの最小の高さ
MAX_ZONE_HEIGHT        = 64  ; ゾーンの最大の高さ
PLAYER_ZONE_HEIGHT     = 32  ; プレイヤーのゾーンの高さ
MAX_X                  = 160 ; X座標の最大値
MIN_X                  = 0   ; X座標の最小値
LANDSCAPE_ZONE_HEIGHT  = MAX_LINES - PLAYER_ZONE_HEIGHT ; 風景ゾーンの高さ
NUMBER_OF_SPRITES_MASK = %00011111 ; スプライトの数のマスク
ORIENT_LEFT            = %00001000 ; 左向き
ORIENT_RIGHT           = %00000000 ; 右向き
BUILDING_GFX_HEIGHT    = 18 ; ビルの高さ

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
ZoneIndex           byte ; ゾーンインデックス(ゾーン描画中のカウンタ)
UsingHeight         byte ; 使用した高さ(ゾーンの生成時に使用)
SpriteInfo          byte ; スプライト情報
SpriteHeight        byte ; スプライトの高さを保持
SpriteGfx           word ; スプライトのアドレス
Sprite2Info         byte ; スプライト2情報
Sprite2Height       byte ; スプライト2の高さを保持
Sprite2Gfx          word ; スプライト2のアドレス

PlayerXPos          byte ; プレイヤーのX座標
PlayerYPos          byte ; プレイヤーのY座標
PlayerOrient        byte ; プレイヤーの向き
PlayerGfxAddr       word ; プレイヤースプライトのアドレス

NumberOfZones       byte ; ゾーン数
ZoneBgColors        ds MAX_NUMBER_OF_ZONES ; 各ゾーンの色
ZoneSpriteColors    ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトの色
ZoneHeights         ds MAX_NUMBER_OF_ZONES ; 各ゾーンの高さ

ZoneSpriteXPos      ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトのX座標
ZoneSpriteOrients   ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトの向き
ZoneSpriteSpeeds    ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトの速さ
ZoneSpriteNusiz     ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトのNUSIZ
ZoneSpriteGfx       ds MAX_NUMBER_OF_ZONES * 2 ; 各ゾーンのスプライトのアドレス

ZoneSprite2Colors   ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト2の色
ZoneSprite2XPos     ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトのX座標
ZoneSprite2Orients  ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトの向き
ZoneSprite2Speeds   ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトの速さ
ZoneSprite2Nusiz    ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライトのNUSIZ
ZoneSprite2Gfx      ds MAX_NUMBER_OF_ZONES * 2 ; 各ゾーンのスプライトのアドレス

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
    bcs .SkipLandscapeWsync ; will take >1 scanline if > 134
    sta WSYNC
.SkipLandscapeWsync
    ; スプライトの横位置の補正
    lda ZoneSpriteXPos,x
    ldy #0 ; プレイヤー0スプライト
    jsr SetObjectXPos
#if USE_SPRITE_2 = 1
    ; スプライト2の横位置の補正
    ldx ZoneIndex
    lda ZoneSprite2XPos,x
    ldy #1 ; プレイヤー1スプライト
    jsr SetObjectXPos
#endif
    ; 横位置の補正を適用
    sta WSYNC
    sta HMOVE
    ; 背景色のセット
    ldx ZoneIndex
    lda ZoneBgColors,x
    sta COLUBK
    ; スプライト情報を取得してSpriteInfoにセット
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

#if USE_SPRITE_2 = 1
    ; スプライト2情報を取得してSpriteInfoにセット
    lda ZoneIndex
    asl
    tax
    lda ZoneSprite2Gfx,x
    sta Sprite2Gfx
    lda ZoneSprite2Gfx,x+1
    ldy #1
    sta Sprite2Gfx,y
    ldy #0
    lda (Sprite2Gfx),y
    sta Sprite2Info
    ; スプライト2の高さを取得してSpriteHeightにセット
    lda Sprite2Info
    and #SPRITE_HEIGHT_MASK
    sta Sprite2Height
    ; Sprite2Gfxがスプライトのアドレスを指すようにする
    inc Sprite2Gfx
    ; スプライトのアニメーション情報を取得してスプライトのアドレスをずらす
    lda Sprite2Info
    and #SPRITE_ANIMATABLE
    beq .SkipSprite2Animation
    lda AnimFrameCounter
    and #%00000001
    ; アニメーションカウンタが1の場合はアドレスをずらす
    beq .SkipSprite2Animation
    lda Sprite2Gfx
    clc
    adc Sprite2Height
    sta Sprite2Gfx
.SkipSprite2Animation
#endif

    ; スプライト色のセット
    ldx ZoneIndex
    lda ZoneSpriteColors,x
    sta COLUP0
#if USE_SPRITE_2 = 1
    ; スプライト2色のセット
    lda ZoneSprite2Colors,x
    sta COLUP1
#endif
    ; スプライトのNUSIZのセット
    lda ZoneSpriteNusiz,x
    sta NUSIZ0
#if USE_SPRITE_2 = 1
    ; スプライト2のNUSIZのセット
    lda ZoneSprite2Nusiz,x
    sta NUSIZ1
#endif
    ; スプライトの向きのセット
    lda SpriteInfo
    and #SPRITE_ORIENTABLE
    bne .LoadOrient
    lda #0
    jmp .SetOrient
.LoadOrient
    lda ZoneSpriteOrients,x
.SetOrient
    sta REFP0
#if USE_SPRITE_2 = 1
    ; スプライト2の向きのセット
    lda Sprite2Info
    and #SPRITE_ORIENTABLE
    bne .LoadOrient2
    lda #0
    jmp .SetOrient2
.LoadOrient2
    lda ZoneSprite2Orients,x
.SetOrient2
    sta REFP1
#endif

    ; プレイフィールドの色をセット
    ; lda #COLOR_BUILDING
    ; sta COLUPF

    ; ゾーンの高さ分のループ
    ldy ZoneIndex
    lda ZoneHeights,y
    clc
    sbc #2 + #1 ; 最初のWSYNC2つとプレイフィールド分を飛ばす
#if USE_SPRITE_2 = 1
    clc
    sbc #4 ; スプライト2の処理多いので更に猶予を作る
#endif
    tax
.RenderLandscapeZoneLoop
    sta WSYNC

    ; スプライト1の描画
    txa
    sec
    sbc #1 ; Y座標は一旦固定で1
    cmp SpriteHeight
    bcc .DrawSprite1
    lda #0
.DrawSprite1
    tay
    lda (SpriteGfx),y
    sta GRP0

#if USE_SPRITE_2 = 1
    ; スプライト2の描画
    txa
    sec
    sbc #20 ; Y座標は一旦固定で20
    cmp Sprite2Height
    bcc .DrawSprite2
    lda #0
.DrawSprite2
    tay
    lda (Sprite2Gfx),y
    sta GRP1
#endif

;     ; プレイフィールドの描画
;     txa
;     cmp #BUILDING_GFX_HEIGHT
;     bcc .DrawPlayField
;     lda #0
; .DrawPlayField
;     tay
;     lda PlayFieldBuildingGfx0,y
;     sta PF0
;     lda PlayFieldBuildingGfx1,y
;     sta PF1
;     lda PlayFieldBuildingGfx2,y
;     sta PF2
    
    dex
    bne .RenderLandscapeZoneLoop

    ; プレイフィールドをクリア
    ; lda #COLOR_BUILDING
    ; sta COLUBK
    ; lda #0
    ; sta PF0
    ; sta PF1
    ; sta PF2

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
    ; プレイヤースプライトのアドレスをセット
    lda #<PlayerGfx
    sta PlayerGfxAddr
    lda #>PlayerGfx
    ldy #1
    sta PlayerGfxAddr,y
    ldy #0
    ; アニメーションカウンタが1の場合はアドレスをずらす
    lda AnimFrameCounter
    and #%00000001
    beq .SkipPlayerAnimation
    lda PlayerGfxAddr
    clc
    adc #PLAYER_GFX_HEIGHT
    sta PlayerGfxAddr
.SkipPlayerAnimation
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
    lda (PlayerGfxAddr),y
    sta GRP0
    lda PlayerGfxColor,y
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
    ; SPRITE_MOVABLEでなければ移動処理はスキップ
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
    beq .EndMove1

    ; スプライト1の移動処理
.StartMove1
    ldx ZoneIndex
    lda FrameCounter
    and ZoneSpriteSpeeds,x
    bne .EndMove1
    lda ZoneSpriteOrients,x
    cmp #ORIENT_RIGHT
    beq .MoveRight1
    jmp .MoveLeft1
.MoveRight1
    inc ZoneSpriteXPos,x
    lda ZoneSpriteXPos,x
    cmp #MAX_X
    bcc .EndMove1
.ResetSpriteXPosToLeft1
    lda #MIN_X
    sta ZoneSpriteXPos,x
    jmp .EndMove1
.MoveLeft1
    dec ZoneSpriteXPos,x
    lda ZoneSpriteXPos,x
    cmp #MAX_X
    bcc .EndMove1
.ResetSpriteXPosToRight1
    lda #MAX_X
    sta ZoneSpriteXPos,x
.EndMove1

#if USE_SPRITE_2 = 1
    ; SPRITE_MOVABLEでなければ移動処理はスキップ
    lda ZoneIndex
    asl
    tax
    lda ZoneSprite2Gfx,x
    sta Sprite2Gfx
    lda ZoneSprite2Gfx,x+1
    ldy #1
    sta Sprite2Gfx,y
    ldy #0
    lda (Sprite2Gfx),y
    and #SPRITE_MOVABLE
    beq .EndMove2

    ; スプライト2の移動処理
.StartMove2
    ldx ZoneIndex
    lda FrameCounter
    and ZoneSprite2Speeds,x
    bne .EndMove2
    lda ZoneSprite2Orients,x
    cmp #ORIENT_RIGHT
    beq .MoveRight2
    jmp .MoveLeft2
.MoveRight2
    inc ZoneSprite2XPos,x
    lda ZoneSprite2XPos,x
    cmp #MAX_X
    bcc .EndMove2
.ResetSpriteXPosToLeft2
    lda #MIN_X
    sta ZoneSprite2XPos,x
    jmp .EndMove2
.MoveLeft2
    dec ZoneSprite2XPos,x
    lda ZoneSprite2XPos,x
    cmp #MAX_X
    bcc .EndMove2
.ResetSpriteXPosToRight2
    lda #MAX_X
    sta ZoneSprite2XPos,x
.EndMove2
#endif

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
    stx Tmp
    txa
    asl
    tax
    ; スプライトのアドレスを取得してセット
    lda SpriteGfxs,y
    sta ZoneSpriteGfx,x
    lda SpriteGfxs,y+1
    sta ZoneSpriteGfx,x+1
    ldx Tmp

#if USE_SPRITE_2 = 1
    ; スプライト2を決定
    jsr NextRandomValue
    lda RandomValue
    ; yはランダムなスプライトの先頭アドレスを指すようにする
    and #NUMBER_OF_SPRITES_MASK
    asl ; SpriteGfxsのアドレスは2バイトなので2倍にする
    tay
    ; xはZoneSpriteGfxのアドレスの先頭を指すようにする
    stx Tmp
    txa
    asl
    tax
    ; スプライト2のアドレスを取得してセット
    lda SpriteGfxs,y
    sta ZoneSprite2Gfx,x
    lda SpriteGfxs,y+1
    sta ZoneSprite2Gfx,x+1
    ldx Tmp
#endif

    ; スプライトの色を決定
    jsr NextRandomValue
    lda RandomValue
    sta ZoneSpriteColors,x

#if USE_SPRITE_2 = 1
    ; スプライト2の色を決定
    jsr NextRandomValue
    lda RandomValue
    sta ZoneSprite2Colors,x
#endif

    ; スプライトのX座標を決定
    jsr NextRandomValue
    lda RandomValue
    and #%01111111
    sta ZoneSpriteXPos,x

#if USE_SPRITE_2 = 1
    ; スプライト2のX座標を決定
    jsr NextRandomValue
    lda RandomValue
    and #%01111111
    sta ZoneSprite2XPos,x
#endif

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

#if USE_SPRITE_2 = 1
    ; スプライト2の向きを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000001
    bne .SetZoneSprite2OrientRight
    lda #ORIENT_LEFT
    jmp .SetZoneSprite2OrientEnd
.SetZoneSprite2OrientRight
    lda #ORIENT_RIGHT
.SetZoneSprite2OrientEnd
    sta ZoneSprite2Orients,x
#endif

    ; スプライトの速さを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000011
    tay
    lda SpeedTable,y
    sta ZoneSpriteSpeeds,x

#if USE_SPRITE_2 = 1
    ; スプライト2の速さを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000011
    tay
    lda SpeedTable,y
    sta ZoneSprite2Speeds,x
#endif

    ; スプライトのNUSIZを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000111
    tay
    sta ZoneSpriteNusiz,x

#if USE_SPRITE_2 = 1
    ; スプライト2のNUSIZを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000111
    tay
    sta ZoneSprite2Nusiz,x
#endif

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

    ; ゾーンの最大数を超えていたらもう一度シーンを生成する
    cmp #MAX_NUMBER_OF_ZONES
    bcc .DoneResetScene
    jsr ResetScene

.DoneResetScene
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

SetObject2XPos subroutine
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
    sta HMP1,Y
    sta RESP1,Y
    rts
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; データ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FA00

; プレイヤースプライト
PlayerGfx:
    .byte %00000000 ; |        |
    .byte %10001010 ; |X   X X |
    .byte %01000100 ; | X   X  |
    .byte %10100100 ; |X X  X  |
    .byte %01101110 ; | XX XXX |
    .byte %11011110 ; |XX XXXX |
    .byte %00111110 ; |  XXXXX |
    .byte %11110100 ; |XXXX X  |
    .byte %00010100 ; |   X X  |
    .byte %11101111 ; |XXX XXXX|
    .byte %00001010 ; |    X X |
    .byte %00001100 ; |    XX  |
    .byte %00001000 ; |    X   |
    .byte %00010100 ; |   X X  |

    .byte %00000000 ; |        |
    .byte %11001110 ; |XX  XXX |
    .byte %00100100 ; |  X  X  |
    .byte %11101110 ; |XXX XXX |
    .byte %01011110 ; | X XXXX |
    .byte %10111110 ; |X XXXXX |
    .byte %01110100 ; | XXX X  |
    .byte %10010100 ; |X  X X  |
    .byte %01101111 ; | XX XXXX|
    .byte %10001010 ; |X   X X |
    .byte %00001100 ; |    XX  |
    .byte %00011000 ; |   XX   |
    .byte %00000100 ; |     X  |
    .byte %00000000 ; |        |

; プレイヤースプライトカラー
PlayerGfxColor:
    .byte $16
    .byte $26
    .byte $36
    .byte $46
    .byte $56
    .byte $66
    .byte $76
    .byte $86

; プレイフィールドビル背景0
PlayFieldBuildingGfx0:
    .byte %00000000 ; |        |
    .byte %11110000 ; |XXXX    |
    .byte %11110000 ; |XXXX    |
    .byte %11110000 ; |XXXX    |
    .byte %11110000 ; |XXXX    |
    .byte %11110000 ; |XXXX    |
    .byte %11110000 ; |XXXX    |
    .byte %01110000 ; | XXX    |
    .byte %01110000 ; | XXX    |
    .byte %01010000 ; | X X    |
    .byte %01010000 ; | X X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |

; プレイフィールドビル背景1
PlayFieldBuildingGfx1:
    .byte %00000000 ; |        |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11110111 ; |XXXX XXX|
    .byte %11110111 ; |XXXX XXX|
    .byte %11010111 ; |XX X XXX|
    .byte %11010011 ; |XX X  XX|
    .byte %01010011 ; | X X  XX|
    .byte %01010010 ; | X X  X |
    .byte %00000010 ; |      X |
    .byte %00000010 ; |      X |
    .byte %00000010 ; |      X |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |

; プレイフィールドビル背景2
PlayFieldBuildingGfx2:
    .byte %00000000 ; |        |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11101111 ; |XXX XXXX|
    .byte %11100111 ; |XXX  XXX|
    .byte %11100111 ; |XXX  XXX|
    .byte %11000101 ; |XX   X X|
    .byte %10000001 ; |X      X|
    .byte %10000001 ; |X      X|
    .byte %10000001 ; |X      X|
    .byte %10000000 ; |X       |
    .byte %10000000 ; |X       |
    .byte %10000000 ; |X       |
    .byte %10000000 ; |X       |

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
    .word BearGfx
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
    .word BearGfx
    .word Building2Gfx
    ; 24~31
    .word CloudGfx
    .word TreeGfx
    .word Tree2Gfx
    .word BirdGfx
    .word FishGfx
    .word BearGfx
    .word BuildingGfx
    .word Building2Gfx

    org $FB00

BearGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #20
    .byte %00000000 ; |        |
    .byte %00000111 ; |     XXX|
    .byte %00000111 ; |     XXX|
    .byte %11100110 ; |XXX  XX |
    .byte %11100110 ; |XXX  XX |
    .byte %01111110 ; | XXXXXX |
    .byte %01111110 ; | XXXXXX |
    .byte %01111100 ; | XXXXX  |
    .byte %01111010 ; | XXXX X |
    .byte %00111011 ; |  XXX XX|
    .byte %00111101 ; |  XXXX X|
    .byte %01111111 ; | XXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111110 ; |XXXXXXX |
    .byte %10011100 ; |X  XXX  |
    .byte %10100010 ; |X X   X |
    .byte %10110110 ; |X XX XX |
    .byte %10101010 ; |X X X X |
    .byte %00011100 ; |   XXX  |
    .byte %00010100 ; |   X X  |

    .byte %00000000 ; |        |
    .byte %11100000 ; |XXX     |
    .byte %11100000 ; |XXX     |
    .byte %11100110 ; |XXX  XX |
    .byte %11100110 ; |XXX  XX |
    .byte %01111110 ; | XXXXXX |
    .byte %00111110 ; |  XXXXX |
    .byte %00111110 ; |  XXXXX |
    .byte %01011110 ; | X XXXX |
    .byte %11111000 ; |XXXXX   |
    .byte %10111100 ; |X XXXX  |
    .byte %01111111 ; | XXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %01111111 ; | XXXXXXX|
    .byte %00011101 ; |   XXX X|
    .byte %00100011 ; |  X   XX|
    .byte %00110111 ; |  XX XXX|
    .byte %00101011 ; |  X X XX|
    .byte %00011100 ; |   XXX  |
    .byte %00010100 ; |   X X  |

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
    .byte %01000000 ; | X      |
    .byte %00110000 ; |  XX    |
    .byte %01111000 ; | XXXX   |
    .byte %11111100 ; |XXXXXX  |
    .byte %00110110 ; |  XX XX |
    .byte %11100100 ; |XXX  X  |
    .byte %00000000 ; |        |

FishGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #11
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %11001100 ; |XX  XX  |
    .byte %11011110 ; |XX XXXX |
    .byte %00111111 ; |  XXXXXX|
    .byte %00111101 ; |  XXXX X|
    .byte %11011110 ; |XX XXXX |
    .byte %11001100 ; |XX  XX  |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |

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
