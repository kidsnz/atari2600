    processor 6502

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; インクルード文
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    include "vcs.h"
    include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; デバッグ用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ANIMATION = 1
OFFSET = 1
START_UPPER_COLOR_IDX = OFFSET
START_LOWER_COLOR_IDX = HALF_PF_GFX_HEIGHT-OFFSET

RENDER_UPPER = 1
RENDER_LOWER = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; カラーコード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WHITE_BASE_COLOR = $00
BLUE_BASE_COLOR  = $70
RED_BASE_COLOR   = $40

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PF_GFX_HEIGHT = 180
HALF_PF_GFX_HEIGHT = PF_GFX_HEIGHT / 2

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
#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg.u Variables
    org $80

; 2 byte / 128 byte

UpperStartColorIdx byte
LowerStartColorIdx byte

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 共通マクロ・データ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイフィールド情報用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PF_UNMIRRORING = %00000000 ; プレイフィールドをミラーリングしない
PF_MIRRORING   = %00000001 ; プレイフィールドをミラーリングする

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プログラムコードの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    seg Code
    org $F000

Reset:
    CLEAN_START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 初期化の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #START_UPPER_COLOR_IDX
    sta UpperStartColorIdx
    lda #START_LOWER_COLOR_IDX
    sta LowerStartColorIdx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NextFrame:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 垂直同期の開始
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    VERTICAL_SYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 処理(垂直ブランクの開始)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
    TIMER_SETUP 37

    ; プレイフィールドの初期化
    lda #0
    sta PF0
    sta PF1
    sta PF2
    sta COLUPF
    lda #PF_UNMIRRORING
    sta CTRLPF

#if ANIMATION = 1
    ; 上部開始色インデックスを変更
    ldx UpperStartColorIdx
    inx

    ; 上部開始色インデックスがHALF_PF_GFX_HEIGHTを超えたら0に戻す
    cpx #HALF_PF_GFX_HEIGHT-1
    bne .SkipUpperStartColorIdxZero
    ldx #0
.SkipUpperStartColorIdxZero
    stx UpperStartColorIdx

    ; 下部開始色インデックスを変更
    ldx LowerStartColorIdx
    dex

    ; 下部開始色インデックスが0未満になったらHALF_PF_GFX_HEIGHT-1に戻す
    bne .SkipLowerStartColorIdxZero
    ldx #HALF_PF_GFX_HEIGHT-1
    dex
.SkipLowerStartColorIdxZero
    stx LowerStartColorIdx
#endif

    TIMER_WAIT

    lda #%00000000
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 上部6ラインはスキップ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    REPEAT 6
        sta WSYNC
    REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 上部の描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldy #HALF_PF_GFX_HEIGHT-1
    ldx UpperStartColorIdx
.UpperScanLoop
    sta WSYNC

#if RENDER_UPPER = 1
    
    ; 背景色の設定
    lda BgColorsUpper,x
    sta COLUBK

    ; プレイフィールド色の設定
    lda PFColorsUpper,x
    sta COLUPF

    ; プレイフィールドのセット
    lda #0 ; 更新が間に合わないので左側のPF0は常に非表示
    sta PF0
    lda PfGfx1Upper,y
    sta PF1
    lda PfGfx2Upper,y
    sta PF2
    ;nop
    ;nop
    ;nop
    lda PfGfx3Upper,y
    sta PF0
    lda PfGfx4Upper,y
    sta PF1
    lda #0 ; 更新が間に合わないので右側のPF2は常に非表示
    sta PF2

    ; 色を変える
    inx
    cpx #HALF_PF_GFX_HEIGHT
    bne .SkipUpperResetColorIdx
    ldx #0
.SkipUpperResetColorIdx

#endif

    ; 次のラインへ
    dey
    bne .UpperScanLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 下部の描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ldy #HALF_PF_GFX_HEIGHT
    ldx LowerStartColorIdx
.LowerScanLoop
    sta WSYNC

#if RENDER_LOWER = 1
    
    ; 背景色の設定
    lda BgColorsLower,x
    sta COLUBK

    ; プレイフィールド色の設定
    lda PFColorsLower,x
    sta COLUPF

    ; プレイフィールドのセット
    lda #0 ; 更新が間に合わないので左側のPF0は常に非表示
    sta PF0
    lda PfGfx1,y
    sta PF1
    lda PfGfx2,y
    sta PF2
    ;nop
    ;nop
    ;nop
    lda PfGfx3,y
    sta PF0
    lda PfGfx4,y
    sta PF1
    lda #0 ; 更新が間に合わないので右側のPF2は常に非表示
    sta PF2

    ; 色を変える
    inx
    cpx #HALF_PF_GFX_HEIGHT
    bne .SkipLowerResetColorIdx
    ldx #0
.SkipLowerResetColorIdx

#endif

    ; 次のラインへ
    dey
    bne .LowerScanLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 描画の後処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; プレイフィールドをクリア
    lda #0
    sta PF0
    sta PF1
    sta PF2
    sta COLUPF
    sta COLUBK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 下部6ラインはスキップ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    REPEAT 6
        sta WSYNC
    REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 処理の開始（オーバースキャン）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_SETUP 28
    lda #%00000010
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 処理の終了（オーバースキャンの終了）
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    TIMER_WAIT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレームの終了
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    jmp NextFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 色
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    MAC WHITE_COLORS_UPPER
        .byte WHITE_BASE_COLOR+14
        .byte WHITE_BASE_COLOR+13
        .byte WHITE_BASE_COLOR+12
        .byte WHITE_BASE_COLOR+11
        .byte WHITE_BASE_COLOR+10
        .byte WHITE_BASE_COLOR+9
        .byte WHITE_BASE_COLOR+8
        .byte WHITE_BASE_COLOR+7
        .byte WHITE_BASE_COLOR+6
        .byte WHITE_BASE_COLOR+5
        .byte WHITE_BASE_COLOR+4
        .byte WHITE_BASE_COLOR+3
        .byte WHITE_BASE_COLOR+2
        .byte WHITE_BASE_COLOR+1
        .byte WHITE_BASE_COLOR+0
    ENDM

    MAC WHITE_COLORS_LOWER
        .byte WHITE_BASE_COLOR+0
        .byte WHITE_BASE_COLOR+1
        .byte WHITE_BASE_COLOR+2
        .byte WHITE_BASE_COLOR+3
        .byte WHITE_BASE_COLOR+4
        .byte WHITE_BASE_COLOR+5
        .byte WHITE_BASE_COLOR+6
        .byte WHITE_BASE_COLOR+7
        .byte WHITE_BASE_COLOR+8
        .byte WHITE_BASE_COLOR+9
        .byte WHITE_BASE_COLOR+10
        .byte WHITE_BASE_COLOR+11
        .byte WHITE_BASE_COLOR+12
        .byte WHITE_BASE_COLOR+13
        .byte WHITE_BASE_COLOR+14
    ENDM

    MAC BLUE_COLORS_UPPER
        .byte BLUE_BASE_COLOR+14
        .byte BLUE_BASE_COLOR+13
        .byte BLUE_BASE_COLOR+12
        .byte BLUE_BASE_COLOR+11
        .byte BLUE_BASE_COLOR+10
        .byte BLUE_BASE_COLOR+9
        .byte BLUE_BASE_COLOR+8
        .byte BLUE_BASE_COLOR+7
        .byte BLUE_BASE_COLOR+6
        .byte BLUE_BASE_COLOR+5
        .byte BLUE_BASE_COLOR+4
        .byte BLUE_BASE_COLOR+3
        .byte BLUE_BASE_COLOR+2
        .byte BLUE_BASE_COLOR+1
        .byte BLUE_BASE_COLOR+0
    ENDM

    MAC BLUE_COLORS_LOWER
        .byte BLUE_BASE_COLOR+0
        .byte BLUE_BASE_COLOR+1
        .byte BLUE_BASE_COLOR+2
        .byte BLUE_BASE_COLOR+3
        .byte BLUE_BASE_COLOR+4
        .byte BLUE_BASE_COLOR+5
        .byte BLUE_BASE_COLOR+6
        .byte BLUE_BASE_COLOR+7
        .byte BLUE_BASE_COLOR+8
        .byte BLUE_BASE_COLOR+9
        .byte BLUE_BASE_COLOR+10
        .byte BLUE_BASE_COLOR+11
        .byte BLUE_BASE_COLOR+12
        .byte BLUE_BASE_COLOR+13
        .byte BLUE_BASE_COLOR+14
    ENDM
    
    MAC RED_COLORS_UPPER
        .byte RED_BASE_COLOR+14
        .byte RED_BASE_COLOR+13
        .byte RED_BASE_COLOR+12
        .byte RED_BASE_COLOR+11
        .byte RED_BASE_COLOR+10
        .byte RED_BASE_COLOR+9
        .byte RED_BASE_COLOR+8 
        .byte RED_BASE_COLOR+7 
        .byte RED_BASE_COLOR+6 
        .byte RED_BASE_COLOR+5 
        .byte RED_BASE_COLOR+4
        .byte RED_BASE_COLOR+3
        .byte RED_BASE_COLOR+2
        .byte RED_BASE_COLOR+1
        .byte RED_BASE_COLOR+0
    ENDM

    MAC RED_COLORS_LOWER
        .byte RED_BASE_COLOR+0 
        .byte RED_BASE_COLOR+1 
        .byte RED_BASE_COLOR+2 
        .byte RED_BASE_COLOR+3 
        .byte RED_BASE_COLOR+4 
        .byte RED_BASE_COLOR+5 
        .byte RED_BASE_COLOR+6 
        .byte RED_BASE_COLOR+7 
        .byte RED_BASE_COLOR+8 
        .byte RED_BASE_COLOR+9 
        .byte RED_BASE_COLOR+10
        .byte RED_BASE_COLOR+11
        .byte RED_BASE_COLOR+12
        .byte RED_BASE_COLOR+13
        .byte RED_BASE_COLOR+14
    ENDM

    align 256
    
BgColorsUpper:
    BLUE_COLORS_UPPER
    WHITE_COLORS_UPPER
    BLUE_COLORS_UPPER
    WHITE_COLORS_UPPER
    BLUE_COLORS_UPPER
    WHITE_COLORS_UPPER

BgColorsLower:
    WHITE_COLORS_LOWER
    BLUE_COLORS_LOWER
    WHITE_COLORS_LOWER
    BLUE_COLORS_LOWER
    WHITE_COLORS_LOWER
    BLUE_COLORS_LOWER

PFColorsUpper:
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER

PFColorsLower:
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイフィールド
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PfGfx0:
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
PfGfx0Upper:
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

PfGfx1
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
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
    .byte %01111111
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
PfGfx1Upper
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

PfGfx2
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
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
PfGfx2Upper
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
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

    

PfGfx3
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
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
PfGfx3Upper
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
    .byte %11110000
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

PfGfx4
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
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
PfGfx4Upper
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
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
    .byte %11111111
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

PfGfx5
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
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
PfGfx5Upper
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
    .byte %00000011
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 末尾
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC
    word Reset
    word Reset
