    processor 6502

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; インクルード文
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    include "vcs.h"
    include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; デバッグ用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ANIMATION             = 1
OFFSET                = 1

; 上部を描画する
RENDER_UPPER = 1

; 下部を描画する
RENDER_LOWER = 1

; 上部のグラデーションの移動(0: 上方向, 1: 下方向)
UPPER_MOVE_DOWN = 0

; 下部のグラデーションの移動(0: 上方向, 2: 下方向)
LOWER_MOVE_DOWN = 1

; 上部のグラデーションの向き(0: 上から下に暗く, 1: 逆)
UPPER_GRADATION_DOWN = 0

; 下部のグラデーションの向き(0: 上から下に暗く, 1: 逆)
LOWER_GRADATION_DOWN = 1

#if UPPER_MOVE_DOWN = 0
START_UPPER_COLOR_IDX = OFFSET
#endif
#if UPPER_MOVE_DOWN = 1
START_UPPER_COLOR_IDX = HALF_PF_GFX_HEIGHT-OFFSET
#endif
#if LOWER_MOVE_DOWN = 0
START_LOWER_COLOR_IDX = OFFSET
#endif
#if LOWER_MOVE_DOWN = 1
START_LOWER_COLOR_IDX = HALF_PF_GFX_HEIGHT-OFFSET
#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; カラーコード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WHITE_BASE_COLOR = $00
BLUE_BASE_COLOR  = $70
RED_BASE_COLOR   = $40
CHARACTER_COLOR  = $0E
CHARACTER_COLOR2 = $0E

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PF_GFX_HEIGHT      = 180               ; プレイフィールドの高さ
HALF_PF_GFX_HEIGHT = PF_GFX_HEIGHT / 2 ; プレイフィールドの高さの半分
SPRITE_X_POS       = 38                ; 文字の開始位置
SPRITE_SLEEP       = 4                ; 文字描画の待機時間(文字の開始位置に応じて調整)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; スプライト用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SPRITE_NUSIZ_TWO_COPY   = %00000001 ; 2つコピー表示
SPRITE_NUSIZ_THREE_COPY = %00000011 ; 3つコピー表示

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; プレイフィールド用定数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PF_UNMIRRORING = %00000000 ; プレイフィールドをミラーリングしない
PF_MIRRORING   = %00000001 ; プレイフィールドをミラーリングする

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

; 3 byte / 128 byte

UpperStartColorIdx byte
LowerStartColorIdx byte
xTemp byte;

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

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; グラデーションのアニメーション処理
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#if ANIMATION = 1
#if UPPER_MOVE_DOWN = 0
    ; 上部開始色インデックスをインクリメント
    ldx UpperStartColorIdx
    inx

    ; 上部開始色インデックスがHALF_PF_GFX_HEIGHTを超えたら0に戻す
    cpx #HALF_PF_GFX_HEIGHT-1
    bne .SkipUpperStartColorIdxZero
    ldx #0
.SkipUpperStartColorIdxZero
    stx UpperStartColorIdx
#endif
#if UPPER_MOVE_DOWN = 1
    ; 上部開始色インデックスをデクリメント
    ldx UpperStartColorIdx
    dex

    ; 上部開始色インデックスが0未満になったらHALF_PF_GFX_HEIGHT-1に戻す
    bne .SkipUpperStartColorIdxZero
    ldx #HALF_PF_GFX_HEIGHT-1
    dex
.SkipUpperStartColorIdxZero
    stx UpperStartColorIdx
#endif
#if LOWER_MOVE_DOWN = 0
    ; 下部開始色インデックスをインクリメント
    ldx LowerStartColorIdx
    inx

    ; 下部開始色インデックスがHALF_PF_GFX_HEIGHTを超えたら0に戻す
    cpx #HALF_PF_GFX_HEIGHT-1
    bne .SkipLowerStartColorIdxZero
    ldx #0
.SkipLowerStartColorIdxZero
    stx LowerStartColorIdx
#endif
#if LOWER_MOVE_DOWN = 1
    ; 下部開始色インデックスをデクリメント
    ldx LowerStartColorIdx
    dex

    ; 下部開始色インデックスが0未満になったらHALF_PF_GFX_HEIGHT-1に戻す
    bne .SkipLowerStartColorIdxZero
    ldx #HALF_PF_GFX_HEIGHT-1
    dex
.SkipLowerStartColorIdxZero
    stx LowerStartColorIdx
#endif

#endif

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; スプライトの処理
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    ; スプライト色をセット
    lda #CHARACTER_COLOR
    sta COLUP0
    lda #CHARACTER_COLOR2
    sta COLUP1

    ; スプライトのNUSIZをセット
    lda #SPRITE_NUSIZ_THREE_COPY
    sta NUSIZ0
    lda #SPRITE_NUSIZ_TWO_COPY
    sta NUSIZ1
    
    ; スプライトの座標
    sta WSYNC
    SLEEP SPRITE_X_POS
    sta RESP0
    sta RESP1
    lda #$10
    sta HMP1
    sta WSYNC
    sta HMOVE
    
    ; VDELPを有効(GRP0,1へのアクセスがバッファリングされる)
    lda #1
    sta VDELP0
    sta VDELP1

    TIMER_WAIT
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 垂直ブランクの終了
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
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
    cpy #30 ; 残り30ラインになったら文字を描画するループへ
    bne .LowerScanLoop
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 下部の文字エリアの描画
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; プレイフィールドは使わないのでクリア
    lda #0
    sta PF0
    sta PF1
    sta PF2
    
.LowerScanLoop2
    sta WSYNC
    
#if RENDER_LOWER = 1

    ; 背景色の設定
    lda BgColorsLower,x
    sta COLUBK
    stx xTemp
    lda ChGfx0,y
    sta GRP0 ; B0 -> [GRP0]
    lda ChGfx1,y
    sta GRP1 ; B1 -> [GRP1], B0 -> GRP0
    lda ChGfx2,y
    sta GRP0 ; B2 -> [GRP0], B1 -> GRP1
    ldx ChGfx4,y ; 5個目をxにバッファ
    lda ChGfx3,y ; 4個目をaにバッファ
    SLEEP SPRITE_SLEEP ; 2個目のスプライトにラインがかかるくらいまで待つ
    sta GRP1 ; B3 -> [GRP1], B2 -> GRP0
    stx GRP0 ; B4 -> [GRP0], B3 -> GRP1
    sta GRP1 ; B4 -> GRP0
    ldx xTemp
.RenderCharacterEnd

    ; 色を変える
    inx
    cpx #HALF_PF_GFX_HEIGHT
    bne .SkipLowerResetColorIdx2
    ldx #0
.SkipLowerResetColorIdx2

#endif

    ; 次のラインへ
    dey
    bne .LowerScanLoop2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 描画の後処理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    sta WSYNC ; ガタつくので1ライン待つ

    ; クリア
    lda #0
    sta PF0
    sta PF1
    sta PF2
    sta COLUPF
    sta COLUBK
    sta GRP0
    sta GRP1
    sta VDELP0
    sta VDELP1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 下部6ラインはスキップ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    REPEAT 6
        sta WSYNC
    REPEND

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
;; フレームの終了
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    jmp NextFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; サブルーチン
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
#if UPPER_GRADATION_DOWN = 0
    BLUE_COLORS_UPPER
    WHITE_COLORS_UPPER
    BLUE_COLORS_UPPER
    WHITE_COLORS_UPPER
    BLUE_COLORS_UPPER
    WHITE_COLORS_UPPER
#endif
#if UPPER_GRADATION_DOWN = 1
    BLUE_COLORS_LOWER
    WHITE_COLORS_LOWER
    BLUE_COLORS_LOWER
    WHITE_COLORS_LOWER
    BLUE_COLORS_LOWER
    WHITE_COLORS_LOWER
#endif

BgColorsLower:
#if LOWER_GRADATION_DOWN = 0
    WHITE_COLORS_UPPER
    BLUE_COLORS_UPPER
    WHITE_COLORS_UPPER
    BLUE_COLORS_UPPER
    WHITE_COLORS_UPPER
    BLUE_COLORS_UPPER
#endif
#if LOWER_GRADATION_DOWN = 1
    WHITE_COLORS_LOWER
    BLUE_COLORS_LOWER
    WHITE_COLORS_LOWER
    BLUE_COLORS_LOWER
    WHITE_COLORS_LOWER
    BLUE_COLORS_LOWER
#endif

PFColorsUpper:
#if UPPER_GRADATION_DOWN = 0
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
#endif
#if UPPER_GRADATION_DOWN = 1
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
#endif

PFColorsLower:
#if LOWER_GRADATION_DOWN = 0
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
    RED_COLORS_UPPER
#endif
#if LOWER_GRADATION_DOWN = 1
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
    RED_COLORS_LOWER
#endif
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 文字
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    align 256

ChGfx0:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %11111101
    .byte %10000101
    .byte %10110101
    .byte %10100100
    .byte %10110101
    .byte %10000100
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
    
ChGfx1:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %11011101
    .byte %00010101
    .byte %11010101
    .byte %01010100
    .byte %11011101
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
ChGfx2:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %11011101
    .byte %00000101
    .byte %11011101
    .byte %01010001
    .byte %11011101
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
    
ChGfx3:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00010101
    .byte %01010101
    .byte %01010111
    .byte %01010101
    .byte %01010101
    .byte %11110111
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
ChGfx4:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %01110101
    .byte %01010101
    .byte %01010111
    .byte %01000101
    .byte %01000101
    .byte %01110111
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    
ChGfx5:
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
    .byte %00000000
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
