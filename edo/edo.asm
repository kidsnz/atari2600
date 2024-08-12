    processor 6502

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; インクルード文
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    include "vcs.h"
    include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; デバッグ用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 開発時は1を指定する
DEBUG = 0

; 開発したいバンクを指定する
;  0: タイトル
;  1: シーン
DEBUG_BANK = 0

; 乱数カウンターの初期値
INITIAL_RANDOM_COUNTER   = 0
INITIAL_RANDOM_COUNTER_2 = 128
; INITIAL_RANDOM_COUNTER = 2 ; 初期化が間に合わないシーン
; INITIAL_RANDOM_COUNTER = 24 ; 縦ズレが確認できるシーン

; スプライト1を使う
USE_SPRITE_1 = 1

; プレイフィールドを使う
USE_PLAYFIELD = 1

; 音楽を使う
USE_MUSIC = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; カラーコード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PLAYER_GFX_HEIGHT          = 14  ; プレイヤーの高さ
PLAYER_STATUS_IS_JUMPING   = %00000001 ; ジャンプ中かどうかのマスク
PLAYER_GRAVITY             = 1   ; プレイヤーの重力
PLAYER_INITIAL_VELOCITY    = 4   ; プレイヤーの初速度
MAX_LINES                  = 192 ; スキャンライン数 
MAX_NUMBER_OF_ZONES        = 5   ; ゾーンの最大数
MIN_ZONE_HEIGHT            = 24  ; ゾーンの最小の高さ
MAX_ZONE_HEIGHT            = 64  ; ゾーンの最大の高さ
PLAYER_ZONE_HEIGHT         = 32  ; プレイヤーのゾーンの高さ
MAX_X                      = 160 ; X座標の最大値
MIN_X                      = 0   ; X座標の最小値
MIN_Y                      = 2   ; Y座標の最小値
LANDSCAPE_ZONE_HEIGHT      = MAX_LINES - PLAYER_ZONE_HEIGHT ; 風景ゾーンの高さ
NUMBER_OF_SPRITES_MASK     = %00111111 ; スプライトの数のマスク
NUMBER_OF_PLAY_FIELDS_MASK = %00001111 ; プレイフィールドの数のマスク
NUMBER_OF_SPEEDS_MASK      = %00000011 ; スプライトの速度の数のマスク
ORIENT_LEFT                = %00001000 ; 左向き
ORIENT_RIGHT               = %00000000 ; 右向き
RENDER_ZONE_INIT_TIME      = 12  ; ゾーン描画の初期化処理に使う時間(ライン数) 4xlinesで処理しているので4の倍数である必要がある
TITLE_GFX_HEIGHT           = 100  ; タイトルの高さ
TITLE_MUSIC_LENGTH         = 128  ; タイトル音楽の長さ
TITLE_MUSIC_TONE           = 12  ; タイトル音楽のトーン(0~15)
TITLE_MUSIC_VOLUME         = 3   ; タイトル音楽の音量(0~15)
TITLE_MUSIC_PITCH          = 16  ; タイトル音楽のピッチ(2の乗数で指定する。大きいほど音の間隔が長い)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; スプライト情報用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 各スプライトの先頭バイトは以下を示す
;  7bit: 移動可能かどうか
;  6bit: アニメーション可能かどうか
;  5bit: 方向づけ可能かどうか
;  4bit: NUSIZの種類(0: ALL, 1: UNWIDEABLE)
;  3bit: 移動のパターン(0: LINEAR, 1: PULSED)
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
SPRITE_MOVING_LINEAR    = %00000000 ; スプライトが線形に動く
SPRITE_MOVING_PULSED    = %00001000 ; スプライトがパルス(停止と動くが周期的)に動く

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; スプライト属性(Sprite0,1Abilities)用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 各スプライトの属性情報バイト(Sprite0,1Abilities)は以下を示す
;  7bit: 移動が有効
;  6bit: アニメーションが有効
;  5bit: 方向
;  4bit: 空き
;  3bit: 移動のパターン(0: LINEAR, 1: PULSED)
;  2bit: 空き
;  1~0bit: 速度番号
SPRITE_MOVING_ON        = %10000000 ; スプライトの移動ON
SPRITE_ANIMATION_ON     = %01000000 ; スプライトの向き右
SPRITE_ORIENT_RIGHT     = %00000000 ; スプライトの向き右
SPRITE_ORIENT_LEFT      = %00100000 ; スプライトの向き右
SPRITE_SPEED_MASK       = %00000011 ; スプライトの速度を取得するマスク

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイフィールド情報用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PLAYFIELD_UNMIRRORING = %00000000 ; プレイフィールドをミラーリングしない
PLAYFIELD_MIRRORING   = %00000001 ; プレイフィールドをミラーリングする

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 汎用マクロ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; 指定のライン数のタイマーをセットする
    ;  {1}: ライン数
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

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; タイマーを待機する
    MAC TIMER_WAIT
.waittimer
        lda INTIM
        bne .waittimer
        sta WSYNC
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; 指定のメモリのアドレスに加算する
    ;  {1}: 加算対象のメモリ
    ;  {2}: 加算する値
    MAC ADD_ADDRESS
        lda {1}
        clc
        adc {2}
        sta {1}
        ; 繰り上がり(キャリー)を上位バイトに足す
        ldy #0
        lda {1},y+1
        adc #0
        sta {1},y+1
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; 指定のメモリのアドレスをコピーする
    ;  {1}: コピー元メモリ
    ;  {2}: コピー先メモリ
    ;  {3}: 加算する値
    MAC COPY_AND_ADD_ADDRESS
        lda {1}
        clc
        adc {3}
        ldy #0
        sta {2},y
        ; 繰り上がり(キャリー)を上位バイトに足す
        lda {1},y+1
        adc #0 
        sta {2},y+1
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; 指定のメモリのアドレスをコピーする
    ;  {1}: 周波数(0~32)
    ;  {2}: 音量(0~8)
    MAC SOUND
.freq	SET {1}
.vol	SET {2}
	.byte (.vol+(.freq<<3))
    ENDM

#if DEBUG = 0
    MAC BANK_SWITCH_TRAMPOLINE
        pha             ; push hi byte
        tya             ; Y -> A
        pha             ; push lo byte
        lda $1FF8,x     ; do the bank switch
        rts             ; return to target
    ENDM

    MAC BANK_SWITCH
.Bank   SET {1}
.Addr   SET {2}
        lda #>(.Addr-1)
        ldy #<(.Addr-1)
        ldx #.Bank
        jmp BankSwitch
    ENDM

; Bank prologue that handles reset
; no matter which bank is selected at powerup
; it switches to bank 0 and jumps to Reset_0
    MAC BANK_PROLOGUE
        lda #>(Reset_0-1)
        ldy #<(Reset_0-1)
        ldx #$ff
        txs
        inx
    ENDM

    MAC BANK_VECTORS
        .word Start ; NMI
        .word Start ; RESET
        .word Start    ; BRK
    ENDM
#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg.u Variables
    org $80

; 117 byte / 128 byte

; 6 byte グローバルに使う用途
FrameCounter        byte ; フレームカウンタ
AnimFrameCounter    byte ; アニメーション用フレームカウンター
MusicFrameCounter   byte ; ミュージック用フレームカウンター
RandomCounter       byte ; 乱数カウンタ
RandomCounter2      byte ; 乱数カウンタ2
RandomValue         byte ; 乱数値

; 24 byte 作業用
Tmp                 byte ; 一時変数
ZoneIndex           byte ; ゾーンインデックス(ゾーン描画中のカウンタ)
UsingHeight         byte ; 使用した高さ(ゾーンの生成時に使用)

Sprite0Info         byte ; スプライト0情報を保持
Sprite0Height       byte ; スプライト0の高さを保持
Sprite0YPos         byte ; スプライト0のY座標を保持
Sprite0Gfx          word ; スプライト0のアドレスを保持

Sprite1Info         byte ; スプライト1情報を保持
Sprite1Height       byte ; スプライト1の高さを保持
Sprite1YPos         byte ; スプライト1のY座標を保持
Sprite1Gfx          word ; スプライト1のアドレスを保持

PlayFieldInfo       byte ; プレイフィールド情報を保持
PlayFieldHeight     byte ; プレイフィールドの高さを保持
PlayFieldGfx0       word ; プレイフィールド0のアドレスを保持
PlayFieldGfx1       word ; プレイフィールド1のアドレスを保持
PlayFieldGfx2       word ; プレイフィールド2のアドレスを保持

PF0Buffer           byte ; PF0のバッファ
PF1Buffer           byte ; PF1のバッファ
PF2Buffer           byte ; PF2のバッファ

; 6 byte プレイヤー関連
PlayerXPos          byte   ; プレイヤーのX座標
PlayerYPos          byte   ; プレイヤーのY座標
PlayerVelocity      byte   ; プレイヤーの加速度
PlayerStatus        byte   ; プレイヤーの状態(0~6bit: 空き, 7bit: ジャンプ中かどうか)
PlayerOrient        byte   ; プレイヤーの向き
PlayerBgColor       byte   ; プレイヤーの背景色
PlayerGfxAddr = Sprite0Gfx ; プレイヤースプライトのアドレス

; 81 byte ゾーン関連
NumberOfZones        byte ; ゾーン数

ZoneBgColors         ds MAX_NUMBER_OF_ZONES ; 各ゾーンの色
ZonePlayFieldColors  ds MAX_NUMBER_OF_ZONES ; 各ゾーンのプレイフィールドの色
ZoneHeights          ds MAX_NUMBER_OF_ZONES ; 各ゾーンの高さ
ZonePlayFieldNumbers ds MAX_NUMBER_OF_ZONES ; 各ゾーンのプレイフィールドの番号

ZoneSprite0Colors    ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0の色
ZoneSprite0XPos      ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0のX座標
ZoneSprite0YPos      ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0のY座標
ZoneSprite0Abilities ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0の属性
ZoneSprite0Nusiz     ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0のNUSIZ
ZoneSprite0Numbers   ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0の番号

ZoneSprite1Colors    ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1の色
ZoneSprite1XPos      ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1のX座標
ZoneSprite1YPos      ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト0のY座標
ZoneSprite1Abilities ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1の属性
ZoneSprite1Nusiz     ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1のNUSIZ
ZoneSprite1Numbers   ds MAX_NUMBER_OF_ZONES ; 各ゾーンのスプライト1の番号

    seg Code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 共通マクロ・データ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイヤーデータ
    MAC PLAYER_DATA
PlayerGfx{1}:
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

PlayerGfxColor{1}:
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
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; BGM
    MAC MUSIC_DATA
MusicSfx{1}:
        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1

        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1

        SOUND 19,7
        SOUND 19,4
        SOUND 19,2
        SOUND 19,1

        SOUND 17,7
        SOUND 17,4
        SOUND 17,2
        SOUND 17,1

        SOUND 17,7
        SOUND 17,4
        SOUND 17,2
        SOUND 17,1
        
        SOUND 19,7
        SOUND 19,4
        SOUND 19,2
        SOUND 19,1

        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1

        SOUND 23,7
        SOUND 23,4
        SOUND 23,2
        SOUND 23,1

        SOUND 26,7
        SOUND 26,4
        SOUND 26,2
        SOUND 26,1

        SOUND 26,7
        SOUND 26,4
        SOUND 26,2
        SOUND 26,1

        SOUND 23,7
        SOUND 23,4
        SOUND 23,2
        SOUND 23,1
        
        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1
        
        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1
        
        SOUND 23,7
        SOUND 23,4
        SOUND 23,2
        SOUND 23,1
        
        SOUND 23,7
        SOUND 23,4
        SOUND 23,2
        SOUND 23,1
        
        SOUND 23,0
        SOUND 23,0
        SOUND 23,0
        SOUND 23,0 ; first phrase ends

        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1

        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1

        SOUND 19,7
        SOUND 19,4
        SOUND 19,2
        SOUND 19,1

        SOUND 17,7
        SOUND 17,4
        SOUND 17,2
        SOUND 17,1

        SOUND 17,7
        SOUND 17,4
        SOUND 17,2
        SOUND 17,1
        
        SOUND 19,7
        SOUND 19,4
        SOUND 19,2
        SOUND 19,1

        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1

        SOUND 23,7
        SOUND 23,4
        SOUND 23,2
        SOUND 23,1

        SOUND 26,7
        SOUND 26,4
        SOUND 26,2
        SOUND 26,1

        SOUND 26,7
        SOUND 26,4
        SOUND 26,2
        SOUND 26,1

        SOUND 23,7
        SOUND 23,4
        SOUND 23,2
        SOUND 23,1
        
        SOUND 20,7
        SOUND 20,4
        SOUND 20,2
        SOUND 20,1
        
        SOUND 23,7
        SOUND 23,4
        SOUND 23,2
        SOUND 23,1
        
        SOUND 26,7
        SOUND 26,4
        SOUND 26,2
        SOUND 26,1
        
        SOUND 26,7
        SOUND 26,4
        SOUND 26,2
        SOUND 26,1
        
        SOUND 23,0
        SOUND 23,0
        SOUND 23,0
        SOUND 23,0 ; second phrase ends
    ENDM

    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; BGMの処理
    MAC PROC_MUSIC
#if USE_MUSIC = 1
        ; TITLE_MUSIC_PITCHで指定されたフレームに1回MusicFrameCounterをインクリメントする
        lda FrameCounter
        and #TITLE_MUSIC_PITCH-#1
        cmp #TITLE_MUSIC_PITCH-#1
        bne .SkipToggleMusicFrameCounter_{1}
        inc MusicFrameCounter
        lda MusicFrameCounter
        and #TITLE_MUSIC_LENGTH-#1
        sta MusicFrameCounter
.SkipToggleMusicFrameCounter_{1}

        lda #TITLE_MUSIC_TONE
        sta AUDC0
        ldx MusicFrameCounter
        lda MusicSfx{1},x
        lsr
        lsr
        lsr
        sta AUDF0
        lda MusicSfx{1},x
        and #%00000111
        asl
        sta AUDV0
#endif
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; プレイヤーの処理
    MAC PROC_PLAYER
ProcPlayer{1}:
        ; 重力加速度の適用
        lda PlayerVelocity
        cmp #0
        beq .SkipApplyVelocity{1}
        sta Tmp
        lda PlayerYPos
        clc
        adc Tmp
        sta PlayerYPos
        dec PlayerVelocity
.SkipApplyVelocity{1}
        ; 重力の適用
        lda PlayerYPos
        sec
        sbc #PLAYER_GRAVITY
        sta PlayerYPos
        ; 最も下端の場合は下端に固定し、ジャンプもなくす
        cmp #MIN_Y
        bpl .SkipJumpEnd{1}
        lda #MIN_Y
        sta PlayerYPos
        lda PlayerStatus
        and #%11111110
        sta PlayerStatus
.SkipJumpEnd{1}
        ; ジャンプボタンのチェック
        bit INPT4
        bmi .SkipButtonPush{1}
        ; ジャンプでない場合はジャンプ状態にする
        lda PlayerStatus
        and #PLAYER_STATUS_IS_JUMPING
        cmp #PLAYER_STATUS_IS_JUMPING
        beq .SkipButtonPush{1}
        ora #PLAYER_STATUS_IS_JUMPING
        sta PlayerStatus
        lda #PLAYER_INITIAL_VELOCITY
        sta PlayerVelocity
.SkipButtonPush{1}
        ; 十字キーのチェック
        lda #%01000000
        bit SWCHA
        bne .SkipMoveLeftTitle{1}
        jsr LeftPlayerXPosTitle
.SkipMoveLeftTitle{1}:
        lda #%10000000
        bit SWCHA
        bne .SkipMoveRightTitle{1}
        jsr RightPlayerXPosTitle
.SkipMoveRightTitle{1}:
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; フレームカウンターの処理
    MAC PROC_FRAME_COUNTER
        ; フレームカウンターをインクリメント
        inc FrameCounter

        ; 32フレームに1回AnimFrameCounterをトグルする
        lda FrameCounter
        and #%00011111
        cmp #%00011111
        bne .SkipToggleAnimFrameCounter_{1}
        lda AnimFrameCounter
        eor #%00000001
        sta AnimFrameCounter
.SkipToggleAnimFrameCounter_{1}
    ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 プログラムコードの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#if DEBUG = 1 && DEBUG_BANK = 0
    org $F000
Start:
#endif

#if DEBUG = 0
    org $1000
    rorg $F000
Start:
#endif

#if DEBUG = 0
    BANK_PROLOGUE
BankSwitch:
    BANK_SWITCH_TRAMPOLINE
#endif

#if DEBUG = 0 || DEBUG_BANK = 0

Reset_0:
    CLEAN_START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 初期化の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; プレイヤー座標の初期化
    lda #70
    sta PlayerXPos
    lda #1
    sta PlayerOrient
    lda #MIN_Y
    sta PlayerYPos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 フレームの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartFrame0:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 垂直同期の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    VERTICAL_SYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 処理の開始(垂直ブランクの開始)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_SETUP 37

    PROC_FRAME_COUNTER 0
    PROC_PLAYER 0
    PROC_MUSIC 0

    TIMER_WAIT
    lda #%00000000
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #$CA
    sta COLUBK

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Bank0 タイトルゾーンの描画
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp RenderTitle
RenderTitleReturn:

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Bank0 プレイヤーゾーンの描画
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp RenderTitlePlayerZone
RenderTitlePlayerZoneReturn:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 処理の開始（オーバースキャン）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_SETUP 29
    lda #%00000010
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 処理の終了（オーバースキャンの終了）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_WAIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 フレームの終了処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    jmp StartFrame0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 プレイヤーの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RenderTitle:
    ; 初期化処理
    TIMER_SETUP 30

    lda #0
    sta PF0
    sta PF1
    sta PF2
    sta COLUPF

    ; 非対称にする
    lda #PLAYFIELD_UNMIRRORING
    sta CTRLPF

    ldx #TITLE_GFX_HEIGHT-#1

    TIMER_WAIT

.RenderTitleLoop
    sta WSYNC

    lda TitleGfx0,x
    sta PF0
    lda TitleGfx1,x
    sta PF1
    lda TitleGfx2,x
    sta PF2
    nop
    nop
    nop
    lda TitleGfx3,x
    sta PF0
    lda TitleGfx4,x
    sta PF1
    lda TitleGfx5,x
    sta PF2

    dex
    bpl .RenderTitleLoop

    ; 後処理
    TIMER_SETUP 30

    lda #0
    sta PF0
    sta PF1
    sta PF2
    sta COLUPF

    TIMER_WAIT

    jmp RenderTitleReturn

RenderTitlePlayerZone:
    TIMER_SETUP #RENDER_ZONE_INIT_TIME
    
    ; 横位置の補正
    lda PlayerXPos
    ldy #0 ; プレイヤー0スプライト
    jsr SetObjectXPos0

    ; 横位置の補正を適用
    sta WSYNC
    sta HMOVE

    ; プレイヤースプライトのアドレスをセット
    lda #<PlayerGfx0
    sta PlayerGfxAddr
    lda #>PlayerGfx0
    ldy #1
    sta PlayerGfxAddr,y
    ldy #0

    ; アニメーションカウンタが1の場合はアドレスをずらす
    lda AnimFrameCounter
    and #%00000001
    beq .SkipPlayerAnimation_0
    ADD_ADDRESS PlayerGfxAddr,#PLAYER_GFX_HEIGHT
.SkipPlayerAnimation_0

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
.RenderPlayerZoneLoop0
    sta WSYNC

    ; プレイヤーの描画要否を判定
    txa
    sec
    sbc PlayerYPos
    cmp #PLAYER_GFX_HEIGHT
    bcc .DrawPlayer0
    lda #0

.DrawPlayer0
    tay
    lda (PlayerGfxAddr),y
    sta GRP0
    lda PlayerGfxColor0,y
    sta COLUP0

    dex
    bpl .RenderPlayerZoneLoop0

    ; プレイヤーゾーンの後処理
    lda #%00000000
    sta NUSIZ0
    lda #0
    sta WSYNC
    sta COLUBK

    jmp RenderTitlePlayerZoneReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 プレイヤーの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 対象のX座標の位置をセットする
;  A は対象のピクセル単位のX座標
;  Y は対象の種類 (0:player0, 1:player1, 2:missile0, 3:missile1, 4:ball)
SetObjectXPos0 subroutine
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; プレイヤーを左に動かす
LeftPlayerXPosTitle subroutine
    lda #%00001000
    sta PlayerOrient
    dec PlayerXPos
    lda PlayerXPos
    cmp #MAX_X
    bcc .EndMoveTitle
    lda #MAX_X-#20
    sta PlayerXPos
#if DEBUG = 0
    lda FrameCounter
    sta RandomCounter
    BANK_SWITCH 1,Reset_1
#endif
.EndMoveTitle
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; プレイヤーを右に動かす
RightPlayerXPosTitle subroutine
    lda #%00000000
    sta PlayerOrient
    inc PlayerXPos
    lda PlayerXPos
    cmp #MAX_X-#20
    bcc .EndMoveTitle
    lda #MIN_X
    sta PlayerXPos
#if DEBUG = 0
    lda FrameCounter
    sta RandomCounter
    BANK_SWITCH 1,Reset_1
#endif
.EndMoveTitle
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 プレイヤーデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    MUSIC_DATA 0
    PLAYER_DATA 0

TitleGfx0:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000
    
    .byte %11000000
    .byte %11000000
    .byte %11000000
    .byte %11000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %10000000
    .byte %10000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000

TitleGfx1
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00101010
    .byte %00101010
    .byte %00101010
    .byte %00101010
    
    .byte %00101010
    .byte %00101010
    .byte %00101010
    .byte %00101010
    
    .byte %00101010
    .byte %00101010
    .byte %00111010
    .byte %00111010
    
    .byte %00111010
    .byte %00111010
    .byte %00101010
    .byte %00101010
    
    .byte %00101010
    .byte %00101010
    .byte %00101010
    .byte %00101010
    
    .byte %10101010
    .byte %10101010
    .byte %10101010
    .byte %10101010
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000100
    .byte %00000100
    .byte %00000100
    .byte %00000100
    
    .byte %00000111
    .byte %00000111
    .byte %00000111
    .byte %00000111
    
    .byte %00000010
    .byte %00000010
    .byte %00000010
    .byte %00000010
    
    .byte %00000010
    .byte %00000010
    .byte %00000010
    .byte %00000010
    
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    
    .byte %00000001
    .byte %00000001
    .byte %00000001
    .byte %00000001
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %10100101
    .byte %10100101
    .byte %10100101
    .byte %10100101
    
    .byte %10100101
    .byte %10100101
    .byte %10100101
    .byte %10100101
    
    .byte %10100101
    .byte %10100101
    .byte %11110111
    .byte %11110111
    
    .byte %11110111
    .byte %11110111
    .byte %01010101
    .byte %01010101
    
    .byte %01010101
    .byte %01010101
    .byte %01010101
    .byte %01010101
    
    .byte %01010101
    .byte %01010101
    .byte %01010101
    .byte %01010101

TitleGfx2
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %11101001
    .byte %11101001
    .byte %11101001
    .byte %11101001
    
    .byte %00101001
    .byte %00101001
    .byte %00101001
    .byte %00101001
    
    .byte %10101101
    .byte %10101101
    .byte %10101101
    .byte %10101101
    
    .byte %00101011
    .byte %00101011
    .byte %00101011
    .byte %00101011
    
    .byte %00101001
    .byte %00101001
    .byte %00101001
    .byte %00101001
    
    .byte %11101001
    .byte %11101001
    .byte %11101001
    .byte %11101001
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %10010010
    .byte %10010010
    .byte %10010010
    .byte %10010010
    
    .byte %10010011
    .byte %10010011
    .byte %10010011
    .byte %10010011
    
    .byte %00010001
    .byte %00010001
    .byte %00010001
    .byte %00010001
    
    .byte %00010001
    .byte %00010001
    .byte %00010001
    .byte %00010001
    
    .byte %00010001
    .byte %00010001
    .byte %00010001
    .byte %00010001
    
    .byte %00111000
    .byte %00111000
    .byte %00111000
    .byte %00111000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %10101110
    .byte %10101110
    .byte %10101110
    .byte %10101110
    
    .byte %10100010
    .byte %10100010
    .byte %01100010
    .byte %01100010
    
    .byte %01100010
    .byte %01100010
    .byte %11101110
    .byte %11101110
    
    .byte %11101110
    .byte %11101110
    .byte %10100010
    .byte %10100010
    
    .byte %10100010
    .byte %10100010
    .byte %10100010
    .byte %10100010

    .byte %11101110
    .byte %11101110
    .byte %11101110
    .byte %11101110

TitleGfx3
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %11010000
    .byte %11010000
    .byte %11010000
    .byte %11010000
    
    .byte %00010000
    .byte %00010000
    .byte %00010000
    .byte %00010000
    
    .byte %00010000
    .byte %00010000
    .byte %11010000
    .byte %11010000
    
    .byte %11000000
    .byte %11000000
    .byte %01000000
    .byte %01000000
    
    .byte %01010000
    .byte %01010000
    .byte %01010000
    .byte %01010000
    
    .byte %11010000
    .byte %11010000
    .byte %11010000
    .byte %11010000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %10000000
    .byte %10000000
    .byte %10000000
    .byte %10000000
    
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    
    .byte %01010000
    .byte %01010000
    .byte %01010000
    .byte %01010000
    
    .byte %01010000
    .byte %01010000
    .byte %01010000
    .byte %01010000
    
    .byte %01110000
    .byte %01110000
    .byte %01110000
    .byte %01110000
    
    .byte %00100000
    .byte %00100000
    .byte %00100000
    .byte %00100000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %11100000
    .byte %11100000
    .byte %11100000
    .byte %11100000
    
    .byte %00100000
    .byte %00100000
    .byte %00100000
    .byte %00100000
    
    .byte %00100000
    .byte %00100000
    .byte %11100000
    .byte %11100000
    
    .byte %11100000
    .byte %11100000
    .byte %00100000
    .byte %00100000
    
    .byte %00100000
    .byte %00100000
    .byte %00100000
    .byte %00100000

    .byte %11100000
    .byte %11100000
    .byte %11100000
    .byte %11100000
    
TitleGfx4
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %10010101
    .byte %10010101
    .byte %10010101
    .byte %10010101
    
    .byte %10010101
    .byte %10010101
    .byte %10010101
    .byte %10010101
    
    .byte %10011101
    .byte %10011101
    .byte %10011101
    .byte %10011101
    
    .byte %10010101
    .byte %10010101
    .byte %00010101
    .byte %00010101
    
    .byte %00011101
    .byte %00011101
    .byte %00011101
    .byte %00011101
    
    .byte %10001001
    .byte %10001001
    .byte %10001001
    .byte %10001001
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %01010010
    .byte %01010010
    .byte %01010010
    .byte %01010010
    
    .byte %01010010
    .byte %01010010
    .byte %01100010
    .byte %01100010
    
    .byte %01100010
    .byte %01100010
    .byte %01110010
    .byte %01110010
    
    .byte %01110010
    .byte %01110010
    .byte %01010010
    .byte %01010010
    
    .byte %01010010
    .byte %01010010
    .byte %01010010
    .byte %01010010
    
    .byte %01110010
    .byte %01110010
    .byte %01110010
    .byte %01110010
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00010010
    .byte %00010010
    .byte %00010010
    .byte %00010010
    
    .byte %00010010
    .byte %00010010
    .byte %00010010
    .byte %00010010
    
    .byte %00010010
    .byte %00010010
    .byte %00010011
    .byte %00010011
    
    .byte %00010011
    .byte %00010011
    .byte %00010010
    .byte %00010010
    
    .byte %00010010
    .byte %00010010
    .byte %00010010
    .byte %00010010
    
    .byte %00111010
    .byte %00111010
    .byte %00111010
    .byte %00111010

TitleGfx5
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
     
    .byte %00111010
    .byte %00111010
    .byte %00111010
    .byte %00111010
    
    .byte %00001010
    .byte %00001010
    .byte %00001001
    .byte %00001001
    
    .byte %00001001
    .byte %00001001
    .byte %00111011
    .byte %00111011
    
    .byte %00111011
    .byte %00111011
    .byte %00001010
    .byte %00001010
    
    .byte %00001010
    .byte %00001010
    .byte %00001010
    .byte %00001010
    
    .byte %00111011
    .byte %00111011
    .byte %00111011
    .byte %00111011
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
    .byte %00011101
    .byte %00011101
    .byte %00011101
    .byte %00011101
    
    .byte %00000101
    .byte %00000101
    .byte %00000101
    .byte %00000101
    
    .byte %00000101
    .byte %00000101
    .byte %00011101
    .byte %00011101
    
    .byte %00011101
    .byte %00011101
    .byte %00000101
    .byte %00000101
    
    .byte %00000101
    .byte %00000101
    .byte %00000101
    .byte %00000101

    .byte %00011101
    .byte %00011101
    .byte %00011101
    .byte %00011101

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank0 末尾
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#if DEBUG = 1 && DEBUG_BANK = 0
    org $FFFC
    word Start
    word Start
#endif

#if DEBUG = 0
    org  $1FFA
    rorg $FFFA
    BANK_VECTORS
#endif

#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 プログラムコードの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#if DEBUG = 1 && DEBUG_BANK = 1
    org $F000
Start:
#endif

#if DEBUG = 0
    org $2000
    rorg $F000
Start:
#endif

#if DEBUG = 0
    BANK_PROLOGUE
BankSwitch:
    BANK_SWITCH_TRAMPOLINE
#endif

#if DEBUG = 0 || DEBUG_BANK = 1

Reset_1:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 初期化の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; プレイヤーの初期化
    lda #1
    sta PlayerOrient
    lda #MIN_Y
    sta PlayerYPos
    lda #0
    sta PlayerStatus
    sta PlayerVelocity

    ; 音の初期化
    lda #0
    sta AUDF0
    sta AUDC0
    sta AUDV0

    ; シーンの初期化
#if DEBUG = 1 && DEBUG_BANK = 1
    lda #INITIAL_RANDOM_COUNTER
    sta RandomCounter
    lda #INITIAL_RANDOM_COUNTER_2
    sta RandomCounter2
#endif

    jsr ResetScene

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 フレームの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartFrame1:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 垂直同期の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    VERTICAL_SYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 処理の開始(垂直ブランクの開始)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_SETUP 37

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Bank1 カウンターの処理
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
    ;; Bank1 プレイヤーの処理
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp ProcPlayer
ProcPlayerReturn:

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Bank1 風景ゾーンの処理
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
;; Bank1 処理の終了(垂直ブランクの終了)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_WAIT
    lda #%00000000
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Bank1 風景ゾーンの描画
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
    ;; Bank1 プレイヤーゾーンの描画
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    jmp RenderPlayerZone
RenderPlayerZoneReturn:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 処理の開始（オーバースキャン）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_SETUP 29
    lda #%00000010
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 処理の終了（オーバースキャンの終了）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_WAIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 フレームの終了処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    jmp StartFrame1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 ゾーン用マクロ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの描画
    MAC RENDER_SPRITES
        ; スプライト0の描画
        txa
        sec
        sbc Sprite0YPos
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
        sbc Sprite1YPos
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
    ; スプライトの描画
    ;  {1}: スプライト番号
    MAC RENDER_SPRITE
        txa
        sec
        sbc Sprite{1}YPos
        cmp Sprite{1}Height
        bcc .DrawSprite{1}
        lda #0
.DrawSprite{1}
        tay
        lda (Sprite{1}Gfx),y
        sta GRP{1}
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドの描画マクロ(一括)
    MAC RENDER_PLAYFIELDS
#if USE_PLAYFIELD = 1
        txa
        cmp PlayFieldHeight
        bcc .LoadPlayfield
        lda #0
.LoadPlayfield
        tay
        lda (PlayFieldGfx0),y
        sta PF0
        lda (PlayFieldGfx1),y
        sta PF1
        lda (PlayFieldGfx2),y
        sta PF2
#endif
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドの描画マクロ
    ;  {1}: プレイフィールド番号
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
#endif
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドのバッファリング
    ;  x: プレイフィールドの番号
    MAC BUFFER_PLAYFIELD
#if USE_PLAYFIELD = 1
        txa
        cmp PlayFieldHeight
        bcc .LoadPlayfield{1}
        lda #0
.LoadPlayfield{1}
        tay
        lda (PlayFieldGfx{1}),y
        sta PF{1}Buffer
#endif
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドのバッファを適用
    MAC FLASH_PLAYFIELD
#if USE_PLAYFIELD = 1
        lda PF0Buffer
        sta PF0
        lda PF1Buffer
        sta PF1
        lda PF2Buffer
        sta PF2
#endif
    ENDM
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドをロードする
    MAC LOAD_PLAYFIELD
        ; PlayFieldGfxの先頭アドレスを得てPlayFieldInfoをセット
        lda ZonePlayFieldNumbers,x
        asl
        tay
        lda PlayFieldGfxs,y
        sta PlayFieldGfx0
        lda PlayFieldGfxs,y+1
        ldy #0
        sta PlayFieldGfx0,y+1
        lda (PlayFieldGfx0),y
        sta PlayFieldInfo
        ; PlayFieldGfx0のアドレスをインクリメントして高さのアドレスを指すようにしてPlayFieldHeightのセット
        ADD_ADDRESS PlayFieldGfx0,#1
        lda (PlayFieldGfx0),y
        sta PlayFieldHeight
        ; PlayFieldGfx0のアドレスをインクリメントしてグラフィック部を指すようにインクリメント
        ADD_ADDRESS PlayFieldGfx0,#1
        ; PlayFieldGfx1のアドレスを計算
        COPY_AND_ADD_ADDRESS PlayFieldGfx0,PlayFieldGfx1,PlayFieldHeight
        ; PlayFieldGfx2のアドレスを計算
        COPY_AND_ADD_ADDRESS PlayFieldGfx1,PlayFieldGfx2,PlayFieldHeight
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトをロードする
    ;  {1}: スプライト番号 なしか1
    MAC LOAD_SPRITE
        LOAD_SPRITE_INFO {1}
        _CALCULATE_SPRITE_GFX {1}
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライト情報を読み取ってSpriteInfoにセットする
    ;  {1}: スプライト番号 なしか1
    MAC LOAD_SPRITE_INFO
        lda ZoneSprite{1}Numbers,x
        asl
        tay
        lda SpriteGfxs,y
        sta Sprite{1}Gfx
        lda SpriteGfxs,y+1
        ldy #0
        sta Sprite{1}Gfx,y+1
        lda (Sprite{1}Gfx),y
        sta Sprite{1}Info
        
        ; スプライトの高さを取得してSpriteHeightにセット
        ADD_ADDRESS Sprite{1}Gfx,#1
        lda (Sprite{1}Gfx),y
        sta Sprite{1}Height
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの高さをSpriteInfoから読み取ってSpriteHeightにセットする
    ;  {1}: スプライト番号 なしか1
    MAC _LOAD_SPRITE_HEIGHT
        ADD_ADDRESS Sprite{1}Gfx,#1
        ; スプライトの高さを取得してSpriteHeightにセット
        lda (Sprite{1}Gfx),y
        sta Sprite{1}Height
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; SpriteGfxが先頭を指している状態でアニメーションカウンターも考慮してSpriteGfxのアドレスを計算する
    ;  {1}: スプライト番号 なしか1
    MAC _CALCULATE_SPRITE_GFX
        ; SpriteGfxがスプライトのグラフィックのアドレスを指すようにする
        ADD_ADDRESS Sprite{1}Gfx,#1
        ; スプライトのアニメーション情報を取得してスプライトのアドレスをずらす
        lda Sprite{1}Info
        and #SPRITE_ANIMATABLE
        beq .SkipSprite{1}Animation
        lda AnimFrameCounter
        and #%00000001
        ; アニメーションカウンタが1の場合はアドレスをずらす
        beq .SkipSprite{1}Animation
        ADD_ADDRESS Sprite{1}Gfx,Sprite{1}Height
.SkipSprite{1}Animation
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; SpriteInfoが移動不可の場合はジャンプする
    MAC IF_SPRITE_IS_UNMOVABLE
        lda Sprite{1}Info
        and #SPRITE_MOVABLE
        beq {2}
        ldx ZoneIndex
        lda ZoneSprite{1}Abilities,x
        and #SPRITE_MOVING_ON
        beq {2}
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの移動処理
    MAC MOVE_SPRITE
.StartMove{1}
        ldx ZoneIndex
        lda ZoneSprite{1}Abilities,x
;         ; 移動の種類をチェック
;         and #SPRITE_MOVING_PULSED
;         beq .MoveLinear{1}
;         ; パルス移動
;         lda FrameCounter
;         and #%10000000
;         bne .EndMove{1} ; 特定フレームでなかったら移動しない
; .MoveLinear{1}
;         lda ZoneSprite{1}Abilities,x
        and #SPRITE_SPEED_MASK
        tay
        lda SpeedTable,y
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

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ゾーンの高さをリセット
    MAC RESET_ZONE_HEIGHT
        jsr NextRandomValue
        lda RandomValue
        ; ゾーンの最小高さ～ゾーンの最大高さの乱数を得る
        sec
.ModLoop
        sbc #(MAX_ZONE_HEIGHT - MIN_ZONE_HEIGHT + 1)
        bcs .ModLoop
        adc #(MAX_ZONE_HEIGHT - MIN_ZONE_HEIGHT + 1)
        clc
        adc #MIN_ZONE_HEIGHT

#if USE_SPRITE_1 = 1 && USE_PLAYFIELD = 1
        ; 高さが4の倍数になるように丸める(各ゾーンで4xline処理をするので4の倍数である必要がある)
        and #%11111100
#endif

        sta ZoneHeights,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ゾーンの色を決定
    MAC RESET_ZONE_COLOR
        jsr NextRandomValue
        lda RandomValue
        sta ZoneBgColors,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドを決定
    MAC RESET_PLAYFIELD
        jsr NextRandomValue
        lda RandomValue
        and #NUMBER_OF_PLAY_FIELDS_MASK
        sta ZonePlayFieldNumbers,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; プレイフィールドの色を決定
    MAC RESET_PLAYFIELD_COLOR
        jsr NextRandomValue
        lda RandomValue
        sta ZonePlayFieldColors,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの決定
    ;  {1}: スプライト番号
    MAC RESET_SPRITE
        jsr NextRandomValue
        lda RandomValue
        and #NUMBER_OF_SPRITES_MASK
        sta ZoneSprite{1}Numbers,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの色の決定
    ;  {1}: スプライト番号
    MAC RESET_SPRITE_COLOR
        jsr NextRandomValue
        lda RandomValue
        sta ZoneSprite{1}Colors,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトのX座標の初期値の決定
    ;  {1}: スプライト番号
    MAC RESET_SPRITE_XPOS
        jsr NextRandomValue
        lda RandomValue
        and #%01111111
        sta ZoneSprite{1}XPos,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの向きの決定
    ;  {1}: スプライト番号
    MAC RESET_SPRITE_ORIENT
        lda Sprite{1}Info
        and #SPRITE_ORIENTABLE
        beq .SkipSetZoneSprite{1}Orient ; SPRITE_ORIENTABLEでなければスキップ
        jsr NextRandomValue
        lda RandomValue
        and #%00000001
        beq .SetZoneSprite{1}OrientRight
        lda ZoneSprite{1}Abilities,x
        ora #SPRITE_ORIENT_LEFT
        jmp .SetZoneSprite{1}OrientEnd
.SetZoneSprite{1}OrientRight 
        lda ZoneSprite{1}Abilities,x
        ora #SPRITE_ORIENT_RIGHT
.SetZoneSprite{1}OrientEnd 
        sta ZoneSprite{1}Abilities,x
.SkipSetZoneSprite{1}Orient
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの速度の決定
    ;  {1}: スプライト番号
    MAC RESET_SPRITE_SPEED
        jsr NextRandomValue
        lda RandomValue
        and #NUMBER_OF_SPEEDS_MASK
        tay 
        lda ZoneSprite{1}Abilities,x
        ora SpeedTable,y
        sta ZoneSprite{1}Abilities,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの移動可否の決定
    ;  {1}: スプライト番号
    MAC RESET_SPRITE_MOVABLE
        jsr NextRandomValue
        lda RandomValue
        and #%00000001
        beq .SetZoneSprite{1}Unmovable
        lda ZoneSprite{1}Abilities,x
        ora #SPRITE_MOVABLE
        jmp .SetZoneSprite{1}MovableEnd
.SetZoneSprite{1}Unmovable
        lda ZoneSprite{1}Abilities,x
        ora #SPRITE_UNMOVABLE
.SetZoneSprite{1}MovableEnd
        sta ZoneSprite{1}Abilities,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトの移動種類の決定
    ;  {1}: スプライト番号
    MAC RESET_SPRITE_MOVING
        lda Sprite{1}Info
        and #%00001000
        sta Tmp
        ora ZoneSprite{1}Abilities,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; スプライトのNUSIZの決定
    ;  {1}: スプライト番号
    MAC RESET_SPRITE_NUSIZ
        jsr NextRandomValue
        lda RandomValue
        and #%00000111
        tay
        lda Sprite{1}Info
        and #SPRITE_NUSIZ_UNQUADABLE
        bne .SetSprite{1}NusizUnwideable
        lda NUSIZTableAll,y
        jmp .EndSprite{1}Nusiz
.SetSprite{1}NusizUnwideable
        lda NUSIZTableUnwideable,y
.EndSprite{1}Nusiz
        sta ZoneSprite{1}Nusiz,x
    ENDM

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; ゾーンのスプライトのY座標を決定
    ;  {1}: スプライト番号
    ;  {2}: 最小のY座標
    ;  {3}: 最大のY座標
    MAC RESET_SPRITE_YPOS
        jsr NextRandomValue
        lda RandomValue
        ; {2}~{3}の乱数を取る
        sec
.ModLoop
        sbc #({3} - {2} + 1)
        bcs .ModLoop
        adc #({3} - {2} + 1)
        clc
        adc #{2}

        ; 一旦Y座標を保持
        sta ZoneSprite{1}YPos,x
        
        ; ゾーンの実質の高さを計算
        lda ZoneHeights,x
        sec
        sbc #RENDER_ZONE_INIT_TIME
        sta Tmp
        
        ; Y座標とスプライトの高さを足して上部のY座標を得る
        lda ZoneSprite{1}YPos,x
        clc
        adc Sprite{1}Height
        
        ; スプライトの上部のY座標 - ゾーンの実質の高さ
        sec
        sbc Tmp
        
        ; プラスならはみ出ているのではみ出た分を調整
        bpl .JustifySprite{1}YPos
        jmp .SkipSubSprite{1}Height
.JustifySprite{1}YPos
    sta Tmp
    lda ZoneSprite{1}YPos,x
        sec
        sbc Tmp
        
        ; 0なら座標1にセット(0だと表示がバグるので)
        beq .SetSprite{1}HeightOne
        
        ; それでY座標がマイナスになる場合は、座標1にセット
        bcc .SetSprite{1}HeightOne
        jmp .StoreSprite{1}Height
.SetSprite{1}HeightOne
        lda #1
.StoreSprite{1}Height
        sta ZoneSprite{1}YPos,x
.SkipSubSprite{1}Height
    ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 風景ゾーンの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RenderZone:
    TIMER_SETUP #RENDER_ZONE_INIT_TIME

    ; まず背景色をセットしてゾーンがガタつかないようにする
    lda ZoneBgColors,x
    sta COLUBK

; >>> 横位置補正前初期化
;  NOTE: 処理時間の関係で横位置補正前にいくつか初期化をしておく(この処理が横位置補正後だとタイマーに間に合わない)

    ; スプライト0色のセット
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

; <<< 横位置補正前初期化終わり

    ; スプライト0の横位置の補正
    lda ZoneSprite0XPos,x
    ldy #0 ; プレイヤー0
    jsr SetObjectXPos

#if USE_SPRITE_1 = 1
    ; スプライト1の横位置の補正
    lda ZoneSprite1XPos,x
    ldy #1 ; プレイヤー1
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

    ; スプライト0のY座標のセット
    lda ZoneSprite0YPos,x
    sta Sprite0YPos

#if USE_SPRITE_1 = 1
    ; スプライト1のY座標のセット
    lda ZoneSprite1YPos,x
    sta Sprite1YPos
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
    LOAD_PLAYFIELD

    ; プレイフィールドの色をセット
    lda ZonePlayFieldColors,x
    sta COLUPF
    
    ; プレイフィールドの設定
    lda PlayFieldInfo
    and #PLAYFIELD_MIRRORING
    sta CTRLPF
#endif

    ; ゾーンの高さ分のループ
    lda ZoneHeights,x
    sec
    sbc #RENDER_ZONE_INIT_TIME ; ゾーンの初期化処理にかかった時間分ライン数を減らす
    tax

    TIMER_WAIT

    ; プレイフィールドがあるかどうかを判定
    lda PlayFieldHeight
    cmp #0

    ; プレイフィールドがない場合はスプライトを2つ表示
    beq .BeginRenderSpritesLoop 

    ; プレイフィールドがある場合はスプライト0とプレイフィールドを表示
    jmp .BeginRenderSprite0AndPlayFieldLoop 

.BeginRenderSpritesLoop

    sta WSYNC
    RENDER_SPRITES
    dex
    
    beq .EndRenderLoop
    jmp .BeginRenderSpritesLoop
    
.BeginRenderSprite0AndPlayFieldLoop

    sta WSYNC
    RENDER_SPRITE 0
    RENDER_PLAYFIELDS
    dex
    
    beq .EndRenderLoop
    jmp .BeginRenderSprite0AndPlayFieldLoop
    
.EndRenderLoop

    ; 後処理
#if USE_PLAYFIELD = 1

    lda #0
    cmp PlayFieldHeight ; 高さが0のプレイフィールドの場合は後処理は不要
    beq .SkipPlayFieldPostProc
    
    ; プレイフィールドがクリアされるまで時間がかかるので背景を同化させる
    ldx ZoneIndex
    lda ZonePlayFieldColors,x
    sta COLUBK

    ; プレイフィールドを初期化
    lda #0
    sta PF0
    sta PF1
    sta PF2

.SkipPlayFieldPostProc
#endif

    jmp RenderZoneReturn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 プレイヤーゾーンの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RenderPlayerZone:
    TIMER_SETUP #RENDER_ZONE_INIT_TIME
    
    ; 背景色のセット
    lda PlayerBgColor
    sta COLUBK

    ; 横位置の補正
    lda PlayerXPos
    ldy #0 ; プレイヤー0スプライト
    jsr SetObjectXPos

    ; 横位置の補正を適用
    sta WSYNC
    sta HMOVE

    ; プレイヤースプライトのアドレスをセット
    lda #<PlayerGfx1
    sta PlayerGfxAddr
    lda #>PlayerGfx1
    ldy #1
    sta PlayerGfxAddr,y
    ldy #0

    ; アニメーションカウンタが1の場合はアドレスをずらす
    lda AnimFrameCounter
    and #%00000001
    beq .SkipPlayerAnimation
    ADD_ADDRESS PlayerGfxAddr,#PLAYER_GFX_HEIGHT
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
    lda PlayerGfxColor1,y
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
;; Bank1 風景ゾーンの処理
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
;; Bank1 プレイヤーの処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcPlayer:
    ; 重力加速度の適用
    lda PlayerVelocity
    cmp #0
    beq .SkipApplyVelocity
    sta Tmp
    lda PlayerYPos
    clc
    adc Tmp
    sta PlayerYPos
    dec PlayerVelocity
.SkipApplyVelocity
    ; 重力の適用
    lda PlayerYPos
    sec
    sbc #PLAYER_GRAVITY
    sta PlayerYPos
    ; 最も下端の場合は下端に固定し、ジャンプもなくす
    cmp #2
    bpl .SkipJumpEnd
    lda #2
    sta PlayerYPos
    lda PlayerStatus
    and #%11111110
    sta PlayerStatus
.SkipJumpEnd
    ; ジャンプボタンのチェック
    bit INPT4
    bmi .SkipButtonPush
    ; ジャンプでない場合はジャンプ状態にする
    lda PlayerStatus
    and #PLAYER_STATUS_IS_JUMPING
    cmp #PLAYER_STATUS_IS_JUMPING
    beq .SkipButtonPush
    ora #PLAYER_STATUS_IS_JUMPING
    sta PlayerStatus
    lda #PLAYER_INITIAL_VELOCITY
    sta PlayerVelocity
.SkipButtonPush

    ; 十字キーのチェック
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
;; Bank1 サブルーチン
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

    ; 各ゾーンの高さの初期化
    ldx #0
.InitializeNumZoneLoop
    stx ZoneIndex

    ; 初期化
    lda #0
    sta ZoneSprite0Abilities,x
    sta ZoneSprite1Abilities,x

    ; ゾーンの高さをランダムで決定
    RESET_ZONE_HEIGHT

    ; ゾーンの高さの合計を保持
    lda UsingHeight
    adc ZoneHeights,x
    sta UsingHeight

    ; ゾーンの合計の高さが風景に使える高さを超えていないかチェック
    lda #LANDSCAPE_ZONE_HEIGHT
    sec
    sbc UsingHeight

    ; 超えていなければ次のゾーンを作成へ
    bcs .InitializeNumZoneNext

    ; 超えていたら終わり
    jmp .InitializeNumZoneEnd
.InitializeNumZoneNext
    inx
    jmp .InitializeNumZoneLoop
.InitializeNumZoneEnd
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

    ; 各ゾーンの情報を初期化
    ldx #0
.InitializeZoneLoop:

    ; ゾーンの色を決定
    RESET_ZONE_COLOR

    ; プレイフィールドの決定
    RESET_PLAYFIELD
    
    ; プレイフィールドの色を決定
    RESET_PLAYFIELD_COLOR

    ; スプライト0を決定
    RESET_SPRITE 0
    LOAD_SPRITE_INFO 0
    
    ; スプライト0のY座標を決定
    RESET_SPRITE_YPOS 0,#1,#16

#if USE_SPRITE_1 = 1
    ; スプライト1を決定
    RESET_SPRITE 1
    LOAD_SPRITE_INFO 1

    ; スプライト1のY座標を決定
    RESET_SPRITE_YPOS 1,#16,#32
#endif

    ; スプライト0の色を決定
    RESET_SPRITE_COLOR 0

#if USE_SPRITE_1 = 1
    ; スプライト1の色を決定
    RESET_SPRITE_COLOR 1
#endif

    ; スプライト0のX座標の初期値を決定
    RESET_SPRITE_XPOS 0

#if USE_SPRITE_1 = 1
    ; スプライト1のX座標の初期値を決定
    RESET_SPRITE_XPOS 1
#endif

    ; スプライト0の向きを決定
    RESET_SPRITE_ORIENT 0

#if USE_SPRITE_1 = 1
    ; スプライト1の向きを決定
    RESET_SPRITE_ORIENT 1
#endif

    ; スプライト0の速さを決定
    RESET_SPRITE_SPEED 0

#if USE_SPRITE_1 = 1
    ; スプライト1の速さを決定
    RESET_SPRITE_SPEED 1
#endif

    ; スプライト0の移動可否を決定
    RESET_SPRITE_MOVABLE 0

#if USE_SPRITE_1 = 1
    ; スプライト1の移動可否を決定
    RESET_SPRITE_MOVABLE 1
#endif

    ; スプライト0の移動の種類を決定
    RESET_SPRITE_MOVING 0

#if USE_SPRITE_1 = 1
    ; スプライト1の移動の種類を決定
    RESET_SPRITE_MOVING 1
#endif

    ; スプライト0のNUSIZを決定
    RESET_SPRITE_NUSIZ 0

#if USE_SPRITE_1 = 1
    ; スプライト1のNUSIZを決定
    RESET_SPRITE_NUSIZ 1
#endif

    inx
    cpx NumberOfZones
    bcc .NextInitializeZoneLoop
    jmp .EndInitializeZoneLoop
.NextInitializeZoneLoop
    jmp .InitializeZoneLoop
.EndInitializeZoneLoop

    ; ゾーンの最大数を超えていたらもう一度シーンを生成する
    lda NumberOfZones
    cmp #MAX_NUMBER_OF_ZONES + 1
    bcc .DoneResetScene
    jsr ResetScene

.DoneResetScene
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 乱数をリセットする
ResetRandomCounter subroutine
    lda RandomCounter
    clc
    adc FrameCounter
    sta RandomCounter2
    clc
    adc FrameCounter
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 次の乱数値をセットする
NextRandomValue subroutine
    pha
    txa
    pha
    inc RandomCounter
    inc RandomCounter2
    inc RandomCounter2
    ldx RandomCounter
    lda RandomTable,x
    ldx RandomCounter2
    eor RandomTable,x
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
;; Bank1 プレイヤーデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    PLAYER_DATA 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 プレイフィールドデータ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayFieldGfxs:
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldNoneGfx
    .word PlayFieldTwinMountainGfx
    .word PlayFieldBigMountainGfx
    .word PlayFieldGrassGfx

PlayFieldNoneGfx:
    .byte #0
    .byte %00000000

PlayFieldTwinMountainGfx:
    .byte PLAYFIELD_MIRRORING
    .byte #12
    .byte %00000000
    .byte %11110000
    .byte %11100000
    .byte %11000000
    .byte %10000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00000000
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %01111111
    .byte %00111111
    .byte %00011111
    .byte %00001110
    .byte %00000100
    .byte %00000000

    .byte %00000000
    .byte %01111111
    .byte %00111111
    .byte %00011111
    .byte %00001111
    .byte %00000111
    .byte %00000011
    .byte %00000001
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
PlayFieldBigMountainGfx:
    .byte PLAYFIELD_MIRRORING
    .byte #20
    .byte %00000000
    .byte %11110000
    .byte %11100000
    .byte %11000000
    .byte %10000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00000000
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %01111111
    .byte %00111111
    .byte %00011111
    .byte %00001111
    .byte %00000111
    .byte %00000011
    .byte %00000001
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00000000
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111110
    .byte %11111100
    .byte %11111000
    .byte %11110000
    .byte %11100000
    .byte %11000000
    .byte %01000000
    
PlayFieldGrassGfx:
    .byte PLAYFIELD_UNMIRRORING
    .byte #16
    .byte %00000000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %01100000
    .byte %01100000
    .byte %01000000
    .byte %01000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00000000
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11011011
    .byte %11011011
    .byte %01001001
    .byte %01001001
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000

    .byte %00000000
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %10110110
    .byte %10110110
    .byte %00100100
    .byte %00100100
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bank1 スプライトデータ
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
    ; 32 ~ 39
    .word CloudGfx
    .word TreeGfx
    .word Tree2Gfx
    .word BirdGfx
    .word FishGfx
    .word HouseGfx
    .word BuildingGfx
    .word Building2Gfx
    ; 40~47
    .word BoxGfx
    .word DonkeyKongGfx
    .word ETGfx
    .word Walker1Gfx
    .word Walker2Gfx
    .word Walker3Gfx
    .word Walker4Gfx
    .word Walker5Gfx
    ; 48~55
    .word Walker6Gfx
    .word Walker7Gfx
    .word Walker8Gfx
    .word Dragonstomper1Gfx
    .word Dragonstomper2Gfx
    .word Dragonstomper3Gfx
    .word Dragonstomper4Gfx
    .word SpringerGfx
    ; 56~63
    .word SkyPatrolGfx
    .word BobbyGfx
    .word RaftRiderGfx
    .word DungeonMasterGfx
    .word LynxGfx
    .word RabbitTransitGfx
    .word PitfallGfx
    .word MontezumaGfx

BearGfx:
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_UNANIMATABLE | #SPRITE_UNORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
    .byte #SPRITE_MOVABLE | #SPRITE_ANIMATABLE | #SPRITE_ORIENTABLE | #SPRITE_NUSIZ_ALL | #SPRITE_MOVING_LINEAR

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
;; Bank1 末尾
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#if DEBUG = 1 && DEBUG_BANK = 1
    org $FFFC
    word Start
    word Start
#endif

#if DEBUG = 0
    org  $2FFA
    rorg $FFFA
    BANK_VECTORS
#endif

#endif
