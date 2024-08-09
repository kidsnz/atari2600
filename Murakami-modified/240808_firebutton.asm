; Disassembly of ~/Documents/Projects/231211_Shibuya Pixel 2024/Files_Asteroid original/Asteroids (1981) (Atari, Brad Stewart - Sears) (CX2649 - 49-75163) ~.bin
; Disassembled Sun May 19 16:58:21 2024
; Using Stella 6.7.1
;
; ROM properties name : Asteroids (1981) (Atari)
; ROM properties MD5  : dd7884b4f93cab423ac471aa1935e3df
; Bankswitch type     : F8* (8K) 
;
; Legend: *  = CODE not yet run (tentative code)
;         D  = DATA directive (referenced in some way)
;         G  = GFX directive, shown as '#' (stored in player, missile, ball)
;         P  = PGFX directive, shown as '*' (stored in playfield)
;         C  = COL directive, shown as color constants (stored in player color)
;         CP = PCOL directive, shown as color constants (stored in playfield color)
;         CB = BCOL directive, shown as color constants (stored in background color)
;         A  = AUD directive (stored in audio registers)
;         i  = indexed accessed only
;         c  = used by code executed in RAM
;         s  = used by stack
;         !  = page crossed, 1 cycle penalty

    processor 6502


;-----------------------------------------------------------
;      Color constants
;-----------------------------------------------------------

BLACK            = $0f    ; demo: no, WHITE
YELLOW           = $17    ; demo: yes, YELLOW
BROWN            = $27    ; demo: no, BROWN
ORANGE           = $37    ; not used, prob only BG of demo
RED              = $47    ; demo: yes, RED
MAUVE            = $57    ; demo: yes, ほぼPURPLE
VIOLET           = $67    ; not used, prob only BG of demo
PURPLE           = $77    ; demo: no, ほぼBLUE
BLUE             = $87    ; not used
BLUE_CYAN        = $87    ; demo: yes, 薄いBLUE
CYAN             = $a7    ; not used
CYAN_GREEN       = $b7    ; not used
GREEN            = $c7    ; not used
GREEN_YELLOW     = $b0    ; not used
GREEN_BEIGE      = $b7    ; demo: no, GREEN
BEIGE            = $f7    ; not used, prob only BG of demo


;-----------------------------------------------------------
;      TIA and IO constants accessed
;-----------------------------------------------------------

;CXM0P          = $00  ; (Ri)
;CXM1P          = $01  ; (Ri)
;CXP0FB         = $02  ; (Ri)
;CXP1FB         = $03  ; (Ri)
;CXM0FB         = $04  ; (Ri)
;CXM1FB         = $05  ; (Ri)
;CXBLPF         = $06  ; (Ri)
;CXPPMM         = $07  ; (Ri)
;INPT0          = $08  ; (Ri)
;INPT1          = $09  ; (Ri)
;INPT2          = $0a  ; (Ri)
;INPT3          = $0b  ; (Ri)
INPT4           = $0c  ; (R)
;INPT5          = $0d  ; (Ri)
;$1e            = $0e  ; (Ri)
;$1f            = $0f  ; (Ri)

VSYNC           = $00  ; (W)
VBLANK          = $01  ; (W)
WSYNC           = $02  ; (W)
NUSIZ0          = $04  ; (W)
NUSIZ1          = $05  ; (W)
COLUP0          = $06  ; (W)
COLUP1          = $07  ; (W)
COLUPF          = $08  ; (W)
COLUBK          = $09  ; (W)
REFP0           = $0b  ; (W)
PF0             = $0d  ; (W)
PF1             = $0e  ; (W)
PF2             = $0f  ; (W)
RESP0           = $10  ; (W)
RESP1           = $11  ; (W)
RESM0           = $12  ; (W)
;RESM1          = $13  ; (Wi)
;RESBL          = $14  ; (Wi)
AUDC0           = $15  ; (W)
AUDC1           = $16  ; (W)
AUDF0           = $17  ; (W)
AUDF1           = $18  ; (W)
AUDV0           = $19  ; (W)
AUDV1           = $1a  ; (W)
GRP0            = $1b  ; (W)
GRP1            = $1c  ; (W)
ENAM0           = $1d  ; (W)
ENAM1           = $1e  ; (W)
ENABL           = $1f  ; (W)
HMP0            = $20  ; (W)
HMP1            = $21  ; (W)
HMM0            = $22  ; (W)
;HMM1           = $23  ; (Wi)
;HMBL           = $24  ; (Wi)
VDELP0          = $25  ; (W)
VDELP1          = $26  ; (W)
HMOVE           = $2a  ; (W)
HMCLR           = $2b  ; (W)

SWCHA           = $0280
SWCHB           = $0282
INTIM           = $0284
TIM64T          = $0296


;-----------------------------------------------------------
;      RIOT RAM (zero-page) labels
;-----------------------------------------------------------

ram_80          = $80
ram_81          = $81
ram_82          = $82
ram_83          = $83
ram_84          = $84
;                 $85  (i)
;                 $86  (i)
;                 $87  (i)
;                 $88  (i)
;                 $89  (i)
;                 $8a  (i)
;                 $8b  (i)
ram_8C          = $8c
;                 $8d  (i)
;                 $8e  (i)
;                 $8f  (i)
;                 $90  (i)
;                 $91  (i)
;                 $92  (i)
;                 $93  (i)
ram_94          = $94
ram_95          = $95
ram_96          = $96
;                 $97  (i)
;                 $98  (i)
;                 $99  (i)
;                 $9a  (i)
;                 $9b  (i)
;                 $9c  (i)
;                 $9d  (i)
;                 $9e  (i)
;                 $9f  (i)
;                 $a0  (i)
;                 $a1  (i)
;                 $a2  (i)
;                 $a3  (i)
;                 $a4  (i)
;                 $a5  (i)
;                 $a6  (i)
ram_A7          = $a7
ram_A8          = $a8
;                 $a9  (i)
;                 $aa  (i)
;                 $ab  (i)
;                 $ac  (i)
;                 $ad  (i)
;                 $ae  (i)
;                 $af  (i)
;                 $b0  (i)
;                 $b1  (i)
;                 $b2  (i)
;                 $b3  (i)
;                 $b4  (i)
;                 $b5  (i)
;                 $b6  (i)
;                 $b7  (i)
;                 $b8  (i)
ram_B9          = $b9
ram_BA          = $ba
ram_BB          = $bb
ram_BC          = $bc
ram_BD          = $bd
ram_BE          = $be
ram_BF          = $bf
;                 $c0  (i)
;                 $c1  (i)
ram_C2          = $c2
ram_C3          = $c3
ram_C4          = $c4
ram_C5          = $c5
ram_C6          = $c6
ram_C7          = $c7
ram_C8          = $c8
ram_C9          = $c9
ram_CA          = $ca
ram_CB          = $cb
ram_CC          = $cc
ram_CD          = $cd
ram_CE          = $ce
ram_CF          = $cf
ram_D0          = $d0
ram_D1          = $d1
ram_D2          = $d2
ram_D3          = $d3
ram_D4          = $d4
ram_D5          = $d5
ram_D6          = $d6
ram_D7          = $d7
ram_D8          = $d8
ram_D9          = $d9
ram_DA          = $da
ram_DB          = $db
ram_DC          = $dc
ram_DD          = $dd
ram_DE          = $de
ram_DF          = $df
ram_E0          = $e0
ram_E1          = $e1
ram_E2          = $e2
ram_E3          = $e3
ram_E4          = $e4
ram_E5          = $e5
ram_E6          = $e6
ram_E7          = $e7
ram_E8          = $e8
ram_E9          = $e9
ram_EA          = $ea
ram_EB          = $eb
ram_EC          = $ec
ram_ED          = $ed
ram_EE          = $ee
ram_EF          = $ef
ram_F0          = $f0
ram_F1          = $f1
ram_F2          = $f2; (s)
ram_F3          = $f3
ram_F4          = $f4
ram_F5          = $f5
ram_F6          = $f6
ram_F7          = $f7
ram_F8          = $f8
ram_F9          = $f9
ram_FA          = $fa; (s)
ram_FB          = $fb; (s)
ram_FC          = $fc; (s)
ram_FD          = $fd; (s)
ram_FE          = $fe; (s)
ram_FF          = $ff; (s)


;-----------------------------------------------------------
;      User Defined Labels
;-----------------------------------------------------------

Start           = $f9da


;***********************************************************
;      Bank 0 / 0..1
;***********************************************************

    SEG     CODE
    ORG     $0000
    RORG    $f000

    .byte   $4c,$da,$f9                     ; $f000 (*)
    
Lf003
    sta     WSYNC                   ;3   =   3
;---------------------------------------
Lf005
    sta     HMOVE                   ;3        
    sta     GRP1                    ;3        
    stx     NUSIZ1                  ;3        
    jmp.ind (ram_E3)                ;5        
    nop                             ;2        
    php                             ;3        
    plp                             ;4        
    nop                             ;2        
    nop                             ;2        
    lda     ram_E9                  ;3        
    sta     HMCLR                   ;3        
    sta     HMP0                    ;3        
    lda     #$83                    ;2        
    sta     ram_E3                  ;3        
    ldx     ram_E7                  ;3        
    lda     #$00                    ;2        
    dex                             ;2        
    bne     Lf029                   ;2/3      
    sta     RESP0                   ;3   =  53
Lf026
    jmp     $d100                   ;3   =   3
    
Lf029
    dex                             ;2        
    bne     Lf030                   ;2/3      
    sta     RESP0                   ;3        
    beq     Lf026                   ;2/3 =   9
Lf030
    dex                             ;2        
    bne     Lf037                   ;2/3      
    sta     RESP0                   ;3        
    beq     Lf026                   ;2/3 =   9
Lf037
    dex                             ;2        
    bne     Lf03f                   ;2/3      
    sta     RESP0                   ;3        
    jmp     $d100                   ;3   =  10
    
Lf03f
    dex                             ;2        
    nop                             ;2        
    sta     RESP0                   ;3        
    jmp     $d102                   ;3   =  10
    
    ldx     ram_E7                  ;3        
    dex                             ;2        
    bne     Lf050                   ;2/3      
    sta     RESP0                   ;3        
    nop                             ;2        
    beq     Lf055                   ;2/3 =  14
Lf050
    dex                             ;2        
    bne     Lf058                   ;2/3      
    sta     RESP0                   ;3   =   7
Lf055
    nop                             ;2        
    beq     Lf05d                   ;2/3 =   4
Lf058
    dex                             ;2        
    bne     Lf060                   ;2/3      
    sta     RESP0                   ;3   =   7
Lf05d
    nop                             ;2        
    beq     Lf065                   ;2/3 =   4
Lf060
    dex                             ;2        
    bne     Lf068                   ;2/3      
    sta     RESP0                   ;3   =   7
Lf065
    nop                             ;2        
    beq     Lf06d                   ;2/3 =   4
Lf068
    dex                             ;2        
    bne     Lf070                   ;2/3      
    sta     RESP0                   ;3   =   7
Lf06d
    nop                             ;2        
    beq     Lf074                   ;2/3 =   4
Lf070
    dex                             ;2        
    nop                             ;2        
    sta     RESP0                   ;3   =   7
Lf074
    sta     HMCLR                   ;3        
    lda     ram_E9                  ;3        
    sta     HMP0                    ;3        
    lda     #$83                    ;2        
    sta     ram_E3                  ;3        
    lda     #$00                    ;2        
    jmp     $d100                   ;3   =  19
    
    ldx     #$00                    ;2        
    lda     (ram_EF,x)              ;6        
    bne     Lf0a2                   ;2/3      
    inc     ram_DC                  ;5        
    ldx     ram_DC                  ;3        
    lda     ram_95,x                ;4        
    sta     HMCLR                   ;3        
    sta     ram_E9                  ;3        
    lsr                             ;2        
    and     #$07                    ;2        
    sta     ram_E7                  ;3        
    lda     #$c0                    ;2        
    sta     ram_E3                  ;3        
    lda     #$00                    ;2        
    tax                             ;2        
    jmp     $d100                   ;3   =  47
    
Lf0a2
    sta     HMCLR                   ;3        
    sta     HMP0                    ;3        
    sta     ram_F3                  ;3        
    ldx     ram_F8                  ;3        
    lda     $de75,x                 ;4        
    sta     COLUP0                  ;3        
    ldx     #$00                    ;2        
    lda     (ram_EB,x)              ;6        
    inc     ram_EB                  ;5        
    inc     ram_EF                  ;5        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    ldx     ram_F3                  ;3        
    nop                             ;2        
    jmp     $d102                   ;3   =  51
    
    ldx     ram_DC                  ;3        
    lda     ram_A7,x                ;4        
    and     #$70                    ;2        
    sta     ram_EB                  ;3        
    sta     ram_EF                  ;3        
    sta     HMCLR                   ;3        
    lda     ram_A7,x                ;4        
    and     #$07                    ;2        
    sta     ram_F8                  ;3        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    tya                             ;2        
    cmp     ram_83,x                ;4        
    bne     Lf0f4                   ;2/3      
    lda     ram_E9                  ;3        
    ror                             ;2        
    ldx     #$46                    ;2        
    bcs     Lf0eb                   ;2/3      
    ldx     #$0e                    ;2        
    stx     ram_E3                  ;3        
    lda     #$00                    ;2        
    tax                             ;2        
    jmp     $d102                   ;3   =  62
    
Lf0eb
    stx.w   ram_E3                  ;4        
    lda     #$00                    ;2        
    tax                             ;2        
    jmp     $d102                   ;3   =  11
    
Lf0f4
    lda     #$00                    ;2        
    tax                             ;2        
    jmp     $d100                   ;3   =   7
    
Lf0fa
    jmp     $d42b                   ;3   =   3
    
    .byte   $00,$00                         ; $f0fd (*)
    .byte   $00                             ; $f0ff (D)
    
Lf100
    sta     WSYNC                   ;3   =   3
;---------------------------------------
Lf102
    sta     HMOVE                   ;3        
    sta     GRP0                    ;3        
    stx     NUSIZ0                  ;3        
    jmp.ind (ram_E5)                ;5        
    iny                             ;2        
    php                             ;3        
    plp                             ;4        
    cpy     #$59                    ;2        
    beq     Lf0fa                   ;2/3!     
    lda     ram_EA                  ;3        
    sta     HMCLR                   ;3        
    sta     HMP1                    ;3        
    lda     #$88                    ;2        
    sta     ram_E5                  ;3        
    ldx     ram_E8                  ;3        
    lda     #$00                    ;2        
    dex                             ;2        
    bne     Lf128                   ;2/3      
    sta     RESP1                   ;3   =  53
Lf125
    jmp     $d003                   ;3   =   3
    
Lf128
    dex                             ;2        
    bne     Lf12f                   ;2/3      
    sta     RESP1                   ;3        
    beq     Lf125                   ;2/3 =   9
Lf12f
    dex                             ;2        
    bne     Lf136                   ;2/3      
    sta     RESP1                   ;3        
    beq     Lf125                   ;2/3 =   9
Lf136
    dex                             ;2        
    bne     Lf13e                   ;2/3      
    sta     RESP1                   ;3        
    jmp     $d003                   ;3   =  10
    
Lf13e
    dex                             ;2        
    nop                             ;2        
    sta     RESP1                   ;3        
    jmp     $d005                   ;3   =  10
    
    ldx     ram_E8                  ;3        
    dex                             ;2        
    bne     Lf14f                   ;2/3      
    sta     RESP1                   ;3        
    nop                             ;2        
    beq     Lf154                   ;2/3 =  14
Lf14f
    dex                             ;2        
    bne     Lf157                   ;2/3      
    sta     RESP1                   ;3   =   7
Lf154
    nop                             ;2        
    beq     Lf15c                   ;2/3 =   4
Lf157
    dex                             ;2        
    bne     Lf15f                   ;2/3      
    sta     RESP1                   ;3   =   7
Lf15c
    nop                             ;2        
    beq     Lf164                   ;2/3 =   4
Lf15f
    dex                             ;2        
    bne     Lf167                   ;2/3      
    sta     RESP1                   ;3   =   7
Lf164
    nop                             ;2        
    beq     Lf16c                   ;2/3 =   4
Lf167
    dex                             ;2        
    bne     Lf16f                   ;2/3      
    sta     RESP1                   ;3   =   7
Lf16c
    nop                             ;2        
    beq     Lf173                   ;2/3 =   4
Lf16f
    dex                             ;2        
    nop                             ;2        
    sta     RESP1                   ;3   =   7
Lf173
    sta     HMCLR                   ;3        
    lda     ram_EA                  ;3        
    sta     HMP1                    ;3        
    iny                             ;2        
    cpy     #$59                    ;2        
    beq     Lf1cc                   ;2/3      
    lda     #$88                    ;2        
    sta     ram_E5                  ;3        
    lda     #$00                    ;2        
    nop                             ;2        
    jmp     $d005                   ;3   =  27
    
    ldx     #$00                    ;2        
    lda     (ram_F1,x)              ;6        
    bne     Lf1ac                   ;2/3      
    inc     ram_DD                  ;5        
    ldx     ram_DD                  ;3        
    lda     ram_95,x                ;4        
    sta     HMCLR                   ;3        
    sta     ram_EA                  ;3        
    lsr                             ;2        
    and     #$07                    ;2        
    sta     ram_E8                  ;3        
    iny                             ;2        
    cpy     #$59                    ;2        
    beq     Lf1cc                   ;2/3      
    lda     #$cf                    ;2        
    sta     ram_E5                  ;3        
    lda     #$00                    ;2        
    tax                             ;2        
    jmp     $d003                   ;3   =  53
    
Lf1ac
    sta     HMCLR                   ;3        
    sta     HMP1                    ;3        
    sta     ram_F3                  ;3        
    ldx     ram_F9                  ;3        
    lda     $de75,x                 ;4        
    sta     COLUP1                  ;3        
    ldx     #$00                    ;2        
    lda     (ram_ED,x)              ;6        
    inc     ram_ED                  ;5        
    inc     ram_F1                  ;5        
    iny                             ;2        
    cpy     #$59                    ;2        
    beq     Lf1cc                   ;2/3      
    ldx     ram_F3                  ;3        
    nop                             ;2        
    jmp     $d005                   ;3   =  51
    
Lf1cc
    jmp     $d42b                   ;3   =   3
    
    ldx     ram_DD                  ;3        
    lda     ram_A7,x                ;4        
    and     #$70                    ;2        
    sta     ram_ED                  ;3        
    sta     ram_F1                  ;3        
    sta     HMCLR                   ;3        
    lda     ram_A7,x                ;4        
    and     #$07                    ;2        
    sta     ram_F9                  ;3        
    tya                             ;2        
    cmp     ram_83,x                ;4        
    bne     Lf20d                   ;2/3!     
    lda     ram_EA                  ;3        
    ror                             ;2        
    ldx     #$45                    ;2        
    bcs     Lf200                   ;2/3!     
    ldx     #$0b                    ;2        
    stx     ram_E5                  ;3        
    lda     #$00                    ;2        
    iny                             ;2        
    cpy     #$59                    ;2        
    beq     Lf218                   ;2/3!     
    tax                             ;2        
    jmp     $d005                   ;3   =  62
    
Lf1fc
    jmp     $d42d                   ;3   =   3
    
    .byte   $00                             ; $f1ff (*)
    
Lf200
    stx     ram_E5                  ;3        
    lda     #$00                    ;2        
    iny                             ;2        
    cpy     #$59                    ;2        
    beq     Lf1fc                   ;2/3!     
    tax                             ;2        
    jmp     $d005                   ;3   =  16
    
Lf20d
    iny                             ;2        
    cpy     #$59                    ;2        
    beq     Lf1cc                   ;2/3!     
    lda     #$00                    ;2        
    tax                             ;2        
    jmp     $d003                   ;3   =  13
    
Lf218
    jmp     $d42d                   ;3   =   3
    
Lf21b
    ldx     ram_F3                  ;3        
    lda     ram_FC                  ;3        
    sta     WSYNC                   ;3   =   9
;---------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
Lf223
    sta     PF0                     ;3        
    lda     ram_FD                  ;3        
    sta     PF1                     ;3        
    lda     ram_FE                  ;3        
    sta     PF2                     ;3        
    lda     $ddc8,x                 ;4        
    sta     GRP0                    ;3        
    lda     $ddd7,x                 ;4        
    sta     GRP1                    ;3        
    dex                             ;2        
    lda     #$00                    ;2        
    sta     PF0                     ;3        
    ldy     ram_F7                  ;3        
    sta     PF1                     ;3        
    lda     (ram_F4),y              ;5        
    ldy     ram_FF                  ;3        
    sty     PF2                     ;3        
    ldy     ram_FC                  ;3        
    sty     PF0                     ;3        
    ldy     ram_FD                  ;3        
    nop                             ;2        
    sty     PF1                     ;3        
    ldy     ram_F8                  ;3        
    ora     (ram_F4),y              ;5        
    sta     ram_FD                  ;3        
    lda     ram_FE                  ;3        
    sta     PF2                     ;3        
    ldy     ram_F9                  ;3        
    lda     (ram_F4),y              ;5        
    ldy     ram_FA                  ;3        
    ora     (ram_F4),y              ;5        
    sta     ram_FE                  ;3        
    ldy     ram_FB                  ;3        
    lda     (ram_F4),y              ;5        
    ldy     ram_FB                  ;3        
    ldy     #$00                    ;2        
    sty     PF0                     ;3        
    sty     PF1                     ;3        
    ldy     ram_FF                  ;3        
    sty     PF2                     ;3        
    sta     ram_FF                  ;3        
    ldy     ram_F6                  ;3        
    lda     (ram_F4),y              ;5        
    sta     ram_FC                  ;3        
    nop                             ;2        
    dec     ram_F4                  ;5        
    bpl     Lf223                   ;2/3      
    sta     PF0                     ;3        
    lda     ram_FD                  ;3        
    sta     PF1                     ;3        
    lda     ram_FE                  ;3        
    sta     PF2                     ;3        
    lda     $ddc8,x                 ;4        
    sta     GRP0                    ;3        
    lda     $ddd7,x                 ;4        
    sta     GRP1                    ;3        
    lda     ram_B9                  ;3        
    ror                             ;2        
    lda     #$00                    ;2        
    sta     PF0                     ;3        
    sta     PF1                     ;3        
    bcs     Lf2a1                   ;2/3      
    bcc     Lf2f3                   ;2/3 = 197
Lf2a1
    lda     ram_FF                  ;3        
    sta     PF2                     ;3        
    ldx     #$09                    ;2        
    lda     ram_A7,x                ;4        
    and     #$07                    ;2        
    sta     ram_F9                  ;3        
    tax                             ;2        
    lda     $de75,x                 ;4        
    sta     ram_F6                  ;3        
    lda     ram_FC                  ;3        
    sta     PF0                     ;3        
    lda     ram_FD                  ;3        
    sta     PF1                     ;3        
    lda     ram_FE                  ;3        
    sta     PF2                     ;3        
    ldx     #$00                    ;2        
    lda     ram_A7,x                ;4        
    and     #$07                    ;2        
    sta     ram_F8                  ;3        
    tax                             ;2        
    lda     $de75,x                 ;4        
    tax                             ;2        
    lda     #$00                    ;2        
    ldy     #$ff                    ;2        
    sta     PF0                     ;3        
    sta     PF1                     ;3        
    nop                             ;2        
    lda     ram_FF                  ;3        
    sta     PF2                     ;3        
    lda     #$00                    ;2        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    stx     COLUP0                  ;3        
    sta     GRP0                    ;3        
    sta     GRP1                    ;3        
    sta     PF2                     ;3        
    ldx     ram_F6                  ;3        
    sta     HMOVE                   ;3        
    stx     COLUP1                  ;3        
    sta     NUSIZ1                  ;3        
    jmp.ind (ram_E3)                ;5   = 122
Lf2f3
    lda     ram_FF                  ;3        
    sta     PF2                     ;3        
    lda     (ram_83,x)              ;6        
    lda     (ram_83,x)              ;6        
    lda     ram_FC                  ;3        
    sta     PF0                     ;3        
    lda     ram_FD                  ;3        
    sta     PF1                     ;3        
    lda     ram_FE                  ;3        
    sta     PF2                     ;3        
    lda     (ram_83,x)              ;6        
    lda     (ram_83,x)              ;6        
    lda     (ram_83,x)              ;6        
    lda     (ram_83,x)              ;6        
    lda     (ram_83,x)              ;6        
    ldx     #$1f                    ;2        
    txs                             ;2        
    lda     #$00                    ;2        
    sta     PF0                     ;3        
    sta     PF1                     ;3        
    lda     ram_FF                  ;3        
    sta     PF2                     ;3        
    lda     #$00                    ;2        
    tay                             ;2        
    ldx     ram_E8                  ;3        
    sta     GRP0                    ;3        
    sta     GRP1                    ;3        
    sta     GRP0                    ;3        
    sta     PF2                     ;3        
    stx     COLUPF                  ;3        
    sta     HMOVE                   ;3        
    lda     ram_C9                  ;3        
    ror                             ;2        
    and     #$07                    ;2        
    tax                             ;2        
    bcs     Lf36d                   ;2/3      
    lda     ram_E9                  ;3        
    sta     COLUP0                  ;3        
    lda     ram_EB                  ;3        
    sta     VDELP0                  ;3        
    sta     REFP0                   ;3        
    lda     ram_C9                  ;3        
    sta     HMP0                    ;3        
    lda     #$00                    ;2        
    sta     NUSIZ0                  ;3        
    lda     (ram_83,x)              ;6        
    dex                             ;2        
    bne     Lf352                   ;2/3      
    sta     RESP0                   ;3        
    beq     Lf383                   ;2/3 = 161
Lf352
    dex                             ;2        
    bne     Lf359                   ;2/3      
    sta     RESP0                   ;3        
    beq     Lf383                   ;2/3 =   9
Lf359
    dex                             ;2        
    bne     Lf360                   ;2/3      
    sta     RESP0                   ;3        
    beq     Lf383                   ;2/3 =   9
Lf360
    dex                             ;2        
    bne     Lf367                   ;2/3      
    sta     RESP0                   ;3        
    beq     Lf383                   ;2/3 =   9
Lf367
    dex                             ;2        
    nop                             ;2        
    sta     RESP0                   ;3        
    beq     Lf385                   ;2/3 =   9
Lf36d
    nop                             ;2   =   2
Lf36e
    dex                             ;2        
    bne     Lf36e                   ;2/3      
    sta     RESP0                   ;3        
    lda     ram_C9                  ;3        
    sta     HMP0                    ;3        
    lda     ram_E9                  ;3        
    sta     COLUP0                  ;3        
    lda     ram_EB                  ;3        
    sta     VDELP0                  ;3        
    sta     REFP0                   ;3        
    stx     NUSIZ0                  ;3   =  31
Lf383
    sta     WSYNC                   ;3   =   3
;---------------------------------------
Lf385
    sta     HMOVE                   ;3        
    lda     ram_D1                  ;3        
    ror                             ;2        
    and     #$07                    ;2        
    tax                             ;2        
    bcs     Lf3c5                   ;2/3      
    lda     ram_EA                  ;3        
    sta     COLUP1                  ;3        
    lda     ram_EC                  ;3        
    sta     VDELP1                  ;3        
    sta     HMCLR                   ;3        
    lda     ram_D1                  ;3        
    sta     HMP1                    ;3        
    lda     (ram_83,x)              ;6        
    lda     #$00                    ;2        
    sta     NUSIZ1                  ;3        
    dex                             ;2        
    bne     Lf3aa                   ;2/3      
    sta     RESP1                   ;3         *
    beq     Lf3db                   ;2/3 =  55 *
Lf3aa
    dex                             ;2        
    bne     Lf3b1                   ;2/3      
    sta     RESP1                   ;3         *
    beq     Lf3db                   ;2/3 =   9 *
Lf3b1
    dex                             ;2        
    bne     Lf3b8                   ;2/3      
    sta     RESP1                   ;3        
    beq     Lf3db                   ;2/3 =   9
Lf3b8
    dex                             ;2         *
    bne     Lf3bf                   ;2/3       *
    sta     RESP1                   ;3         *
    beq     Lf3db                   ;2/3 =   9 *
Lf3bf
    dex                             ;2         *
    nop                             ;2         *
    sta     RESP1                   ;3         *
    beq     Lf3dd                   ;2/3 =   9 *
Lf3c5
    nop                             ;2   =   2 *
Lf3c6
    dex                             ;2         *
    bne     Lf3c6                   ;2/3       *
    sta     RESP1                   ;3         *
    sta     HMCLR                   ;3         *
    lda     ram_D1                  ;3         *
    sta     HMP1                    ;3         *
    lda     ram_EA                  ;3         *
    sta     COLUP1                  ;3         *
    lda     ram_EC                  ;3         *
    sta     VDELP1                  ;3         *
    stx     NUSIZ1                  ;3   =  31 *
Lf3db
    sta     WSYNC                   ;3   =   3
;---------------------------------------
Lf3dd
    sta     HMOVE                   ;3        
    stx     GRP1                    ;3        
    cpy     ram_D8                  ;3        
    php                             ;3        
    cpy     ram_D7                  ;3        
    php                             ;3        
    cpy     ram_D6                  ;3        
    php                             ;3        
    ldx     #$00                    ;2   =  26
Lf3ec
    lda     (ram_ED,x)              ;6        
    cmp     #$ff                    ;2        
    beq     Lf3f6                   ;2/3      
    inc     ram_ED                  ;5        
    bne     Lf402                   ;2/3!=  17
Lf3f6
    cpy     ram_EF                  ;3        
    bne     Lf401                   ;2/3!     
    lda     ram_F1                  ;3        
    sta     ram_ED                  ;3        
    jmp     $d3ec                   ;3   =  14
    
Lf401
    txa                             ;2   =   2
Lf402
    sta     HMCLR                   ;3        
    sta     WSYNC                   ;3   =   6
;---------------------------------------
    sta     HMOVE                   ;3        
    sta     GRP0                    ;3        
    ldx     #$00                    ;2   =   8
Lf40c
    lda     (ram_E6,x)              ;6        
    cmp     #$ff                    ;2        
    beq     Lf416                   ;2/3      
    inc     ram_E6                  ;5         *
    bne     Lf422                   ;2/3 =  17 *
Lf416
    cpy     ram_D2                  ;3        
    bne     Lf421                   ;2/3      
    lda     ram_F2                  ;3         *
    sta     ram_E6                  ;3         *
    jmp     $d40c                   ;3   =  14 *
    
Lf421
    txa                             ;2   =   2
Lf422
    ldx     #$1f                    ;2        
    txs                             ;2        
    tax                             ;2        
    iny                             ;2        
    cpy     #$59                    ;2        
    bne     Lf3db                   ;2/3!=  12
Lf42b
    sta     WSYNC                   ;3   =   3
;---------------------------------------
Lf42d
    lda     #$00                    ;2        
    sta     GRP0                    ;3        
    sta     GRP1                    ;3        
    sta     ENABL                   ;3        
    sta     ENAM0                   ;3        
    sta     ENAM1                   ;3        
    jmp     $d586                   ;3   =  20
    
    bit     ram_C7                  ;3        
    bvc     Lf488                   ;2/3      
    lda     ram_80                  ;3        
    and     #$bf                    ;2        
    bpl     Lf452                   ;2/3      
    cmp     #$80                    ;2         *
    bne     Lf44e                   ;2/3       *
    
    .byte   $a9                             ; $f44a (D)
    .byte   $21,$d0,$0c                     ; $f44b (*)
    
Lf44e
    lda     #$42                    ;2         *
    bne     Lf45a                   ;2/3 =  20 *
Lf452
    tax                             ;2        
    inx                             ;2        
    and     #$20                    ;2        
    beq     Lf459                   ;2/3      
    inx                             ;2   =  10 *
Lf459
    txa                             ;2   =   2
Lf45a
    ldx     #$00                    ;2   =   2
Lf45c
    cmp     #$0a                    ;2        
    bcc     Lf466                   ;2/3      
    inx                             ;2         *
    sec                             ;2         *
    sbc     #$0a                    ;2         *
    bcs     Lf45c                   ;2/3 =  12 *
Lf466
    sta     ram_F4                  ;3        
    txa                             ;2        
    asl                             ;2        
    asl                             ;2        
    asl                             ;2        
    asl                             ;2        
    ora     ram_F4                  ;3        
    sta     ram_BE                  ;3        
    lda     #$00                    ;2        
    sta     ram_BD                  ;3        
    lda     #$c8                    ;2        
    sta     ram_FA                  ;3        
    ldx     #$37                    ;2        
    lda     ram_80                  ;3        
    and     #$20                    ;2        
    beq     Lf483                   ;2/3      
    ldx     #$3c                    ;2   =  40 *
Lf483
    stx     ram_FB                  ;3        
    jmp     $d4ab                   ;3   =   6
    
Lf488
    lda     ram_C8                  ;3        
    ror                             ;2        
    bcc     Lf497                   ;2/3      
    lda     #$37                    ;2        
    bit     ram_C7                  ;3        
    bpl     Lf4a5                   ;2/3      
    lda     #$3c                    ;2         *
    bne     Lf4a5                   ;2/3 =  18 *
Lf497
    lda     ram_BC                  ;3        
    and     #$f0                    ;2        
    lsr                             ;2        
    lsr                             ;2        
    sta     ram_F6                  ;3        
    lsr                             ;2        
    lsr                             ;2        
    adc     ram_F6                  ;3        
    adc     #$32                    ;2   =  21
Lf4a5
    sta     ram_FB                  ;3        
    lda     #$00                    ;2        
    sta     ram_FA                  ;3   =   8
Lf4ab
    lda     #$00                    ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    cmp     #$08                    ;2        
    bcc     Lf4b7                   ;2/3      
    lda     #$07                    ;2   =  16 *
Lf4b7
    tax                             ;2        
    lda     $de7d,x                 ;4        
    sta     WSYNC                   ;3   =   9
;---------------------------------------
    sta     ram_F3                  ;3        
    lda     $de85,x                 ;4        
    sta     HMP0                    ;3        
    asl                             ;2        
    asl                             ;2        
    asl                             ;2        
    asl                             ;2        
    sta     HMP1                    ;3        
    lda     $de8d,x                 ;4        
    sta     NUSIZ0                  ;3        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    sta     NUSIZ1                  ;3        
    ldy     $de95,x                 ;4   =  43
Lf4d8
    dey                             ;2        
    bpl     Lf4d8                   ;2/3      
    sta     RESP0                   ;3        
    sta     RESP1                   ;3        
    sta     WSYNC                   ;3   =  13
;---------------------------------------
    sta     HMOVE                   ;3        
    lda     #$dd                    ;2        
    sta     ram_F5                  ;3        
    lda     #$04                    ;2        
    sta     ram_F4                  ;3        
    lda     ram_BE                  ;3        
    and     #$0f                    ;2        
    sta     ram_F6                  ;3        
    asl                             ;2        
    asl                             ;2        
    adc     ram_F6                  ;3        
    adc     #$32                    ;2        
    sta     ram_F9                  ;3        
    lda     ram_BE                  ;3        
    and     #$f0                    ;2        
    lsr                             ;2        
    lsr                             ;2        
    sta     ram_F6                  ;3        
    lsr                             ;2        
    lsr                             ;2        
    adc     ram_F6                  ;3        
    adc     #$96                    ;2        
    sta     ram_F8                  ;3        
    lda     ram_BD                  ;3        
    and     #$0f                    ;2        
    sta     ram_F6                  ;3        
    asl                             ;2        
    asl                             ;2        
    adc     ram_F6                  ;3        
    adc     #$64                    ;2        
    sta     ram_F7                  ;3        
    lda     ram_BD                  ;3        
    and     #$f0                    ;2        
    lsr                             ;2        
    lsr                             ;2        
    sta     ram_F6                  ;3        
    lsr                             ;2        
    lsr                             ;2        
    adc     ram_F6                  ;3        
    sta     ram_F6                  ;3        
    ldx     #$00                    ;2        
    ldy     #$c8                    ;2   = 103
Lf529
    lda     ram_F6,x                ;4        
    beq     Lf539                   ;2/3      
    cmp     #$32                    ;2        
    beq     Lf539                   ;2/3      
    cmp     #$64                    ;2        
    beq     Lf539                   ;2/3      
    cmp     #$96                    ;2        
    bne     Lf540                   ;2/3 =  18
Lf539
    sty     ram_F6,x                ;4        
    inx                             ;2        
    cpx     #$04                    ;2        
    bne     Lf529                   ;2/3 =  10
Lf540
    sta     HMCLR                   ;3        
    ldy     ram_F6                  ;3        
    lda     (ram_F4),y              ;5        
    sta     ram_FC                  ;3        
    ldy     ram_F7                  ;3        
    lda     (ram_F4),y              ;5        
    ldy     ram_F8                  ;3        
    ora     (ram_F4),y              ;5        
    sta     ram_FD                  ;3        
    ldy     ram_F9                  ;3        
    lda     (ram_F4),y              ;5        
    ldy     ram_FA                  ;3        
    ora     (ram_F4),y              ;5        
    sta     ram_FE                  ;3        
    ldy     ram_FB                  ;3        
    lda     (ram_F4),y              ;5        
    sta     ram_FF                  ;3        
    dec     ram_F4                  ;5        
    lda     #$74                    ;2      What's this?  
    sta     COLUP0                  ;3        
    sta     COLUP1                  ;3        
    lda     #$44                    ;2        
    bit     ram_C7                  ;3        
    bpl     Lf572                   ;2/3      
    lda     #$d6                    ;2   =  85 *
Lf572
    eor     ram_E0                  ;3        
    sta     COLUPF                  ;3        
    lda     #$00                    ;2        
    sta     VDELP0                  ;3        
    sta     VDELP1                  ;3        
    sta     REFP0                   ;3   =  17
Lf57e
    lda     INTIM                   ;4        
    bne     Lf57e                   ;2/3      
    jmp     $d21b                   ;3   =   9
    
Lf586
    lda     #$00                    ;2        
    sta     ram_F7                  ;3        
    lda     #$f0                    ;2        
    sta     ram_F8                  ;3        
    jmp     $dff0                   ;3   =  13
    
    .byte   $a9,$da,$85,$f7,$a9,$f9,$85,$f8 ; $f591 (*)
    .byte   $4c,$f0,$df,$00,$00,$00,$00,$00 ; $f599 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5a1 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5a9 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5b1 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5b9 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5c1 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5c9 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5d1 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5d9 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5e1 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f5e9 (*)
    .byte   $00,$00,$00,$00,$00,$00         ; $f5f1 (*)
    .byte   $00                             ; $f5f7 (D)
    .byte   $00,$00                         ; $f5f8 (*)
    .byte   $00                             ; $f5fa (D)
    .byte   $00,$00,$00,$00,$00             ; $f5fb (*)
    
Lf600
    ldy     ram_95,x                ;4        
    stx     ram_F4                  ;3        
    tax                             ;2        
    bcs     Lf610                   ;2/3 =  11
Lf607
    lda     $d700,y                 ;4        
    tay                             ;2        
    dex                             ;2        
    bne     Lf607                   ;2/3      
    beq     Lf617                   ;2/3 =  12
Lf610
    lda     $d800,y                 ;4        
    tay                             ;2        
    dex                             ;2        
    bne     Lf610                   ;2/3 =  10
Lf617
    ldx     ram_F4                  ;3        
    sta     ram_95,x                ;4        
    ldy     #$fa                    ;2        
    sty     ram_F8                  ;3        
    ldy     #$cd                    ;2        
    sty     ram_F7                  ;3        
    jmp     $dff0                   ;3   =  20
    
    .byte   $00,$00,$00,$00,$00,$00         ; $f626 (*)
    .byte   $00                             ; $f62c (D)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f62d (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f635 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f63d (*)
    .byte   $00                             ; $f645 (D)
    .byte   $00,$00,$00,$00,$00,$00         ; $f646 (*)
    .byte   $00                             ; $f64c (D)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f64d (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f655 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f65d (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f665 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f66d (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f675 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f67d (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f685 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f68d (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f695 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f69d (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6a5 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6ad (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6b5 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6bd (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6c5 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6cd (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6d5 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6dd (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6e5 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f6ed (*)
    .byte   $00,$00,$00                     ; $f6f5 (*)
    .byte   $00                             ; $f6f8 (D)
    .byte   $00,$00                         ; $f6f9 (*)
    .byte   $00                             ; $f6fb (D)
    .byte   $00,$00,$00,$00                 ; $f6fc (*)
Lf700
    .byte   $f0,$f1                         ; $f700 (*)
    .byte   $f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9 ; $f702 (D)
    .byte   $fa,$fb                         ; $f70a (D)
    .byte   $fc                             ; $f70c (*)
    .byte   $fd                             ; $f70d (D)
    .byte   $fe,$ff,$00,$01                 ; $f70e (*)
    .byte   $02,$03,$04,$05,$06,$07,$08,$09 ; $f712 (D)
    .byte   $0a,$0b,$0c,$0d                 ; $f71a (D)
    .byte   $0e,$0f,$10,$11                 ; $f71e (*)
    .byte   $12,$13,$14,$15,$16,$17,$18,$19 ; $f722 (D)
    .byte   $1a,$1b                         ; $f72a (D)
    .byte   $1c                             ; $f72c (*)
    .byte   $1d                             ; $f72d (D)
    .byte   $1e,$1f,$20,$21                 ; $f72e (*)
    .byte   $22,$23,$24,$25,$26,$27,$28,$29 ; $f732 (D)
    .byte   $2a,$2b                         ; $f73a (D)
    .byte   $2c                             ; $f73c (*)
    .byte   $2d                             ; $f73d (D)
    .byte   $2e,$2f,$30,$31,$32             ; $f73e (*)
    .byte   $33,$34,$35,$36,$37,$38,$39,$3a ; $f743 (D)
    .byte   $3b                             ; $f74b (D)
    .byte   $3c                             ; $f74c (*)
    .byte   $3d                             ; $f74d (D)
    .byte   $3e,$3f,$40,$41,$42             ; $f74e (*)
    .byte   $43,$44,$45,$46,$47,$48,$49,$4a ; $f753 (D)
    .byte   $4b                             ; $f75b (D)
    .byte   $4c                             ; $f75c (*)
    .byte   $4d                             ; $f75d (D)
    .byte   $4e,$4f,$50,$51,$52             ; $f75e (*)
    .byte   $53,$54,$55,$56,$57,$58,$59,$5a ; $f763 (D)
    .byte   $5b                             ; $f76b (D)
    .byte   $5c                             ; $f76c (*)
    .byte   $5d                             ; $f76d (D)
    .byte   $5e,$5f,$00,$00,$00,$00,$00,$00 ; $f76e (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f776 (*)
    .byte   $00,$00,$62,$63                 ; $f77e (*)
    .byte   $64                             ; $f782 (D)
    .byte   $65                             ; $f783 (*)
    .byte   $66,$67,$68,$69,$6a,$6b,$63,$6d ; $f784 (D)
    .byte   $6e                             ; $f78c (*)
    .byte   $32                             ; $f78d (D)
    .byte   $00,$00,$80,$81                 ; $f78e (*)
    .byte   $82                             ; $f792 (D)
    .byte   $83                             ; $f793 (*)
    .byte   $84,$85,$86,$87,$88,$89,$8a,$8b ; $f794 (D)
    .byte   $8c                             ; $f79c (*)
    .byte   $8d                             ; $f79d (D)
    .byte   $8e,$8f,$90,$91                 ; $f79e (*)
    .byte   $92,$65,$94,$95,$96,$97,$98,$99 ; $f7a2 (D)
    .byte   $9a,$9b                         ; $f7aa (D)
    .byte   $9c                             ; $f7ac (*)
    .byte   $9d                             ; $f7ad (D)
    .byte   $9e,$9f,$a0,$a1                 ; $f7ae (*)
    .byte   $a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9 ; $f7b2 (D)
    .byte   $aa,$ab                         ; $f7ba (D)
    .byte   $ac                             ; $f7bc (*)
    .byte   $ad                             ; $f7bd (D)
    .byte   $ae,$af,$b0,$b1                 ; $f7be (*)
    .byte   $b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9 ; $f7c2 (D)
    .byte   $ba,$bb                         ; $f7ca (D)
    .byte   $bc                             ; $f7cc (*)
    .byte   $bd                             ; $f7cd (D)
    .byte   $be,$bf,$c0,$c1                 ; $f7ce (*)
    .byte   $c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9 ; $f7d2 (D)
    .byte   $ca,$cb                         ; $f7da (D)
    .byte   $cc                             ; $f7dc (*)
    .byte   $cd                             ; $f7dd (D)
    .byte   $ce,$cf,$d0,$d1                 ; $f7de (*)
    .byte   $d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9 ; $f7e2 (D)
    .byte   $da,$db                         ; $f7ea (D)
    .byte   $dc                             ; $f7ec (*)
    .byte   $dd                             ; $f7ed (D)
    .byte   $de,$df,$e0,$e1                 ; $f7ee (*)
    .byte   $e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9 ; $f7f2 (D)
    .byte   $ea,$eb,$ec,$ed                 ; $f7fa (D)
    .byte   $ee,$ef                         ; $f7fe (*)
Lf800
    .byte   $10,$11,$12                     ; $f800 (*)
    .byte   $13                             ; $f803 (D)
    .byte   $14                             ; $f804 (*)
    .byte   $15                             ; $f805 (D)
    .byte   $16                             ; $f806 (*)
    .byte   $17,$18,$19,$1a,$1b             ; $f807 (D)
    .byte   $1c,$1d                         ; $f80c (*)
    .byte   $1e                             ; $f80e (D)
    .byte   $1f,$20,$21,$22                 ; $f80f (*)
    .byte   $23                             ; $f813 (D)
    .byte   $24                             ; $f814 (*)
    .byte   $25                             ; $f815 (D)
    .byte   $26                             ; $f816 (*)
    .byte   $27,$28,$29,$2a,$2b             ; $f817 (D)
    .byte   $2c                             ; $f81c (*)
    .byte   $2d                             ; $f81d (D)
    .byte   $2e,$2f,$30,$31,$32             ; $f81e (*)
    .byte   $33,$34,$35                     ; $f823 (D)
    .byte   $36                             ; $f826 (*)
    .byte   $37                             ; $f827 (D)
    .byte   $38                             ; $f828 (*)
    .byte   $39,$3a,$3b                     ; $f829 (D)
    .byte   $3c                             ; $f82c (*)
    .byte   $3d                             ; $f82d (D)
    .byte   $3e,$3f,$40,$41,$8d             ; $f82e (*)
    .byte   $43                             ; $f833 (D)
    .byte   $44                             ; $f834 (*)
    .byte   $45                             ; $f835 (D)
    .byte   $46                             ; $f836 (*)
    .byte   $47                             ; $f837 (D)
    .byte   $48                             ; $f838 (*)
    .byte   $49,$4a,$4b                     ; $f839 (D)
    .byte   $4c                             ; $f83c (*)
    .byte   $4d                             ; $f83d (D)
    .byte   $4e,$4f,$50,$51,$52             ; $f83e (*)
    .byte   $53                             ; $f843 (D)
    .byte   $54                             ; $f844 (*)
    .byte   $55                             ; $f845 (D)
    .byte   $56                             ; $f846 (*)
    .byte   $57                             ; $f847 (D)
    .byte   $58                             ; $f848 (*)
    .byte   $59,$5a,$5b                     ; $f849 (D)
    .byte   $5c                             ; $f84c (*)
    .byte   $5d,$5e                         ; $f84d (D)
    .byte   $5f,$60,$61,$62                 ; $f84f (*)
    .byte   $63                             ; $f853 (D)
    .byte   $64                             ; $f854 (*)
    .byte   $65                             ; $f855 (D)
    .byte   $66                             ; $f856 (*)
    .byte   $67                             ; $f857 (D)
    .byte   $68                             ; $f858 (*)
    .byte   $69,$6a,$6b                     ; $f859 (D)
    .byte   $6c                             ; $f85c (*)
    .byte   $6d                             ; $f85d (D)
    .byte   $6e,$6f,$00,$00,$00             ; $f85e (*)
    .byte   $8a                             ; $f863 (D)
    .byte   $82                             ; $f864 (*)
    .byte   $83                             ; $f865 (D)
    .byte   $84                             ; $f866 (*)
    .byte   $85                             ; $f867 (D)
    .byte   $86                             ; $f868 (*)
    .byte   $87,$88,$89                     ; $f869 (D)
    .byte   $8a                             ; $f86c (*)
    .byte   $8b                             ; $f86d (D)
    .byte   $8c,$8d,$00,$00,$00,$00,$00,$00 ; $f86e (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $f876 (*)
    .byte   $00,$00,$90,$91,$92             ; $f87e (*)
    .byte   $93                             ; $f883 (D)
    .byte   $94                             ; $f884 (*)
    .byte   $95                             ; $f885 (D)
    .byte   $96                             ; $f886 (*)
    .byte   $97,$98,$99,$9a,$9b             ; $f887 (D)
    .byte   $9c,$9d,$9e,$9f,$a0,$a1,$a2     ; $f88c (*)
    .byte   $a3                             ; $f893 (D)
    .byte   $a4                             ; $f894 (*)
    .byte   $a5                             ; $f895 (D)
    .byte   $a6                             ; $f896 (*)
    .byte   $a7,$a8,$a9,$aa,$ab             ; $f897 (D)
    .byte   $ac,$ad,$ae,$af,$b0,$b1,$b2     ; $f89c (*)
    .byte   $b3                             ; $f8a3 (D)
    .byte   $b4                             ; $f8a4 (*)
    .byte   $b5                             ; $f8a5 (D)
    .byte   $b6                             ; $f8a6 (*)
    .byte   $b7,$b8,$b9,$ba,$bb             ; $f8a7 (D)
    .byte   $bc,$bd,$be,$bf,$c0,$c1,$c2     ; $f8ac (*)
    .byte   $c3                             ; $f8b3 (D)
    .byte   $c4                             ; $f8b4 (*)
    .byte   $c5                             ; $f8b5 (D)
    .byte   $c6                             ; $f8b6 (*)
    .byte   $c7,$c8,$c9,$ca,$cb             ; $f8b7 (D)
    .byte   $cc,$cd,$ce,$cf,$d0,$d1,$d2     ; $f8bc (*)
    .byte   $d3                             ; $f8c3 (D)
    .byte   $d4                             ; $f8c4 (*)
    .byte   $d5                             ; $f8c5 (D)
    .byte   $d6                             ; $f8c6 (*)
    .byte   $d7,$d8,$d9,$da,$db             ; $f8c7 (D)
    .byte   $dc,$dd,$de,$df,$e0,$e1,$e2     ; $f8cc (*)
    .byte   $e3                             ; $f8d3 (D)
    .byte   $e4                             ; $f8d4 (*)
    .byte   $e5                             ; $f8d5 (D)
    .byte   $e6                             ; $f8d6 (*)
    .byte   $e7,$e8,$e9,$ea,$eb             ; $f8d7 (D)
    .byte   $ec,$ed,$ee,$ef,$f0,$f1,$f2     ; $f8dc (*)
    .byte   $f3                             ; $f8e3 (D)
    .byte   $f4                             ; $f8e4 (*)
    .byte   $f5                             ; $f8e5 (D)
    .byte   $f6                             ; $f8e6 (*)
    .byte   $f7,$f8,$f9,$fa,$fb             ; $f8e7 (D)
    .byte   $fc,$fd,$fe,$ff,$00,$01,$02     ; $f8ec (*)
    .byte   $03                             ; $f8f3 (D)
    .byte   $04                             ; $f8f4 (*)
    .byte   $05                             ; $f8f5 (D)
    .byte   $06                             ; $f8f6 (*)
    .byte   $07,$08,$09,$0a,$0b             ; $f8f7 (D)
    .byte   $0c                             ; $f8fc (*)
    .byte   $0d                             ; $f8fd (D)
    .byte   $0e,$0f                         ; $f8fe (*)
    
Lf900
    ldy     #$00                    ;2        
    lda     (ram_EF),y              ;5        
    ldy     #$f4                    ;2        
    sty     ram_F8                  ;3        
    ldy     #$80                    ;2        
    sty     ram_F7                  ;3        
    jmp     $dff0                   ;3   =  20
    
    ldy     #$00                    ;2        
    lda     (ram_F1),y              ;5        
    ldy     #$f4                    ;2        
    sty     ram_F8                  ;3        
    ldy     #$0c                    ;2        
    sty     ram_F7                  ;3        
    jmp     $dff0                   ;3   =  20
    
    .byte   $45                             ; $f91e (D)
    .byte   $b9,$b4,$4b,$b5,$4b,$bc,$4b,$b4 ; $f91f (*)
    .byte   $4b,$f4,$4b,$b4,$5b,$34,$3b,$b4 ; $f927 (*)
    .byte   $fb,$4b,$b4,$4b,$b4,$4b,$b4,$4b ; $f92f (*)
    .byte   $b0,$4a,$b4,$4b,$bb,$4d,$bd,$45 ; $f937 (*)
    .byte   $bb,$a4,$0b,$f4,$4b,$f4,$0b,$a4 ; $f93f (*)
    .byte   $bb,$94,$9b,$44,$bb,$44,$bb,$44 ; $f947 (*)
    .byte   $bb,$4b,$b4,$4b,$b4,$4b,$b4,$4b ; $f94f (*)
    .byte   $b4,$4b,$b4,$49,$b4,$43,$bd,$41 ; $f957 (*)
    .byte   $bc,$b4,$4b,$b4,$4b,$b4,$4b,$b4 ; $f95f (*)
    .byte   $6b,$d4,$9b,$a4,$0b,$74,$bb,$64 ; $f967 (*)
    .byte   $3b,$4b,$b4,$4b,$b0,$4f,$b4,$4b ; $f96f (*)
    .byte   $b4,$4f,$b1,$46,$bf,$44,$bb,$44 ; $f977 (*)
    .byte   $bb,$b4,$4b,$b4,$4b,$b4,$4b,$b4 ; $f97f (*)
    .byte   $4b,$94,$5b,$34,$bb,$24,$9b,$54 ; $f987 (*)
    .byte   $bb,$4b,$b4,$4b,$b4,$4b,$b4,$4b ; $f98f (*)
    .byte   $b4,$4b,$b4,$4b,$b4,$4b,$b4,$4b ; $f997 (*)
    .byte   $b4,$b4,$4b,$b4,$4b,$b4,$4b,$b4 ; $f99f (*)
    .byte   $4b,$94,$ab,$34,$fb,$54,$db,$e4 ; $f9a7 (*)
    .byte   $bb,$4b,$b4,$4b,$b4,$4b,$b4,$4b ; $f9af (*)
    .byte   $b4,$4a,$b4,$42,$b5,$4c,$bb,$4c ; $f9b7 (*)
    .byte   $ba,$b4,$4b,$b4,$4b,$b4,$4b,$b4 ; $f9bf (*)
    .byte   $4b,$b4,$5b,$b4,$5b,$94,$0b,$b4 ; $f9c7 (*)
    .byte   $eb,$4b,$b4,$4b,$b4,$4b,$b0,$4c ; $f9cf (*)
    .byte   $b5,$4b,$b1,$46,$bf,$4a,$bb,$44 ; $f9d7 (*)
    .byte   $ba,$b4,$4b,$94,$6b,$f4,$1b,$d4 ; $f9df (*)
    .byte   $1b,$74,$2b,$44,$bb,$44,$bb,$44 ; $f9e7 (*)
    .byte   $bb,$4b,$b4,$4b,$b4,$4b,$b4,$4b ; $f9ef (*)
    .byte   $b4,$4f,$b2,$4e                 ; $f9f7 (*)
    .byte   $b0                             ; $f9fb (D)
    .byte   $43,$ba                         ; $f9fc (*)
    .byte   $41                             ; $f9fe (D)
    .byte   $b8                             ; $f9ff (*)
    
    .byte   %00000000 ; |        |            $fa00 (G)
	.byte %11111100 ; |XXXXXX  |
	.byte %11000001 ; |XX     X|
	.byte %11000001 ; |XX     X|
	.byte %01111001 ; | XXXX  X|
	.byte %00001101 ; |    XX X|
	.byte %11001101 ; |XX  XX X|
	.byte %01111000 ; | XXXX   |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %11000001 ; |XX     X|
	.byte %11000001 ; |XX     X|
	.byte %11111001 ; |XXXXX  X|
	.byte %11001101 ; |XX  XX X|
	.byte %11001101 ; |XX  XX X|
	.byte %11001101 ; |XX  XX X|
	.byte %11111001 ; |XXXXX  X|
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %01111001 ; | XXXX  X|
	.byte %11001101 ; |XX  XX X|
	.byte %00001101 ; |    XX X|
	.byte %01111001 ; | XXXX  X|
	.byte %11000001 ; |XX     X|
	.byte %11001101 ; |XX  XX X|
	.byte %01111001 ; | XXXX  X|

    .byte   %00000000 ; |        |            $fa1a (G)
	.byte %11110011 ; |XXXX  XX|
	.byte %10011011 ; |X  XX XX|
	.byte %10011011 ; |X  XX XX|
	.byte %10011001 ; |X  XX  X|
	.byte %10011000 ; |X  XX   |
	.byte %10011011 ; |X  XX XX|
	.byte %11110001 ; |XXXX   X|
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %10110011 ; |X XX  XX|
	.byte %10110011 ; |X XX  XX|
	.byte %10011110 ; |X  XXXX |
	.byte %10001100 ; |X   XX  |
	.byte %10011110 ; |X  XXXX |
	.byte %10110011 ; |X XX  XX|
	.byte %10110011 ; |X XX  XX|
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %10011011 ; |X  XX XX|
	.byte %10011011 ; |X  XX XX|
	.byte %10011011 ; |X  XX XX|
	.byte %11111011 ; |XXXXX XX|
	.byte %10011011 ; |X  XX XX|
	.byte %10011011 ; |X  XX XX|
	.byte %10011011 ; |X  XX XX|

    .byte   %00000000 ; |        |            $fa34 (G)
	.byte %11110000 ; |XXXX    |
	.byte %00000111 ; |     XXX|
	.byte %00000110 ; |     XX |
	.byte %11100110 ; |XXX  XX |
	.byte %00110110 ; |  XX XX |
	.byte %00110110 ; |  XX XX |
	.byte %11100110 ; |XXX  XX |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %01111011 ; | XXXX XX|
	.byte %01100011 ; | XX   XX|
	.byte %01100011 ; | XX   XX|
	.byte %01111011 ; | XXXX XX|
	.byte %01100011 ; | XX   XX|
	.byte %01100011 ; | XX   XX|
	.byte %01111011 ; | XXXX XX|
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %01111100 ; | XXXXX  |
	.byte %01100110 ; | XX  XX |
	.byte %01100110 ; | XX  XX |
	.byte %01111100 ; | XXXXX  |
	.byte %01100110 ; | XX  XX |
	.byte %01100110 ; | XX  XX |
	.byte %01111100 ; | XXXXX  |

    .byte   %00000000 ; |        |            $fa4e (G)
	.byte %11000000 ; |XX      |
	.byte %11100000 ; |XXX     |
	.byte %11000000 ; |XX      |
	.byte %11000000 ; |XX      |
	.byte %11000000 ; |XX      |
	.byte %11000000 ; |XX      |
	.byte %11000000 ; |XX      |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %11001100 ; |XX  XX  |
	.byte %00001100 ; |    XX  |
	.byte %00001111 ; |    XXXX|
	.byte %00001100 ; |    XX  |
	.byte %00001100 ; |    XX  |
	.byte %00000111 ; |     XXX|
	.byte %00000011 ; |      XX|
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %01111000 ; | XXXX   |
	.byte %11111100 ; |XXXXXX  |
	.byte %11001100 ; |XX  XX  |
	.byte %11001100 ; |XX  XX  |
	.byte %11001100 ; |XX  XX  |
	.byte %11001101 ; |XX  XX X|
	.byte %11001101 ; |XX  XX X|
    
    .byte   %00000000 ; |        |            $fa4e (G)
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %11011001 ; |XX XX  X|
	.byte %11011011 ; |XX XX XX|
	.byte %11011110 ; |XX XXXX |
	.byte %11011001 ; |XX XX  X|
	.byte %11011001 ; |XX XX  X|
	.byte %10011001 ; |X  XX  X|
	.byte %00011111 ; |   XXXXX|
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %01100011 ; | XX   XX|
	.byte %01100011 ; | XX   XX|
	.byte %01100011 ; | XX   XX|
	.byte %01100011 ; | XX   XX|
	.byte %11110011 ; |XXXX  XX|
	.byte %10011001 ; |X  XX  X|
	.byte %10011000 ; |X  XX   |
    
    .byte   %00000000 ; |        |            $fa82 (G)
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %10001100 ; |X   XX  |
	.byte %00001100 ; |    XX  |
	.byte %00001100 ; |    XX  |
	.byte %00001100 ; |    XX  |
	.byte %10001100 ; |X   XX  |
	.byte %10001100 ; |X   XX  |
	.byte %00111111 ; |  XXXXXX|
	.byte %00000000 ; |        |
	.byte %00000000 ; |        |
	.byte %00110000 ; |  XX    |
	.byte %00110000 ; |  XX    |
	.byte %11110000 ; |XXXX    |
	.byte %00110000 ; |  XX    |
	.byte %00110000 ; |  XX    |
	.byte %11100000 ; |XXX     |
	.byte %11000000 ; |XX      |
    
    .byte   $4c,$ba,$44,$ba,$b4,$4b,$b4,$4b ; $fa9c (*)
    .byte   $b4,$4b,$b4,$4b,$34,$0b,$b4,$6b ; $faa4 (*)
    .byte   $34,$3b,$54,$7b,$4b,$b4,$4f,$b6 ; $faac (*)
    .byte   $4b,$b8,$4b,$b0,$4c,$b1,$4f,$bf ; $fab4 (*)
    .byte   $44,$bb,$44,$bb,$b4,$4b,$b4,$4b ; $fabc (*)
    .byte   $b4,$4b,$34,$4b,$b4,$0b,$94,$db ; $fac4 (*)
    .byte   $e4,$ab,$c4,$bb,$4b,$b4,$4b,$b4 ; $facc (*)
    .byte   $4b,$b4,$4b,$b4,$4b,$bc,$4f,$bc ; $fad4 (*)
    .byte   $42,$ba,$46,$bf,$b4,$4b,$b4,$4b ; $fadc (*)
    .byte   $b4,$4b,$b4,$4b,$34,$0b,$b4,$0b ; $fae4 (*)
    .byte   $24,$6b,$64,$bb,$4b,$b4,$4b,$b4 ; $faec (*)
    .byte   $4b,$b4,$4b,$b4,$4b,$be,$4d,$b3 ; $faf4 (*)
    .byte   $4d                             ; $fafc (D)
    .byte   $bb,$42                         ; $fafd (*)
    .byte   $bb                             ; $faff (D)
    
Lfb00
    lda     #$03                    ;2        
    sta     VDELP0                  ;3        
    sta     VDELP1                  ;3        
    sta     NUSIZ0                  ;3        
    sta     NUSIZ1                  ;3        
    lda     #$4b                    ;2    Title_Color *original $44   
    sta     COLUP0                  ;3        
    sta     COLUP1                  ;3        
    ldx     #$06                    ;2        
    sta     WSYNC                   ;3   =  27
;---------------------------------------
    nop                             ;2   =   2
Lfb15
    dex                             ;2        
    bpl     Lfb15                   ;2/3      
    sta     RESP0                   ;3        
    sta     RESP1                   ;3        
    lda     #$10                    ;2        
    sta     HMP1                    ;3        
    sta     WSYNC                   ;3   =  18
;---------------------------------------
    sta     HMOVE                   ;3   =   3
Lfb24
    lda     #$da                    ;2        
    sta     ram_F5                  ;3        
    sta     ram_F7                  ;3        
    sta     ram_F9                  ;3        
    sta     ram_FB                  ;3        
    sta     ram_FD                  ;3        
    sta     ram_FF                  ;3        
    lda     #$00                    ;2        
    sta     ram_F4                  ;3        
    lda     #$1a                    ;2        
    sta     ram_F6                  ;3        
    lda     #$34                    ;2        
    sta     ram_F8                  ;3        
    lda     #$4e                    ;2        
    sta     ram_FA                  ;3        
    lda     #$68                    ;2        
    sta     ram_FC                  ;3        
    lda     #$82                    ;2        
    sta     ram_FE                  ;3        
    ldx     #$19                    ;2        
    stx     ram_F3                  ;3        
    ldx     #$ff                    ;2   =  57
Lfb50
    lda     INTIM                   ;4        
    bne     Lfb50                   ;2/3      
    stx     VBLANK                  ;3        
    stx     VSYNC                   ;3        
    sta     WSYNC                   ;3   =  15
;---------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    sta     VSYNC                   ;3        
    lda     #$2d                    ;2        
    sta     TIM64T                  ;4   =   9
Lfb66
    lda     INTIM                   ;4        
    bne     Lfb66                   ;2/3      
    ldx     #$54                    ;2   =   8
Lfb6d
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    dex                             ;2        
    bpl     Lfb6d                   ;2/3      
    lda     #$00                    ;2        
    sta     VBLANK                  ;3   =   9
Lfb76
    ldy     ram_F3                  ;3        
    lda     (ram_F4),y              ;5        
    sta     GRP0                    ;3        
    sta     WSYNC                   ;3   =  14
;---------------------------------------
    nop                             ;2        
    lda     (ram_F6),y              ;5        
    sta     GRP1                    ;3        
    lda     (ram_F8),y              ;5        
    sta     GRP0                    ;3        
    lda     (ram_FA),y              ;5        
    tax                             ;2        
    lda     (ram_FC),y              ;5        
    sta     ram_F2                  ;3        
    lda     (ram_FE),y              ;5        
    ldy     ram_F2                  ;3        
    stx     GRP1                    ;3        
    sty     GRP0                    ;3        
    sta     GRP1                    ;3        
    sta     GRP0                    ;3        
    dec     ram_F3                  ;5        
    bpl     Lfb76                   ;2/3      
    ldx     #$54                    ;2   =  62
Lfba0
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    dex                             ;2        
    bpl     Lfba0                   ;2/3      
    lda     #$24                    ;2        
    sta     TIM64T                  ;4        
    inc     ram_C6                  ;5        
    beq     Lfbb1                   ;2/3      
    jmp     $db24                   ;3   =  20
    
Lfbb1
    lda     #$00                    ;2        
    sta     VDELP0                  ;3        
    sta     VDELP1                  ;3        
    sta     NUSIZ0                  ;3        
    sta     NUSIZ1                  ;3        
    lda     #$07                    ;2        
    sta     ram_F7                  ;3        
    lda     #$fa                    ;2        
    sta     ram_F8                  ;3        
    jmp     $dff0                   ;3   =  27
    
    .byte   $b4,$5b,$74,$3b,$34,$bb,$44,$bb ; $fbc6 (*)
    .byte   $04,$bb,$4b,$b4,$4b,$be,$4b,$bc ; $fbce (*)
    .byte   $4f,$b5,$45,$ba,$44,$bb,$46,$bb ; $fbd6 (*)
    .byte   $44,$b9,$b4,$4b,$b4,$4b,$b4,$4b ; $fbde (*)
    .byte   $b4,$4b,$b4,$5b,$b4,$db,$f4,$7b ; $fbe6 (*)
    .byte   $b4,$ab,$4f,$ba,$4a,$b5,$44,$b3 ; $fbee (*)
    .byte   $4c,$bb,$4c,$b9,$44,$bb,$44     ; $fbf6 (*)
    .byte   $bb                             ; $fbfd (D)
    .byte   $44,$bb,$bb                     ; $fbfe (*)
    .byte   $45                             ; $fc01 (D)
    .byte   $bb,$44,$bb,$44,$bb,$44,$bb,$49 ; $fc02 (*)
    .byte   $ba,$43,$bc,$0b,$f0,$4b,$44,$bb ; $fc0a (*)
    .byte   $44                             ; $fc12 (D)
    .byte   $bb,$44,$bb,$44,$bb,$44,$bb,$44 ; $fc13 (*)
    .byte   $bb,$44,$bb,$44,$bb,$bb         ; $fc1b (*)
    .byte   $44                             ; $fc21 (D)
    .byte   $bb,$44,$bb,$44,$bb,$44,$bb,$45 ; $fc22 (*)
    .byte   $bb,$05,$ba,$57,$b5,$43,$44,$bb ; $fc2a (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fc32 (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$bb,$44 ; $fc3a (*)
    .byte   $bb,$44,$bb,$44,$bb,$45,$b9,$47 ; $fc42 (*)
    .byte   $b9,$47,$f9,$42,$b8,$4b,$44,$bb ; $fc4a (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fc52 (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$bb,$44 ; $fc5a (*)
    .byte   $bb,$44,$ba,$47,$ba,$47,$bf,$47 ; $fc62 (*)
    .byte   $b8,$4b,$b4,$43,$b4,$43,$44,$bb ; $fc6a (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fc72 (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$bb,$44 ; $fc7a (*)
    .byte   $bb,$44,$bb,$44,$bb,$44,$bb,$46 ; $fc82 (*)
    .byte   $b1,$47,$ba,$47,$be,$44,$44,$bb ; $fc8a (*)
    .byte   $44,$3b,$44,$bb,$44,$bb,$44,$bb ; $fc92 (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$bb,$44 ; $fc9a (*)
    .byte   $ba,$47,$be,$47,$bf,$4e,$ba,$43 ; $fca2 (*)
    .byte   $90,$43,$b4,$1b,$6c,$89,$44,$bb ; $fcaa (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fcb2 (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$bb,$44 ; $fcba (*)
    .byte   $bb,$44,$bb,$45,$ba,$47,$b5,$0b ; $fcc2 (*)
    .byte   $bc,$4f,$bc,$4b,$b4,$4b,$44,$bb ; $fcca (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fcd2 (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$bb,$44 ; $fcda (*)
    .byte   $bb,$45,$ba,$45,$bb,$40,$be,$4f ; $fce2 (*)
    .byte   $b9,$47,$b4,$43,$9c,$5b,$cc,$bb ; $fcea (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fcf2 (*)
    .byte   $44,$bb,$44,$bb                 ; $fcfa (*)
    .byte   $44                             ; $fcfe (D)
    .byte   $bb                             ; $fcff (*)
    .byte   $e0,$a0,$a0,$a0,$e0             ; $fd00 (D)
    .byte   $e0,$40,$40,$60,$40,$e0,$20,$e0 ; $fd05 (*)
    .byte   $80,$e0,$e0,$80,$c0,$80         ; $fd0d (*)
    .byte   $e0                             ; $fd13 (D)
    .byte   $80,$80,$e0,$a0,$a0,$e0,$80,$e0 ; $fd14 (*)
    .byte   $20,$e0,$e0,$a0,$e0,$20         ; $fd1c (*)
    .byte   $20                             ; $fd22 (D)
    .byte   $80,$80,$80,$80,$e0,$e0,$a0,$e0 ; $fd23 (*)
    .byte   $a0,$e0,$80,$80,$e0,$a0,$e0     ; $fd2b (*)
    .byte   $0e,$0a,$0a,$0a,$0e,$0e,$04,$04 ; $fd32 (D)
    .byte   $06,$04,$0e,$02,$0e,$08,$0e,$0e ; $fd3a (D)
    .byte   $08,$0c,$08,$0e,$08,$08,$0e,$0a ; $fd42 (D)
    .byte   $0a                             ; $fd4a (D)
    .byte   $0e,$08,$0e,$02,$0e             ; $fd4b (*)
    .byte   $0e,$0a,$0e,$02,$02,$08,$08,$08 ; $fd50 (D)
    .byte   $08,$0e                         ; $fd58 (D)
    .byte   $0e,$0a,$0e,$0a,$0e             ; $fd5a (*)
    .byte   $08,$08,$0e,$0a,$0e             ; $fd5f (D)
    .byte   $70,$50,$50,$50,$70,$70,$20,$20 ; $fd64 (*)
    .byte   $60,$20,$70,$40,$70,$10,$70,$70 ; $fd6c (*)
    .byte   $10,$30,$10,$70,$10,$10,$70,$50 ; $fd74 (*)
    .byte   $50,$70,$10,$70,$40,$70,$70,$50 ; $fd7c (*)
    .byte   $70,$40,$40,$10,$10,$10,$10,$70 ; $fd84 (*)
    .byte   $70,$50,$70,$50,$70,$10,$10,$70 ; $fd8c (*)
    .byte   $50,$70,$07,$05,$05,$05,$07     ; $fd94 (*)
    .byte   $07,$02,$02,$06,$02             ; $fd9b (D)
    .byte   $07,$04,$07,$01,$07,$07,$01,$03 ; $fda0 (*)
    .byte   $01,$07,$01,$01,$07,$05,$05,$07 ; $fda8 (*)
    .byte   $01,$07,$04,$07,$07,$05,$07,$04 ; $fdb0 (*)
    .byte   $04,$01,$01,$01,$01,$07,$07,$05 ; $fdb8 (*)
    .byte   $07,$05,$07,$01,$01,$07,$05,$07 ; $fdc0 (*)
    
Lfdc8
    .byte   %00000000 ; |        |            $fdc8 (P)
    .byte   %00000000 ; |        |            $fdc9 (P)
    .byte   %00000000 ; |        |            $fdca (P)
    .byte   %00000000 ; |        |            $fdcb (P)
    .byte   %00000000 ; |        |            $fdcc (G)
    
    .byte   $7c,$38,$38,$10,$10,$7c,$38,$38 ; $fdcd (*)
    .byte   $10,$10                         ; $fdd5 (*)
    
Lfdd7
    .byte   %00000000 ; |        |            $fdd7 (G)
    .byte   %00000000 ; |        |            $fdd8 (G)
    .byte   %00000000 ; |        |            $fdd9 (G)
    .byte   %00000000 ; |        |            $fdda (G)
    .byte   %00000000 ; |        |            $fddb (G)
    
    .byte   $00,$00,$00,$00,$00,$7c,$38,$38 ; $fddc (*)
    .byte   $10,$10,$b8,$4b,$be,$03,$bc,$0b ; $fde4 (*)
    .byte   $fc,$cb,$54,$0b,$44,$bb,$54,$bb ; $fdec (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fdf4 (*)
    .byte   $44,$bb,$44                     ; $fdfc (*)
    .byte   $bb,$0d,$0d,$1d,$05,$05,$05,$05 ; $fdff (D)
    .byte   $f5,$1d,$f5,$1d,$f5,$0d,$0d,$0d ; $fe07 (D)
    .byte   $00,$0d,$0d,$0d,$0d,$0d,$0d,$0d ; $fe0f (D)
    .byte   $0d,$0d,$1d,$05,$05,$f5,$0d,$0d ; $fe17 (D)
    .byte   $00,$08,$08,$08,$08,$08,$08,$08 ; $fe1f (D)
    .byte   $00                             ; $fe27 (D)
    .byte   $bc,$43,$fc,$4b,$bc,$4b,$f4,$0b ; $fe28 (*)
    .byte   $08,$08,$08,$08,$00             ; $fe30 (D)
    .byte   $bb,$44,$bb,$44,$bb,$44,$bb,$44 ; $fe35 (*)
    .byte   $bb,$44,$bb,$08,$08,$08,$08,$08 ; $fe3d (*)
    .byte   $08,$08,$08,$08,$08,$08,$00,$3c ; $fe45 (*)
    .byte   $4b,$b4,$0b,$08,$08,$08,$08,$08 ; $fe4d (*)
    .byte   $08,$08,$08,$08,$08,$08,$00,$44 ; $fe55 (*)
    .byte   $bb,$44,$bb,$08,$08,$08,$08,$08 ; $fe5d (*)
    .byte   $08,$08,$08,$00,$45,$ba,$43,$be ; $fe65 (*)
    .byte   $4b,$b2,$4b,$08,$08,$08,$08,$00 ; $fe6d (*)
    
Lfe75
    .byte   BLACK|$c                        ; $fe75 (C)
    .byte   RED|$4                          ; $fe76 (C)
    .byte   BLUE_CYAN|$c                    ; $fe77 (C)
    .byte   YELLOW|$8                       ; $fe78 (C)
    .byte   BROWN|$6                        ; $fe79 (C)
    .byte   MAUVE|$6                        ; $fe7a (C)
    .byte   PURPLE|$6                       ; $fe7b (C)
    .byte   GREEN_BEIGE|$6                  ; $fe7c (C)
    
Lfe7d
    .byte   $04                             ; $fe7d (D)
    .byte   $04,$09,$0e,$0e,$0e,$0e,$0e     ; $fe7e (*)
Lfe85
    .byte   $55                             ; $fe85 (D)
    .byte   $55,$25,$bc,$34,$cd,$45,$45     ; $fe86 (*)
Lfe8d
    .byte   $00                             ; $fe8d (D)
    .byte   $00,$00,$00,$01,$11,$13,$33     ; $fe8e (*)
Lfe95
    .byte   $00                             ; $fe95 (D)
    .byte   $00,$02,$01,$01,$00,$00,$00,$bb ; $fe96 (*)
    .byte   $44,$bb,$bb,$44,$bb,$45,$bb,$44 ; $fe9e (*)
    .byte   $ba,$41,$bf,$01,$b0,$43,$bc,$4b ; $fea6 (*)
    .byte   $fc,$c3,$44,$bb,$44,$bb,$44,$bb ; $feae (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $feb6 (*)
    .byte   $44,$bb,$bb,$44,$bb,$44,$bb,$45 ; $febe (*)
    .byte   $ba,$45,$ba,$45,$be,$23,$f4,$4b ; $fec6 (*)
    .byte   $bc,$4b,$44,$bb,$44,$bb,$44,$bb ; $fece (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fed6 (*)
    .byte   $44,$bb,$bb,$44,$bb,$44,$bb,$45 ; $fede (*)
    .byte   $bb,$45,$be,$43,$be,$43,$bc,$0b ; $fee6 (*)
    .byte   $b4,$4b,$44,$bb,$44,$bb,$44,$bb ; $feee (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $fef6 (*)
    .byte   $44,$bb                         ; $fefe (*)
    
	.byte %00001100 ; |    XX  |
	.byte %00001110 ; |    XXX |
	.byte %01101110 ; | XX XXX |
	.byte %11111110 ; |XXXXXXX |
	.byte %11111110 ; |XXXXXXX |
	.byte %11100100 ; |XXX  X  |
	.byte %01000110 ; | X   XX |
	.byte %01010111 ; | X X XXX|
	.byte %11010111 ; |XX X XXX|
	.byte %11000111 ; |XX   XXX|
	.byte %11101111 ; |XXX XXXX|
	.byte %11111100 ; |XXXXXX  |
	.byte %01011100 ; | X XXX  |
	.byte %00011100 ; |   XXX  |
	.byte %00001000 ; |    X   |
    
    .byte   $43                             ; $ff0f (*)
    
	.byte %00001100 ; |    XX  |
	.byte %00011110 ; |   XXXX |
	.byte %00011110 ; |   XXXX |
	.byte %00011111 ; |   XXXXX|
	.byte %01110111 ; | XXX XXX|
	.byte %11110011 ; |XXXX  XX|
	.byte %11100011 ; |XXX   XX|
	.byte %11101011 ; |XXX X XX|
	.byte %11101010 ; |XXX X X |
	.byte %00100011 ; |  X   XX|
	.byte %01110111 ; | XXX XXX|
	.byte %01111111 ; | XXXXXXX|
	.byte %01111110 ; | XXXXXX |
	.byte %01110110 ; | XXX XX |
	.byte %00110000 ; |  XX    |
    
    .byte   $bb                             ; $ff1f (*)
    
	.byte %00001100 ; |    XX  |
	.byte %11011110 ; |XX XXXX |
	.byte %11110010 ; |XXXX  X |
	.byte %01101011 ; | XX X XX|
	.byte %11100111 ; |XXX  XXX|
	.byte %11111100 ; |XXXXXX  |
	.byte %00011100 ; |   XXX  |
    
    .byte   $43,$be,$4b,$bc,$4b,$b4,$5b,$b4 ; $ff27 (*)
    .byte   $5b                             ; $ff2f (*)
    
	.byte %00101000 ; |  X X   |
	.byte %11010000 ; |XX X    |
	.byte %01111000 ; | XXXX   |
	.byte %00100000 ; |  X     |
    
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $ff34 (*)
    .byte   $44,$bb,$44,$bb,$a0,$04,$40,$09 ; $ff3c (*)
    .byte   $20,$00,$88,$01,$10,$40,$11,$43 ; $ff44 (*)
    .byte   $b4,$4b,$b4,$4b,$48,$02,$20,$88 ; $ff4c (*)
    .byte   $01,$40,$14,$40,$00,$21,$84,$bb ; $ff54 (*)
    .byte   $44,$bb,$44,$bb,$50,$02,$20,$81 ; $ff5c (*)
    .byte   $04,$40,$10,$41,$bc,$41,$b4,$43 ; $ff64 (*)
    .byte   $b6,$49,$b0,$5b,$40,$10,$80,$20 ; $ff6c (*)
    
	.byte %00010000 ; |   X    |
	.byte %00010000 ; |   X    |
	.byte %01111000 ; | XXXX   |
	.byte %01110100 ; | XXX X  |
	.byte %01111000 ; | XXXX   |
    
    .byte   $ff                             ; $ff79 (D)
    
	.byte %00100000 ; |  X     |
	.byte %00100000 ; |  X     |
	.byte %00111000 ; |  XXX   |
	.byte %01110100 ; | XXX X  |
	.byte %00111000 ; |  XXX   |
    
    .byte   $ff                             ; $ff7f (D)
    
	.byte %01000000 ; | X      |
	.byte %00101000 ; |  X X   |
	.byte %00110100 ; |  XX X  |
	.byte %01111000 ; | XXXX   |
	.byte %00110000 ; |  XX    |
    
    .byte   $ff                             ; $ff85 (D)
    
	.byte %00001000 ; |    X   |
	.byte %01010100 ; | X X X  |
	.byte %00111100 ; |  XXXX  |
	.byte %00111100 ; |  XXXX  |
	.byte %00001100 ; |    XX  |
    
    .byte   $ff                             ; $ff8b (D)
    
	.byte %00001000 ; |    X   |
	.byte %00010100 ; |   X X  |
	.byte %01111100 ; | XXXXX  |
	.byte %00011100 ; |   XXX  |
	.byte %00011100 ; |   XXX  |
    
    .byte   $ff                             ; $ff91 (D)
    .byte   $08,$14,$1c,$7c,$08,$ff,$10,$28 ; $ff92 (*)
    .byte   $1c,$3c,$48,$ff,$3c,$5c,$38,$18 ; $ff9a (*)
    .byte   $20,$ff,$3c,$5c,$3c,$10,$10,$ff ; $ffa2 (*)
    
    .byte   %00010000 ; |   #    |            $ffaa (G)
    .byte   %00000010 ; |      # |            $ffab (G)
    .byte   %00001000 ; |    #   |            $ffac (G)
    .byte   %00100010 ; |  #   # |            $ffad (G)
    .byte   %00001000 ; |    #   |            $ffae (G)
    
    .byte   $ff                             ; $ffaf (D)
    
    .byte   %00001000 ; |    #   |            $ffb0 (G)
    .byte   %00010000 ; |   #    |            $ffb1 (G)
    .byte   %10000000 ; |#       |            $ffb2 (G)
    .byte   %00000100 ; |     #  |            $ffb3 (G)
    .byte   %10100010 ; |# #   # |            $ffb4 (G)
    
    .byte   $ff                             ; $ffb5 (D)
    
    .byte   %00100000 ; |  #     |            $ffb6 (G)
    .byte   %10000001 ; |#      #|            $ffb7 (G)
    .byte   %00100010 ; |  #   # |            $ffb8 (G)
    .byte   %00010000 ; |   #    |            $ffb9 (G)
    .byte   %00000100 ; |     #  |            $ffba (G)
    
    .byte   $ff                             ; $ffbb (D)
    .byte   $38,$44,$54,$44,$38,$ff,$10,$7c ; $ffbc (*)
    .byte   $38,$ff,$10,$38,$fe,$7c,$38,$ff ; $ffc4 (*)
    .byte   $b4,$cb,$74,$8b,$44,$bb,$44,$bb ; $ffcc (*)
    .byte   $44,$bb,$44,$bb,$44,$bb,$44,$bb ; $ffd4 (*)
    .byte   $44,$bb,$44,$bb,$bb,$44,$bb,$44 ; $ffdc (*)
    .byte   $bb,$44,$bb,$4c,$be,$43,$be,$40 ; $ffe4 (*)
    .byte   $b4,$49,$b6,$0b                 ; $ffec (*)
    
Lfff0
    sta     Lfff9                   ;4        ; MEMO: ここでBANK1に切り替えてる挙動になっている
    jmp.ind (ram_F7)                ;5        ; このコードはBANK1にもあるので、なににせよram_F7にジャンプする
    NOP     ram_BB                  ;3         *
    .byte   $44 ;NOP                ;3-7 =   8 *
    
Lfff9
    .byte   $00                             ; $fff9 (D)
    .byte   $91,$d5,$91,$d5,$91             ; $fffa (*)
    .byte   $d5                             ; $ffff (*)


;***********************************************************
;      Bank 1 / 0..1
;***********************************************************

    SEG     CODE
    ORG     $1000
    RORG    $f000

    ldx     #$ff                    ;2        
    txs                             ;2        
    lda     #$24                    ;2        
    sta     TIM64T                  ;4        
    lda     SWCHB                   ;4        
    ror                             ;2        
    ror                             ;2        
    bcs     Lf059                   ;2/3      
    bit     ram_80                  ;3         *
    bvs     Lf035                   ;2/3       *
    lda     ram_80                  ;3         *
    ora     #$40                    ;2         *
    sta     ram_80                  ;3         *
    lda     ram_C7                  ;3         *
    ora     #$40                    ;2         *
    sta     ram_C7                  ;3         *
    lda     ram_C8                  ;3         *
    ora     #$01                    ;2         *
    sta     ram_C8                  ;3         *
    lda     #$e0                    ;2         *
    sta     ram_CA                  ;3         *
    sta     ram_D2                  ;3         *
    lda     #$00                    ;2         *
    sta     ram_B9                  ;3         *
    sta     ram_BA                  ;3         *
    sta     ram_BC                  ;3         *
    sta     ram_BF                  ;3   =  71 *
Lf035
    lda     SWCHB                   ;4         *
    ror                             ;2         *
    lda     ram_B9                  ;3         *
    and     #$3f                    ;2         *
    bcs     Lf041                   ;2/3       *
    and     #$0f                    ;2   =  15 *
Lf041
    bne     Lf056                   ;2/3       *
    inc     ram_80                  ;5         *
    lda     ram_80                  ;3         *
    ldx     #$04                    ;2   =  12 *
Lf049
    dex                             ;2         *
    bmi     Lf056                   ;2/3       *
    cmp     Lff5f,x                 ;4         *
    bne     Lf049                   ;2/3       *
    lda     Lff63,x                 ;4         *
    sta     ram_80                  ;3   =  17 *
Lf056
    jmp     Lf07d                   ;3   =   3 *
    
Lf059
    lda     ram_80                  ;3        
    and     #$bf                    ;2        
    sta     ram_80                  ;3        
    lda     SWCHB                   ;4        
    ror                             ;2        
    bcs     Lf07d                   ;2/3      
    lda     #$00                    ;2        
    sta     COLUBK                  ;3        
    ldx     #$83                    ;2   =  23
Lf06b
    sta     VSYNC,x                 ;4        
    inx                             ;2        
    bne     Lf06b                   ;2/3      
    lda     #$40                    ;2        
    sta     ram_BC                  ;3        
    sta     ram_BF                  ;3        
    lda     #$29                    ;2        
    sta     ram_CA                  ;3        
    jmp     Lfa03                   ;3   =  24
    
Lf07d
    ldx     #$00                    ;2   =   2
Lf07f
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    beq     Lf088                   ;2/3      
    inx                             ;2        
    bpl     Lf07f                   ;2/3 =  12
Lf088
    cpx     #$00                    ;2        
    beq     Lf08d                   ;2/3      
    dex                             ;2   =   6
Lf08d
    stx     ram_DC                  ;3        
    ldx     #$09                    ;2   =   5
Lf091
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    beq     Lf09a                   ;2/3      
    inx                             ;2        
    bpl     Lf091                   ;2/3 =  12
Lf09a
    cpx     #$09                    ;2        
    beq     Lf09f                   ;2/3      
    dex                             ;2   =   6
Lf09f
    stx     ram_DD                  ;3        
    ldx     #$00                    ;2        
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    bne     Lf0b7                   ;2/3      
    ldx     #$09                    ;2         *
    lda     ram_83,x                ;4         *
    cmp     #$e0                    ;2         *
    bne     Lf0b7                   ;2/3       *
    jsr     Lfdf3                   ;6         *
    jmp     Lf20f                   ;3   =  32 *
    
Lf0b7
    lda     ram_C2                  ;3        
    bne     Lf136                   ;2/3!     
    bit     ram_C8                  ;3        
    bvs     Lf0ce                   ;2/3      
    lda     ram_C8                  ;3        
    ror                             ;2        
    bcs     Lf12f                   ;2/3!     
    lda     ram_CA                  ;3        
    cmp     #$e0                    ;2        
    bne     Lf132                   ;2/3!     
    lda     ram_DE                  ;3        
    beq     Lf0df                   ;2/3 =  29
Lf0ce
    lda     ram_D2                  ;3        
    cmp     #$e0                    ;2        
    bne     Lf132                   ;2/3!     
    lda     ram_D9                  ;3        
    ora     ram_DA                  ;3        
    ora     ram_DB                  ;3        
    bne     Lf132                   ;2/3!     
    jmp     Lf20f                   ;3   =  21
    
Lf0df
    lda     ram_C8                  ;3        
    and     #$02                    ;2        
    beq     Lf0fd                   ;2/3      
    lda     ram_D2                  ;3        
    cmp     #$e0                    ;2        
    bne     Lf132                   ;2/3!     
    lda     ram_DB                  ;3        
    bne     Lf132                   ;2/3!     
    ldx     #$00                    ;2        
    jsr     Lfea9                   ;6        
    bne     Lf12f                   ;2/3!     
    ldx     #$09                    ;2        
    jsr     Lfea9                   ;6        
    bne     Lf12f                   ;2/3!=  39
Lf0fd
    lda     ram_DF                  ;3        
    sta     ram_CA                  ;3        
    lda     #$00                    ;2        
    ldx     #$05                    ;2   =  10
Lf105
    sta     ram_CB,x                ;4        
    dex                             ;2        
    bpl     Lf105                   ;2/3      
    lda     ram_80                  ;3        
    and     #$20                    ;2        
    bne     Lf114                   ;2/3      
    sta     ram_BF                  ;3        
    beq     Lf12f                   ;2/3 =  20
Lf114
    lda     ram_BF                  ;3         *
    beq     Lf12f                   ;2/3       *
    lda     ram_C8                  ;3         *
    and     #$02                    ;2         *
    beq     Lf12f                   ;2/3       *
    jsr     Lface                   ;6         *
    lda     #$e0                    ;2         *
    sta     ram_83                  ;3         *
    sta     ram_8C                  ;3         *
    lda     #$00                    ;2         *
    sta     ram_DC                  ;3         *
    lda     #$09                    ;2         *
    sta     ram_DD                  ;3   =  36 *
Lf12f
    jmp     Lf20f                   ;3   =   3
    
Lf132
    lda     ram_C2                  ;3        
    beq     Lf152                   ;2/3 =   5
Lf136
    ldx     ram_DC                  ;3        
    stx     ram_F5                  ;3        
    ldx     #$00                    ;2        
    jsr     Lfce7                   ;6        
    stx     ram_DC                  ;3        
    ldx     ram_DD                  ;3        
    stx     ram_F5                  ;3        
    ldx     #$09                    ;2        
    jsr     Lfce7                   ;6        
    stx     ram_DD                  ;3        
    lda     #$00                    ;2        
    sta     ram_C2                  ;3        
    beq     Lf12f                   ;2/3 =  41
Lf152
    lda     ram_E1                  ;3        
    bit     ram_E1                  ;3        
    bpl     Lf19a                   ;2/3      
    eor     #$c0                    ;2        
    sta     ram_E1                  ;3        
    bvc     Lf17c                   ;2/3      
    lda     ram_D9                  ;3        
    beq     Lf152                   ;2/3      
    lda     ram_D6                  ;3        
    ldy     ram_D3                  ;3        
    ldx     #$07                    ;2        
    jsr     Lfaf0                   ;6        
    ldy     ram_D2                  ;3        
    cpy     #$e0                    ;2        
    beq     Lf179                   ;2/3      
    jsr     Lfcdc                   ;6         *
    ldy     ram_D1                  ;3         *
    jsr     Lfba9                   ;6   =  56 *
Lf179
    jmp     Lf20f                   ;3   =   3
    
Lf17c
    lda     ram_DA                  ;3        
    beq     Lf152                   ;2/3      
    lda     ram_D7                  ;3        
    ldy     ram_D4                  ;3        
    ldx     #$08                    ;2        
    jsr     Lfaf0                   ;6        
    ldy     ram_D2                  ;3        
    cpy     #$e0                    ;2        
    beq     Lf197                   ;2/3      
    jsr     Lfcdc                   ;6         *
    ldy     ram_D1                  ;3         *
    jsr     Lfba9                   ;6   =  41 *
Lf197
    jmp     Lf20f                   ;3   =   3
    
Lf19a
    and     #$03                    ;2        
    tax                             ;2        
    inc     ram_E1                  ;5        
    lda     ram_E1                  ;3        
    ora     #$80                    ;2        
    tay                             ;2        
    and     #$03                    ;2        
    cmp     #$03                    ;2        
    bne     Lf1ae                   ;2/3      
    tya                             ;2        
    and     #$fc                    ;2        
    tay                             ;2   =  28
Lf1ae
    sty     ram_E1                  ;3        
    dex                             ;2        
    bmi     Lf1ec                   ;2/3      
    dex                             ;2        
    bmi     Lf1db                   ;2/3      
    bit     ram_C8                  ;3        
    bvc     Lf1bd                   ;2/3 =  16
Lf1ba
    jmp     Lf152                   ;3   =   3
    
Lf1bd
    lda     ram_DE                  ;3        
    bmi     Lf1d8                   ;2/3      
    ldy     ram_C9                  ;3        
    ldx     #$04                    ;2        
    lda     ram_CA                  ;3        
    jsr     Lfaf0                   ;6        
    ldy     ram_D2                  ;3        
    cpy     #$e0                    ;2        
    beq     Lf1d8                   ;2/3      
    jsr     Lfcdc                   ;6         *
    ldy     ram_D1                  ;3         *
    jsr     Lfba9                   ;6   =  41 *
Lf1d8
    jmp     Lf20f                   ;3   =   3
    
Lf1db
    ldy     ram_D2                  ;3        
    cpy     #$e0                    ;2        
    beq     Lf1ba                   ;2/3      
    jsr     Lfcdc                   ;6         *
    ldy     ram_D1                  ;3         *
    jsr     Lfaf0                   ;6         *
    jmp     Lf20f                   ;3   =  25 *
    
Lf1ec
    lda     ram_DB                  ;3        
    beq     Lf1ba                   ;2/3      
    lda     ram_D8                  ;3         *
    ldy     ram_D5                  ;3         *
    ldx     #$09                    ;2         *
    jsr     Lfaf0                   ;6         *
    ldy     ram_CA                  ;3         *
    cpy     #$e0                    ;2         *
    beq     Lf20f                   ;2/3!      *
    bit     ram_C8                  ;3         *
    bvs     Lf20f                   ;2/3       *
    lda     ram_DE                  ;3         *
    bmi     Lf20f                   ;2/3       *
    ldx     #$04                    ;2         *
    tya                             ;2         *
    ldy     ram_C9                  ;3         *
    jsr     Lfba9                   ;6   =  49 *
Lf20f
    lda     ram_C8                  ;3        
    ror                             ;2        
    bcc     Lf21d                   ;2/3      
    lda     #$00                    ;2        
    sta     AUDV0                   ;3        
    sta     AUDV1                   ;3        
    jmp     Lf316                   ;3   =  18
    
Lf21d
    lda     ram_C5                  ;3        
    sta     ram_F4                  ;3        
    ldy     #$08                    ;2        
    ror     ram_F4                  ;5        
    bcc     Lf240                   ;2/3      
    lda     ram_B9                  ;3        
    ror                             ;2        
    bcs     Lf238                   ;2/3      
    dec     ram_C3                  ;5        
    bne     Lf238                   ;2/3      
    lda     ram_C5                  ;3        
    and     #$fe                    ;2        
    sta     ram_C5                  ;3        
    bcc     Lf240                   ;2/3 =  39
Lf238
    ror     ram_F4                  ;5        
    ldx     #$1f                    ;2        
    lda     ram_C3                  ;3        
    bpl     Lf24c                   ;2/3 =  12
Lf240
    ror     ram_F4                  ;5        
    bcc     Lf24a                   ;2/3      
    ldx     #$08                    ;2        
    lda     #$06                    ;2        
    bpl     Lf24c                   ;2/3 =  13
Lf24a
    lda     #$00                    ;2   =   2
Lf24c
    sty     AUDC0                   ;3        
    stx     AUDF0                   ;3        
    sta     AUDV0                   ;3        
    ror     ram_F4                  ;5        
    bcc     Lf274                   ;2/3      
    ldx     #$04                    ;2         *
    ldy     #$0f                    ;2         *
    lda     ram_C4                  ;3         *
    and     #$10                    ;2         *
    beq     Lf262                   ;2/3       *
    ldy     #$00                    ;2   =  29 *
Lf262
    tya                             ;2         *
    ldy     #$04                    ;2         *
    dec     ram_C4                  ;5         *
    bne     Lf2c2                   ;2/3       *
    lda     ram_C5                  ;3         *
    and     #$eb                    ;2         *
    sta     ram_C5                  ;3         *
    inc     ram_C4                  ;5         *
    jmp     Lf2a4                   ;3   =  27 *
    
Lf274
    ror     ram_F4                  ;5        
    bcc     Lf290                   ;2/3      
    ldx     #$08                    ;2         *
    lda     ram_C7                  ;3         *
    and     #$20                    ;2         *
    bne     Lf282                   ;2/3       *
    ldx     #$10                    ;2   =  18 *
Lf282
    lda     ram_B9                  ;3         *
    and     #$02                    ;2         *
    beq     Lf28a                   ;2/3       *
    dex                             ;2         *
    dex                             ;2   =  11 *
Lf28a
    ldy     #$0c                    ;2         *
    lda     #$08                    ;2         *
    bpl     Lf2c2                   ;2/3 =   6 *
Lf290
    ror     ram_F4                  ;5        
    bcc     Lf2ca                   ;2/3      
    dec     ram_C4                  ;5        
    bne     Lf2ab                   ;2/3      
    lda     ram_C5                  ;3        
    and     #$ef                    ;2        
    ora     #$60                    ;2        
    sta     ram_C5                  ;3        
    lda     #$08                    ;2        
    sta     ram_C4                  ;3   =  29
Lf2a4
    lda     #$00                    ;2        
    sta     AUDV1                   ;3        
    jmp     Lf316                   ;3   =   8
    
Lf2ab
    ldy     #$0c                    ;2        
    lda     ram_C4                  ;3        
    cmp     #$08                    ;2        
    bcc     Lf2ba                   ;2/3      
    lda     ram_B9                  ;3        
    ror                             ;2        
    bcc     Lf2ba                   ;2/3      
    ldy     #$08                    ;2   =  18
Lf2ba
    lda     #$0f                    ;2        
    sec                             ;2        
    sbc     ram_C4                  ;3        
    tax                             ;2        
    lda     #$0d                    ;2   =  11
Lf2c2
    sty     AUDC1                   ;3        
    stx     AUDF1                   ;3        
    sta     AUDV1                   ;3        
    bpl     Lf316                   ;2/3!=  11
Lf2ca
    ldy     #$06                    ;2        
    dec     ram_C4                  ;5        
    bne     Lf2f5                   ;2/3      
    lda     ram_C5                  ;3        
    and     #$9f                    ;2        
    ror     ram_F4                  ;5        
    bcs     Lf308                   ;2/3!     
    ora     #$20                    ;2        
    ror     ram_F4                  ;5        
    bcc     Lf2e0                   ;2/3      
    ora     #$40                    ;2   =  32
Lf2e0
    sta     ram_C5                  ;3        
    lda     ram_BA                  ;3        
    bmi     Lf2f1                   ;2/3      
    lda     #$0e                    ;2        
    sec                             ;2        
    sbc     ram_BA                  ;3        
    bmi     Lf2f1                   ;2/3      
    cmp     #$06                    ;2        
    bcs     Lf2f3                   ;2/3 =  21
Lf2f1
    lda     #$06                    ;2   =   2 *
Lf2f3
    sta     ram_C4                  ;3   =   3
Lf2f5
    lda     ram_C5                  ;3        
    rol                             ;2        
    rol                             ;2        
    bmi     Lf2ff                   ;2/3      
    lda     #$00                    ;2        
    beq     Lf2c2                   ;2/3 =  13
Lf2ff
    ldx     #$13                    ;2        
    bcc     Lf304                   ;2/3      
    inx                             ;2   =   6
Lf304
    lda     #$0c                    ;2        
    bpl     Lf2c2                   ;2/3!=   4
Lf308
    ror     ram_F4                  ;5        
    bcs     Lf30e                   ;2/3      
    ora     #$40                    ;2   =   9
Lf30e
    sta     ram_C5                  ;3        
    lda     #$08                    ;2        
    sta     ram_C4                  ;3        
    bpl     Lf2f5                   ;2/3!=  10
Lf316
    ldx     #$ff                    ;2   =   2
Lf318
    lda     INTIM                   ;4        
    bne     Lf318                   ;2/3      
    stx     VBLANK                  ;3        
    stx     VSYNC                   ;3        
    sta     WSYNC                   ;3   =  15
;---------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    sta     VSYNC                   ;3        
    sta     VBLANK                  ;3        
    lda     #$2d                    ;2        
    sta     TIM64T                  ;4        
    inc     ram_B9                  ;5        
    bne     Lf352                   ;2/3      
    inc     ram_BA                  ;5        
    bit     ram_C7                  ;3        
    bvs     Lf352                   ;2/3      
    lda     ram_C8                  ;3        
    ror                             ;2        
    bcc     Lf352                   ;2/3      
    lda     ram_BA                  ;3         *
    bpl     Lf349                   ;2/3       *
    lda     ram_C7                  ;3         *
    ora     #$40                    ;2         *
    sta     ram_C7                  ;3   =  49 *
Lf349
    lda     ram_80                  ;3         *
    and     #$20                    ;2         *
    beq     Lf352                   ;2/3       *
    jsr     Lface                   ;6   =  13 *
Lf352
    jsr     Lfae2                   ;6        
    lda     ram_B9                  ;3        
    ror                             ;2        
    bcs     Lf35d                   ;2/3      
    jmp     Lf5d7                   ;3   =  16
    
Lf35d
    ldy     #$00                    ;2        
    lda     ram_BB                  ;3        
    sec                             ;2        
    sbc     #$11                    ;2        
    cmp     #$10                    ;2        
    bcs     Lf36c                   ;2/3      
    ora     #$70                    ;2        
    iny                             ;2        
    iny                             ;2   =  19
Lf36c
    tax                             ;2        
    and     #$0f                    ;2        
    bne     Lf376                   ;2/3      
    txa                             ;2        
    ora     #$03                    ;2        
    tax                             ;2        
    iny                             ;2   =  14
Lf376
    stx     ram_BB                  ;3        
    tya                             ;2        
    ror                             ;2        
    ror                             ;2        
    ror                             ;2        
    sta     ram_EC                  ;3        
    lda     #$c0                    ;2        
    sta     ram_E3                  ;3        
    lda     #$cf                    ;2        
    sta     ram_E5                  ;3        
    lda     #$de                    ;2        
    sta     ram_F2                  ;3        
    ldx     #$09                    ;2   =  31
Lf38c
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    beq     Lf39a                   ;2/3      
    inc     ram_83,x                ;6        
    jsr     Lfa3b                   ;6        
    inx                             ;2        
    bne     Lf38c                   ;2/3 =  24
Lf39a
    ldx     ram_DD                  ;3        
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    beq     Lf417                   ;2/3!     
    cmp     #$59                    ;2        
    bcc     Lf3ae                   ;2/3      
    lda     #$e0                    ;2        
    sta     ram_83,x                ;4        
    dec     ram_DD                  ;5        
    bne     Lf39a                   ;2/3 =  28
Lf3ae
    lda     ram_A7,x                ;4        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    and     #$03                    ;2        
    tay                             ;2        
    lda     ram_83,x                ;4        
    cmp     Lff5b,y                 ;4        
    bne     Lf3cf                   ;2/3      
    stx     ram_F5                  ;3        
    lda     #$09                    ;2        
    sta     ram_F4                  ;3        
    jsr     Lfe74                   ;6        
    lda.wy  ram_83,y                ;4        
    sec                             ;2        
    sbc     #$59                    ;2        
    sta     ram_83,x                ;4   =  52
Lf3cf
    ldx     #$09                    ;2        
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    beq     Lf417                   ;2/3!     
    lda     ram_95,x                ;4        
    sta     ram_EA                  ;3        
    lsr                             ;2        
    and     #$07                    ;2        
    sta     ram_E8                  ;3        
    lda     ram_83,x                ;4        
    bpl     Lf417                   ;2/3!     
    cmp     #$ff                    ;2        
    beq     Lf417                   ;2/3!     
    lda     ram_95,x                ;4        
    ror                             ;2        
    ldy     #$45                    ;2        
    bcs     Lf3f1                   ;2/3      
    ldy     #$0b                    ;2   =  46
Lf3f1
    sty     ram_E5                  ;3        
    lda     ram_A7,x                ;4        
    and     #$70                    ;2        
    sec                             ;2        
    sbc     #$02                    ;2        
    sec                             ;2        
    sbc     ram_83,x                ;4        
    sta     ram_ED                  ;3        
    sta     ram_F1                  ;3        
    ldy     #$d9                    ;2        
    sty     ram_F8                  ;3        
    ldy     #$0f                    ;2        
    sty     ram_F7                  ;3        
    jmp     Lfff0                   ;3   =  38
    
    and     #$08                    ;2        
    bne     Lf417                   ;2/3      
    lda     ram_EA                  ;3        
    clc                             ;2        
    adc     #$10                    ;2        
    sta     ram_EA                  ;3   =  14
Lf417
    lda     ram_95                  ;3        
    sta     ram_E9                  ;3        
    lsr                             ;2        
    and     #$07                    ;2        
    sta     ram_E7                  ;3        
    ldx     #$00                    ;2        
    beq     Lf42a                   ;2/3 =  17
Lf424
    dec     ram_83,x                ;6   =   6
Lf426
    jsr     Lfa3b                   ;6        
    inx                             ;2   =   8
Lf42a
    lda     ram_83,x                ;4        
    beq     Lf436                   ;2/3      
    bpl     Lf424                   ;2/3      
    cmp     #$e0                    ;2        
    beq     Lf49e                   ;2/3      
    bne     Lf455                   ;2/3 =  14
Lf436
    ldx     ram_DC                  ;3        
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    beq     Lf43f                   ;2/3      
    inx                             ;2   =  13
Lf43f
    lda     #$59                    ;2        
    sta     ram_83,x                ;4        
    lda     ram_95                  ;3        
    sta     ram_95,x                ;4        
    lda     ram_A7                  ;3        
    sta     ram_A7,x                ;4        
    lda     #$e0                    ;2        
    sta     ram_84,x                ;4        
    inc     ram_DC                  ;5        
    ldx     #$00                    ;2        
    beq     Lf424                   ;2/3 =  35
Lf455
    dec     ram_83                  ;5        
    lda     ram_A7                  ;3        
    ror                             ;2        
    ror                             ;2        
    ror                             ;2        
    ror                             ;2        
    and     #$03                    ;2        
    tay                             ;2        
    lda     ram_83                  ;3        
    cmp     Lff57,y                 ;4        
    beq     Lf498                   ;2/3      
    lda     ram_A7                  ;3        
    and     #$70                    ;2        
    sec                             ;2        
    sbc     ram_83                  ;3        
    sec                             ;2        
    sbc     #$02                    ;2        
    sta     ram_EB                  ;3        
    sta     ram_EF                  ;3        
    ldy     #$d9                    ;2        
    sty     ram_F8                  ;3        
    ldy     #$00                    ;2        
    sty     ram_F7                  ;3        
    jmp     Lfff0                   ;3   =  62
    
    and     #$08                    ;2        
    bne     Lf48b                   ;2/3      
    lda     ram_E9                  ;3        
    clc                             ;2        
    adc     #$10                    ;2        
    sta     ram_E9                  ;3   =  14
Lf48b
    ldy     #$46                    ;2        
    lda     ram_95                  ;3        
    ror                             ;2        
    bcs     Lf494                   ;2/3      
    ldy     #$0e                    ;2   =  11
Lf494
    sty     ram_E3                  ;3        
    bne     Lf426                   ;2/3 =   5
Lf498
    jsr     Lfde1                   ;6        
    jmp     Lf417                   ;3   =   9
    
Lf49e
    lda     SWCHB                   ;4        
    bit     ram_C7                  ;3        
    bmi     Lf4a6                   ;2/3      
    asl                             ;2   =  11
Lf4a6
    asl                             ;2        
    bcs     Lf4b0                   ;2/3      
    lda     ram_C5                  ;3        
    and     #$f7                    ;2        
    jmp     Lf560                   ;3   =  12
    
Lf4b0
    lda     ram_D2                  ;3         *
    cmp     #$e0                    ;2         *
    bne     Lf511                   ;2/3!      *
    lda     ram_CA                  ;3         *
    cmp     #$e0                    ;2         *
    beq     Lf506                   ;2/3!      *
    lda     #$03                    ;2         *
    cmp     ram_BA                  ;3         *
    bcs     Lf506                   ;2/3!      *
    dec     ram_C6                  ;5         *
    bne     Lf506                   ;2/3!      *
    lda     ram_C5                  ;3         *
    ora     #$08                    ;2         *
    sta     ram_C5                  ;3         *
    jsr     Lfae2                   ;6         *
    lsr                             ;2         *
    tax                             ;2         *
    and     #$06                    ;2         *
    sta     ram_F4                  ;3         *
    lda     ram_C7                  ;3         *
    and     #$f8                    ;2         *
    ora     ram_F4                  ;3         *
    bcc     Lf4df                   ;2/3       *
    ora     #$01                    ;2   =  63 *
Lf4df
    sta     ram_C7                  ;3         *
    lda     #$ba                    ;2         *
    sta     ram_D1                  ;3         *
    txa                             ;2         *
    cmp     #$4f                    ;2         *
    beq     Lf4ee                   ;2/3       *
    bcc     Lf4ee                   ;2/3       *
    sbc     #$4f                    ;2   =  18 *
Lf4ee
    sta     ram_D2                  ;3         *
    lda     ram_BD                  ;3         *
    cmp     #$15                    ;2         *
    bcs     Lf509                   ;2/3!      *
    cmp     #$07                    ;2         *
    bcc     Lf500                   ;2/3!      *
    jsr     Lfae2                   ;6         *
    ror                             ;2         *
    bcc     Lf509                   ;2/3 =  24 *
Lf500
    lda     ram_C7                  ;3         *
    and     #$df                    ;2         *
    sta     ram_C7                  ;3   =   8 *
Lf506
    jmp     Lf5b8                   ;3   =   3
    
Lf509
    lda     ram_C7                  ;3         *
    ora     #$20                    ;2         *
    sta     ram_C7                  ;3         *
    bne     Lf506                   ;2/3 =  10 *
Lf511
    lda     ram_C7                  ;3         *
    and     #$06                    ;2         *
    beq     Lf54a                   ;2/3       *
    cmp     #$06                    ;2         *
    beq     Lf54a                   ;2/3       *
    cmp     #$02                    ;2         *
    beq     Lf529                   ;2/3       *
    inc     ram_D2                  ;5         *
    lda     ram_D2                  ;3         *
    cmp     #$4f                    ;2         *
    bne     Lf536                   ;2/3       *
    beq     Lf52d                   ;2/3 =  29 *
Lf529
    dec     ram_D2                  ;5         *
    bne     Lf536                   ;2/3 =   7 *
Lf52d
    lda     ram_C7                  ;3         *
    eor     #$06                    ;2         *
    sta     ram_C7                  ;3         *
    jmp     Lf54a                   ;3   =  11 *
    
Lf536
    lda     ram_B9                  ;3         *
    asl                             ;2         *
    bne     Lf54a                   ;2/3       *
    jsr     Lfae2                   ;6         *
    and     #$06                    ;2         *
    sta     ram_F4                  ;3         *
    lda     ram_C7                  ;3         *
    and     #$f9                    ;2         *
    ora     ram_F4                  ;3         *
    sta     ram_C7                  ;3   =  29 *
Lf54a
    ldx     #$3c                    ;2         *
    lda     ram_C7                  ;3         *
    ror                             ;2         *
    jsr     Lfa62                   ;6         *
    lda     ram_D1                  ;3         *
    cmp     #$ba                    ;2         *
    bne     Lf568                   ;2/3       *
    lda     #$00                    ;2         *
    sta     ram_C6                  ;3         *
    lda     ram_C5                  ;3         *
    and     #$e7                    ;2   =  30 *
Lf560
    sta     ram_C5                  ;3        
    lda     #$e0                    ;2        
    sta     ram_D2                  ;3        
    bne     Lf506                   ;2/3 =  10
Lf568
    lda     ram_DB                  ;3         *
    bne     Lf506                   ;2/3       *
    jsr     Lfae2                   ;6         *
    and     #$0f                    ;2         *
    tax                             ;2         *
    lda     ram_C7                  ;3         *
    asl                             ;2         *
    asl                             ;2         *
    asl                             ;2         *
    txa                             ;2         *
    bcc     Lf5a7                   ;2/3       *
    and     #$03                    ;2         *
    sta     ram_F4                  ;3         *
    lda     ram_D1                  ;3         *
    jsr     Lfcca                   ;6         *
    sta     ram_F5                  ;3         *
    lda     ram_C9                  ;3         *
    jsr     Lfcca                   ;6         *
    ldy     #$00                    ;2         *
    sec                             ;2         *
    sbc     ram_F5                  ;3         *
    bcc     Lf593                   ;2/3       *
    ldy     #$08                    ;2   =  65 *
Lf593
    lda     ram_CA                  ;3         *
    sec                             ;2         *
    sbc     ram_D2                  ;3         *
    tya                             ;2         *
    bcc     Lf5a2                   ;2/3       *
    bne     Lf5a4                   ;2/3 =  14 *
Lf59d
    clc                             ;2         *
    adc     #$04                    ;2         *
    bpl     Lf5a4                   ;2/3 =   6 *
Lf5a2
    bne     Lf59d                   ;2/3 =   2 *
Lf5a4
    clc                             ;2         *
    adc     ram_F4                  ;3   =   5 *
Lf5a7
    tax                             ;2         *
    ora     Lfede,x                 ;4         *
    sta     ram_DB                  ;3         *
    lda     ram_D1                  ;3         *
    sta     ram_D5                  ;3         *
    lda     ram_D2                  ;3         *
    clc                             ;2         *
    adc     #$03                    ;2         *
    sta     ram_D8                  ;3   =  25 *
Lf5b8
    lda     #$df                    ;2        
    sta     ram_EC                  ;3        
    sta     ram_EE                  ;3        
    lda     #$de                    ;2        
    sta     ram_F0                  ;3        
    sta     ram_F2                  ;3        
    lda     #$d0                    ;2        
    sta     ram_E4                  ;3        
    lda     #$d1                    ;2        
    sta     ram_E6                  ;3        
    lda     #$00                    ;2        
    sta     ram_DC                  ;3        
    lda     #$09                    ;2        
    sta     ram_DD                  ;3        
    jmp     Lff97                   ;3   =  39
    
Lf5d7
    lda     #$cb                    ;2    Player_Color changed from $bb *original $4c   
    bit     ram_C7                  ;3        
    bpl     Lf5df                   ;2/3      
    lda     #$dc                    ;2   =   9 *
Lf5df
    sta     ram_E9                  ;3        
    sta     ram_E8                  ;3        
    ldx     #$9c                    ;2        
    lda     ram_C7                  ;3        
    and     #$20                    ;2        
    beq     Lf5ed                   ;2/3      
    ldx     #$ec                    ;2   =  17 *
Lf5ed
    stx     ram_EA                  ;3        
    lda     #$00                    ;2        
    sta     ram_E0                  ;3        
    lda     ram_BC                  ;3        
    ora     ram_BF                  ;3        
    and     #$f0                    ;2        
    bne     Lf626                   ;2/3!     
    sta     AUDV1                   ;3        
    lda     ram_C8                  ;3        
    ror                             ;2        
    bcs     Lf60f                   ;2/3      
    ldx     #$01                    ;2        
    stx     ram_BA                  ;3        
    dex                             ;2        
    stx     ram_B9                  ;3        
    lda     ram_C8                  ;3        
    ora     #$01                    ;2        
    sta     ram_C8                  ;3   =  46
Lf60f
    lda     ram_BA                  ;3        
    rol                             ;2        
    adc     #$00                    ;2        
    rol                             ;2        
    adc     #$00                    ;2        
    rol                             ;2        
    adc     #$00                    ;2        
    rol                             ;2        
    adc     #$00                    ;2        
    and     #$f7                    ;2        
    sta     COLUBK                  ;3        
    sta     ram_E0                  ;3        
    jmp     Lf834                   ;3   =  30
    
Lf626
    lda     SWCHA                   ;4        
    bit     ram_C7                  ;3        
    bpl     Lf631                   ;2/3      
    asl                             ;2         *
    asl                             ;2         *
    asl                             ;2         *
    asl                             ;2   =  17 *
Lf631
    and     #$f0                    ;2        
    sta     ram_F3                  ;3        
    bit     ram_C8                  ;3        
    bvc     Lf669                   ;2/3      
    and     #$20                    ;2         *
    beq     Lf646                   ;2/3       *
    lda     ram_C8                  ;3         *
    and     #$bf                    ;2         *
    sta     ram_C8                  ;3         *
    jmp     Lf669                   ;3   =  25 *
    
Lf646
    inc     ram_DE                  ;5         *
    lda     ram_DE                  ;3         *
    and     #$1f                    ;2         *
    bne     Lf666                   ;2/3       *
    lda     ram_C8                  ;3         *
    and     #$bf                    ;2         *
    ora     #$02                    ;2         *
    sta     ram_C8                  ;3         *
    lda     #$80                    ;2         *
    sta     ram_DE                  ;3         *
    lda     ram_C5                  ;3         *
    ora     #$01                    ;2         *
    and     #$fd                    ;2         *
    sta     ram_C5                  ;3         *
    lda     #$0f                    ;2         *
    sta     ram_C3                  ;3   =  42 *
Lf666
    jmp     Lf7b1                   ;3   =   3 *
    
Lf669
    lda     ram_CA                  ;3        
    cmp     #$e0                    ;2        
    beq     Lf679                   ;2/3      
    lda     ram_DE                  ;3        
    beq     Lf682                   ;2/3      
    bmi     Lf67f                   ;2/3      
    dec     ram_DE                  ;5         *
    bpl     Lf682                   ;2/3 =  21 *
Lf679
    lda     ram_DE                  ;3        
    beq     Lf67f                   ;2/3      
    dec     ram_DE                  ;5   =  10
Lf67f
    jmp     Lf834                   ;3   =   3
    
Lf682
    lda     ram_F3                  ;3        
    cmp     #$d0                    ;2        
    bne     Lf6f0                   ;2/3      
    lda     ram_80                  ;3        
    and     #$18                    ;2        
    beq     Lf6b2                   ;2/3      
    cmp     #$18                    ;2         *
    beq     Lf6f0                   ;2/3       *
    and     #$08                    ;2         *
    bne     Lf6a8                   ;2/3       *
    bit     ram_C8                  ;3         *
    bmi     Lf6f6                   ;2/3       *
    lda     ram_BC                  ;3         *
    eor     #$08                    ;2         *
    sta     ram_BC                  ;3         *
    lda     ram_C8                  ;3         *
    ora     #$80                    ;2         *
    sta     ram_C8                  ;3         *
    bne     Lf6f6                   ;2/3 =  45 *
Lf6a8
    lda     ram_C8                  ;3         *
    ora     #$40                    ;2         *
    sta     ram_C8                  ;3         *
    inc     ram_DE                  ;5         *
    bne     Lf6f6                   ;2/3 =  15 *
Lf6b2
    lda     ram_C8                  ;3        
    and     #$04                    ;2        
    bne     Lf6c0                   ;2/3      
    lda     ram_C8                  ;3        
    ora     #$04                    ;2        
    sta     ram_C8                  ;3        
    bne     Lf6f6                   ;2/3 =  17
Lf6c0
    lda     ram_CA                  ;3        
    cmp     #$e0                    ;2        
    beq     Lf6f6                   ;2/3      
    lda     #$e0                    ;2        
    sta     ram_CA                  ;3        
    lda     ram_C8                  ;3        
    and     #$f9                    ;2        
    sta     ram_C8                  ;3        
    jsr     Lfa9d                   ;6        
    sta     ram_C9                  ;3        
    lda     ram_81                  ;3        
    lsr                             ;2        
    cmp     #$4f                    ;2        
    bcc     Lf6de                   ;2/3      
    sbc     #$4f                    ;2   =  40
Lf6de
    sta     ram_DF                  ;3        
    lda     #$00                    ;2        
    ldx     #$05                    ;2   =   7
Lf6e4
    sta     ram_CB,x                ;4        
    dex                             ;2        
    bpl     Lf6e4                   ;2/3      
    lda     #$1f                    ;2        
    sta     ram_DE                  ;3        
    jmp     Lf834                   ;3   =  16
    
Lf6f0
    lda     ram_C8                  ;3        
    and     #$3b                    ;2        
    sta     ram_C8                  ;3   =   8
Lf6f6
    lda     ram_B9                  ;3        
    ror                             ;2        
    ror                             ;2        
    bcc     Lf719                   ;2/3!     
    lda     ram_BC                  ;3        
    and     #$f0                    ;2        
    sta     ram_F4                  ;3        
    asl     ram_F3                  ;5        
    bcs     Lf708                   ;2/3      
    dec     ram_BC                  ;5   =  29
Lf708
    asl     ram_F3                  ;5        
    bcs     Lf70e                   ;2/3      
    inc     ram_BC                  ;5   =  12
Lf70e
    lda     ram_BC                  ;3        
    and     #$0f                    ;2        
    ora     ram_F4                  ;3        
    sta     ram_BC                  ;3        
    jmp     Lf71d                   ;3   =  14
    
Lf719
    asl     ram_F3                  ;5        
    asl     ram_F3                  ;5   =  10
Lf71d
    asl     ram_F3                  ;5        
    ldy     #$01                    ;2        
    bit     ram_C7                  ;3        
    bmi     Lf727                   ;2/3      
    ldy     #$00                    ;2   =  14
Lf727
    lda.wy  INPT4|$30,y             ;4        
    bmi     Lf772                   ;2/3      
    lda     ram_C7                  ;3        
    and     #$10                    ;2        
    bne     Lf778                   ;2/3      
    lda     ram_C7                  ;3        
    ora     #$10                    ;2        
    sta     ram_C7                  ;3        
    ldy     #$01                    ;2        
    lda     ram_DA                  ;3        
    beq     Lf743                   ;2/3      
    dey                             ;2        
    lda     ram_D9                  ;3        
    bne     Lf778                   ;2/3 =  35
Lf743
    lda     ram_CA                  ;3        
    clc                             ;2        
    adc     #$03                    ;2        
    sta.wy  ram_D6,y                ;5        
    lda     ram_C9                  ;3        
    sta.wy  ram_D3,y                ;5        
    lda     ram_C5                  ;3        
    and     #$04                    ;2        
    bne     Lf760                   ;2/3      
    lda     ram_C5                  ;3        
    ora     #$10                    ;2        
    sta     ram_C5                  ;3        
    lda     #$0f                    ;2        
    sta     ram_C4                  ;3   =  40
Lf760
    lda     ram_BC                  ;3        
    and     #$07                    ;2        
    tax                             ;2        
    lda     ram_BC                  ;3        
    and     #$0f                    ;2        
    ora     Lfede,x                 ;4        
    sta.wy  ram_D9,y                ;5        
    jmp     Lf778                   ;3   =  24
    
Lf772
    lda     ram_C7                  ;3        
    and     #$ef                    ;2        
    sta     ram_C7                  ;3   =   8
Lf778
    asl     ram_F3                  ;5        
    bcs     Lf7b1                   ;2/3      
    lda     ram_C5                  ;3        
    ora     #$02                    ;2        
    sta     ram_C5                  ;3        
    lda     ram_BC                  ;3        
    and     #$0f                    ;2        
    tay                             ;2        
    lda     Lff67,y                 ;4        
    bpl     Lf78e                   ;2/3      
    dec     ram_CE                  ;5   =  33
Lf78e
    clc                             ;2        
    adc     ram_D0                  ;3        
    sta     ram_D0                  ;3        
    bcc     Lf797                   ;2/3      
    inc     ram_CE                  ;5   =  15
Lf797
    tya                             ;2        
    clc                             ;2        
    adc     #$04                    ;2        
    and     #$0f                    ;2        
    tay                             ;2        
    lda     Lff67,y                 ;4        
    bpl     Lf7a5                   ;2/3      
    dec     ram_CD                  ;5   =  21
Lf7a5
    clc                             ;2        
    adc     ram_CF                  ;3        
    sta     ram_CF                  ;3        
    bcc     Lf7ae                   ;2/3      
    inc     ram_CD                  ;5   =  15
Lf7ae
    jmp     Lf7d7                   ;3   =   3
    
Lf7b1
    lda     ram_C5                  ;3        
    and     #$fd                    ;2        
    sta     ram_C5                  ;3        
    ldx     #$01                    ;2   =  10
Lf7b9
    lda     ram_CD,x                ;4        
    ora     ram_CF,x                ;4        
    beq     Lf7d4                   ;2/3      
    lda     ram_CD,x                ;4        
    asl                             ;2        
    ldy     #$ff                    ;2        
    clc                             ;2        
    eor     #$ff                    ;2        
    bmi     Lf7cb                   ;2/3      
    iny                             ;2        
    sec                             ;2   =  28
Lf7cb
    adc     ram_CF,x                ;4        
    sta     ram_CF,x                ;4        
    tya                             ;2        
    adc     ram_CD,x                ;4        
    sta     ram_CD,x                ;4   =  18
Lf7d4
    dex                             ;2        
    bpl     Lf7b9                   ;2/3 =   4
Lf7d7
    ldx     #$01                    ;2   =   2
Lf7d9
    lda     ram_CD,x                ;4        
    tay                             ;2        
    rol                             ;2        
    eor     ram_CD,x                ;4        
    rol                             ;2        
    tya                             ;2        
    bcc     Lf7e7                   ;2/3      
    eor     #$7f                    ;2         *
    sta     ram_CD,x                ;4   =  24 *
Lf7e7
    ror                             ;2        
    ror                             ;2        
    ror                             ;2        
    ror                             ;2        
    and     #$0f                    ;2        
    cpy     #$00                    ;2        
    bpl     Lf7f3                   ;2/3      
    ora     #$f0                    ;2   =  16
Lf7f3
    sta     ram_F4                  ;3        
    tya                             ;2        
    rol                             ;2        
    rol                             ;2        
    rol                             ;2        
    rol                             ;2        
    and     #$f0                    ;2        
    sta     ram_F5                  ;3        
    lda     ram_CF,x                ;4        
    ror                             ;2        
    ror                             ;2        
    ror                             ;2        
    ror                             ;2        
    and     #$0f                    ;2        
    ora     ram_F5                  ;3        
    clc                             ;2        
    adc     ram_CB,x                ;4        
    sta     ram_CB,x                ;4        
    lda     ram_F4                  ;3        
    php                             ;3        
    cpx     #$00                    ;2        
    beq     Lf81c                   ;2/3      
    plp                             ;4        
    adc     ram_CA                  ;3        
    sta     ram_CA                  ;3        
    dex                             ;2        
    bpl     Lf7d9                   ;2/3!=  69
Lf81c
    plp                             ;4        
    bmi     Lf823                   ;2/3      
    adc     #$00                    ;2        
    bpl     Lf825                   ;2/3 =  10
Lf823
    sbc     #$00                    ;2   =   2
Lf825
    sec                             ;2        
    cmp     #$00                    ;2        
    bpl     Lf82d                   ;2/3      
    eor     #$ff                    ;2        
    clc                             ;2   =  10
Lf82d
    beq     Lf834                   ;2/3      
    ldx     #$34                    ;2        
    jsr     Lfac2                   ;6   =  10
Lf834
    lda     #$df                    ;2        
    sta     ram_EE                  ;3        
    sta     ram_E7                  ;3        
    lda     ram_C7                  ;3        
    and     #$08                    ;2        
    beq     Lf866                   ;2/3      
    lda     #$aa                    ;2        
    clc                             ;2        
    adc     ram_C6                  ;3        
    sta     ram_F2                  ;3        
    lda     ram_C6                  ;3        
    clc                             ;2        
    adc     #$06                    ;2        
    sta     ram_C6                  ;3        
    cmp     #$12                    ;2        
    bne     Lf872                   ;2/3      
    lda     ram_C7                  ;3        
    and     #$f7                    ;2        
    sta     ram_C7                  ;3        
    lda     ram_C5                  ;3        
    and     #$e7                    ;2        
    sta     ram_C5                  ;3        
    lda     #$00                    ;2        
    sta     ram_C6                  ;3        
    lda     #$e0                    ;2        
    sta     ram_D2                  ;3   =  65
Lf866
    ldx     #$c2                    ;2        
    lda     ram_C7                  ;3        
    and     #$20                    ;2        
    bne     Lf870                   ;2/3      
    ldx     #$c6                    ;2   =  11
Lf870
    stx     ram_F2                  ;3   =   3
Lf872
    lda     #$79                    ;2        
    sta     ram_E6                  ;3        
    ldx     #$00                    ;2        
    lda     ram_DE                  ;3        
    bpl     Lf8ad                   ;2/3      
    inc     ram_DE                  ;5        
    lda     ram_DE                  ;3        
    ror                             ;2        
    and     #$07                    ;2        
    clc                             ;2        
    adc     #$09                    ;2        
    cmp     #$0c                    ;2        
    bne     Lf8c9                   ;2/3      
    lda     #$e0                    ;2        
    sta     ram_CA                  ;3        
    lda     #$3f                    ;2        
    sta     ram_DE                  ;3        
    lda     #$1d                    ;2        
    sta     ram_C9                  ;3        
    lda     #$29                    ;2        
    sta     ram_DF                  ;3        
    lda     ram_BC                  ;3        
    and     #$f0                    ;2        
    sec                             ;2        
    sbc     #$10                    ;2        
    tay                             ;2        
    and     #$f0                    ;2        
    bne     Lf8a7                   ;2/3      
    tay                             ;2   =  69
Lf8a7
    sty     ram_BC                  ;3        
    lda     #$0c                    ;2        
    bpl     Lf8c9                   ;2/3 =   7
Lf8ad
    bit     ram_C8                  ;3        
    bvc     Lf8b9                   ;2/3      
    lda     #$00                    ;2         *
    sta     ram_F4                  ;3         *
    lda     #$bc                    ;2         *
    bne     Lf8d3                   ;2/3 =  14 *
Lf8b9
    lda     ram_BC                  ;3        
    and     #$0f                    ;2        
    cmp     #$08                    ;2        
    bcc     Lf8c9                   ;2/3      
    ldx     #$08                    ;2        
    and     #$07                    ;2        
    eor     #$ff                    ;2        
    adc     #$08                    ;2   =  17
Lf8c9
    stx     ram_F4                  ;3        
    sta     ram_F5                  ;3        
    asl                             ;2        
    adc     ram_F5                  ;3        
    asl                             ;2        
    adc     #$74                    ;2   =  15
Lf8d3
    sta     ram_F1                  ;3   =   3
Lf8d5
    lda     ram_CA                  ;3        
    cmp     #$e0                    ;2        
    bne     Lf8e3                   ;2/3      
    sta     ram_EF                  ;3        
    lda     #$79                    ;2        
    sta     ram_ED                  ;3        
    bne     Lf921                   ;2/3!=  17
Lf8e3
    lda     ram_CA                  ;3        
    bmi     Lf8fc                   ;2/3 =   5
Lf8e7
    sta     ram_EF                  ;3        
    sec                             ;2        
    sbc     #$54                    ;2        
    bcc     Lf8f6                   ;2/3      
    clc                             ;2         *
    adc     #$fb                    ;2         *
    sta     ram_CA                  ;3         *
    jmp     Lf8d5                   ;3   =  19 *
    
Lf8f6
    lda     #$79                    ;2        
    sta     ram_ED                  ;3        
    bne     Lf917                   ;2/3!=   7
Lf8fc
    cmp     #$fb                    ;2         *
    bcs     Lf909                   ;2/3       *
    lda     #$59                    ;2         *
    clc                             ;2         *
    adc     ram_CA                  ;3         *
    sta     ram_CA                  ;3         *
    bne     Lf8e7                   ;2/3!=  16 *
Lf909
    eor     #$ff                    ;2         *
    sec                             ;2         *
    adc     ram_F1                  ;3         *
    sta     ram_ED                  ;3         *
    lda     #$59                    ;2         *
    clc                             ;2         *
    adc     ram_CA                  ;3         *
    sta     ram_EF                  ;3   =  20 *
Lf917
    lda     ram_CC                  ;3        
    rol                             ;2        
    rol                             ;2        
    and     #$01                    ;2        
    ora     ram_F4                  ;3        
    sta     ram_EB                  ;3   =  15
Lf921
    ldx     #$40                    ;2        
    stx     ram_F6                  ;3        
    ldx     #$02                    ;2   =   7
Lf927
    lda     ram_D9,x                ;4        
    bne     Lf946                   ;2/3 =   6
Lf92b
    ldy     #$e0                    ;2        
    lda     ram_C9                  ;3        
    cpx     #$02                    ;2        
    bne     Lf935                   ;2/3      
    lda     ram_D1                  ;3   =  12
Lf935
    sty     ram_D6,x                ;4        
    sta     ram_D3,x                ;4        
    stx     ram_F5                  ;3        
    ldx     ram_F6                  ;3        
    clc                             ;2        
    lda     #$02                    ;2        
    jsr     Lfac2                   ;6        
    jmp     Lf9aa                   ;3   =  27
    
Lf946
    lda     ram_B9                  ;3        
    ror                             ;2        
    ror                             ;2        
    bcs     Lf95b                   ;2/3      
    lda     ram_D9,x                ;4        
    sec                             ;2        
    sbc     #$10                    ;2        
    sta     ram_D9,x                ;4        
    and     #$f0                    ;2        
    bne     Lf95b                   ;2/3      
    sta     ram_D9,x                ;4        
    beq     Lf92b                   ;2/3 =  31
Lf95b
    lda     ram_D9,x                ;4        
    and     #$0f                    ;2        
    tay                             ;2        
    lda     ram_CE                  ;3        
    php                             ;3        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    plp                             ;4        
    bpl     Lf96f                   ;2/3      
    ora     #$f0                    ;2         *
    clc                             ;2         *
    adc     #$01                    ;2   =  34 *
Lf96f
    clc                             ;2        
    adc     Lff77,y                 ;4        
    clc                             ;2        
    adc     ram_D6,x                ;4        
    sta     ram_D6,x                ;4        
    bpl     Lf97f                   ;2/3      
    clc                             ;2         *
    adc     #$59                    ;2         *
    bpl     Lf984                   ;2/3 =  24 *
Lf97f
    sec                             ;2        
    sbc     #$59                    ;2        
    bcc     Lf986                   ;2/3 =   6
Lf984
    sta     ram_D6,x                ;4   =   4 *
Lf986
    lda     ram_CD                  ;3        
    php                             ;3        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    plp                             ;4        
    bpl     Lf995                   ;2/3      
    ora     #$f0                    ;2        
    clc                             ;2        
    adc     #$01                    ;2   =  26
Lf995
    stx     ram_F5                  ;3        
    ldx     ram_F6                  ;3        
    clc                             ;2        
    adc     Lff87,y                 ;4        
    sec                             ;2        
    bpl     Lf9a5                   ;2/3      
    eor     #$ff                    ;2        
    adc     #$01                    ;2        
    clc                             ;2   =  22
Lf9a5
    beq     Lf9aa                   ;2/3      
    jsr     Lfac2                   ;6   =   8
Lf9aa
    txa                             ;2        
    sec                             ;2        
    sbc     #$3e                    ;2        
    tay                             ;2        
    lda     ram_95,x                ;4        
    sta     WSYNC                   ;3   =  15
;---------------------------------------
    sta.wy  HMM0,y                  ;5        
    ror                             ;2        
    and     #$07                    ;2        
    bcs     Lf9c9                   ;2/3      
    ldx     #$06                    ;2   =  13
Lf9bd
    dex                             ;2        
    bne     Lf9bd                   ;2/3      
    nop                             ;2        
    tax                             ;2   =   8
Lf9c2
    dex                             ;2        
    bne     Lf9c2                   ;2/3      
    stx     RESM0,y                 ;4        
    beq     Lf9cc                   ;2/3 =  10
Lf9c9
    tax                             ;2        
    bcs     Lf9c2                   ;2/3 =   4
Lf9cc
    dec     ram_F6                  ;5        
    dec     ram_F5                  ;5        
    ldx     ram_F5                  ;3        
    bmi     Lf9d7                   ;2/3      
    jmp     Lf927                   ;3   =  18
    
Lf9d7
    jmp     Lff97                   ;3   =   3
    
Start
    sei                             ;2        
    cld                             ;2        
    ldx     #$ff                    ;2        
    txs                             ;2        
    inx                             ;2        
    txa                             ;2   =  12
Lf9e1
    sta     VSYNC,x                 ;4        
    inx                             ;2        
    bne     Lf9e1                   ;2/3      
    lda     #$e0                    ;2        
    sta     ram_CA                  ;3        
    lda     #$34                    ;2        
    sta     ram_82                  ;3        
    sta     ram_81                  ;3        
    lda     #$40                    ;2        
    sta     ram_C7                  ;3        
    lda     #$01                    ;2        
    sta     ram_C8                  ;3        
    lda     #$00                    ;2        
    sta     ram_F7                  ;3        
    lda     #$db                    ;2        
    sta     ram_F8                  ;3        
    jmp     Lfff0                   ;3   =  44
    
Lfa03
    lda     #$08                    ;2        
    sta     ram_C7                  ;3        
    sta     ram_C4                  ;3        
    lda     #$fe                    ;2        
    sta     ram_F0                  ;3        
    sta     ram_F2                  ;3        
    lda     #$ff                    ;2        
    sta     ram_EC                  ;3        
    sta     ram_EE                  ;3        
    lda     #$f0                    ;2        
    sta     ram_E4                  ;3        
    lda     #$f1                    ;2        
    sta     ram_E6                  ;3        
    jsr     Lfdf3                   ;6        
    lda     #$73                    ;2        
    sta     ram_BB                  ;3        
    lda     #$cf                    ;2        
    sta     ram_E5                  ;3        
    lda     #$e0                    ;2        
    sta     ram_D8                  ;3        
    sta     ram_D2                  ;3        
    lda     #$1d                    ;2        
    sta     ram_C9                  ;3        
    lda     #$c6                    ;2        
    sta     ram_D1                  ;3        
    sta     ram_C2                  ;3        
    jmp     Lf316                   ;3   =  74
    
Lfa3b
    lda     ram_A7,x                ;4        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    sta     ram_F5                  ;3        
    lda     ram_80                  ;3        
    bmi     Lfa5e                   ;2/3      
    and     #$01                    ;2        
    bne     Lfa51                   ;2/3      
    lda     ram_F5                  ;3        
    and     #$07                    ;2        
    bpl     Lfa53                   ;2/3 =  31
Lfa51
    lda     ram_F5                  ;3   =   3 *
Lfa53
    tay                             ;2        
    lda     Lfee6,y                 ;4        
    beq     Lfa62                   ;2/3 =   8
Lfa59
    bit     ram_EC                  ;3        
    bne     Lfa62                   ;2/3      
    rts                             ;6   =  11
    
Lfa5e
    lda     #$80                    ;2         *
    bne     Lfa59                   ;2/3 =   4 *
Lfa62
    bcs     Lfa80                   ;2/3      
    lda     #$f0                    ;2        
    adc     ram_95,x                ;4        
    cmp     #$93                    ;2        
    bne     Lfa70                   ;2/3      
    lda     #$65                    ;2        
    bne     Lfa9a                   ;2/3 =  16
Lfa70
    cmp     #$70                    ;2        
    bcc     Lfa9a                   ;2/3      
    cmp     #$80                    ;2        
    bcs     Lfa9a                   ;2/3      
    and     #$0f                    ;2        
    tay                             ;2        
    lda     Lfef4,y                 ;4        
    bne     Lfa9a                   ;2/3 =  18
Lfa80
    lda     #$0f                    ;2        
    adc     ram_95,x                ;4        
    cmp     #$42                    ;2        
    bne     Lfa8c                   ;2/3      
    lda     #$8d                    ;2        
    bne     Lfa9a                   ;2/3 =  14
Lfa8c
    cmp     #$70                    ;2        
    bcc     Lfa9a                   ;2/3      
    cmp     #$80                    ;2        
    bcs     Lfa9a                   ;2/3      
    and     #$0f                    ;2        
    tay                             ;2        
    lda     Lfeff,y                 ;4   =  16
Lfa9a
    sta     ram_95,x                ;4        
    rts                             ;6   =  10
    
Lfa9d
    lda     ram_82                  ;3        
    and     #$07                    ;2        
    tay                             ;2        
    lda     ram_82                  ;3        
    and     #$f0                    ;2        
    cmp     #$70                    ;2        
    bcc     Lfab0                   ;2/3      
    cmp     #$80                    ;2        
    bcs     Lfab0                   ;2/3      
    lda     #$80                    ;2   =  22
Lfab0
    ora     Lff0d,y                 ;4        
    cmp     #$42                    ;2        
    bne     Lfac1                   ;2/3      
    cmp     #$52                    ;2         *
    bne     Lfac1                   ;2/3       *
    cmp     #$62                    ;2         *
    bne     Lfac1                   ;2/3       *
    lda     #$8d                    ;2   =  18 *
Lfac1
    rts                             ;6   =   6
    
Lfac2
    ldy     #$d6                    ;2        
    sty     ram_F8                  ;3        
    ldy     #$00                    ;2        
    sty     ram_F7                  ;3        
    jmp     Lfff0                   ;3   =  13
    
    rts                             ;6   =   6
    
Lface
    ldx     #$02                    ;2   =   2 *
Lfad0
    ldy     ram_BC,x                ;4         *
    lda     ram_BF,x                ;4         *
    sty     ram_BF,x                ;4         *
    sta     ram_BC,x                ;4         *
    dex                             ;2         *
    bpl     Lfad0                   ;2/3       *
    lda     ram_C7                  ;3         *
    eor     #$80                    ;2         *
    sta     ram_C7                  ;3         *
    rts                             ;6   =  34 *
    
Lfae2
    lda     ram_81                  ;3        
    asl                             ;2        
    eor     ram_81                  ;3        
    asl                             ;2        
    asl                             ;2        
    rol     ram_82                  ;5        
    rol     ram_81                  ;5        
    lda     ram_82                  ;3        
    rts                             ;6   =  31
    
Lfaf0
    stx     ram_F6                  ;3        
    clc                             ;2        
    adc     #$11                    ;2        
    sta     ram_F5                  ;3        
    clc                             ;2        
    adc     Lff33,x                 ;4        
    sta     ram_E2                  ;3        
    tya                             ;2        
    jsr     Lfcca                   ;6        
    sta     ram_F4                  ;3        
    ldx     #$00                    ;2   =  32
Lfb05
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    beq     Lfb53                   ;2/3      
    tay                             ;2        
    clc                             ;2        
    adc     #$11                    ;2        
    bmi     Lfb1b                   ;2/3      
    cmp     ram_E2                  ;3        
    bcs     Lfb39                   ;2/3      
    adc     #$0f                    ;2        
    cmp     ram_F5                  ;3        
    bcc     Lfb39                   ;2/3 =  28
Lfb1b
    lda     ram_A7,x                ;4        
    rol                             ;2        
    rol                             ;2        
    bcs     Lfb39                   ;2/3      
    rol                             ;2        
    rol                             ;2        
    rol                             ;2        
    and     #$07                    ;2        
    sta     ram_F2                  ;3        
    tya                             ;2        
    clc                             ;2        
    adc     #$03                    ;2        
    ldy     ram_95,x                ;4        
    stx     ram_F1                  ;3        
    ldx     ram_F2                  ;3        
    jsr     Lfba9                   ;6        
    bcs     Lfb3c                   ;2/3      
    ldx     ram_F1                  ;3   =  48
Lfb39
    inx                             ;2        
    bne     Lfb05                   ;2/3 =   4
Lfb3c
    lda     ram_83                  ;3        
    bpl     Lfb52                   ;2/3      
    ldx     ram_DC                  ;3        
    lda     ram_A7                  ;3        
    ora     ram_A7,x                ;4        
    and     #$40                    ;2        
    beq     Lfb52                   ;2/3      
    lda     ram_A7                  ;3         *
    ora     #$44                    ;2         *
    sta     ram_A7                  ;3         *
    sta     ram_A7,x                ;4   =  31 *
Lfb52
    rts                             ;6   =   6
    
Lfb53
    ldx     #$09                    ;2   =   2
Lfb55
    lda     ram_83,x                ;4        
    cmp     #$e0                    ;2        
    beq     Lfb8c                   ;2/3      
    tay                             ;2        
    clc                             ;2        
    adc     #$11                    ;2        
    bmi     Lfb6b                   ;2/3      
    cmp     ram_E2                  ;3        
    bcs     Lfb89                   ;2/3      
    adc     #$0f                    ;2        
    cmp     ram_F5                  ;3        
    bcc     Lfb89                   ;2/3 =  28
Lfb6b
    lda     ram_A7,x                ;4        
    rol                             ;2        
    rol                             ;2        
    bcs     Lfb89                   ;2/3      
    rol                             ;2        
    rol                             ;2        
    rol                             ;2        
    and     #$07                    ;2        
    sta     ram_F2                  ;3        
    tya                             ;2        
    clc                             ;2        
    adc     #$03                    ;2        
    ldy     ram_95,x                ;4        
    stx     ram_F1                  ;3        
    ldx     ram_F2                  ;3        
    jsr     Lfba9                   ;6        
    bcs     Lfb8c                   ;2/3      
    ldx     ram_F1                  ;3   =  48
Lfb89
    inx                             ;2        
    bne     Lfb55                   ;2/3 =   4
Lfb8c
    ldy     #$09                    ;2        
    lda.wy  ram_83,y                ;4        
    bpl     Lfba8                   ;2/3      
    ldx     ram_DD                  ;3        
    lda     ram_A7,x                ;4        
    ora.wy  ram_A7,y                ;4        
    and     #$40                    ;2        
    beq     Lfba8                   ;2/3      
    lda.wy  ram_A7,y                ;4         *
    ora     #$44                    ;2         *
    sta     ram_A7,x                ;4         *
    sta.wy  ram_A7,y                ;5   =  38 *
Lfba8
    rts                             ;6   =   6
    
Lfba9
    stx     ram_F3                  ;3        
    sty     ram_F7                  ;3        
    clc                             ;2        
    adc     #$11                    ;2        
    sta     ram_F8                  ;3        
    cmp     ram_F5                  ;3        
    bcc     Lfbc3                   ;2/3      
    lda     ram_F5                  ;3        
    ldx     ram_F6                  ;3        
    adc     Lff33,x                 ;4        
    sec                             ;2        
    sbc     ram_F8                  ;3        
    bcs     Lfbcc                   ;2/3 =  35
Lfbc2
    rts                             ;6   =   6
    
Lfbc3
    clc                             ;2        
    adc     Lff33,x                 ;4        
    sec                             ;2        
    sbc     ram_F5                  ;3        
    bcc     Lfbc2                   ;2/3 =  13
Lfbcc
    lda     ram_F7                  ;3        
    jsr     Lfcca                   ;6        
    sta     ram_F7                  ;3        
    ldx     ram_F3                  ;3        
    cmp     ram_F4                  ;3        
    bcc     Lfbe6                   ;2/3      
    lda     ram_F4                  ;3        
    ldx     ram_F6                  ;3        
    adc     Lff3e,x                 ;4        
    sec                             ;2        
    sbc     ram_F7                  ;3        
    bcs     Lfbef                   ;2/3      
    rts                             ;6   =  43
    
Lfbe6
    clc                             ;2        
    adc     Lff3e,x                 ;4        
    sec                             ;2        
    sbc     ram_F4                  ;3        
    bcc     Lfbc2                   ;2/3 =  13
Lfbef
    ldx     ram_F6                  ;3        
    cpx     #$0a                    ;2        
    bne     Lfbf8                   ;2/3      
    jmp     Lfcc4                   ;3   =  10 *
    
Lfbf8
    cpx     #$05                    ;2        
    beq     Lfc0a                   ;2/3!     
    cpx     #$06                    ;2        
    beq     Lfc0a                   ;2/3      
    ldy     ram_F3                  ;3        
    cpy     #$05                    ;2        
    beq     Lfc0a                   ;2/3      
    cpy     #$06                    ;2        
    bne     Lfc1b                   ;2/3 =  19
Lfc0a
    lda     ram_C7                  ;3         *
    and     #$08                    ;2         *
    beq     Lfc11                   ;2/3 =   7 *
Lfc10
    rts                             ;6   =   6 *
    
Lfc11
    lda     ram_C7                  ;3         *
    ora     #$08                    ;2         *
    sta     ram_C7                  ;3         *
    lda     #$00                    ;2         *
    sta     ram_C6                  ;3   =  13 *
Lfc1b
    cpx     #$04                    ;2        
    beq     Lfc29                   ;2/3      
    cpx     #$09                    ;2        
    bne     Lfc37                   ;2/3      
    lda     ram_F3                  ;3         *
    cmp     #$04                    ;2         *
    bne     Lfc37                   ;2/3 =  15 *
Lfc29
    lda     ram_DE                  ;3        
    bmi     Lfc10                   ;2/3      
    lda     ram_C8                  ;3        
    ora     #$02                    ;2        
    sta     ram_C8                  ;3        
    lda     #$80                    ;2        
    sta     ram_DE                  ;3   =  18
Lfc37
    lda     ram_C5                  ;3        
    ora     #$01                    ;2        
    and     #$fd                    ;2        
    sta     ram_C5                  ;3        
    lda     #$0f                    ;2        
    sta     ram_C3                  ;3        
    ldy     ram_F3                  ;3        
    cpy     #$04                    ;2        
    bcs     Lfc55                   ;2/3      
    ldy     ram_F1                  ;3        
    lda.wy  ram_A7,y                ;4        
    ora     #$44                    ;2        
    sta.wy  ram_A7,y                ;5        
    sta     ram_C2                  ;3   =  39
Lfc55
    cpx     #$07                    ;2        
    bpl     Lfc61                   ;2/3      
    ldy     ram_F3                  ;3        
    cpy     #$09                    ;2        
    bne     Lfc65                   ;2/3      
    ldx     #$09                    ;2   =  13 *
Lfc61
    lda     #$00                    ;2        
    sta     ram_D2,x                ;4   =   6
Lfc65
    cpx     #$09                    ;2        
    beq     Lfcc1                   ;2/3      
    cpx     #$05                    ;2        
    beq     Lfcc1                   ;2/3      
    cpx     #$06                    ;2        
    beq     Lfcc1                   ;2/3      
    ldy     ram_F3                  ;3        
    clc                             ;2        
    sed                             ;2        
    lda     ram_BE                  ;3        
    adc     Lff49,y                 ;4        
    sta     ram_BE                  ;3        
    lda     Lff50,y                 ;4        
    bcs     Lfc83                   ;2/3      
    beq     Lfcc1                   ;2/3 =  37
Lfc83
    adc     ram_BD                  ;3         *
    sta     ram_BD                  ;3         *
    cld                             ;2         *
    tay                             ;2         *
    lda     ram_80                  ;3         *
    and     #$06                    ;2         *
    beq     Lfca0                   ;2/3       *
    cmp     #$06                    ;2         *
    beq     Lfcc1                   ;2/3       *
    ror                             ;2         *
    ror                             ;2         *
    tya                             ;2         *
    and     #$1f                    ;2         *
    bcc     Lfc9c                   ;2/3       *
    and     #$0f                    ;2   =  33 *
Lfc9c
    bne     Lfcc1                   ;2/3       *
    beq     Lfca9                   ;2/3 =   4 *
Lfca0
    tya                             ;2         *
    and     #$0f                    ;2         *
    beq     Lfca9                   ;2/3       *
    cmp     #$05                    ;2         *
    bne     Lfcc1                   ;2/3 =  10 *
Lfca9
    lda     ram_BC                  ;3         *
    clc                             ;2         *
    adc     #$10                    ;2         *
    tay                             ;2         *
    and     #$f0                    ;2         *
    cmp     #$a0                    ;2         *
    beq     Lfcc1                   ;2/3       *
    sty     ram_BC                  ;3         *
    lda     ram_C5                  ;3         *
    ora     #$04                    ;2         *
    sta     ram_C5                  ;3         *
    lda     #$7f                    ;2         *
    sta     ram_C4                  ;3   =  31 *
Lfcc1
    cld                             ;2        
    sec                             ;2        
    rts                             ;6   =  10
    
Lfcc4
    stx     ram_C2                  ;3         *
    pla                             ;4         *
    pla                             ;4         *
    sec                             ;2         *
    rts                             ;6   =  19 *
    
Lfcca
    tax                             ;2        
    and     #$0f                    ;2        
    tay                             ;2        
    txa                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    tax                             ;2        
    lda     Lff15,x                 ;4        
    clc                             ;2        
    adc     Lff25,y                 ;4        
    rts                             ;6   =  34
    
Lfcdc
    ldx     #$06                    ;2         *
    lda     ram_C7                  ;3         *
    and     #$20                    ;2         *
    beq     Lfce5                   ;2/3       *
    dex                             ;2   =  11 *
Lfce5
    tya                             ;2         *
    rts                             ;6   =   8 *
    
Lfce7
    stx     ram_F4                  ;3   =   3
Lfce9
    lda     ram_83,x                ;4        
    bpl     Lfcf4                   ;2/3      
    cmp     #$e0                    ;2        
    bne     Lfcf4                   ;2/3      
    ldx     ram_F5                  ;3        
    rts                             ;6   =  19
    
Lfcf4
    lda     ram_A7,x                ;4        
    tay                             ;2        
    and     #$40                    ;2        
    bne     Lfd09                   ;2/3!=  10
Lfcfb
    inx                             ;2        
    bpl     Lfce9                   ;2/3 =   4
Lfcfe
    stx     ram_F6                  ;3         *
    jsr     Lfde1                   ;6         *
    dec     ram_F5                  ;5         *
    ldx     ram_F6                  ;3         *
    bpl     Lfce9                   ;2/3!=  19 *
Lfd09
    lda     ram_83,x                ;4        
    bmi     Lfcfe                   ;2/3!     
    tya                             ;2        
    and     #$30                    ;2        
    beq     Lfd1d                   ;2/3      
    cmp     #$20                    ;2        
    bne     Lfd19                   ;2/3      
    jmp     Lfdc2                   ;3   =  19
    
Lfd19
    cmp     #$30                    ;2         *
    beq     Lfcfe                   ;2/3!=   4 *
Lfd1d
    jsr     Lfae2                   ;6        
    and     #$8f                    ;2        
    ora     #$20                    ;2        
    sta     ram_A7,x                ;4        
    lda     ram_83,x                ;4        
    cmp     #$53                    ;2        
    bcc     Lfd39                   ;2/3      
    jsr     Lfe74                   ;6         *
    lda.wy  ram_83,y                ;4         *
    sec                             ;2         *
    sbc     #$59                    ;2         *
    sta     ram_83,x                ;4         *
    inc     ram_F5                  ;5   =  45 *
Lfd39
    bit     ram_80                  ;3        
    bmi     Lfcfb                   ;2/3!     
    jsr     Lfe9d                   ;6        
    bcs     Lfcfb                   ;2/3!     
    lda     ram_83,x                ;4        
    bmi     Lfd75                   ;2/3      
    cmp     #$4f                    ;2        
    bcc     Lfd75                   ;2/3      
    jsr     Lfe74                   ;6         *
    lda     ram_A7,x                ;4         *
    and     #$08                    ;2         *
    sta     ram_F7                  ;3         *
    jsr     Lfae2                   ;6         *
    and     #$87                    ;2         *
    ora     #$20                    ;2         *
    ora     ram_F7                  ;3         *
    eor     #$08                    ;2         *
    sta     ram_A7,x                ;4         *
    lda.wy  ram_95,y                ;4         *
    sta     ram_95,x                ;4         *
    lda.wy  ram_83,y                ;4         *
    clc                             ;2         *
    adc     #$0a                    ;2         *
    sec                             ;2         *
    sbc     #$59                    ;2         *
    sta     ram_83,x                ;4         *
    inc     ram_F5                  ;5         *
    jmp     Lfcfb                   ;3   =  89 *
    
Lfd75
    lda     ram_F4                  ;3        
    sta     ram_F7                  ;3        
    stx     ram_F4                  ;3        
    ldx     ram_F5                  ;3        
    jsr     Lfe89                   ;6        
    ldx     ram_F4                  ;3        
    inx                             ;2        
    lda     ram_F7                  ;3        
    sta     ram_F4                  ;3        
    inc     ram_F5                  ;5        
    lda     ram_A7,x                ;4        
    and     #$08                    ;2        
    sta     ram_F7                  ;3        
    jsr     Lfae2                   ;6        
    and     #$87                    ;2        
    ora     #$20                    ;2        
    ora     ram_F7                  ;3        
    eor     #$08                    ;2        
    sta     ram_A7,x                ;4        
    lda     ram_94,x                ;4        
    sta     ram_95,x                ;4        
    lda     ram_82,x                ;4        
    clc                             ;2        
    adc     #$0a                    ;2        
    cmp     #$59                    ;2        
    sta     ram_83,x                ;4        
    bcs     Lfdb2                   ;2/3      
    cmp     #$53                    ;2        
    bcs     Lfdb2                   ;2/3      
    jmp     Lfcfb                   ;3   =  93
    
Lfdb2
    jsr     Lfe74                   ;6         *
    lda.wy  ram_83,y                ;4         *
    sec                             ;2         *
    sbc     #$59                    ;2         *
    sta     ram_83,x                ;4         *
    inc     ram_F5                  ;5         *
    jmp     Lfcfb                   ;3   =  26 *
    
Lfdc2
    jsr     Lfae2                   ;6        
    and     #$8f                    ;2        
    ora     #$30                    ;2        
    sta     ram_A7,x                ;4        
    lda     ram_83,x                ;4        
    cmp     #$56                    ;2        
    bcc     Lfdde                   ;2/3      
    jsr     Lfe74                   ;6         *
    lda.wy  ram_83,y                ;4         *
    sec                             ;2         *
    sbc     #$59                    ;2         *
    sta     ram_83,x                ;4         *
    inc     ram_F5                  ;5   =  45 *
Lfdde
    jmp     Lfcfb                   ;3   =   3
    
Lfde1
    lda     ram_96,x                ;4        
    sta     ram_95,x                ;4        
    lda     ram_A8,x                ;4        
    sta     ram_A7,x                ;4        
    lda     ram_84,x                ;4        
    sta     ram_83,x                ;4        
    inx                             ;2        
    cmp     #$e0                    ;2        
    bne     Lfde1                   ;2/3      
    rts                             ;6   =  36
    
Lfdf3
    lda     #$00                    ;2        
    bit     ram_80                  ;3        
    bmi     Lfe05                   ;2/3!     
    ldx     ram_BD                  ;3        
    beq     Lfe05                   ;2/3!     
    ora     #$40                    ;2         *
    cpx     #$15                    ;2         *
    bcc     Lfe05                   ;2/3       *
    ora     #$80                    ;2   =  20 *
Lfe05
    sta     ram_F4                  ;3        
    ldx     #$00                    ;2        
    jsr     Lfe16                   ;6        
    stx     ram_DC                  ;3        
    ldx     #$09                    ;2        
    jsr     Lfe16                   ;6        
    stx     ram_DD                  ;3        
    rts                             ;6   =  31
    
Lfe16
    lda     #$01                    ;2        
    sta     ram_83,x                ;4        
    jsr     Lfa9d                   ;6        
    sta     ram_95,x                ;4        
    jsr     Lfae2                   ;6        
    and     #$1f                    ;2        
    sta     ram_A7,x                ;4        
    inx                             ;2        
    bit     ram_F4                  ;3        
    bvc     Lfe5f                   ;2/3      
    bmi     Lfe35                   ;2/3       *
    lda     #$15                    ;2         *
    cpx     #$09                    ;2         *
    bcs     Lfe4c                   ;2/3       *
    bcc     Lfe4a                   ;2/3 =  45 *
Lfe35
    lda     #$15                    ;2         *
    sta     ram_83,x                ;4         *
    jsr     Lfae2                   ;6         *
    and     #$e0                    ;2         *
    ora     #$0a                    ;2         *
    sta     ram_95,x                ;4         *
    jsr     Lfae2                   ;6         *
    and     #$1f                    ;2         *
    sta     ram_A7,x                ;4         *
    inx                             ;2   =  34 *
Lfe4a
    lda     #$2a                    ;2   =   2 *
Lfe4c
    sta     ram_83,x                ;4         *
    jsr     Lfae2                   ;6         *
    and     #$e0                    ;2         *
    ora     #$0a                    ;2         *
    sta     ram_95,x                ;4         *
    jsr     Lfae2                   ;6         *
    and     #$1f                    ;2         *
    sta     ram_A7,x                ;4         *
    inx                             ;2   =  32 *
Lfe5f
    lda     #$3f                    ;2        
    sta     ram_83,x                ;4        
    jsr     Lfa9d                   ;6        
    sta     ram_95,x                ;4        
    jsr     Lfae2                   ;6        
    and     #$1f                    ;2        
    sta     ram_A7,x                ;4        
    lda     #$e0                    ;2        
    sta     ram_84,x                ;4        
    rts                             ;6   =  40
    
Lfe74
    stx     ram_F6                  ;3        
    ldx     ram_F5                  ;3        
    jsr     Lfe89                   ;6        
    ldy     ram_F6                  ;3        
    iny                             ;2        
    lda.wy  ram_95,y                ;4        
    sta     ram_95,x                ;4        
    lda.wy  ram_A7,y                ;4        
    sta     ram_A7,x                ;4        
    rts                             ;6   =  39
    
Lfe89
    inx                             ;2   =   2
Lfe8a
    lda     ram_83,x                ;4        
    sta     ram_84,x                ;4        
    lda     ram_95,x                ;4        
    sta     ram_96,x                ;4        
    lda     ram_A7,x                ;4        
    sta     ram_A8,x                ;4        
    dex                             ;2        
    cpx     ram_F4                  ;3        
    bpl     Lfe8a                   ;2/3      
    inx                             ;2        
    rts                             ;6   =  39
    
Lfe9d
    lda     ram_F5                  ;3        
    cmp     #$09                    ;2        
    bcs     Lfea6                   ;2/3      
    cmp     #$06                    ;2        
    rts                             ;6   =  15
    
Lfea6
    cmp     #$0f                    ;2        
    rts                             ;6   =   8
    
Lfea9
    lda     ram_83,x                ;4        
    tay                             ;2        
    cmp     #$e0                    ;2        
    bne     Lfeb1                   ;2/3      
    rts                             ;6   =  16
    
Lfeb1
    lda     ram_95,x                ;4        
    and     #$0f                    ;2        
    cmp     #$0d                    ;2        
    beq     Lfec4                   ;2/3      
    cmp     #$0b                    ;2        
    beq     Lfed2                   ;2/3      
    cmp     #$02                    ;2        
    beq     Lfed2                   ;2/3 =  18
Lfec1
    inx                             ;2        
    bpl     Lfea9                   ;2/3 =   4
Lfec4
    tya                             ;2        
    bmi     Lfec1                   ;2/3      
    cmp     #$08                    ;2        
    bcc     Lfec1                   ;2/3      
    cmp     #$40                    ;2        
    bcs     Lfec1                   ;2/3      
    cmp     #$00                    ;2        
    rts                             ;6   =  20
    
Lfed2
    tya                             ;2        
    cmp     #$18                    ;2        
    bcc     Lfec1                   ;2/3      
    cmp     #$38                    ;2        
    bcs     Lfec1                   ;2/3      
    cmp     #$00                    ;2        
    rts                             ;6   =  18
    
Lfede
    .byte   $60                             ; $fede (D)
    .byte   $70                             ; $fedf (*)
    .byte   $70                             ; $fee0 (D)
    .byte   $b0                             ; $fee1 (*)
    .byte   $90                             ; $fee2 (D)
    .byte   $b0,$70,$70                     ; $fee3 (*)
Lfee6
    .byte   $80,$80,$80,$80                 ; $fee6 (D)
    .byte   $80,$80,$80,$40,$80,$80,$40,$00 ; $feea (*)
    .byte   $80,$80                         ; $fef2 (*)
Lfef4
    .byte   $40,$00                         ; $fef4 (*)
    .byte   $64                             ; $fef6 (D)
    .byte   $00                             ; $fef7 (*)
    .byte   $66,$67,$68,$69,$6a,$6b,$63     ; $fef8 (D)
Lfeff
    .byte   $6d                             ; $feff (D)
    .byte   $00                             ; $ff00 (*)
    .byte   $32,$8a,$82,$a3,$84,$85,$86,$87 ; $ff01 (D)
    .byte   $88,$89                         ; $ff09 (D)
    .byte   $00,$8b                         ; $ff0b (*)
Lff0d
    .byte   $06,$04,$05,$06,$07,$09,$07,$05 ; $ff0d (D)
Lff15
    .byte   $06,$05,$04,$03,$02,$01,$00     ; $ff15 (D)
    .byte   $00                             ; $ff1c (*)
    .byte   $0e,$0d,$0c,$0b,$0a,$09,$08,$07 ; $ff1d (D)
Lff25
    .byte   $00,$00                         ; $ff25 (*)
    .byte   $55,$00,$64,$0d,$73,$1c,$82,$2b ; $ff27 (D)
    .byte   $91,$3a                         ; $ff2f (D)
    .byte   $00                             ; $ff31 (*)
    .byte   $49                             ; $ff32 (D)
Lff33
    .byte   $0e                             ; $ff33 (D)
    .byte   $0e                             ; $ff34 (*)
    .byte   $06,$03,$04                     ; $ff35 (D)
    .byte   $04,$06                         ; $ff38 (*)
    .byte   $02,$02                         ; $ff3a (D)
    .byte   $02,$24                         ; $ff3c (*)
Lff3e
    .byte   $0f                             ; $ff3e (D)
    .byte   $0f                             ; $ff3f (*)
    .byte   $07                             ; $ff40 (D)
    .byte   $03                             ; $ff41 (*)
    .byte   $04                             ; $ff42 (D)
    .byte   $04,$06                         ; $ff43 (*)
    .byte   $02,$02                         ; $ff45 (D)
    .byte   $02,$24                         ; $ff47 (*)
Lff49
    .byte   $02                             ; $ff49 (D)
    .byte   $02                             ; $ff4a (*)
    .byte   $05                             ; $ff4b (D)
    .byte   $10,$00,$00,$20                 ; $ff4c (*)
Lff50
    .byte   $00                             ; $ff50 (D)
    .byte   $00                             ; $ff51 (*)
    .byte   $00                             ; $ff52 (D)
    .byte   $00,$00,$01,$00                 ; $ff53 (*)
Lff57
    .byte   $f1,$f1,$f9,$fc                 ; $ff57 (D)
Lff5b
    .byte   $4b,$4b,$53,$56                 ; $ff5b (D)
Lff5f
    .byte   $60,$c1,$80,$e1                 ; $ff5f (*)
Lff63
    .byte   $c0,$60,$e0,$40                 ; $ff63 (*)
Lff67
    .byte   $81                             ; $ff67 (D)
    .byte   $8b,$a6,$cf                     ; $ff68 (*)
    .byte   $00                             ; $ff6b (D)
    .byte   $31,$5a,$75                     ; $ff6c (*)
    .byte   $7f                             ; $ff6f (D)
    .byte   $75,$5a,$31                     ; $ff70 (*)
    .byte   $00                             ; $ff73 (D)
    .byte   $cf,$a6,$8b                     ; $ff74 (*)
Lff77
    .byte   $fc                             ; $ff77 (D)
    .byte   $fd                             ; $ff78 (*)
    .byte   $fd                             ; $ff79 (D)
    .byte   $ff                             ; $ff7a (*)
    .byte   $00                             ; $ff7b (D)
    .byte   $01,$03,$03,$04,$03,$03,$01     ; $ff7c (*)
    .byte   $00                             ; $ff83 (D)
    .byte   $ff,$fd,$fd                     ; $ff84 (*)
Lff87
    .byte   $00                             ; $ff87 (D)
    .byte   $01                             ; $ff88 (*)
    .byte   $03                             ; $ff89 (D)
    .byte   $03                             ; $ff8a (*)
    .byte   $04                             ; $ff8b (D)
    .byte   $03,$03,$01,$00,$ff,$fd,$fd     ; $ff8c (*)
    .byte   $fc                             ; $ff93 (D)
    .byte   $fd,$fd,$ff                     ; $ff94 (*)
    
Lff97
    lda     #$3c                    ;2        
    sta     ram_F7                  ;3        
    lda     #$d4                    ;2        
    sta     ram_F8                  ;3        
    jmp     Lfff0                   ;3   =  13
    
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffa2 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffaa (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffb2 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffba (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffc2 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffca (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffd2 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffda (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $ffe2 (*)
    .byte   $00,$00,$00,$00,$00,$00         ; $ffea (*)
    
Lfff0
    sta     Lfff8                   ;4        
    jmp.ind (ram_F7)                ;5        
    brk                             ;7   =  16 *
    
    brk                             ;7   =   7 *
    
Lfff8
    .byte   $44                             ; $fff8 (D)
    .byte   $00,$da,$f9                     ; $fff9 (*)
    .byte   $da,$f9,$da                     ; $fffc (D)
    .byte   $f9                             ; $ffff (*)
