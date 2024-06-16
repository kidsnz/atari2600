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

; バイオーム番号を指定する
DEBUG_BIOME_NUMBER = 0

; ゾーン組み合わせ番号を指定する
DEBUG_ZONE_COMB_NUMBER = 0

; その他計算用
DEBUG_BIOME_OFFSET = DEBUG_BIOME_NUMBER * 2
DEBUG_ZONE_COMB_OFFSET = DEBUG_ZONE_COMB_NUMBER * 8

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
BUILDING_GFX_HEIGHT = 18 ; ビルの高さ
CLOUD_GFX_HEIGHT    = 16 ; 雲の高さ
YACHT_GFX_HEIGHT    = 16 ; ヨットの高さ

NUM_ZONES        = #5  ; 描画するゾーン数(4+1つの道)
ZONE_HEIGHT      = #33 ; ゾーンの高さ
ROAD_ZONE_HEIGHT = #58 ; 道ゾーンの高さ

NUMBER_OF_BIOMES = #4
NUMBER_OF_BIOMES_MASK = #%00000011

NUMBER_OF_ZONE_COMBS = #4
NUMBER_OF_ZONE_COMBS_MASK = #%00000011

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
SkyZoneP0XPos       byte ; SkyZoneのP0のX座標
ZoneP0XPosAddr      byte ; プレイヤー0のX座標のアドレス
Zone1P0XPos         byte ; ゾーン1のプレイヤー0のX座標
Zone2P0XPos         byte ; ゾーン2のプレイヤー0のX座標
Zone3P0XPos         byte ; ゾーン3のプレイヤー0のX座標
Zone4P0XPos         byte ; ゾーン4のプレイヤー0のX座標

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
    sta SkyZoneP0XPos
    lda #120
    sta Zone1P0XPos
    lda #120
    sta Zone3P0XPos
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

    ; タイマー版
;     lda #%10000010
;     sta VBLANK
;     lda #35
;     sta TIM64T
; .WaitOnVBlank
;     cpx INTIM
;     bmi .WaitOnVBlank
;     lda #%00000000
;     sta VBLANK

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

    ; タイマー版
    ; lda #255
    ; sta TIM64T
    
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
    lda #<Zone1P0XPos
    sta ZoneP0XPosAddr
    jmp (Zone1Addr)
.JmpZone2
    lda #<Zone2P0XPos
    sta ZoneP0XPosAddr
    jmp (Zone2Addr)
.JmpZone3
    lda #<Zone3P0XPos
    sta ZoneP0XPosAddr
    jmp (Zone3Addr)
.JmpZone4
    lda #<Zone4P0XPos
    sta ZoneP0XPosAddr
    jmp (Zone4Addr)
.ZoneEnd
    sta WSYNC
    inc ZoneCounter
    lda ZoneCounter
    cmp #NUM_ZONES
    bmi .ZoneLoop
.ZoneLoopEnd
    ; lda #COLOR_BG
    ; sta COLUBK

; ジョイスティックの処理
MoveJoystick:
    lda #%00010000
    bit SWCHA
    bne SkipMoveUp
    jsr NextRandomValue
SkipMoveUp:
    lda #%00100000
    bit SWCHA
    bne SkipMoveDown
    jsr ResetScene
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
;; ゾーンの実装
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 空ゾーン
SkyZone:
    ; 初期化
    lda #%00000000
    sta NUSIZ0
    ; 横位置の補正
    ldx ZoneP0XPosAddr
    lda $00,X
    ldy #0
    jsr SetObjectXPos
    ; sta WSYNC
    ; sta HMOVE
    ; 背景色のセット
    lda #COLOR_SKY
    sta COLUBK
    ; ラインループの開始
    ldx #ZONE_HEIGHT+1
.SkyZoneLoop
    sta WSYNC
    txa
    sbc #5
    cmp #CLOUD_GFX_HEIGHT
    bcc .DrawCloud
    lda #0
.DrawCloud
    tay
    lda CloudGfx,Y
    sta GRP0
    lda #COLOR_CLOUD
    sta COLUP0
    dex
    bpl .SkyZoneLoop
    ; 雲の横移動
    lda FrameCounter
    and #%00000011
    beq .MoveCloud
    jmp .SkipMoveCloud
.MoveCloud
    ldx ZoneP0XPosAddr
    inc $00,X
    ldy $00,X
    cpy #150
    bcc .SkipMoveCloud
    lda #0
    sta $00,X
.SkipMoveCloud
    jmp .ZoneEnd
    
BuildingZone:
    sta WSYNC
    lda #COLOR_BUILDING_BG
    sta COLUBK

    ; lda #%00000000
    ; sta PF0
    ; lda #%10101010
    ; sta PF1
    ; lda #%01010101
    ; sta PF2
    ; lda #COLOR_BUILDING
    ; sta COLUPF

    ldx ZoneP0XPosAddr
    inc #0,X

    ldx #ZONE_HEIGHT-1
.BuildingZoneLoop
    sta WSYNC
    txa
    cmp #0
    beq .LastDrawBuilding
    txa
    cmp #BUILDING_GFX_HEIGHT
    bcc .DrawBuilding
    lda #0
    jmp .DrawBuilding
.DrawBuilding
    tay
    lda BuildingGfx0,Y
    sta PF0
    lda BuildingGfx1,Y
    sta PF1
    lda BuildingGfx2,Y
    sta PF2
    lda #COLOR_BUILDING
    sta COLUPF

    dex
    bpl .BuildingZoneLoop

.LastDrawBuilding
    lda #COLOR_BUILDING
    sta COLUBK

    lda #0
    sta PF0
    sta PF1
    sta PF2
    jmp .ZoneEnd
    
; 暗い空ゾーン
DarkSkyZone:
    sta WSYNC
    lda #COLOR_DARK_SKY
    sta COLUBK
    ldx #ZONE_HEIGHT-1
.DarkSkyZoneLoop
    sta WSYNC
    dex
    bpl .DarkSkyZoneLoop
    jmp .ZoneEnd
    
; 海ゾーン
SeaZone:
    ; 初期化
    lda #%00000000
    sta NUSIZ0
    ; 横位置の補正
    ldx ZoneP0XPosAddr
    lda #0,X
    ldy #0
    jsr SetObjectXPos
    ; sta WSYNC
    ; sta HMOVE
    ; 背景色のセット
    lda #COLOR_SEA
    sta COLUBK
    ; ラインループの開始
    ldx #ZONE_HEIGHT-1
.SeaZoneLoop
    sta WSYNC
    txa
    sbc #5
    cmp #YACHT_GFX_HEIGHT
    bcc .DrawYacht
    lda #0
.DrawYacht
    tay
    lda YachtGfx,Y
    sta GRP0
    lda YachtGfxColor,Y
    sta COLUP0
    dex
    bpl .SeaZoneLoop
    ; ヨットの横移動
    lda FrameCounter
    and #%00001111
    beq .MoveYacht
    jmp .SkipMoveYacht
.MoveYacht
    ldx ZoneP0XPosAddr
    inc $00,X
    ldy $00,X
    cpy #150
    bcc .SkipMoveYacht
    lda #0
    sta #0,X
.SkipMoveYacht
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
    lda #%00000101
    sta NUSIZ0
    ; 横位置の補正
    lda PlayerXPos
    ldy #0
    jsr SetObjectXPos
    ; sta WSYNC
    ; sta HMOVE
    ; 背景色のセット
    lda #COLOR_ROAD
    sta COLUBK
    ldx #ROAD_ZONE_HEIGHT-1
.RoadZoneLoop
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
    bpl .RoadZoneLoop
    lda #%00000000
    sta NUSIZ0
    jmp .ZoneEnd
  
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


#if DEBUG = 1
    ; バイオームを選択
    lda Biomes + DEBUG_BIOME_OFFSET
    sta SelectedBiomeAddr
    lda Biomes + DEBUG_BIOME_OFFSET + 1
    sta SelectedBiomeAddr+1
#else
    ; バイオームをランダムに選択
    jsr NextRandomValue
    lda RandomValue
    and #NUMBER_OF_BIOMES_MASK
    sta BiomeNumber
    REPEAT 1
      clc
      adc BiomeNumber
    REPEND
    tax
    lda Biomes,x
    sta SelectedBiomeAddr
    lda Biomes+1,x
    sta SelectedBiomeAddr+1
#endif

#if DEBUG = 1
    ; ゾーンの組み合わせを選択
    lda SelectedBiomeAddr
    clc
    adc DEBUG_ZONE_COMB_OFFSET
    sta SelectedCombAddr
    lda SelectedBiomeAddr+1
    sta SelectedCombAddr+1
#else
    ; ゾーンの組み合わせをランダムに選択
    jsr NextRandomValue
    lda RandomValue
    and #NUMBER_OF_ZONE_COMBS_MASK
    sta ZoneCombNumber
    REPEAT ((NUM_ZONES - 1) * 2) - 1 ; ゾーン番号に応じたオフセット値を計算してAに入れる
      clc
      adc ZoneCombNumber
    REPEND
    adc SelectedBiomeAddr ; 選択されたバイオームのアドレスにオフセット値を加算
    sta SelectedCombAddr ; バイオームのアドレス + オフセット値を組み合わせのアドレスとして保存
    lda SelectedBiomeAddr+1
    sta SelectedCombAddr+1
#endif

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
    cpx #134
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
    sta WSYNC
    tax
    sec
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
    sta WSYNC
    sta HMOVE
    rts
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; データ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; バイオーム一覧
Biomes:
    .word TownBiome
    .word SeaBiome
    .word GrasslandBiome
    .word SandBiome
`
; 街バイオーム
TownBiome:
    .word SkyZone, BuildingZone, SeaZone, GrasslandZone
    .word SkyZone, BuildingZone, GrasslandZone, GrasslandZone
    .word SkyZone, BuildingZone, GrasslandZone, GrasslandZone
    .word SkyZone, BuildingZone, GrasslandZone, GrasslandZone

; 海バイオーム
SeaBiome:
    .word SkyZone, SeaZone, SeaZone, SandZone
    .word SkyZone, SeaZone, SeaZone, SeaZone
    .word SkyZone, SeaZone, SeaZone, SeaZone
    .word SkyZone, SeaZone, SeaZone, SeaZone

; 草原バイオーム
GrasslandBiome:
    .word SkyZone, SkyZone, GrasslandZone, GrasslandZone
    .word SkyZone, GrasslandZone, GrasslandZone, GrasslandZone
    .word SkyZone, GrasslandZone, GrasslandZone, GrasslandZone
    .word SkyZone, GrasslandZone, GrasslandZone, GrasslandZone

; 砂バイオーム
SandBiome:
    .word SkyZone, SandZone, SandZone, SandZone
    .word SkyZone, SandZone, SeaZone, SandZone
    .word SkyZone, SandZone, SandZone, SeaZone
    .word SandZone, SandZone, SandZone, SandZone

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

; 雲スプライト
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


; ヨットスプライト
YachtGfx:
    .byte %00000000 ; |        |
    .byte %00111100 ; |  XXXX  |
    .byte %01111110 ; | XXXXXX |
    .byte %11111111 ; |XXXXXXXX|
    .byte %11111111 ; |XXXXXXXX|
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00010000 ; |   X    |
    .byte %00011000 ; |   XX   |
    .byte %00011100 ; |   XXX  |
    .byte %00011110 ; |   XXXX |
    .byte %00011111 ; |   XXXXX|
    .byte %00011110 ; |   XXXX |
    .byte %00011100 ; |   XXX  |
    .byte %00011000 ; |   XX   |

; ヨットスプライトカラー
YachtGfxColor:
    .byte $FF ; |        |
    .byte $1C ; |  XXXX  |
    .byte $1C ; | XXXXXX |
    .byte $1C ; |XXXXXXXX|
    .byte $1C ; |XXXXXXXX|
    .byte $00 ; |   X    |
    .byte $00 ; |   X    |
    .byte $00 ; |   X    |
    .byte $00 ; |   X    |
    .byte $0E ; |   XX   |
    .byte $0E ; |   XXX  |
    .byte $0E ; |   XXXX |
    .byte $0E ; |   XXXXX|
    .byte $0E ; |   XXXX |
    .byte $0E ; |   XXX  |
    .byte $0E ; |   XX   |

; ビル背景0
BuildingGfx0:
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

; ビル背景1
BuildingGfx1:
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

; ビル背景2
BuildingGfx2:
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
