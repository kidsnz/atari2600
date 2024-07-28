    processor 6502

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; インクルード文
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    include "vcs.h"
    include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; デバッグ用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; デバッグ動作にする場合は1を指定する
DEBUG = 1

; 乱数カウンターの初期値
INITIAL_RANDOM_COUNTER = 0

; スプライト1を使う
USE_SPRITE_1 = 1

; プレイフィールドを使う
USE_PLAYFIELD = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; カラーコード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PLAYER_GFX_HEIGHT          = 14  ; プレイヤーの高さ
MAX_LINES                  = 192 ; スキャンライン数 
MAX_NUMBER_OF_ZONES        = 6   ; ゾーンの最大数
MIN_ZONE_HEIGHT            = 32  ; ゾーンの最小の高さ
MAX_ZONE_HEIGHT            = 64  ; ゾーンの最大の高さ
PLAYER_ZONE_HEIGHT         = 32  ; プレイヤーのゾーンの高さ
MAX_X                      = 160 ; X座標の最大値
MIN_X                      = 0   ; X座標の最小値
LANDSCAPE_ZONE_HEIGHT      = MAX_LINES - PLAYER_ZONE_HEIGHT ; 風景ゾーンの高さ
NUMBER_OF_SPRITES_MASK     = %00011111 ; スプライトの数のマスク
NUMBER_OF_PLAY_FIELDS_MASK = %00000111 ; プレイフィールドの数のマスク
NUMBER_OF_SPEEDS_MASK      = %00000011 ; スプライトの速度の数のマスク
ORIENT_LEFT                = %00001000 ; 左向き
ORIENT_RIGHT               = %00000000 ; 右向き
BUILDING_GFX_HEIGHT        = 18 ; ビルの高さ
RENDER_ZONE_INIT_TIME      = 12 ; ゾーン描画の初期化処理に使う時間(ライン数) 4xlinesで処理しているので4の倍数である必要がある

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; スプライト情報用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 各スプライトの先頭バイトは以下を示す
;  7bit: 移動可能かどうか
;  6bit: アニメーション可能かどうか
;  5bit: 方向づけ可能かどうか
;  4bit: NUSIZの種類(0: ALL, 1: UNWIDEABLE)
;  3bit: 空き
;  2bit: 空き
;  1bit: 空き
;  0bit: 空き
SPRITE_MOVABLE          = %10000000 ; スプライトを動かすことが可能
SPRITE_UNMOVABLE        = %00000000 ; スプライトを動かすことがなし
SPRITE_ANIMATABLE       = %01000000 ; スプライトアニメーション可能
SPRITE_UNANIMATABLE     = %00000000 ; スプライトアニメーションなし
SPRITE_ORIENTABLE       = %00100000 ; スプライト方向可能
SPRITE_UNORIENTABLE     = %00000000 ; スプライト方向なし
SPRITE_NUSIZ_ALL        = %00000000 ; スプライトのNUSIZの全種類使う
SPRITE_NUSIZ_UNQUADABLE = %00010000 ; スプライトのNUSIZのQuadサイズなし

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; スプライト属性(Sprite0,1Abilities)用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 各スプライトの属性情報バイト(Sprite0,1Abilities)は以下を示す
;  7bit: 移動可能かどうか
;  6bit: アニメーション可能かどうか
;  5bit: 方向づけ可能かどうか
;  4~0bit: 速度 
SPRITE_ORIENT_RIGHT     = %00000000 ; スプライトの向き右
SPRITE_ORIENT_LEFT      = %00100000 ; スプライトの向き右
SPRITE_SPEED_MASK       = %00011111 ; スプライトの速度を取得するマスク

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 共通マクロ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    MAC TIMER_SETUP
.lines  SET {1}
.cycles SET ((.lines * 76) - 13)
    if (.cycles % 64) < 12
        lda #(.cycles / 64) - 1
        sta WSYNC
        else
        lda #(.cycles / 64)
        sta WSYNC
        endif
        sta TIM64T
    ENDM

    MAC TIMER_WAIT
.waittimer
        lda INTIM
        bne .waittimer
        sta WSYNC
    ENDM
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg.u Variables
    org $80

; 111 byte / 128 byte

; 4 byte グローバルに使う用途
FrameCounter        byte ; フレームカウンタ
AnimFrameCounter    byte ; アニメーション用フレームカウンター
RandomCounter       byte ; 乱数カウンタ
RandomValue         byte ; 乱数値

; 18 byte 作業用
Tmp                 byte ; 一時変数
ZoneIndex           byte ; ゾーンインデックス(ゾーン描画中のカウンタ)
UsingHeight         byte ; 使用した高さ(ゾーンの生成時に使用)

Sprite0Info         byte ; スプライト0情報
Sprite0Height       byte ; スプライト0の高さを保持
Sprite0Gfx          word ; スプライト0のアドレス

Sprite1Info         byte ; スプライト1情報
Sprite1Height       byte ; スプライト1の高さを保持
Sprite1Gfx          word ; スプライト1のアドレス

PlayFieldHeight     byte ; プレイフィールドの高さ
PlayFieldGfx0       word ; プレイフィールド0のアドレス
PlayFieldGfx1       word ; プレイフィールド1のアドレス
PlayFieldGfx2       word ; プレイフィールド2のアドレス

; 4 byte プレイヤー関連
PlayerXPos          byte   ; プレイヤーのX座標
PlayerYPos          byte   ; プレイヤーのY座標
PlayerOrient        byte   ; プレイヤーの向き
PlayerBgColor       byte   ; プレイヤーの背景色
PlayerGfxAddr = Sprite0Gfx ; プレイヤースプライトのアドレス

; 85 byte ゾーン関連
NumberOfZones        byte ; ゾーン数

ZoneBgColors         ds MAX_NUMBER_OF_ZONES ; 各ゾーンの色
ZonePlayFieldColors  ds MAX_NUMBER_OF_ZONES ; 各ゾーンのプレイフィールドの色
ZoneHeights          ds MAX_NUMBER_OF_ZONES ; 各ゾーンの高さ
ZonePlayFieldNumbers ds MAX_NUMBER_OF_ZONES ; 各ゾーンのプレイフィールドの番号

ZoneSprite0Colors    ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0の色
ZoneSprite0XPos      ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0のX座標
ZoneSprite0Abilities ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0の属性
ZoneSprite0Nusiz     ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0のNUSIZ
ZoneSprite0Numbers   ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0の番号

ZoneSprite1Colors    ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1の色
ZoneSprite1XPos      ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1のX座標
ZoneSprite1Abilities ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1の属性
ZoneSprite1Nusiz     ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1のNUSIZ
ZoneSprite1Numbers   ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1の番号

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プログラムコードの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    seg Code
    org $F000

Start:
    CLEAN_START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 初期化の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; プレイヤー座標の初期化
    lda #60
    sta PlayerXPos
    lda #1
    sta PlayerOrient
    lda #2
    sta PlayerYPos

    ; シーンの初期化
    lda #INITIAL_RANDOM_COUNTER
    sta RandomCounter
    jsr ResetScene

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 初期化の終了
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartFrame:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 垂直同期の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    VERTICAL_SYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 処理の開始(垂直ブランクの開始)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_SETUP 37

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; カウンターの処理
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; フレームカウンターをインクリメント
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
    ;; プレイヤーの処理
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp ProcPlayer
ProcPlayerReturn:

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; 風景ゾーンの処理
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldx #0
ProcZoneLoopStart:
    stx ZoneIndex
    jmp ProcZone
ProcZoneReturn:
    ldx ZoneIndex
    inx
    cpx NumberOfZones
    bcc ProcZoneLoopStart

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 処理の終了(垂直ブランクの終了)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_WAIT
    lda #%00000000
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 描画の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; 風景ゾーンの描画
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ldx #0
RenderZoneLoopStart:
    stx ZoneIndex
    jmp RenderZone
RenderZoneReturn:
    ldx ZoneIndex
    inx
    cpx NumberOfZones
    bcc RenderZoneLoopStart

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; プレイヤーゾーンの描画
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp RenderPlayerZone
RenderPlayerZoneReturn:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 描画の終了
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 処理の開始（オーバースキャン）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_SETUP 29
    lda #%00000010
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 処理の終了（オーバースキャンの終了）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_WAIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの終了処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    jmp StartFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ゾーン用マクロ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの描画マクロ
    ;  x: ゾーンのY座標
    MAC RENDER_SPRITES
        ; スプライト0の描画
        txa
        sec
        sbc #1 ; Y座標は一旦固定で1
        cmp Sprite0Height
        bcc .DrawSprite0
        lda #0
.DrawSprite0
        tay
        lda (Sprite0Gfx),y
        sta GRP0

#if USE_SPRITE_1 = 1
        ; スプライト1の描画
        txa
        sec
        sbc #20 ; Y座標は一旦固定で20
        cmp Sprite1Height
        bcc .DrawSprite1
        lda #0
.DrawSprite1
        tay
        lda (Sprite1Gfx),y
        sta GRP1
#endif
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドの描画マクロ
    ;  x: ゾーンのY座標
    MAC RENDER_PLAYFIELD
#if USE_PLAYFIELD = 1
        txa
        cmp PlayFieldHeight
        bcc .LoadPlayfield{1}
        lda #0
.LoadPlayfield{1}
        tay
        lda (PlayFieldGfx{1}),y
        sta PF{1}
.SkipPlayField
#endif
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトをロードする
    ;  {1}: スプライト番号 なしか1
    MAC LOAD_SPRITE
        LOAD_SPRITE_INFO {1}
        _LOAD_SPRITE_HEIGHT {1}
        _CALCULATE_SPRITE_GFX {1}
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライト情報を読み取ってSpriteInfoにセットする
    ;  {1}: スプライト番号 なしか1
    MAC LOAD_SPRITE_INFO
        ldx ZoneIndex
        lda ZoneSprite{1}Numbers,x
        asl ; wordを指したいので2倍にする
        tay
        lda SpriteGfxs,y
        sta Sprite{1}Gfx
        lda SpriteGfxs,y+1
        ldy #0
        sta Sprite{1}Gfx,y+1
        lda (Sprite{1}Gfx),y
        sta Sprite{1}Info
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの高さをSpriteInfoから読み取ってSpriteHeightにセットする
    ;  {1}: スプライト番号 なしか1
    MAC _LOAD_SPRITE_HEIGHT
        ; SpriteGfxのアドレスをインクリメントして高さのアドレスを指すようにする
        lda Sprite{1}Gfx
        clc
        adc #1
        sta Sprite{1}Gfx
        ; 繰り上がり(キャリー)を上位バイトに足す
        ldy #1
        lda Sprite{1}Gfx,y
        adc #0
        sta Sprite{1}Gfx,y
        ; スプライトの高さを取得してSpriteHeightにセット
        ldy #0
        lda (Sprite{1}Gfx),y
        sta Sprite{1}Height
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; SpriteGfxが先頭を指している状態でアニメーションカウンターも考慮してSpriteGfxのアドレスを計算する
    ;  {1}: スプライト番号 なしか1
    MAC _CALCULATE_SPRITE_GFX
        ; SpriteGfxがスプライトのグラフィックのアドレスを指すようにする
        lda Sprite{1}Gfx
        clc
        adc #1
        sta Sprite{1}Gfx
        ; 繰り上がり(キャリー)を上位バイトに足す
        ldy #1
        lda Sprite{1}Gfx,y
        adc #0
        sta Sprite{1}Gfx,y
        ; スプライトのアニメーション情報を取得してスプライトのアドレスをずらす
        lda Sprite{1}Info
        and #SPRITE_ANIMATABLE
        beq .SkipSprite{1}Animation
        lda AnimFrameCounter
        and #%00000001
        ; アニメーションカウンタが1の場合はアドレスをずらす
        beq .SkipSprite{1}Animation
        lda Sprite{1}Gfx
        clc
        adc Sprite{1}Height
        sta Sprite{1}Gfx
        ; 繰り上がり(キャリー)を上位バイトに足す
        ldy #1
        lda Sprite{1}Gfx,y
        adc #0 
        sta Sprite{1}Gfx,y
.SkipSprite{1}Animation
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドをロードする
    MAC LOAD_PLAY_FIELD
        ; PlayFieldGfxの先頭アドレスを得るのとPlayFieldHeightのセット
        ldx ZoneIndex
        lda ZonePlayFieldNumbers,x
        asl
        tay
        lda PlayFieldGfxs,y
        sta PlayFieldGfx0
        lda PlayFieldGfxs,y+1
        ldy #0
        sta PlayFieldGfx0,y+1
        ldy #0
        lda (PlayFieldGfx0),y
        sta PlayFieldHeight
        ; PlayFieldGfx0がグラフィック部を指すようにインクリメント
        inc PlayFieldGfx0
        ; PlayFieldGfx1のアドレスを計算
        lda PlayFieldGfx0
        clc
        adc PlayFieldHeight
        ldy #0
        sta PlayFieldGfx1,y
        ; 繰り上がり(キャリー)を上位バイトに足す
        lda PlayFieldGfx0,y+1
        adc #0 
        sta PlayFieldGfx1,y+1
        ; PlayFieldGfx2のアドレスを指す
        lda PlayFieldGfx1
        clc
        adc PlayFieldHeight
        ldy #0
        sta PlayFieldGfx2,y
        ; 繰り上がり(キャリー)を上位バイトに足す
        lda PlayFieldGfx1,y+1
        adc #0 
        sta PlayFieldGfx2,y+1
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; SpriteInfoが移動不可の場合はジャンプする
    MAC IF_SPRITE_IS_UNMOVABLE
        lda Sprite{1}Info
        and #SPRITE_MOVABLE
        beq {2}
        ldx ZoneIndex
        lda ZoneSprite{1}Abilities,x
        and #SPRITE_MOVABLE
        beq {2}
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの移動処理
    MAC MOVE_SPRITE
.StartMove{1}
        ldx ZoneIndex
        lda ZoneSprite{1}Abilities,x
        and #SPRITE_SPEED_MASK
        sta Tmp
        lda FrameCounter
        and Tmp
        bne .EndMove{1}
        lda ZoneSprite{1}Abilities,x
        and #SPRITE_ORIENTABLE
        beq .MoveRight{1}
        jmp .MoveLeft{1}
.MoveRight{1}
        inc ZoneSprite{1}XPos,x
        lda ZoneSprite{1}XPos,x
        cmp #MAX_X
        bcc .EndMove{1}
.ResetSpriteXPosToLeft{1}
        lda #MIN_X
        sta ZoneSprite{1}XPos,x
        jmp .EndMove{1}
.MoveLeft{1}
        dec ZoneSprite{1}XPos,x
        lda ZoneSprite{1}XPos,x
        cmp #MAX_X
        bcc .EndMove{1}
.ResetSpriteXPosToRight{1}
        lda #MAX_X
        sta ZoneSprite{1}XPos,x
.EndMove{1}
    ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 風景ゾーンの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RenderZone:
    TIMER_SETUP #RENDER_ZONE_INIT_TIME

    ; まず背景色をセットしてゾーンがガタつかないようにする
    ldx ZoneIndex
    lda ZoneBgColors,x
    sta COLUBK

    ; 初期化
    lda #0
    sta PF0
    sta PF1
    sta PF2

    ; スプライト0の横位置の補正
    lda ZoneSprite0XPos,x
    ldy #0 ; プレイヤー0スプライト
    jsr SetObjectXPos

#if USE_SPRITE_1 = 1
    ; スプライト1の横位置の補正
    ldx ZoneIndex
    lda ZoneSprite1XPos,x
    ldy #1 ; プレイヤー1スプライト
    jsr SetObjectXPos
#endif

    ; 横位置の補正を適用
    sta WSYNC
    sta HMOVE

    ; スプライト0をロード
    LOAD_SPRITE 0

#if USE_SPRITE_1 = 1
    ; スプライト1をロード
    LOAD_SPRITE 1
#endif

    ; スプライト0色のセット
    ldx ZoneIndex
    lda ZoneSprite0Colors,x
    sta COLUP0
    
#if USE_SPRITE_1 = 1
    ; スプライト1色のセット
    lda ZoneSprite1Colors,x
    sta COLUP1
#endif

    ; スプライト0のNUSIZのセット
    lda ZoneSprite0Nusiz,x
    sta NUSIZ0

#if USE_SPRITE_1 = 1
    ; スプライト1のNUSIZのセット
    lda ZoneSprite1Nusiz,x
    sta NUSIZ1
#endif

    ; スプライト0の向きのセット
    lda ZoneSprite0Abilities,x
    and #SPRITE_ORIENT_LEFT
    lsr
    lsr
    sta REFP0

#if USE_SPRITE_1 = 1
    ; スプライト1の向きのセット
    lda ZoneSprite1Abilities,x
    and #SPRITE_ORIENT_LEFT
    lsr
    lsr
    sta REFP1
#endif

#if USE_PLAYFIELD = 1
    ; プレイフィールドのロード
    LOAD_PLAY_FIELD

    ; プレイフィールドの色をセット
    ldx ZoneIndex
    lda ZonePlayFieldColors,x
    sta COLUPF

    ; プレイフィールドの設定
    lda #%00000001 ; 左右ミラーリング
    sta CTRLPF
#endif

    TIMER_WAIT

    ; ゾーンの高さ分のループ
    ldy ZoneIndex
    lda ZoneHeights,y
    sec
    sbc #RENDER_ZONE_INIT_TIME ; ゾーンの初期化処理にかかった時間分ライン数を減らす
    tax

; ラインの描画(4xlineで処理するので4ライン分の処理)
.BeginRenderZoneLoop

    ; 1ライン目の処理
    sta WSYNC
    RENDER_SPRITES
    dex

    ; 2ライン目の処理
    sta WSYNC
    RENDER_PLAYFIELD 0
    RENDER_SPRITES
    dex

    ; 3ライン目の処理
    sta WSYNC
    RENDER_PLAYFIELD 1
    RENDER_SPRITES
    dex

    ; 4ライン目の処理
    sta WSYNC
    RENDER_PLAYFIELD 2
    RENDER_SPRITES
    dex
    
    beq .EndRenderZoneLoop
    jmp .BeginRenderZoneLoop
    
.EndRenderZoneLoop

    ; 後処理
#if USE_PLAYFIELD = 1
    ; 次のゾーンの初期化でプレイフィールドがクリアされるまで時間がかかるので
    ; 背景色をプレイフィールドの色にして同化させる
    lda #0
    cmp PlayFieldHeight ; 高さが0のプレイフィールドの場合は後処理は不要
    beq .SkipPlayFieldPostProc
    ldx ZoneIndex
    lda ZonePlayFieldColors,x
    sta COLUBK
.SkipPlayFieldPostProc
#endif

    jmp RenderZoneReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイヤーゾーンの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RenderPlayerZone:
    TIMER_SETUP #RENDER_ZONE_INIT_TIME
    
    ; 背景色のセット
    lda PlayerBgColor
    sta COLUBK

    ; 初期化
    lda #0
    sta PF0
    sta PF1
    sta PF2

    ; 横位置の補正
    lda PlayerXPos
    ldy #0 ; プレイヤー0スプライト
    jsr SetObjectXPos

    ; 横位置の補正を適用
    sta WSYNC
    sta HMOVE

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
    ; 繰り上がり(キャリー)を上位バイトに足す
    ldy #1
    lda PlayerGfxAddr,y
    adc #0
    sta PlayerGfxAddr,y
.SkipPlayerAnimation

    ; プレイヤーのNUSIZのセット
    lda #%00000101
    sta NUSIZ0

    ; プレイヤーの向きのセット
    lda PlayerOrient
    sta REFP0

    TIMER_WAIT

    ; プレイヤーゾーンの高さ
    lda #PLAYER_ZONE_HEIGHT
    sec
    sbc #RENDER_ZONE_INIT_TIME ; ゾーンの初期化処理にかかった時間分ライン数を減らす
    tax

    ; プレイヤーゾーンの描画を開始
.RenderPlayerZoneLoop
    sta WSYNC

    ; プレイヤーの描画要否を判定
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

    ; プレイヤーゾーンの後処理
    lda #%00000000
    sta NUSIZ0
    lda #0
    sta WSYNC
    sta COLUBK

    jmp RenderPlayerZoneReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 風景ゾーンの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcZone
    ; SPRITE_MOVABLEでなければ移動処理はスキップ
    LOAD_SPRITE_INFO 0
    IF_SPRITE_IS_UNMOVABLE 0,EnvMove0

    ; スプライト0の移動処理
    MOVE_SPRITE 0
EnvMove0

#if USE_SPRITE_1 = 1
    ; SPRITE_MOVABLEでなければ移動処理はスキップ
    LOAD_SPRITE_INFO 1
    IF_SPRITE_IS_UNMOVABLE 1,EndMove1

    ; スプライト1の移動処理
    MOVE_SPRITE 1
EndMove1
#endif

.EndMove
    jmp ProcZoneReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイヤーの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcPlayer:
    lda #%00010000
    bit SWCHA
    bne .SkipMoveUp
    jsr ResetRandomCounter
    jsr ResetScene
.SkipMoveUp:
    lda #%00100000
    bit SWCHA
    bne .SkipMoveDown
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
    ; 初期化
    lda #0
    sta UsingHeight

    ; プレイヤー背景色を決定
    jsr NextRandomValue
    lda RandomValue
    sta PlayerBgColor

    ; 各ゾーンの初期化
    ldx #0
.InitializeZoneLoop
    stx ZoneIndex

    ; 初期化
    lda #0
    sta ZoneSprite0Abilities,x
    sta ZoneSprite1Abilities,x

    ; ゾーンの高さをランダムで決定
    jsr NextRandomValue
    lda RandomValue
    and #MAX_ZONE_HEIGHT - #MIN_ZONE_HEIGHT - #1
    clc
    adc #MIN_ZONE_HEIGHT

    ; 高さが4の倍数になるように丸める(各ゾーンで4xline処理をするので4の倍数である必要がある)
    and #%11111100
    sta ZoneHeights,x

    ; ゾーンの色を決定
    lda RandomValue
    sta ZoneBgColors,x

    ; プレイフィールドの決定
    jsr NextRandomValue
    lda RandomValue
    and #NUMBER_OF_PLAY_FIELDS_MASK
    sta ZonePlayFieldNumbers,x
    
    ; プレイフィールドの色を決定
    jsr NextRandomValue
    lda RandomValue
    sta ZonePlayFieldColors,x

    ; スプライト0を決定
    jsr NextRandomValue
    lda RandomValue
    and #NUMBER_OF_SPRITES_MASK
    sta ZoneSprite0Numbers,x
    LOAD_SPRITE_INFO 0

#if USE_SPRITE_1 = 1
    ; スプライト1を決定
    jsr NextRandomValue
    lda RandomValue
    and #NUMBER_OF_SPRITES_MASK
    sta ZoneSprite1Numbers,x
    LOAD_SPRITE_INFO 1
#endif

    ; スプライト0の色を決定
    jsr NextRandomValue
    lda RandomValue
    sta ZoneSprite0Colors,x

#if USE_SPRITE_1 = 1
    ; スプライト1の色を決定
    jsr NextRandomValue
    lda RandomValue
    sta ZoneSprite1Colors,x
#endif

    ; スプライト0のX座標の初期値を決定
    jsr NextRandomValue
    lda RandomValue
    and #%01111111
    sta ZoneSprite0XPos,x

#if USE_SPRITE_1 = 1
    ; スプライト1のX座標の初期値を決定
    jsr NextRandomValue
    lda RandomValue
    and #%01111111
    sta ZoneSprite1XPos,x
#endif

    ; スプライト0の向きを決定
    lda Sprite0Info
    and #SPRITE_ORIENTABLE
    beq .SkipSetZoneSprite0Orient ; SPRITE_ORIENTABLEでなければスキップ
    jsr NextRandomValue
    lda RandomValue
    and #%00000001
    beq .SetZoneSprite0OrientRight
    lda ZoneSprite0Abilities,x
    ora #SPRITE_ORIENT_LEFT
    jmp .SetZoneSprite0OrientEnd
.SetZoneSprite0OrientRight 
    lda ZoneSprite0Abilities,x
    ora #SPRITE_ORIENT_RIGHT
.SetZoneSprite0OrientEnd 
    sta ZoneSprite0Abilities,x
.SkipSetZoneSprite0Orient

#if USE_SPRITE_1 = 1
    ; スプライト1の向きを決定
    lda Sprite1Info
    and #SPRITE_ORIENTABLE
    beq .SkipSetZoneSprite1Orient ; SPRITE_ORIENTABLEでなければスキップ
    jsr NextRandomValue
    lda RandomValue
    and #%00000001
    beq .SetZoneSprite1OrientRight
    lda ZoneSprite1Abilities,x
    ora #SPRITE_ORIENT_LEFT
    jmp .SetZoneSprite1OrientEnd
.SetZoneSprite1OrientRight
    lda ZoneSprite1Abilities,x
    ora #SPRITE_ORIENT_RIGHT
.SetZoneSprite1OrientEnd
    sta ZoneSprite1Abilities,x
.SkipSetZoneSprite1Orient
#endif

    ; スプライト0の速さを決定
    jsr NextRandomValue
    lda RandomValue
    and #NUMBER_OF_SPEEDS_MASK
    tay 
    lda ZoneSprite0Abilities,x
    ora SpeedTable,y
    sta ZoneSprite0Abilities,x

#if USE_SPRITE_1 = 1
    ; スプライト1の速さを決定
    jsr NextRandomValue
    lda RandomValue
    and #NUMBER_OF_SPEEDS_MASK
    tay
    lda ZoneSprite1Abilities,x
    ora SpeedTable,y
    sta ZoneSprite1Abilities,x
#endif

    ; スプライト0の移動可否を決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000001
    beq .SetZoneSprite0Unmovable
    lda ZoneSprite0Abilities,x
    ora #SPRITE_MOVABLE
    jmp .SetZoneSprite0MovableEnd
.SetZoneSprite0Unmovable
    lda ZoneSprite0Abilities,x
    ora #SPRITE_UNMOVABLE
.SetZoneSprite0MovableEnd 
    sta ZoneSprite0Abilities,x

#if USE_SPRITE_1 = 1
    ; スプライト1の移動可否を決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000001
    beq .SetZoneSprite1Unmovable
    lda ZoneSprite1Abilities,x
    ora #SPRITE_MOVABLE
    jmp .SetZoneSprite1MovableEnd
.SetZoneSprite1Unmovable
    lda ZoneSprite1Abilities,x
    ora #SPRITE_UNMOVABLE
.SetZoneSprite1MovableEnd 
    sta ZoneSprite1Abilities,x
#endif

    ; スプライト0のNUSIZを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000111
    tay
    lda Sprite0Info
    and #SPRITE_NUSIZ_UNQUADABLE
    bne .SetSprite0NusizUnwideable
    lda NUSIZTableAll,y
    jmp .EndSprite0Nusiz
.SetSprite0NusizUnwideable
    lda NUSIZTableUnwideable,y
.EndSprite0Nusiz
    sta ZoneSprite0Nusiz,x

#if USE_SPRITE_1 = 1
    ; スプライト1のNUSIZを決定
    jsr NextRandomValue
    lda RandomValue
    and #%00000111
    tay
    lda Sprite1Info
    and #SPRITE_NUSIZ_UNQUADABLE
    bne .SetSprite1NusizUnwideable
    lda NUSIZTableAll,y
    jmp .EndSprite1Nusiz
.SetSprite1NusizUnwideable
    lda NUSIZTableUnwideable,y
.EndSprite1Nusiz
    sta ZoneSprite1Nusiz,x
#endif

    ; ゾーンの高さの合計を保持
    lda UsingHeight
    adc ZoneHeights,x
    sta UsingHeight

    ; ゾーンの合計の高さが風景に使える高さを超えていないかチェック
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

    ; ゾーン数を計算してセット(ゾーンインデックスに1を足してゾーン数とする)
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
; 乱数をリセットする
ResetRandomCounter subroutine
    lda FrameCounter
    sta RandomCounter
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
    jsr ResetRandomCounter
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
    jsr ResetRandomCounter
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
;; プレイヤーデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
    .byte %00001000 ; |    X   |
    .byte %00010100 ; |   X X  |
    .byte %00000000 ; |        |

; プレイヤースプライトカラー
PlayerGfxColor:
    .byte $00
    .byte $16
    .byte $26
    .byte $36
    .byte $46
    .byte $56
    .byte $66
    .byte $76
    .byte $86
    .byte $86
    .byte $86
    .byte $86
    .byte $86
    .byte $86

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイフィールドデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayFieldGfxs:
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldBuildingGfx
    .word PlayFieldBuildingGfx
    .word PlayFieldBuildingGfx
    .word PlayFieldMountainGfx
    .word PlayFieldMountainGfx

PlayFieldNoneGfx:
    .byte #0
    .byte %00000000 ; |        |
   
PlayFieldBuildingGfx:
    .byte #18
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

PlayFieldMountainGfx:
    .byte #18
    .byte %00000000 ; |        |
    .byte %11110000 ; |XXXX    |
    .byte %11110000 ; |XXXX    |
    .byte %11000000 ; |XX      |
    .byte %11000000 ; |XX      |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |

    .byte %00000000 ; |        |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %00111111 ; |  XXXXXX|
    .byte %00111111 ; |  XXXXXX|
    .byte %00001111 ; |    XXXX|
    .byte %00001111 ; |    XXXX|
    .byte %00000011 ; |      XX|
    .byte %00000011 ; |      XX|
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |

    .byte %00000000 ; |        |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111100 ; |XXXXXX  |
    .byte %11110000 ; |XXXX    |
    .byte %11110000 ; |XXXX    |
    .byte %00000000 ; |        |

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; スプライトデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
    .word DonkeyKongGfx
    .word ETGfx
    .word Walker1Gfx
    .word Walker2Gfx
    .word Walker3Gfx
    .word Walker4Gfx
    .word Walker5Gfx
    ; 16~23
    .word Walker6Gfx
    .word Walker7Gfx
    .word Walker8Gfx
    .word Dragonstomper1Gfx
    .word Dragonstomper2Gfx
    .word Dragonstomper3Gfx
    .word Dragonstomper4Gfx
    .word SpringerGfx
    ; 24~31
    .word SkyPatrolGfx
    .word BobbyGfx
    .word RaftRiderGfx
    .word DungeonMasterGfx
    .word LynxGfx
    .word RabbitTransitGfx
    .word PitfallGfx
    .word MontezumaGfx

BearGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #20
    .byte %00000000 ; |        |
    .byte %11100000 ; |###     |
    .byte %11100000 ; |###     |
    .byte %01100111 ; | ##  ###|
    .byte %01100111 ; | ##  ###|
    .byte %01111110 ; | ###### |
    .byte %01111110 ; | ###### |
    .byte %00111110 ; |  ##### |
    .byte %01011110 ; | # #### |
    .byte %11011100 ; |## ###  |
    .byte %10111100 ; |# ####  |
    .byte %11111110 ; |####### |
    .byte %11111111 ; |########|
    .byte %01111111 ; | #######|
    .byte %00111001 ; |  ###  #|
    .byte %01000101 ; | #   # #|
    .byte %01101101 ; | ## ## #|
    .byte %01010101 ; | # # # #|
    .byte %01111100 ; | #####  |
    .byte %00101000 ; |  # #   |

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
    .byte %00111110 ; |  XXXXX |
    .byte %00010100 ; |   X X  |

CloudGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #13
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
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #14
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
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #18
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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #8
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
    .byte %01000000 ; | X      |
    .byte %00110000 ; |  XX    |
    .byte %01111000 ; | XXXX   |
    .byte %11111100 ; |XXXXXX  |
    .byte %00110110 ; |  XX XX |
    .byte %11100100 ; |XXX  X  |

FishGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #11
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
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #9
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
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #11
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
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #15
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
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #10
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
    
DonkeyKongGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #20
    .byte %00000000 ; |        |
    .byte %11100000 ; |###     |
    .byte %11100000 ; |###     |
    .byte %01100111 ; | ##  ###|
    .byte %01100111 ; | ##  ###|
    .byte %01111110 ; | ###### |
    .byte %01111110 ; | ###### |
    .byte %00111110 ; |  ##### |
    .byte %01011110 ; | # #### |
    .byte %11011100 ; |## ###  |
    .byte %10111100 ; |# ####  |
    .byte %11111110 ; |####### |
    .byte %11111111 ; |########|
    .byte %01111111 ; | #######|
    .byte %00111001 ; |  ###  #|
    .byte %01000101 ; | #   # #|
    .byte %01111101 ; | ##### #|
    .byte %01010101 ; | # # # #|
    .byte %01111100 ; | #####  |
    .byte %00111000 ; |  ###   |

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
    .byte %10111110 ; |X XXXXX |
    .byte %10101010 ; |X X X X |
    .byte %00111110 ; |  XXXXX |
    .byte %00011100 ; |   XXX  |

ETGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #16
    .byte %00000000 ; |        |
    .byte %11100111 ; |XXX  XXX|
    .byte %01100011 ; | XX   XX|
    .byte %00101011 ; |  X X XX|
    .byte %00111111 ; |  XXXXXX|
    .byte %00111111 ; |  XXXXXX|
    .byte %10111111 ; |X XXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %00011111 ; |   XXXXX|
    .byte %00001111 ; |    XXXX|
    .byte %00000011 ; |      XX|
    .byte %11000011 ; |XX    XX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %10111111 ; |X XXXXXX|
    .byte %11111110 ; |XXXXXXX |

Walker1Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #19
    .byte %00000000 ; |        |
    .byte %00011100 ; |   ###  |
    .byte %00111110 ; |  ##### |
    .byte %01111100 ; | #####  |
    .byte %00111111 ; |  ######|
    .byte %11111100 ; |######  |
    .byte %00111111 ; |  ######|
    .byte %01111100 ; | #####  |
    .byte %00111111 ; |  ######|
    .byte %01111110 ; | ###### |
    .byte %00111100 ; |  ####  |
    .byte %01111110 ; | ###### |
    .byte %00011100 ; |   ###  |
    .byte %00111000 ; |  ###   |
    .byte %00011100 ; |   ###  |
    .byte %00011000 ; |   ##   |
    .byte %00001100 ; |    ##  |
    .byte %00001000 ; |    #   |
    .byte %00001000 ; |    #   |
    
Walker2Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #19
    .byte %00000000 ; |        |
    .byte %00011000 ; |   XX   |
    .byte %00011000 ; |   XX   |
    .byte %11111111 ; |XXXXXXXX|
    .byte %01111110 ; | XXXXXX |
    .byte %00111100 ; |  XXXX  |
    .byte %01111111 ; | XXXXXXX|
    .byte %00111100 ; |  XXXX  |
    .byte %11111111 ; |XXXXXXXX|
    .byte %01111110 ; | XXXXXX |
    .byte %00111111 ; |  XXXXXX|
    .byte %11111110 ; |XXXXXXX |
    .byte %01111100 ; | XXXXX  |
    .byte %00111111 ; |  XXXXXX|
    .byte %00011110 ; |   XXXX |
    .byte %01111100 ; | XXXXX  |
    .byte %00111110 ; |  XXXXX |
    .byte %00011100 ; |   XXX  |
    .byte %00000001 ; |       X|
        
Walker3Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #9
    .byte %00000000 ; |        |
    .byte %00011000 ; |   ##   |
    .byte %00011000 ; |   ##   |
    .byte %00011000 ; |   ##   |
    .byte %01111110 ; | ###### |
    .byte %11111111 ; |########|
    .byte %11111111 ; |########|
    .byte %01111110 ; | ###### |
    .byte %00111100 ; |  ####  |

Walker4Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #8
    .byte %00000000 ; |        |
    .byte %11111111 ; |########|
    .byte %10011001 ; |#  ##  #|
    .byte %10011001 ; |#  ##  #|
    .byte %11111111 ; |########|
    .byte %11111111 ; |########|
    .byte %01111110 ; | ###### |

Walker5Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #12
    .byte %00000000 ; |        |
    .byte %11111111 ; |########|
    .byte %11111111 ; |########|
    .byte %11111111 ; |########|
    .byte %10011001 ; |#  ##  #|
    .byte %10011001 ; |#  ##  #|
    .byte %11111111 ; |########|
    .byte %11111111 ; |########|
    .byte %01111110 ; | ###### |
    .byte %01111110 ; | ###### |
    .byte %01100000 ; | ##     |
    .byte %01100000 ; | ##     |

Walker6Gfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #9
    .byte %00000000 ; |        |
    .byte %10100010 ; |X X   X |
    .byte %01010101 ; | X X X X|
    .byte %00111010 ; |  XXX X |
    .byte %01111100 ; | XXXXX  |
    .byte %10110100 ; |X XX X  |
    .byte %00000111 ; |     XXX|
    .byte %00000110 ; |     XX |
    .byte %00001010 ; |    X X |

    .byte %00000000 ; |        |
    .byte %00101000 ; |  X X   |
    .byte %01010100 ; | X X X  |
    .byte %10111010 ; |X XXX X |
    .byte %01111100 ; | XXXXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00000111 ; |     XXX|
    .byte %00000110 ; |     XX |
    .byte %00001010 ; |    X X |

Walker7Gfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #9
    .byte %00000000 ; |        |
    .byte %01001001 ; | X  X  X|
    .byte %00110011 ; |  XX  XX|
    .byte %00111100 ; |  XXXX  |
    .byte %01111010 ; | XXXX X |
    .byte %11000100 ; |XX   X  |
    .byte %10010010 ; |X  X  X |
    .byte %11011000 ; |XX XX   |
    .byte %01110000 ; | XXX    |

    .byte %00000000 ; |        |
    .byte %10000101 ; |X    X X|
    .byte %00110010 ; |  XX  X |
    .byte %00111101 ; |  XXXX X|
    .byte %01111000 ; | XXXX   |
    .byte %11000110 ; |XX   XX |
    .byte %10010010 ; |X  X  X |
    .byte %11011000 ; |XX XX   |
    .byte %01110000 ; | XXX    |

Walker8Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #7
    .byte %00000000 ; |        |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %01111110 ; | XXXXXX |
    .byte %01111110 ; | XXXXXX |
    .byte %00111100 ; |  XXXX  |
    .byte %00011000 ; |   XX   |

Dragonstomper1Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #20
    .byte %00000000 ; |        |
    .byte %00011000 ; |   XX   |
    .byte %00111100 ; |  XXXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00011000 ; |   XX   |
    .byte %11000011 ; |XX    XX|
    .byte %01111110 ; | XXXXXX |
    .byte %00011000 ; |   XX   |
    .byte %11111111 ; |XXXXXXXX|
    .byte %00011000 ; |   XX   |
    .byte %01111110 ; | XXXXXX |
    .byte %11000011 ; |XX    XX|
    .byte %00011000 ; |   XX   |
    .byte %00111100 ; |  XXXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00011000 ; |   XX   |
    .byte %00100100 ; |  X  X  |
    .byte %00100100 ; |  X  X  |
    .byte %01000010 ; | X    X |
    .byte %10000001 ; |X      X|
    
Dragonstomper2Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #16
    .byte %00000000 ; |        |
    .byte %10011001 ; |X  XX  X|
    .byte %10111101 ; |X XXXX X|
    .byte %01111110 ; | XXXXXX |
    .byte %00111100 ; |  XXXX  |
    .byte %10111101 ; |X XXXX X|
    .byte %01111110 ; | XXXXXX |
    .byte %00111100 ; |  XXXX  |
    .byte %10111101 ; |X XXXX X|
    .byte %01111110 ; | XXXXXX |
    .byte %00011000 ; |   XX   |
    .byte %00111100 ; |  XXXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00011000 ; |   XX   |
    .byte %00100100 ; |  X  X  |
    .byte %11000011 ; |XX    XX|
    
Dragonstomper3Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #12
    .byte %00000000 ; |        |
    .byte %11001100 ; |XX  XX  |
    .byte %01001000 ; | X  X   |
    .byte %01111000 ; | XXXX   |
    .byte %00110000 ; |  XX    |
    .byte %00110000 ; |  XX    |
    .byte %01111000 ; | XXXX   |
    .byte %11111100 ; |XXXXXX  |
    .byte %10110100 ; |X XX X  |
    .byte %10110100 ; |X XX X  |
    .byte %10000100 ; |X    X  |
    .byte %01001000 ; | X  X   |

Dragonstomper4Gfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_ANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #15
    .byte %00000000 ; |        |
    .byte %01111100 ; | XXXXX  |
    .byte %00111000 ; |  XXX   |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %10010000 ; |X  X    |
    .byte %01010100 ; | X X X  |
    .byte %10111000 ; |X XXX   |
    .byte %11100000 ; |XXX     |
    .byte %01011000 ; | X XX   |
    .byte %00001110 ; |    XXX |

    .byte %00000000 ; |        |
    .byte %01111100 ; | XXXXX  |
    .byte %00111000 ; |  XXX   |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010100 ; |   X X  |
    .byte %01010100 ; | X X X  |
    .byte %00111000 ; |  XXX   |
    .byte %11010011 ; |XX X  XX|
    .byte %01101110 ; | XX XXX |
    .byte %00000000 ; |        |

SpringerGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #14
    .byte %00000000 ; |        | 
    .byte %01001100 ; | X  XX  |
    .byte %01111000 ; | XXXX   |
    .byte %00011000 ; |   XX   |
    .byte %11111100 ; |XXXXXX  |
    .byte %01111100 ; | XXXXX  |
    .byte %01111100 ; | XXXXX  |
    .byte %00010000 ; |   X    |
    .byte %00111100 ; |  XXXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00111000 ; |  XXX   |
    .byte %00101000 ; |  X X   |
    .byte %01000100 ; | X   X  |
    .byte %11000110 ; |XX   XX |

    .byte %00000000 ; |        |
    .byte %00011000 ; |   XX   |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %11111100 ; |XXXXXX  |
    .byte %01111100 ; | XXXXX  |
    .byte %01111100 ; | XXXXX  |
    .byte %00010000 ; |   X    |
    .byte %00111100 ; |  XXXX  |
    .byte %00111100 ; |  XXXX  |
    .byte %00111000 ; |  XXX   |
    .byte %00101000 ; |  X X   |
    .byte %01000100 ; | X   X  |
    .byte %11000110 ; |XX   XX |

SkyPatrolGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #14
    .byte %00000000 ; |        |
    .byte %01011000 ; | X XX   |
    .byte %00111000 ; |  XXX   |
    .byte %00011001 ; |   XX  X|
    .byte %11011110 ; |XX XXXX |
    .byte %01111100 ; | XXXXX  |
    .byte %00111001 ; |  XXX  X|
    .byte %01011010 ; | X XX X |
    .byte %00111100 ; |  XXXX  |
    .byte %00011000 ; |   XX   |
    .byte %01011000 ; | X XX   |
    .byte %00111010 ; |  XXX X |
    .byte %00011100 ; |   XXX  |
    .byte %00001000 ; |    X   |

BobbyGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #9
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00101000 ; |  X X   |
    .byte %01111100 ; | XXXXX  |
    .byte %01010100 ; | X X X  |
    .byte %10010010 ; |X  X  X |
    .byte %10101010 ; |X X X X |
    .byte %10000010 ; |X     X |
    .byte %01000100 ; | X   X  |

    .byte %00000000 ; |        |
    .byte %01000100 ; | X   X  |
    .byte %10000010 ; |X     X |
    .byte %01010100 ; | X X X  |
    .byte %00111000 ; |  XXX   |
    .byte %00010000 ; |   X    |
    .byte %00101000 ; |  X X   |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |

RaftRiderGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #21
    .byte %00000000 ; |        |
    .byte %00001000 ; |    X   |
    .byte %00001000 ; |    X   |
    .byte %00001000 ; |    X   |
    .byte %00011100 ; |   XXX  |
    .byte %01111110 ; | XXXXXX |
    .byte %01111110 ; | XXXXXX |
    .byte %10001001 ; |X   X  X|
    .byte %00001000 ; |    X   |
    .byte %00111110 ; |  XXXXX |
    .byte %01111110 ; | XXXXXX |
    .byte %01001001 ; | X  X  X|
    .byte %00001100 ; |    XX  |
    .byte %00011100 ; |   XXX  |
    .byte %00011110 ; |   XXXX |
    .byte %00101010 ; |  X X X |
    .byte %00001001 ; |    X  X|
    .byte %00011100 ; |   XXX  |
    .byte %00101010 ; |  X X X |
    .byte %00001000 ; |    X   |
    .byte %00001000 ; |    X   |

DungeonMasterGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #8
    .byte %00000000 ; |        |
    .byte %00111000 ; |  XXX   |
    .byte %01111100 ; | XXXXX  |
    .byte %11111110 ; |XXXXXXX |
    .byte %11111110 ; |XXXXXXX |
    .byte %01111100 ; | XXXXX  |
    .byte %00010000 ; |   X    |
    .byte %00001000 ; |    X   |

LynxGfx:
    .byte #SPRITE_UNMOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #12
    .byte %00000000 ; |        |
    .byte %10010101 ; |X  X X X|
    .byte %10010101 ; |X  X X X|
    .byte %11010010 ; |XX X  X |
    .byte %11100110 ; |XXX  XX |
    .byte %01111100 ; | XXXXX  |
    .byte %01111010 ; | XXXX X |
    .byte %01111111 ; | XXXXXXX|
    .byte %00111010 ; |  XXX X |
    .byte %01000101 ; | X   X X|
    .byte %10000111 ; |X    XXX|
    .byte %00000101 ; |     X X|

RabbitTransitGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #6
    .byte %00000000 ; |        |
    .byte %00001000 ; |    X   |
    .byte %11011101 ; |XX XXX X|
    .byte %01110110 ; | XXX XX |
    .byte %00100011 ; |  X   XX|
    .byte %00000010 ; |      X |

    .byte %00000000 ; |        |
    .byte %00010000 ; |   X    |
    .byte %00111000 ; |  XXX   |
    .byte %11101111 ; |XXX XXXX|
    .byte %01000111 ; | X   XXX|
    .byte %00000010 ; |      X |

PitfallGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #10
    .byte %00000000 ; |        |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11010101 ; |XX X X X|
    .byte %10101010 ; |X X X X |
    .byte %11111111 ; |XXXXXXXX|
    .byte %01100000 ; | XX     |
    .byte %00100000 ; |  X     |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |
    .byte %00000000 ; |        |

    .byte %00000000 ; |        |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11010101 ; |XX X X X|
    .byte %11000000 ; |XX      |
    .byte %11000000 ; |XX      |
    .byte %11010000 ; |XX X    |
    .byte %01110100 ; | XXX X  |
    .byte %01011101 ; | X XXX X|
    .byte %00000111 ; |     XXX|
    .byte %00000001 ; |       X|

MontezumaGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL

    .byte #12
    .byte %00000000 ; |        |
    .byte %00011001 ; |   XX  X|
    .byte %10111101 ; |X XXXX X|
    .byte %10111111 ; |X XXXXXX|
    .byte %11111110 ; |XXXXXXX |
    .byte %01011101 ; | X XXX X|
    .byte %10111111 ; |X XXXXXX|
    .byte %11111010 ; |XXXXX X |
    .byte %01011101 ; | X XXX X|
    .byte %10110111 ; |X XX XXX|
    .byte %11100010 ; |XXX   X |
    .byte %01000000 ; | X      |

    .byte %00000000 ; |        |
    .byte %10011000 ; |X  XX   |
    .byte %10111101 ; |X XXXX X|
    .byte %11111101 ; |XXXXXX X|
    .byte %01111111 ; | XXXXXXX|
    .byte %10111110 ; |X XXXXX |
    .byte %11111101 ; |XXXXXX X|
    .byte %01011111 ; | X XXXXX|
    .byte %10111010 ; |X XXX X |
    .byte %11101101 ; |XXX XX X|
    .byte %01000111 ; | X   XXX|
    .byte %00000010 ; |      X |

; 速度の種類テーブル
SpeedTable:
    .byte %00000001
    .byte %00000011
    .byte %00000111
    .byte %00001111

; NUSIZの種類テーブル
NUSIZTableAll:
    .byte #%00000000 ; One copy
    .byte #%00000001 ; Two copies, close
    .byte #%00000010 ; Two copies, medium
    .byte #%00000011 ; Three copies, close
    .byte #%00000100 ; Two copies, wide
    .byte #%00000101 ; Double-size player
    .byte #%00000110 ; Three copies, medium
    .byte #%00000111 ; Quad-size player 

; NUSIZの最大サイズを抜いた種類テーブル
NUSIZTableUnwideable:
    .byte #%00000000 ; One copy
    .byte #%00000000 ; One copy
    .byte #%00000001 ; Two copies, close
    .byte #%00000010 ; Two copies, medium
    .byte #%00000011 ; Three copies, close
    .byte #%00000100 ; Two copies, wide
    .byte #%00000101 ; Double-size player
    .byte #%00000110 ; Three copies, medium

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
    word Start
    word Start
