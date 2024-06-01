; Disassembly of ~/Downloads/distella-master/Walker.bin
; Disassembled Mon May  1 17:45:54 2023
; Using Stella 6.7
;
; ROM properties name : Walker (1983) (Suntek) (PAL)
; ROM properties MD5  : 7ff53f6922708119e7bf478d7d618c86
; Bankswitch type     : 4K* (4K) 
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

BLACK0           = $00
BLACK1           = $10
YELLOW           = $20
GREEN_YELLOW     = $30
ORANGE           = $40
GREEN            = $50
RED              = $60
CYAN_GREEN       = $70
MAUVE            = $80
CYAN             = $90
VIOLET           = $a0
BLUE_CYAN        = $b0
PURPLE           = $c0
BLUE             = $d0
BLACKE           = $e0
BLACKF           = $f0


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
CXPPMM          = $07  ; (R)
;INPT0          = $08  ; (Ri)
;INPT1          = $09  ; (Ri)
;INPT2          = $0a  ; (Ri)
;INPT3          = $0b  ; (Ri)
INPT4           = $0c  ; (R)
;INPT5          = $0d  ; (Ri)
;$1e            = $0e  ; (Ri)

VSYNC           = $00  ; (W)
VBLANK          = $01  ; (W)
WSYNC           = $02  ; (W)
NUSIZ0          = $04  ; (W)
NUSIZ1          = $05  ; (W)
COLUP0          = $06  ; (W)
COLUP1          = $07  ; (W)
COLUPF          = $08  ; (W)
COLUBK          = $09  ; (W)
CTRLPF          = $0a  ; (W)
REFP0           = $0b  ; (W)
REFP1           = $0c  ; (W)
PF0             = $0d  ; (W)
PF1             = $0e  ; (W)
PF2             = $0f  ; (W)
RESP0           = $10  ; (W)
RESP1           = $11  ; (W)
AUDC0           = $15  ; (W)
AUDC1           = $16  ; (W)
AUDF0           = $17  ; (W)
AUDF1           = $18  ; (W)
AUDV0           = $19  ; (W)
AUDV1           = $1a  ; (W)
GRP0            = $1b  ; (W)
GRP1            = $1c  ; (W)
HMP0            = $20  ; (W)
HMP1            = $21  ; (W)
HMOVE           = $2a  ; (W)
HMCLR           = $2b  ; (W)
CXCLR           = $2c  ; (W)

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
ram_85          = $85
ram_86          = $86
ram_87          = $87
ram_88          = $88
ram_89          = $89
ram_8A          = $8a
ram_8B          = $8b
ram_8C          = $8c
ram_8D          = $8d
ram_8E          = $8e
ram_8F          = $8f
ram_90          = $90
ram_91          = $91
ram_92          = $92
ram_93          = $93
ram_94          = $94
ram_95          = $95
ram_96          = $96
ram_97          = $97
ram_98          = $98
ram_99          = $99
ram_9A          = $9a
ram_9B          = $9b
ram_9C          = $9c
ram_9D          = $9d
ram_9E          = $9e
ram_9F          = $9f
ram_A0          = $a0
ram_A1          = $a1
ram_A2          = $a2
ram_A3          = $a3
ram_A4          = $a4
ram_A5          = $a5
ram_A6          = $a6
ram_A7          = $a7
ram_A8          = $a8
ram_A9          = $a9
ram_AA          = $aa
ram_AB          = $ab
ram_AC          = $ac
ram_AD          = $ad
ram_AE          = $ae
ram_AF          = $af
ram_B0          = $b0
ram_B1          = $b1
ram_B2          = $b2
ram_B3          = $b3
ram_B4          = $b4
ram_B5          = $b5
ram_B6          = $b6
ram_B7          = $b7
ram_B8          = $b8
ram_B9          = $b9
ram_BA          = $ba
ram_BB          = $bb
ram_BC          = $bc
ram_BD          = $bd
ram_BE          = $be
ram_BF          = $bf
ram_C0          = $c0
ram_C1          = $c1
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

;                 $f8  (s)
;                 $f9  (s)
;                 $fa  (s)
;                 $fb  (s)
;                 $fc  (s)
;                 $fd  (s)
;                 $fe  (s)
;                 $ff  (s)


;-----------------------------------------------------------
;      User Defined Labels
;-----------------------------------------------------------

Start           = $f000


;***********************************************************
;      Bank 0
;***********************************************************

    SEG     CODE
    ORG     $f000

Start
    sei                             ;2        
    cld                             ;2        
    lda     #$00                    ;2        
    tax                             ;2   =   8
Lf005
    sta     VSYNC,x                 ;4        
    txs                             ;2        
    inx                             ;2        
    bne     Lf005                   ;2/3      
    lda     #$fe                    ;2        
    sta     ram_9B                  ;3        
    sta     ram_9D                  ;3        
    sta     ram_9F                  ;3        
    sta     ram_A1                  ;3        
    lda     #$08                    ;2        
    sta     ram_97                  ;3        
    lda     #$1f                    ;2        
    sta     ram_98                  ;3        
    lda     #$2f                    ;2        
    sta     ram_99                  ;3   =  39
Lf021
    lda     #$01                    ;2        
    sta     ram_C0                  ;3        
    sta     ram_C1                  ;3        
    lda     #$0f                    ;2        
    sta     ram_D5                  ;3        
    lda     #$0f                    ;2        
    sta     ram_BF                  ;3        
    lda     #$0e                    ;2        
    sta     ram_BE                  ;3        
    lda     #$0c                    ;2        
    sta     ram_BD                  ;3        
    lda     #$0d                    ;2        
    sta     ram_BC                  ;3   =  33
Lf03b
    lda     #$01                    ;2        
    sta     ram_B8                  ;3        
    lda     #$02                    ;2        
    sta     ram_B9                  ;3        
    lda     #$3c                    ;2        
    sta     ram_C5                  ;3        
    lda     #$ff                    ;2        
    sta     ram_B3                  ;3        
    lda     #$84                    ;2        
    sta     ram_B2                  ;3        
    lda     #$ff                    ;2        
    sta     ram_B5                  ;3        
    lda     #$bb                    ;2        
    sta     ram_B4                  ;3        
    lda     #$fd                    ;2        
    sta     ram_B7                  ;3        
    lda     #$9d                    ;2        
    sta     ram_B6                  ;3        
    lda     #$1f                    ;2        
    sta     ram_B0                  ;3        
    sta     ram_BB                  ;3        
    lda     #$ff                    ;2        
    sta     ram_C2                  ;3        
    lda     #$ff                    ;2        
    sta     ram_D2                  ;3        
    sta     ram_D4                  ;3        
    lda     #$00                    ;2        
    sta     AUDV1                   ;3   =  71
Lf073
    sta     CXCLR                   ;3        
    lda     ram_A2                  ;3        
    sta     ram_C7                  ;3        
    lda     ram_A3                  ;3        
    sta     ram_C8                  ;3        
    lda     ram_A4                  ;3        
    sta     ram_C9                  ;3        
    lda     ram_A5                  ;3        
    sta     ram_CA                  ;3        
    lda     #$01                    ;2        
    sta     ram_CB                  ;3        
    sta     ram_CC                  ;3        
    lda     #$07                    ;2        
    sta     ram_D6                  ;3   =  40
Lf08f
    lda     INTIM                   ;4        
    bne     Lf08f                   ;2/3      
    sta     WSYNC                   ;3   =   9
;---------------------------------------
    sta     VBLANK                  ;3        
    jsr     Lf8f0                   ;6        
    ldx     ram_81                  ;3        
    cpx     #$05                    ;2        
    bne     Lf0a4                   ;2/3      
    jmp     Lf34e                   ;3   =  19
    
Lf0a4
    lda     #$01                    ;2        
    sta     CTRLPF                  ;3        
    lda     Lfee6,x                 ;4        
    jsr     Lfa0f                   ;6        
    sta     WSYNC                   ;3   =  18
;---------------------------------------
    lda     Lff09,x                 ;4        
    bit     ram_80                  ;3        
    bne     Lf0bd                   ;2/3      
    lda     Lfeeb,x                 ;4        
    jmp     Lf0c0                   ;3   =  16
    
Lf0bd
    lda     Lfef0,x                 ;4   =   4
Lf0c0
    sta     ram_82                  ;3        
    sta     WSYNC                   ;3   =   6
;---------------------------------------
    lda     Lfef5,x                 ;4        
    sta     ram_86                  ;3        
    lda     Lfefa,x                 ;4        
    sta     ram_8A                  ;3        
    lda     Lfeff,x                 ;4        
    sta     ram_8C                  ;3        
    lda     ram_8D                  ;3        
    sta     ram_8E                  ;3        
    lda     Lff04,x                 ;4        
    jsr     Lf958                   ;6        
    sta     WSYNC                   ;3   =  40
;---------------------------------------
    ldx     ram_81                  ;3        
    ldy     Lfa6c,x                 ;4        
    jsr     Lfa09                   ;6        
    lda     Lfedc,x                 ;4        
    sta     ram_A9                  ;3        
    lda     Lfee1,x                 ;4        
    sta     ram_A8                  ;3        
    jmp.ind (ram_A8)                ;5        
    sta     WSYNC                   ;3   =  35
;---------------------------------------
    lda     #$18                    ;2        
    sta     COLUPF                  ;3        
    ldx     #$06                    ;2   =   7
Lf0fc
    ldy     Lfd56,x                 ;4        
    lda     Lfd5d,x                 ;4        
    sta     WSYNC                   ;3   =  11
;---------------------------------------
    sta     PF0                     ;3        
    lda     Lfd64,x                 ;4        
    sta     PF1                     ;3        
    lda     Lfd6b,x                 ;4        
    sta     PF2                     ;3        
    jsr     Lfa09                   ;6        
    dex                             ;2        
    bpl     Lf0fc                   ;2/3!     
    jmp     Lf1e0                   ;3   =  30
    
    lda     #$08                    ;2        
    sta     COLUPF                  ;3        
    ldy     #$0a                    ;2   =   7
Lf11f
    lda     Lfd72,y                 ;4        
    sta     WSYNC                   ;3   =   7
;---------------------------------------
    sta     COLUBK                  ;3        
    cpy     #$08                    ;2        
    bpl     Lf139                   ;2/3      
    lda     Lfd7d,y                 ;4        
    sta     PF0                     ;3        
    lda     Lfd85,y                 ;4        
    sta     PF1                     ;3        
    lda     Lfd8d,y                 ;4        
    sta     PF2                     ;3   =  28
Lf139
    dey                             ;2        
    bpl     Lf11f                   ;2/3      
    jmp     Lf1e0                   ;3   =   7
    
    ldy     #$0f                    ;2        
    jsr     Lfa09                   ;6        
    lda     #$02                    ;2        
    sta     COLUPF                  ;3        
    ldy     #$07                    ;2   =  15
Lf14a
    lda     Lfd95,y                 ;4        
    sta     WSYNC                   ;3   =   7
;---------------------------------------
    sta     PF1                     ;3        
    dey                             ;2        
    bpl     Lf14a                   ;2/3      
    lda     #$00                    ;2        
    sta     PF1                     ;3        
    lda     #$97                    ;2        
    sta     WSYNC                   ;3   =  17
;---------------------------------------
    sta     COLUBK                  ;3        
    jmp     Lf2e6                   ;3   =   6
    
    lda     #$26                    ;2        
    sta     COLUPF                  ;3        
    ldy     #$07                    ;2   =   7
Lf167
    lda     Lfd7d,y                 ;4        
    sta     WSYNC                   ;3   =   7
;---------------------------------------
    sta     PF0                     ;3        
    lda     Lfd85,y                 ;4        
    sta     PF1                     ;3        
    lda     Lfd8d,y                 ;4        
    sta     PF2                     ;3        
    dey                             ;2        
    bpl     Lf167                   ;2/3      
    ldx     #$02                    ;2        
    jmp     Lf1e2                   ;3   =  26
    
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    lda     #$0a                    ;2        
    sta     COLUPF                  ;3        
    lda     #$00                    ;2        
    sta     ram_AA                  ;3        
    sta     ram_AB                  ;3        
    ldy     #$10                    ;2   =  15
Lf18e
    lda     ram_AA                  ;3        
    sec                             ;2        
    ror                             ;2        
    sta     ram_AA                  ;3        
    sta     WSYNC                   ;3   =  13
;---------------------------------------
    sta     PF2                     ;3        
    lda     ram_AB                  ;3        
    rol                             ;2        
    sta     PF1                     ;3        
    sta     ram_AB                  ;3        
    sta     WSYNC                   ;3   =  17
;---------------------------------------
    cpy     #$0d                    ;2        
    bne     Lf1a9                   ;2/3      
    lda     #$59                    ;2        
    sta     COLUPF                  ;3   =   9
Lf1a9
    dey                             ;2        
    bne     Lf18e                   ;2/3      
    lda     #$b8                    ;2        
    sta     WSYNC                   ;3   =   9
;---------------------------------------
    sta     COLUBK                  ;3        
    jsr     Lf9f7                   ;6        
    ldx     #$04                    ;2        
    jsr     Lf25c                   ;6        
    ldy     #$05                    ;2        
    jsr     Lfa09                   ;6        
    ldx     #$05                    ;2        
    jsr     Lf25c                   ;6        
    lda     #$b8                    ;2        
    sta     WSYNC                   ;3   =  38
;---------------------------------------
    sta     COLUBK                  ;3        
    ldx     #$04                    ;2        
    lda     #$08                    ;2        
    bit     ram_80                  ;3        
    bne     Lf1da                   ;2/3      
    lda     #$46                    ;2        
    jsr     Lf2ae                   ;6        
    jmp     Lf398                   ;3   =  23
    
Lf1da
    jsr     Lf2ab                   ;6        
    jmp     Lf398                   ;3   =   9
    
Lf1e0
    ldx     ram_81                  ;3   =   3
Lf1e2
    lda     Lfa71,x                 ;4        
    sta     WSYNC                   ;3   =   7
;---------------------------------------
    sta     COLUBK                  ;3        
    lda     Lfa74,x                 ;4        
    sta     ram_8E                  ;3        
    lda     Lfa77,x                 ;4        
    sta     ram_8F                  ;3        
    lda     Lfa7a,x                 ;4        
    sta     ram_8A                  ;3        
    lda     Lfa7d,x                 ;4        
    sta     ram_8B                  ;3        
    sta     WSYNC                   ;3   =  34
;---------------------------------------
    lda     Lfa80,x                 ;4        
    sta     ram_82                  ;3        
    lda     Lfa83,x                 ;4        
    sta     ram_83                  ;3        
    lda     Lfa86,x                 ;4        
    sta     ram_86                  ;3        
    lda     Lfa89,x                 ;4        
    sta     ram_87                  ;3        
    lda     Lfa8c,x                 ;4        
    sta     ram_90                  ;3        
    lda     Lfa71,x                 ;4        
    jsr     Lf998                   ;6        
    ldx     ram_81                  ;3        
    bne     Lf224                   ;2/3      
    sta     WSYNC                   ;3   =  53
;---------------------------------------
Lf224
    lda     ram_81                  ;3        
    bne     Lf22b                   ;2/3      
    jmp     Lf298                   ;3   =   8
    
Lf22b
    cmp     #$03                    ;2        
    beq     Lf23c                   ;2/3      
    ldx     #$01                    ;2        
    jsr     Lf25c                   ;6        
    ldx     #$00                    ;2        
    jsr     Lf25c                   ;6        
    jmp     Lf2e6                   ;3   =  23
    
Lf23c
    ldx     #$02                    ;2        
    jsr     Lf25c                   ;6        
    ldx     #$03                    ;2        
    jsr     Lf25c                   ;6        
    ldx     #$03                    ;2        
    lda     #$08                    ;2        
    bit     ram_80                  ;3        
    bne     Lf256                   ;2/3      
    lda     #$00                    ;2        
    jsr     Lf2ae                   ;6        
    jmp     Lf398                   ;3   =  36
    
Lf256
    jsr     Lf2ab                   ;6        
    jmp     Lf398                   ;3   =   9
    
Lf25c
    lda     Lfa95,x                 ;4        
    sta     ram_82                  ;3        
    lda     Lfaa1,x                 ;4        
    sta     ram_84                  ;3        
    lda     Lfa9b,x                 ;4        
    sta     ram_86                  ;3        
    lda     Lfaa7,x                 ;4        
    sta     ram_88                  ;3        
    lda     Lfaad,x                 ;4        
    sta     ram_8A                  ;3        
    lda     Lfab3,x                 ;4        
    sta     ram_8B                  ;3        
    lda     Lfab9,x                 ;4        
    sta     ram_8E                  ;3        
    lda     Lfabf,x                 ;4        
    sta     ram_8F                  ;3        
    lda     Lfa8f,x                 ;4        
    jsr     Lfa0f                   ;6        
    lda     Lfac5,x                 ;4        
    sta     ram_8C                  ;3        
    lda     Lfacb,x                 ;4        
    jsr     Lf972                   ;6        
    sta     WSYNC                   ;3   =  86
;---------------------------------------
    rts                             ;6   =   6
    
Lf298
    lda     #$04                    ;2        
    ldx     #$00                    ;2        
    sta     WSYNC                   ;3   =   7
;---------------------------------------
    sta     COLUBK                  ;3        
    lda     #$02                    ;2        
    bit     ram_80                  ;3        
    bne     Lf2ab                   ;2/3      
    lda     #$0a                    ;2        
    jmp     Lf2ae                   ;3   =  15
    
Lf2ab
    lda     Lfad1,x                 ;4   =   4
Lf2ae
    sta     ram_82                  ;3        
    lda     Lfadb,x                 ;4        
    sta     ram_8A                  ;3        
    lda     Lfae0,x                 ;4        
    sta     ram_8C                  ;3        
    lda     ram_91,x                ;4        
    sta     ram_8E                  ;3        
    lda     Lfae5,x                 ;4        
    sta     ram_86                  ;3        
    lda     Lfad6,x                 ;4        
    jsr     Lfa0f                   ;6        
    lda     Lfaea,x                 ;4        
    stx     ram_A7                  ;3        
    jsr     Lf958                   ;6        
    ldx     ram_A7                  ;3        
    beq     Lf2d6                   ;2/3      
    rts                             ;6   =  65
    
Lf2d6
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    lda     #$1e                    ;2        
    sta     WSYNC                   ;3   =   5
;---------------------------------------
    sta     COLUBK                  ;3        
    sta     WSYNC                   ;3   =   6
;---------------------------------------
    lda     #$04                    ;2        
    sta     WSYNC                   ;3   =   5
;---------------------------------------
    sta     COLUBK                  ;3   =   3
Lf2e6
    ldx     ram_81                  ;3        
    sta     WSYNC                   ;3   =   6
;---------------------------------------
    lda     Lfbf2,x                 ;4        
    jsr     Lfa0f                   ;6        
    lda     ram_98                  ;3        
    sta     ram_82                  ;3        
    lda     ram_99                  ;3        
    sta     ram_84                  ;3        
    lda     Lfc01,x                 ;4        
    sta     ram_86                  ;3        
    sta     ram_88                  ;3        
    sta     WSYNC                   ;3   =  35
;---------------------------------------
    lda     ram_96                  ;3        
    sta     ram_8E                  ;3        
    lda     ram_97                  ;3        
    sta     ram_8F                  ;3        
    lda     #$04                    ;2        
    sta     ram_8A                  ;3        
    sta     ram_8B                  ;3        
    lda     Lfc04,x                 ;4        
    sta     ram_8C                  ;3        
    lda     Lfc07,x                 ;4        
    jsr     Lf972                   ;6        
    ldx     ram_81                  ;3        
    cpx     #$02                    ;2        
    beq     Lf323                   ;2/3      
    jmp     Lf335                   ;3   =  47
    
Lf323
    ldx     #$01                    ;2        
    jsr     Lf2ab                   ;6        
    ldx     #$02                    ;2        
    jsr     Lf2ab                   ;6        
    ldy     #$05                    ;2        
    jsr     Lfa09                   ;6        
    jmp     Lf398                   ;3   =  27
    
Lf335
    txa                             ;2        
    beq     Lf33b                   ;2/3      
    jmp     Lf398                   ;3   =   7
    
Lf33b
    ldy     #$03                    ;2        
    jsr     Lfa09                   ;6        
    lda     #$68                    ;2        
    sta     WSYNC                   ;3   =  13
;---------------------------------------
    sta     COLUBK                  ;3        
    ldy     #$07                    ;2        
    jsr     Lfa09                   ;6        
    jmp     Lf398                   ;3   =  14
    
Lf34e
    lda     #$01                    ;2        
    sta     WSYNC                   ;3   =   5
;---------------------------------------
    sta     COLUBK                  ;3        
    lda     #$00                    ;2        
    sta     CTRLPF                  ;3        
    lda     #$1c                    ;2        
    jsr     Lf9c1                   ;6        
    ldx     ram_C4                  ;3        
    sta     WSYNC                   ;3   =  22
;---------------------------------------
    sta     COLUPF                  ;3        
    lda     Lfdf6,x                 ;4        
    sta     PF0                     ;3        
    lda     Lfdfa,x                 ;4        
    sta     PF1                     ;3        
    lda     Lfdf6,x                 ;4        
    sta     PF2                     ;3        
    ldy     #$27                    ;2        
    jsr     Lfa09                   ;6        
    lda     #$1c                    ;2        
    jsr     Lf9c1                   ;6        
    jsr     Lf9f7                   ;6        
    lda     #$48                    ;2        
    sta     WSYNC                   ;3   =  51
;---------------------------------------
    sta     COLUBK                  ;3        
    ldy     #$0c                    ;2        
    jsr     Lfa09                   ;6        
    ldy     ram_C6                  ;3        
    jsr     Lfa09                   ;6        
    lda     #$28                    ;2        
    sta     WSYNC                   ;3   =  25
;---------------------------------------
    sta     COLUBK                  ;3        
    jmp     Lf39a                   ;3   =   6
    
Lf398
    ldx     ram_81                  ;3   =   3
Lf39a
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    ldx     #$01                    ;2        
    lda     ram_AC                  ;3        
    jsr     Lfa3e                   ;6        
    dex                             ;2        
    stx     NUSIZ0                  ;3        
    stx     REFP1                   ;3        
    lda     ram_AD                  ;3        
    jsr     Lfa3e                   ;6        
    lda     ram_AE                  ;3        
    sta     REFP0                   ;3        
    lda     ram_AF                  ;3        
    sta     NUSIZ1                  ;3        
    ldy     ram_C5                  ;3        
    lda     ram_BB                  ;3        
    sta     ram_B1                  ;3        
    ldx     ram_81                  ;3        
    lda     Lfaef,x                 ;4        
    sta     WSYNC                   ;3   =  59
;---------------------------------------
    sta     HMOVE                   ;3        
    sta     COLUBK                  ;3        
    ldx     #$00                    ;2   =   8
Lf3c8
    cpy     ram_B0                  ;3        
    bcs     Lf3d3                   ;2/3      
    dec     ram_B1                  ;5        
    bmi     Lf3d3                   ;2/3      
    lda     (ram_B2),y              ;5        
    tax                             ;2   =  19
Lf3d3
    lda     ram_81                  ;3        
    beq     Lf3e2                   ;2/3      
    cpy     #$1b                    ;2        
    bcs     Lf3e0                   ;2/3      
    lda     (ram_B6),y              ;5        
    jmp     Lf3e2                   ;3   =  17
    
Lf3e0
    lda     #$00                    ;2   =   2
Lf3e2
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    sta     GRP1                    ;3        
    stx     GRP0                    ;3        
    lda     Lfdd3,y                 ;4        
    sta     COLUP1                  ;3        
    lda     (ram_B4),y              ;5        
    sta     COLUP0                  ;3        
    dey                             ;2        
    bpl     Lf3c8                   ;2/3      
    jsr     Lfa00                   ;6        
    sta     REFP0                   ;3        
    sta     WSYNC                   ;3   =  37
;---------------------------------------
    sta     COLUBK                  ;3        
    lda     ram_BF                  ;3        
    sta     ram_D0                  ;3        
    lda     ram_BE                  ;3        
    sta     ram_C8                  ;3        
    lda     ram_BC                  ;3        
    sta     ram_C9                  ;3        
    lda     ram_BD                  ;3        
    sta     ram_CA                  ;3        
    lda     ram_C0                  ;3        
    sta     ram_CB                  ;3        
    lda     ram_C1                  ;3        
    sta     ram_CC                  ;3        
    lda     ram_D5                  ;3        
    sta     ram_D6                  ;3        
    jsr     Lf8f0                   ;6        
    lda     ram_D5                  ;3        
    cmp     #$07                    ;2        
    bne     Lf427                   ;2/3      
    ldy     #$08                    ;2        
    jsr     Lfa09                   ;6   =  66
Lf427
    lda     #$38                    ;2        
    sta     TIM64T                  ;4   =   6
Lf42c
    lda     INTIM                   ;4        
    bne     Lf42c                   ;2/3      
    ldy     #$82                    ;2        
    sty     WSYNC                   ;3   =  11
;---------------------------------------
    sty     VBLANK                  ;3        
    sty     VSYNC                   ;3        
    sty     WSYNC                   ;3   =   9
;---------------------------------------
    sty     WSYNC                   ;3   =   3
;---------------------------------------
    sty     WSYNC                   ;3   =   3
;---------------------------------------
    sta     VSYNC                   ;3        
    inc     ram_80                  ;5        
    lda     #$30                    ;2        
    sta     TIM64T                  ;4        
    ldy     ram_DA                  ;3        
    lda     Lfa68,y                 ;4        
    sta     AUDC0                   ;3        
    lda     ram_D0                  ;3        
    and     ram_80                  ;3        
    bne     Lf481                   ;2/3      
    dec     ram_CD                  ;5        
    bpl     Lf47d                   ;2/3      
    lda     #$05                    ;2        
    sta     ram_CD                  ;3        
    ldy     ram_CE                  ;3        
    ldx     ram_CF                  ;3        
    cpx     #$0d                    ;2        
    bne     Lf473                   ;2/3      
    ldx     #$00                    ;2        
    stx     ram_CF                  ;3        
    inc     ram_DA                  ;5        
    lda     ram_DA                  ;3        
    cmp     #$04                    ;2        
    bne     Lf473                   ;2/3      
    stx     ram_DA                  ;3   =  74 *
Lf473
    jsr     Lfa22                   ;6        
    sty     ram_CE                  ;3        
    tya                             ;2        
    bne     Lf47d                   ;2/3      
    inc     ram_CF                  ;5   =  18
Lf47d
    lda     ram_CD                  ;3        
    sta     AUDV0                   ;3   =   6
Lf481
    ldx     ram_81                  ;3        
    stx     ram_BA                  ;3        
    inc     ram_BA                  ;5        
    cpx     #$05                    ;2        
    bne     Lf4c9                   ;2/3      
    lda     #$00                    ;2        
    sta     AUDV1                   ;3        
    lda     #$07                    ;2        
    and     ram_80                  ;3        
    bne     Lf4a1                   ;2/3      
    lda     ram_C4                  ;3        
    cmp     #$03                    ;2        
    bne     Lf49f                   ;2/3      
    lda     #$ff                    ;2        
    sta     ram_C4                  ;3   =  39
Lf49f
    inc     ram_C4                  ;5   =   5
Lf4a1
    lda     #$03                    ;2        
    and     ram_80                  ;3        
    bne     Lf4bd                   ;2/3      
    lda     ram_C3                  ;3        
    cmp     #$03                    ;2        
    bne     Lf4b1                   ;2/3      
    lda     #$ff                    ;2        
    sta     ram_C3                  ;3   =  19
Lf4b1
    inc     ram_C3                  ;5        
    lda     ram_C6                  ;3        
    cmp     #$31                    ;2        
    beq     Lf4bd                   ;2/3      
    dec     ram_C6                  ;5        
    inc     ram_C5                  ;5   =  22
Lf4bd
    lda     ram_C6                  ;3        
    cmp     #$31                    ;2        
    bne     Lf4c6                   ;2/3      
    jmp     Lf556                   ;3   =  10
    
Lf4c6
    jmp     Lf073                   ;3   =   3
    
Lf4c9
    lda     ram_80                  ;3        
    and     #$03                    ;2        
    bne     Lf50e                   ;2/3!     
    lda     ram_8D                  ;3        
    jsr     Lf8de                   ;6        
    sta     ram_8D                  ;3        
    cpx     #$02                    ;2        
    beq     Lf4ec                   ;2/3      
    cpx     #$03                    ;2        
    beq     Lf4fd                   ;2/3      
    cpx     #$04                    ;2        
    beq     Lf507                   ;2/3!     
    lda     ram_91                  ;3        
    jsr     Lf8e8                   ;6        
    sta     ram_91                  ;3        
    jmp     Lf50e                   ;3   =  46
    
Lf4ec
    lda     ram_92                  ;3        
    jsr     Lf8de                   ;6        
    sta     ram_92                  ;3        
    lda     ram_93                  ;3        
    jsr     Lf8e8                   ;6        
    sta     ram_93                  ;3        
    jmp     Lf50e                   ;3   =  27
    
Lf4fd
    lda     ram_94                  ;3        
    jsr     Lf8e8                   ;6        
    sta     ram_94                  ;3        
    jmp     Lf50e                   ;3   =  15
    
Lf507
    lda     ram_95                  ;3        
    jsr     Lf8e8                   ;6        
    sta     ram_95                  ;3   =  12
Lf50e
    lda     Lfbec,x                 ;4        
    bit     ram_80                  ;3        
    bne     Lf522                   ;2/3      
    lda     Lfbf5,x                 ;4        
    sta     ram_98                  ;3        
    lda     Lfbf8,x                 ;4        
    sta     ram_99                  ;3        
    jmp     Lf52c                   ;3   =  26
    
Lf522
    lda     Lfbfb,x                 ;4        
    sta     ram_98                  ;3        
    lda     Lfbfe,x                 ;4        
    sta     ram_99                  ;3   =  14
Lf52c
    lda     ram_80                  ;3        
    and     Lfbef,x                 ;4        
    bne     Lf556                   ;2/3      
    cpx     #$02                    ;2        
    beq     Lf548                   ;2/3      
    lda     ram_96                  ;3        
    jsr     Lf8de                   ;6        
    sta     ram_96                  ;3        
    lda     ram_97                  ;3        
    jsr     Lf8de                   ;6        
    sta     ram_97                  ;3        
    jmp     Lf556                   ;3   =  40
    
Lf548
    lda     ram_96                  ;3        
    jsr     Lf8e8                   ;6        
    sta     ram_96                  ;3        
    lda     ram_97                  ;3        
    jsr     Lf8e8                   ;6        
    sta     ram_97                  ;3   =  24
Lf556
    lda     ram_D9                  ;3        
    beq     Lf57b                   ;2/3      
    dec     ram_D7                  ;5        
    bpl     Lf574                   ;2/3      
    ldy     ram_D8                  ;3        
    bne     Lf569                   ;2/3      
    sty     ram_D7                  ;3        
    sty     ram_D9                  ;3        
    jmp     Lf83a                   ;3   =  26
    
Lf569
    lda     #$0a                    ;2        
    sta     ram_D7                  ;3        
    lda     Lff60,y                 ;4        
    sta     AUDF1                   ;3        
    dec     ram_D8                  ;5   =  17
Lf574
    lda     ram_D7                  ;3        
    sta     AUDV1                   ;3        
    jmp     Lf073                   ;3   =   9
    
Lf57b
    lda     #$01                    ;2        
    bit     SWCHB                   ;4        
    bne     Lf588                   ;2/3      
    jsr     Lf5c4                   ;6         *
    jmp     Lf03b                   ;3   =  17 *
    
Lf588
    lda     #$01                    ;2        
    bit     ram_AE                  ;3        
    bne     Lf5ed                   ;2/3      
    lda     #$10                    ;2        
    bit     ram_AE                  ;3        
    beq     Lf5a4                   ;2/3      
    lda     #$80                    ;2        
    bit     INPT4                   ;3        
    bne     Lf59d                   ;2/3      
    jmp     Lf073                   ;3   =  24 *
    
Lf59d
    lda     #$00                    ;2        
    sta     ram_AE                  ;3        
    jmp     Lf073                   ;3   =   8
    
Lf5a4
    lda     #$80                    ;2        
    bit     ram_AE                  ;3        
    bne     Lf5b7                   ;2/3      
    bit     INPT4                   ;3        
    beq     Lf5b1                   ;2/3      
    jmp     Lf073                   ;3   =  15
    
Lf5b1
    jsr     Lfa1d                   ;6        
    jmp     Lf073                   ;3   =   9
    
Lf5b7
    bit     INPT4                   ;3        
    bne     Lf5be                   ;2/3      
    jmp     Lf073                   ;3   =   8
    
Lf5be
    jsr     Lf5c4                   ;6        
    jmp     Lf073                   ;3   =   9
    
Lf5c4
    lda     #$01                    ;2        
    sta     ram_AE                  ;3        
    sta     ram_BD                  ;3        
    lda     #$00                    ;2        
    sta     ram_81                  ;3        
    sta     ram_AD                  ;3        
    sta     ram_A2                  ;3        
    sta     ram_A3                  ;3        
    sta     ram_A5                  ;3        
    sta     ram_A4                  ;3        
    sta     ram_BC                  ;3        
    lda     #$0a                    ;2        
    sta     ram_BE                  ;3        
    lda     #$0b                    ;2        
    sta     ram_BF                  ;3        
    lda     #$03                    ;2        
    sta     ram_C0                  ;3        
    sta     ram_C1                  ;3        
    lda     #$07                    ;2        
    sta     ram_D5                  ;3        
    rts                             ;6   =  60
    
Lf5ed
    lda     #$04                    ;2        
    bit     ram_AE                  ;3        
    beq     Lf5f6                   ;2/3      
    jmp     Lf6e7                   ;3   =  10
    
Lf5f6
    lda     #$02                    ;2        
    bit     ram_AE                  ;3        
    bne     Lf66b                   ;2/3!     
    lda     #$80                    ;2        
    bit     INPT4                   ;3        
    bne     Lf636                   ;2/3      
    lda     #$10                    ;2        
    bit     ram_AE                  ;3        
    bne     Lf63b                   ;2/3      
    lda     #$02                    ;2        
    jsr     Lfa1d                   ;6        
    lda     #$04                    ;2        
    sta     ram_D8                  ;3        
    lda     #$0c                    ;2        
    sta     AUDC1                   ;3        
    lda     ram_B0                  ;3        
    clc                             ;2        
    adc     #$15                    ;2        
    sta     ram_B0                  ;3        
    lda     ram_B2                  ;3        
    clc                             ;2        
    adc     #$03                    ;2        
    sta     ram_B2                  ;3        
    lda     ram_B4                  ;3        
    clc                             ;2        
    adc     #$03                    ;2        
    sta     ram_B4                  ;3        
    lda     #$18                    ;2        
    sta     ram_BB                  ;3        
    lda     #$10                    ;2        
    jsr     Lfa1d                   ;6        
    jmp     Lf765                   ;3   =  85
    
Lf636
    lda     #$ef                    ;2        
    jsr     Lfa18                   ;6   =   8
Lf63b
    lda     #$80                    ;2        
    bit     SWCHA                   ;4        
    bne     Lf64a                   ;2/3      
    lda     #$f7                    ;2        
    jsr     Lfa18                   ;6        
    jmp     Lf659                   ;3   =  19
    
Lf64a
    lda     #$40                    ;2        
    bit     SWCHA                   ;4        
    beq     Lf654                   ;2/3      
    jmp     Lf765                   ;3   =  11
    
Lf654
    lda     #$08                    ;2        
    jsr     Lfa1d                   ;6   =   8
Lf659
    lda     #$04                    ;2        
    jsr     Lfa1d                   ;6        
    inc     ram_D8                  ;5        
    lda     #$0b                    ;2        
    sta     AUDC1                   ;3        
    lda     #$1c                    ;2        
    sta     AUDF1                   ;3        
    jmp     Lf6e7                   ;3   =  26
    
Lf66b
    dec     ram_D7                  ;5        
    dec     ram_D7                  ;5        
    bpl     Lf685                   ;2/3      
    ldy     ram_D8                  ;3        
    bne     Lf67a                   ;2/3      
    sty     ram_D7                  ;3        
    jmp     Lf685                   ;3   =  23
    
Lf67a
    lda     #$0a                    ;2        
    sta     ram_D7                  ;3        
    lda     Lff5b,y                 ;4        
    sta     AUDF1                   ;3        
    dec     ram_D8                  ;5   =  17
Lf685
    lda     ram_D7                  ;3        
    sta     AUDV1                   ;3        
    lda     ram_B0                  ;3        
    cmp     #$3c                    ;2        
    bne     Lf693                   ;2/3      
    lda     #$ff                    ;2        
    sta     ram_B8                  ;3   =  18
Lf693
    lda     #$07                    ;2        
    and     ram_80                  ;3        
    bne     Lf69c                   ;2/3      
    jmp     Lf765                   ;3   =  10
    
Lf69c
    sec                             ;2        
    lda     ram_B2                  ;3        
    sbc     ram_B8                  ;3        
    sta     ram_B2                  ;3        
    sec                             ;2        
    lda     ram_B4                  ;3        
    sbc     ram_B8                  ;3        
    sta     ram_B4                  ;3        
    clc                             ;2        
    lda     ram_B0                  ;3        
    adc     ram_B8                  ;3        
    sta     ram_B0                  ;3        
    cmp     #$1f                    ;2        
    bne     Lf6cd                   ;2/3      
    lda     #$01                    ;2        
    sta     ram_B8                  ;3        
    lda     #$f9                    ;2        
    jsr     Lfa18                   ;6        
    lda     #$84                    ;2        
    sta     ram_B2                  ;3        
    lda     #$bb                    ;2        
    sta     ram_B4                  ;3        
    lda     #$1f                    ;2        
    sta     ram_BB                  ;3        
    jmp     Lf765                   ;3   =  68
    
Lf6cd
    lda     #$08                    ;2        
    bit     ram_AE                  ;3        
    bne     Lf6dd                   ;2/3      
    lda     #$80                    ;2        
    bit     SWCHA                   ;4        
    beq     Lf720                   ;2/3!     
    jmp     Lf765                   ;3   =  18
    
Lf6dd
    lda     #$40                    ;2         *
    bit     SWCHA                   ;4         *
    beq     Lf720                   ;2/3!      *
    jmp     Lf765                   ;3   =  11 *
    
Lf6e7
    lda     ram_D8                  ;3        
    beq     Lf6f4                   ;2/3      
    lda     #$03                    ;2        
    sta     AUDV1                   ;3        
    dec     ram_D8                  ;5        
    jmp     Lf6f6                   ;3   =  18
    
Lf6f4
    sta     AUDV1                   ;3   =   3
Lf6f6
    lda     #$03                    ;2        
    and     ram_80                  ;3        
    beq     Lf6ff                   ;2/3      
    jmp     Lf765                   ;3   =  10
    
Lf6ff
    lda     #$20                    ;2        
    bit     ram_AE                  ;3        
    bne     Lf712                   ;2/3      
    jsr     Lfa1d                   ;6        
    lda     ram_B2                  ;3        
    sec                             ;2        
    sbc     #$1f                    ;2        
    sta     ram_B2                  ;3        
    jmp     Lf720                   ;3   =  26
    
Lf712
    lda     #$db                    ;2        
    jsr     Lfa18                   ;6        
    lda     ram_B2                  ;3        
    clc                             ;2        
    adc     #$1f                    ;2        
    sta     ram_B2                  ;3        
    inc     ram_D8                  ;5   =  23
Lf720
    lda     #$08                    ;2        
    bit     ram_AE                  ;3        
    bne     Lf75f                   ;2/3      
    lda     ram_AD                  ;3        
    cmp     #$97                    ;2        
    bne     Lf75a                   ;2/3      
    inc     ram_81                  ;5        
    sed                             ;2        
    clc                             ;2        
    lda     ram_A3                  ;3        
    adc     ram_BD                  ;3        
    sta     ram_A3                  ;3        
    clc                             ;2        
    lda     ram_A2                  ;3        
    adc     ram_BC                  ;3        
    sta     ram_A2                  ;3        
    lda     #$00                    ;2        
    sta     ram_BC                  ;3        
    lda     #$9d                    ;2        
    sta     ram_B6                  ;3        
    lda     #$00                    ;2        
    sta     AUDV1                   ;3        
    lda     ram_81                  ;3        
    clc                             ;2        
    adc     #$01                    ;2        
    sta     ram_BD                  ;3        
    cld                             ;2        
    lda     #$40                    ;2        
    jsr     Lfa1d                   ;6        
    lda     #$ff                    ;2        
    sta     ram_AD                  ;3   =  83
Lf75a
    inc     ram_AD                  ;5        
    jmp     Lf765                   ;3   =   8
    
Lf75f
    lda     ram_AD                  ;3        
    beq     Lf765                   ;2/3      
    dec     ram_AD                  ;5   =  10
Lf765
    lda     ram_81                  ;3        
    bne     Lf76c                   ;2/3      
    jmp     Lf88b                   ;3   =   8
    
Lf76c
    cmp     #$01                    ;2        
    bne     Lf77b                   ;2/3      
    lda     #$00                    ;2        
    sta     ram_AF                  ;3        
    lda     #$4f                    ;2        
    sta     ram_AC                  ;3        
    jmp     Lf825                   ;3   =  17
    
Lf77b
    cmp     #$02                    ;2        
    bne     Lf78a                   ;2/3      
    lda     #$04                    ;2        
    sta     ram_AF                  ;3        
    lda     #$35                    ;2        
    sta     ram_AC                  ;3        
    jmp     Lf825                   ;3   =  17
    
Lf78a
    cmp     #$03                    ;2        
    bne     Lf799                   ;2/3      
    lda     #$06                    ;2        
    sta     ram_AF                  ;3        
    lda     #$28                    ;2        
    sta     ram_AC                  ;3        
    jmp     Lf825                   ;3   =  17
    
Lf799
    cmp     #$06                    ;2        
    bpl     Lf815                   ;2/3!     
    lda     #$40                    ;2        
    bit     ram_AE                  ;3        
    beq     Lf7e3                   ;2/3      
    sta     CXCLR                   ;3        
    lda     #$bf                    ;2        
    jsr     Lfa18                   ;6        
    lda     ram_81                  ;3        
    cmp     #$04                    ;2        
    beq     Lf7d8                   ;2/3      
    lda     #$04                    ;2        
    sta     ram_AF                  ;3        
    lda     #$00                    ;2        
    sta     ram_C5                  ;3        
    lda     #$6d                    ;2        
    sta     ram_C6                  ;3        
    lda     #$50                    ;2        
    sta     ram_AC                  ;3        
    lda     #$1f                    ;2        
    sta     ram_B0                  ;3        
    sta     ram_BB                  ;3        
    lda     #$84                    ;2        
    sta     ram_B2                  ;3        
    lda     #$bb                    ;2        
    sta     ram_B4                  ;3        
    lda     #$01                    ;2        
    sta     ram_B8                  ;3        
    jsr     Lfa18                   ;6        
    jmp     Lf825                   ;3   =  81
    
Lf7d8
    lda     #$00                    ;2        
    sta     ram_AF                  ;3        
    lda     #$97                    ;2        
    sta     ram_AC                  ;3        
    jmp     Lf825                   ;3   =  13
    
Lf7e3
    lda     #$03                    ;2        
    and     ram_80                  ;3        
    bne     Lf825                   ;2/3!     
    lda     #$80                    ;2        
    bit     ram_AE                  ;3        
    bne     Lf7fc                   ;2/3      
    jsr     Lfa1d                   ;6        
    lda     ram_B6                  ;3        
    clc                             ;2        
    adc     #$1b                    ;2        
    sta     ram_B6                  ;3        
    jmp     Lf808                   ;3   =  33
    
Lf7fc
    lda     #$7f                    ;2        
    jsr     Lfa18                   ;6        
    lda     ram_B6                  ;3        
    sec                             ;2        
    sbc     #$1b                    ;2        
    sta     ram_B6                  ;3   =  18
Lf808
    lda     ram_AC                  ;3        
    bne     Lf810                   ;2/3      
    lda     #$a0                    ;2        
    sta     ram_AC                  ;3   =  10
Lf810
    dec     ram_AC                  ;5        
    jmp     Lf825                   ;3   =   8
    
Lf815
    lda     ram_C2                  ;3        
    cmp     #$1f                    ;2        
    beq     Lf81e                   ;2/3      
    lsr                             ;2        
    sta     ram_C2                  ;3   =  12
Lf81e
    lda     #$00                    ;2        
    sta     ram_81                  ;3        
    jmp     Lf850                   ;3   =   8
    
Lf825
    lda     #$80                    ;2        
    bit     CXPPMM                  ;3        
    beq     Lf88b                   ;2/3 =   7
Lf82b
    lda     #$ff                    ;2        
    sta     ram_D9                  ;3        
    lda     #$04                    ;2        
    sta     ram_D8                  ;3        
    lda     #$0c                    ;2        
    sta     AUDC1                   ;3        
    jmp     Lf073                   ;3   =  18
    
Lf83a
    lda     ram_B9                  ;3        
    bne     Lf84c                   ;2/3      
    lda     #$00                    ;2        
    sta     ram_81                  ;3        
    sta     ram_AD                  ;3        
    lda     #$10                    ;2        
    jsr     Lfa18                   ;6        
    jmp     Lf021                   ;3   =  24
    
Lf84c
    dec     ram_B9                  ;5        
    lda     #$00                    ;2   =   7
Lf850
    sta     ram_AD                  ;3        
    sta     ram_BC                  ;3        
    lda     #$1f                    ;2        
    sta     ram_B0                  ;3        
    sta     ram_BB                  ;3        
    lda     #$84                    ;2        
    sta     ram_B2                  ;3        
    lda     #$bb                    ;2        
    sta     ram_B4                  ;3        
    lda     #$9d                    ;2        
    sta     ram_B6                  ;3        
    lda     #$01                    ;2        
    sta     ram_B8                  ;3        
    lda     #$11                    ;2        
    jsr     Lfa18                   ;6        
    lda     #$40                    ;2        
    jsr     Lfa1d                   ;6        
    lda     #$00                    ;2        
    sta     AUDV1                   ;3        
    ldx     ram_B9                  ;3        
    lda     Lfaf5,x                 ;4        
    sta     ram_C0                  ;3        
    lda     Lfaf8,x                 ;4        
    sta     ram_C1                  ;3        
    lda     ram_81                  ;3        
    clc                             ;2        
    adc     #$01                    ;2        
    sta     ram_BD                  ;3   =  82
Lf88b
    lda     ram_C2                  ;3        
    and     ram_80                  ;3        
    bne     Lf8b9                   ;2/3      
    lda     ram_BD                  ;3        
    bne     Lf8a2                   ;2/3      
    lda     ram_BA                  ;3        
    cmp     ram_BC                  ;3        
    bmi     Lf8a2                   ;2/3      
    lda     #$00                    ;2         *
    sta     ram_BC                  ;3         *
    jmp     Lf82b                   ;3   =  29 *
    
Lf8a2
    sed                             ;2        
    lda     ram_BC                  ;3        
    sec                             ;2        
    sbc     ram_BA                  ;3        
    sta     ram_BC                  ;3        
    lda     ram_BD                  ;3        
    sbc     #$00                    ;2        
    and     #$0f                    ;2        
    sta     ram_BD                  ;3        
    lda     ram_BC                  ;3        
    and     #$0f                    ;2        
    sta     ram_BC                  ;3        
    cld                             ;2   =  33
Lf8b9
    ldx     #$00                    ;2   =   2
Lf8bb
    lda     ram_A2,x                ;4        
    and     #$f0                    ;2        
    beq     Lf8d0                   ;2/3      
    lda     ram_A2,x                ;4        
    and     #$0f                    ;2        
    sta     ram_A2,x                ;4        
    sed                             ;2        
    lda     ram_A3,x                ;4        
    clc                             ;2        
    adc     #$01                    ;2        
    sta     ram_A3,x                ;4        
    cld                             ;2   =  34
Lf8d0
    inx                             ;2        
    cpx     #$03                    ;2        
    bmi     Lf8bb                   ;2/3      
    lda     ram_A5                  ;3        
    and     #$0f                    ;2        
    sta     ram_A5                  ;3        
    jmp     Lf073                   ;3   =  17
    
Lf8de
    cmp     #$9f                    ;2        
    bne     Lf8e4                   ;2/3      
    lda     #$ff                    ;2   =   6
Lf8e4
    clc                             ;2        
    adc     #$01                    ;2        
    rts                             ;6   =  10
    
Lf8e8
    bne     Lf8ec                   ;2/3      
    lda     #$a0                    ;2   =   4
Lf8ec
    sec                             ;2        
    sbc     #$01                    ;2        
    rts                             ;6   =  10
    
Lf8f0
    ldx     ram_C7                  ;3        
    lda     Lfdfe,x                 ;4        
    sta     ram_9A                  ;3        
    ldx     ram_C8                  ;3        
    lda     Lfdfe,x                 ;4        
    sta     ram_9C                  ;3        
    ldx     ram_C9                  ;3        
    lda     Lfdfe,x                 ;4        
    sta     ram_9E                  ;3        
    ldx     ram_CA                  ;3        
    lda     Lfdfe,x                 ;4        
    sta     ram_A0                  ;3        
    ldx     #$08                    ;2        
    sta     HMCLR                   ;3        
    sta     WSYNC                   ;3   =  48
;---------------------------------------
Lf912
    dex                             ;2        
    bne     Lf912                   ;2/3      
    sta     RESP0                   ;3        
    sta     RESP1                   ;3        
    lda     #$10                    ;2        
    sta     HMP1                    ;3        
    sta     WSYNC                   ;3   =  18
;---------------------------------------
    sta     HMOVE                   ;3        
    lda     ram_CB                  ;3        
    sta     NUSIZ0                  ;3        
    lda     ram_CC                  ;3        
    sta     NUSIZ1                  ;3        
    ldx     ram_81                  ;3        
    lda     Lfe0e,x                 ;4        
    sta     COLUP0                  ;3        
    sta     COLUP1                  ;3        
    ldy     ram_D6                  ;3   =  31
Lf934
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    lda     (ram_A0),y              ;5        
    sta     GRP0                    ;3        
    lda     (ram_9E),y              ;5        
    sta     GRP1                    ;3        
    lda     (ram_9C),y              ;5        
    tax                             ;2        
    lda     (ram_9A),y              ;5        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    nop                             ;2        
    stx     GRP0                    ;3        
    sta     GRP1                    ;3        
    sta     GRP0                    ;3        
    dey                             ;2        
    bpl     Lf934                   ;2/3      
    jsr     Lfa00                   ;6        
    rts                             ;6   =  69
    
Lf958
    jsr     Lf9dc                   ;6        
    sta     WSYNC                   ;3   =   9
;---------------------------------------
    sta     HMOVE                   ;3        
    ldy     ram_8C                  ;3   =   6
Lf961
    lda     (ram_82),y              ;5        
    sta     WSYNC                   ;3   =   8
;---------------------------------------
    sta     GRP0                    ;3        
    lda     (ram_86),y              ;5        
    sta     COLUP0                  ;3        
    dey                             ;2        
    bpl     Lf961                   ;2/3      
    jsr     Lfa00                   ;6        
    rts                             ;6   =  27
    
Lf972
    jsr     Lf9dc                   ;6        
    jsr     Lf9ec                   ;6        
    sta     WSYNC                   ;3   =  15
;---------------------------------------
    sta     HMOVE                   ;3        
    ldy     ram_8C                  ;3   =   6
Lf97e
    lda     (ram_82),y              ;5        
    tax                             ;2        
    lda     (ram_84),y              ;5        
    sta     WSYNC                   ;3   =  15
;---------------------------------------
    stx     GRP0                    ;3        
    sta     GRP1                    ;3        
    lda     (ram_86),y              ;5        
    sta     COLUP0                  ;3        
    lda     (ram_88),y              ;5        
    sta     COLUP1                  ;3        
    dey                             ;2        
    bpl     Lf97e                   ;2/3      
    jsr     Lfa00                   ;6        
    rts                             ;6   =  38
    
Lf998
    jsr     Lf9dc                   ;6        
    jsr     Lf9ec                   ;6        
    jsr     Lf9f7                   ;6        
    ldy     #$07                    ;2   =  20
Lf9a3
    lda     (ram_82),y              ;5        
    sta     WSYNC                   ;3   =   8
;---------------------------------------
    sta     GRP0                    ;3        
    sta     GRP1                    ;3        
    lda     (ram_86),y              ;5        
    sta     COLUP0                  ;3        
    sta     COLUP1                  ;3        
    tya                             ;2        
    cmp     #$03                    ;2        
    bne     Lf9ba                   ;2/3      
    lda     ram_90                  ;3        
    sta     COLUBK                  ;3   =  29
Lf9ba
    dey                             ;2        
    bpl     Lf9a3                   ;2/3      
    jsr     Lfa00                   ;6        
    rts                             ;6   =  16
    
Lf9c1
    ldx     ram_C3                  ;3        
    sta     WSYNC                   ;3   =   6
;---------------------------------------
    sta     COLUPF                  ;3        
    lda     Lfdee,x                 ;4        
    sta     PF0                     ;3        
    lda     Lfdf2,x                 ;4        
    sta     PF1                     ;3        
    lda     Lfdee,x                 ;4        
    sta     PF2                     ;3        
    ldy     #$03                    ;2        
    jsr     Lfa09                   ;6        
    rts                             ;6   =  38
    
Lf9dc
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    sta     COLUBK                  ;3        
    lda     ram_8A                  ;3        
    sta     NUSIZ0                  ;3        
    ldx     #$00                    ;2        
    lda     ram_8E                  ;3        
    jsr     Lfa3e                   ;6        
    rts                             ;6   =  26
    
Lf9ec
    lda     ram_8B                  ;3        
    sta     NUSIZ1                  ;3        
    inx                             ;2        
    lda     ram_8F                  ;3        
    jsr     Lfa3e                   ;6        
    rts                             ;6   =  23
    
Lf9f7
    lda     #$00                    ;2        
    sta     PF0                     ;3        
    sta     PF1                     ;3        
    sta     PF2                     ;3        
    rts                             ;6   =  17
    
Lfa00
    lda     #$00                    ;2        
    sta     WSYNC                   ;3   =   5
;---------------------------------------
    sta     GRP0                    ;3        
    sta     GRP1                    ;3        
    rts                             ;6   =  12
    
Lfa09
    sta     WSYNC                   ;3   =   3
;---------------------------------------
    dey                             ;2        
    bne     Lfa09                   ;2/3      
    rts                             ;6   =  10
    
Lfa0f
    sta     ram_83                  ;3        
    sta     ram_85                  ;3        
    sta     ram_87                  ;3        
    sta     ram_89                  ;3        
    rts                             ;6   =  18
    
Lfa18
    and     ram_AE                  ;3        
    sta     ram_AE                  ;3        
    rts                             ;6   =  12
    
Lfa1d
    ora     ram_AE                  ;3        
    sta     ram_AE                  ;3        
    rts                             ;6   =  12
    
Lfa22
    lda     Lfeb4,x                 ;4        
    sta     ram_D1                  ;3        
    lda     Lfec1,x                 ;4        
    sta     ram_D3                  ;3        
    lda     (ram_D3),y              ;5        
    sta     AUDF0                   ;3        
    lda     (ram_D1),y              ;5        
    sta     ram_D0                  ;3        
    tya                             ;2        
    cmp     Lfece,x                 ;4        
    bne     Lfa3c                   ;2/3      
    ldy     #$ff                    ;2   =  40
Lfa3c
    iny                             ;2        
    rts                             ;6   =   8
    
Lfa3e
    clc                             ;2        
    adc     #$2e                    ;2        
    tay                             ;2        
    and     #$0f                    ;2        
    sta     ram_A6                  ;3        
    tya                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    lsr                             ;2        
    tay                             ;2        
    clc                             ;2        
    adc     ram_A6                  ;3        
    cmp     #$0f                    ;2        
    bcc     Lfa56                   ;2/3      
    sbc     #$0f                    ;2        
    iny                             ;2   =  36
Lfa56
    eor     #$07                    ;2        
    asl                             ;2        
    asl                             ;2        
    asl                             ;2        
    asl                             ;2        
    sta     HMP0,x                  ;4        
    sta     WSYNC                   ;3   =  17
;---------------------------------------
Lfa60
    dey                             ;2        
    bpl     Lfa60                   ;2/3      
    sta     RESP0,x                 ;4        
    sta     WSYNC                   ;3   =  11
;---------------------------------------
    rts                             ;6   =   6
    
Lfa68
    .byte   $0c                             ; $fa68 (A)
    .byte   $04                             ; $fa69 (A)
    .byte   $01,$0d                         ; $fa6a (*)
Lfa6c
    .byte   $08,$01,$07,$02,$09             ; $fa6c (D)
    
Lfa71
    .byte   CYAN|$3                         ; $fa71 (CB)
    .byte   BLACK0|$4                       ; $fa72 (CB)
    .byte   BLACK1|$2                       ; $fa73 (CB)
    
Lfa74
    .byte   $01,$05,$00                     ; $fa74 (D)
Lfa77
    .byte   $40,$68,$52                     ; $fa77 (D)
Lfa7a
    .byte   $02,$02,$06                     ; $fa7a (D)
Lfa7d
    .byte   $06,$03,$06                     ; $fa7d (D)
Lfa80
    .byte   $50,$60,$60                     ; $fa80 (D)
Lfa83
    .byte   $fb,$fb,$fb                     ; $fa83 (D)
Lfa86
    .byte   $58,$68,$68                     ; $fa86 (D)
Lfa89
    .byte   $fb,$fb,$fb                     ; $fa89 (D)
Lfa8c
    .byte   $68,$58,$58                     ; $fa8c (D)
Lfa8f
    .byte   $fb,$fb,$fb,$fb,$fb,$fd         ; $fa8f (D)
Lfa95
    .byte   $70,$50,$70,$94,$60,$30         ; $fa95 (D)
Lfa9b
    .byte   $82,$58,$82,$a6,$68,$37         ; $fa9b (D)
Lfaa1
    .byte   $c8,$b8,$94,$70,$60,$30         ; $faa1 (D)
Lfaa7
    .byte   $da,$c0,$a6,$82,$68,$37         ; $faa7 (D)
Lfaad
    .byte   $06,$06,$06,$06,$01,$00         ; $faad (D)
Lfab3
    .byte   $05,$04,$06,$03,$02,$00         ; $fab3 (D)
Lfab9
    .byte   $80,$35,$16,$27,$30,$29         ; $fab9 (D)
Lfabf
    .byte   $4f,$05,$65,$80,$70,$79         ; $fabf (D)
Lfac5
    .byte   $11,$07,$11,$11,$07,$06         ; $fac5 (D)
    
Lfacb
    .byte   GREEN|$8                        ; $facb (CB)
    .byte   GREEN|$8                        ; $facc (CB)
    .byte   GREEN|$8                        ; $facd (CB)
    .byte   GREEN|$8                        ; $face (CB)
    .byte   GREEN|$8                        ; $facf (CB)
    .byte   CYAN|$6                         ; $fad0 (CB)
    
Lfad1
    .byte   $11,$ba,$ca,$08,$3e             ; $fad1 (D)
Lfad6
    .byte   $fc,$fc,$fc,$fd,$fd             ; $fad6 (D)
Lfadb
    .byte   $06,$06,$04,$04,$04             ; $fadb (D)
Lfae0
    .byte   $06,$07,$0e,$07,$07             ; $fae0 (D)
Lfae5
    .byte   $18,$c2,$d9,$10,$4e             ; $fae5 (D)
    
Lfaea
    .byte   BLACK0|$4                       ; $faea (CB)
    .byte   CYAN|$7                         ; $faeb (CB)
    .byte   CYAN|$7                         ; $faec (CB)
    .byte   CYAN_GREEN|$8                   ; $faed (CB)
    .byte   CYAN_GREEN|$8                   ; $faee (CB)
Lfaef
    .byte   BLACK0|$a                       ; $faef (CB)
    .byte   BLACK0|$a                       ; $faf0 (CB)
    .byte   BLACK0|$a                       ; $faf1 (CB)
    .byte   BLACK0|$a                       ; $faf2 (CB)
    .byte   BLACK0|$a                       ; $faf3 (CB)
    .byte   BLACK0|$a                       ; $faf4 (CB)
    
Lfaf5
    .byte   $00,$03                         ; $faf5 (D)
    .byte   $03                             ; $faf7 (*)
Lfaf8
    .byte   $01,$01                         ; $faf8 (D)
    .byte   $03,$7e,$b3,$e0,$00,$f0         ; $fafa (*)
    
    .byte   %00001110 ; |    ### |            $fb00 (G)
    .byte   %00001000 ; |    #   |            $fb01 (G)
    .byte   %00011100 ; |   ###  |            $fb02 (G)
    .byte   %01101110 ; | ## ### |            $fb03 (G)
    .byte   %11110110 ; |#### ## |            $fb04 (G)
    .byte   %11111011 ; |##### ##|            $fb05 (G)
    .byte   %11001101 ; |##  ## #|            $fb06 (G)
    .byte   %11000001 ; |##     #|            $fb07 (G)
    .byte   %00111110 ; |  ##### |            $fb08 (G)
    .byte   %00001110 ; |    ### |            $fb09 (G)
    .byte   %00001000 ; |    #   |            $fb0a (G)
    .byte   %00011100 ; |   ###  |            $fb0b (G)
    .byte   %01101111 ; | ## ####|            $fb0c (G)
    .byte   %11110111 ; |#### ###|            $fb0d (G)
    .byte   %11111011 ; |##### ##|            $fb0e (G)
    .byte   %11001100 ; |##  ##  |            $fb0f (G)
    .byte   %11000000 ; |##      |            $fb10 (G)
    .byte   %00111110 ; |  ##### |            $fb11 (G)
    
    .byte   BLACK0|$0                       ; $fb12 (C)
    .byte   BLACK0|$0                       ; $fb13 (C)
    .byte   BLACK0|$0                       ; $fb14 (C)
    .byte   YELLOW|$b                       ; $fb15 (C)
    .byte   YELLOW|$b                       ; $fb16 (C)
    .byte   YELLOW|$b                       ; $fb17 (C)
    .byte   YELLOW|$b                       ; $fb18 (C)
    .byte   YELLOW|$b                       ; $fb19 (C)
    .byte   BLACK0|$0                       ; $fb1a (C)
    
    .byte   %00000000 ; |        |            $fb1b (G)
    .byte   %01000000 ; | #      |            $fb1c (G)
    .byte   %00110000 ; |  ##    |            $fb1d (G)
    .byte   %01111000 ; | ####   |            $fb1e (G)
    .byte   %11111100 ; |######  |            $fb1f (G)
    .byte   %00110110 ; |  ## ## |            $fb20 (G)
    .byte   %11100100 ; |###  #  |            $fb21 (G)
    .byte   %11000000 ; |##      |            $fb22 (G)
    .byte   %01100000 ; | ##     |            $fb23 (G)
    .byte   %00110000 ; |  ##    |            $fb24 (G)
    .byte   %01111000 ; | ####   |            $fb25 (G)
    .byte   %11111100 ; |######  |            $fb26 (G)
    .byte   %00000111 ; |     ###|            $fb27 (G)
    .byte   %00000010 ; |      # |            $fb28 (G)
    
    .byte   BLACK0|$c                       ; $fb29 (C)
    .byte   BLACK0|$c                       ; $fb2a (C)
    .byte   BLACK0|$c                       ; $fb2b (C)
    .byte   BLACK0|$c                       ; $fb2c (C)
    .byte   BLACK0|$c                       ; $fb2d (C)
    .byte   BLACK0|$c                       ; $fb2e (C)
    .byte   BLACK0|$c                       ; $fb2f (C)
    
    .byte   %00111100 ; |  ####  |            $fb30 (G)
    .byte   %00111100 ; |  ####  |            $fb31 (G)
    .byte   %00000000 ; |        |            $fb32 (G)
    .byte   %00100100 ; |  #  #  |            $fb33 (G)
    .byte   %00000000 ; |        |            $fb34 (G)
    .byte   %01000010 ; | #    # |            $fb35 (G)
    .byte   %00011000 ; |   ##   |            $fb36 (G)
    .byte   %10111101 ; |# #### #|            $fb37 (G)
    .byte   %01111110 ; | ###### |            $fb38 (G)
    .byte   %11111111 ; |########|            $fb39 (G)
    .byte   %11111111 ; |########|            $fb3a (G)
    .byte   %11111111 ; |########|            $fb3b (G)
    .byte   %11111111 ; |########|            $fb3c (G)
    .byte   %11111111 ; |########|            $fb3d (G)
    .byte   %01111110 ; | ###### |            $fb3e (G)
    .byte   %00111100 ; |  ####  |            $fb3f (G)
    
    .byte   $48,$48,$00,$00,$00,$00,$00,$00 ; $fb40 (*)
    .byte   $2b,$2b,$62,$62,$62,$2b,$2b,$2b ; $fb48 (*)
    
    .byte   %00011000 ; |   ##   |            $fb50 (G)
    .byte   %00011000 ; |   ##   |            $fb51 (G)
    .byte   %00011000 ; |   ##   |            $fb52 (G)
    .byte   %01111110 ; | ###### |            $fb53 (G)
    .byte   %11111111 ; |########|            $fb54 (G)
    .byte   %11111111 ; |########|            $fb55 (G)
    .byte   %01111110 ; | ###### |            $fb56 (G)
    .byte   %00111100 ; |  ####  |            $fb57 (G)
    
    .byte   ORANGE|$3                       ; $fb58 (C)
    .byte   ORANGE|$3                       ; $fb59 (C)
    .byte   ORANGE|$3                       ; $fb5a (C)
    .byte   GREEN_YELLOW|$3                 ; $fb5b (C)
    .byte   GREEN_YELLOW|$3                 ; $fb5c (C)
    .byte   GREEN_YELLOW|$3                 ; $fb5d (C)
    .byte   GREEN_YELLOW|$3                 ; $fb5e (C)
    .byte   GREEN_YELLOW|$3                 ; $fb5f (C)
    
    .byte   %00100000 ; |  #     |            $fb60 (G)
    .byte   %00100000 ; |  #     |            $fb61 (G)
    .byte   %01110000 ; | ###    |            $fb62 (G)
    .byte   %11111000 ; |#####   |            $fb63 (G)
    .byte   %01110000 ; | ###    |            $fb64 (G)
    .byte   %11111000 ; |#####   |            $fb65 (G)
    .byte   %01110000 ; | ###    |            $fb66 (G)
    .byte   %00100000 ; |  #     |            $fb67 (G)
    
    .byte   ORANGE|$3                       ; $fb68 (C)
    .byte   ORANGE|$3                       ; $fb69 (C)
    .byte   GREEN_YELLOW|$3                 ; $fb6a (C)
    .byte   GREEN_YELLOW|$3                 ; $fb6b (C)
    .byte   GREEN_YELLOW|$3                 ; $fb6c (C)
    .byte   GREEN_YELLOW|$3                 ; $fb6d (C)
    .byte   GREEN_YELLOW|$3                 ; $fb6e (C)
    .byte   GREEN_YELLOW|$3                 ; $fb6f (C)
    
    .byte   %00011100 ; |   ###  |            $fb70 (G)
    .byte   %00111110 ; |  ##### |            $fb71 (G)
    .byte   %01111100 ; | #####  |            $fb72 (G)
    .byte   %00111111 ; |  ######|            $fb73 (G)
    .byte   %11111100 ; |######  |            $fb74 (G)
    .byte   %00111111 ; |  ######|            $fb75 (G)
    .byte   %01111100 ; | #####  |            $fb76 (G)
    .byte   %00111111 ; |  ######|            $fb77 (G)
    .byte   %01111110 ; | ###### |            $fb78 (G)
    .byte   %00111100 ; |  ####  |            $fb79 (G)
    .byte   %01111110 ; | ###### |            $fb7a (G)
    .byte   %00011100 ; |   ###  |            $fb7b (G)
    .byte   %00111000 ; |  ###   |            $fb7c (G)
    .byte   %00011100 ; |   ###  |            $fb7d (G)
    .byte   %00011000 ; |   ##   |            $fb7e (G)
    .byte   %00001100 ; |    ##  |            $fb7f (G)
    .byte   %00001000 ; |    #   |            $fb80 (G)
    .byte   %00001000 ; |    #   |            $fb81 (G)
    
    .byte   CYAN_GREEN|$3                   ; $fb82 (C)
    .byte   CYAN_GREEN|$3                   ; $fb83 (C)
    .byte   CYAN_GREEN|$3                   ; $fb84 (C)
    .byte   CYAN_GREEN|$3                   ; $fb85 (C)
    .byte   CYAN_GREEN|$3                   ; $fb86 (C)
    .byte   CYAN_GREEN|$3                   ; $fb87 (C)
    .byte   CYAN_GREEN|$3                   ; $fb88 (C)
    .byte   CYAN_GREEN|$3                   ; $fb89 (C)
    .byte   CYAN_GREEN|$3                   ; $fb8a (C)
    .byte   CYAN_GREEN|$3                   ; $fb8b (C)
    .byte   CYAN_GREEN|$3                   ; $fb8c (C)
    .byte   CYAN_GREEN|$3                   ; $fb8d (C)
    .byte   CYAN_GREEN|$3                   ; $fb8e (C)
    .byte   CYAN_GREEN|$3                   ; $fb8f (C)
    .byte   CYAN_GREEN|$3                   ; $fb90 (C)
    .byte   CYAN_GREEN|$3                   ; $fb91 (C)
    .byte   CYAN_GREEN|$3                   ; $fb92 (C)
    .byte   CYAN_GREEN|$3                   ; $fb93 (C)
    
    .byte   %00011000 ; |   ##   |            $fb94 (G)
    .byte   %00011000 ; |   ##   |            $fb95 (G)
    .byte   %11111111 ; |########|            $fb96 (G)
    .byte   %01111110 ; | ###### |            $fb97 (G)
    .byte   %00111100 ; |  ####  |            $fb98 (G)
    .byte   %01111111 ; | #######|            $fb99 (G)
    .byte   %00111100 ; |  ####  |            $fb9a (G)
    .byte   %11111111 ; |########|            $fb9b (G)
    .byte   %01111110 ; | ###### |            $fb9c (G)
    .byte   %00111111 ; |  ######|            $fb9d (G)
    .byte   %11111110 ; |####### |            $fb9e (G)
    .byte   %01111100 ; | #####  |            $fb9f (G)
    .byte   %00111111 ; |  ######|            $fba0 (G)
    .byte   %00011110 ; |   #### |            $fba1 (G)
    .byte   %01111100 ; | #####  |            $fba2 (G)
    .byte   %00111110 ; |  ##### |            $fba3 (G)
    .byte   %00011100 ; |   ###  |            $fba4 (G)
    .byte   %00000001 ; |       #|            $fba5 (G)
    
    .byte   YELLOW|$4                       ; $fba6 (C)
    .byte   YELLOW|$4                       ; $fba7 (C)
    .byte   GREEN_YELLOW|$3                 ; $fba8 (C)
    .byte   GREEN_YELLOW|$3                 ; $fba9 (C)
    .byte   GREEN_YELLOW|$3                 ; $fbaa (C)
    .byte   GREEN_YELLOW|$3                 ; $fbab (C)
    .byte   GREEN_YELLOW|$3                 ; $fbac (C)
    .byte   GREEN_YELLOW|$3                 ; $fbad (C)
    .byte   GREEN_YELLOW|$3                 ; $fbae (C)
    .byte   GREEN_YELLOW|$3                 ; $fbaf (C)
    .byte   GREEN_YELLOW|$3                 ; $fbb0 (C)
    .byte   GREEN_YELLOW|$3                 ; $fbb1 (C)
    .byte   GREEN_YELLOW|$3                 ; $fbb2 (C)
    .byte   GREEN_YELLOW|$3                 ; $fbb3 (C)
    .byte   GREEN_YELLOW|$3                 ; $fbb4 (C)
    .byte   GREEN_YELLOW|$3                 ; $fbb5 (C)
    .byte   GREEN_YELLOW|$3                 ; $fbb6 (C)
    .byte   GREEN_YELLOW|$3                 ; $fbb7 (C)
    
    .byte   %00000000 ; |        |            $fbb8 (G)
    .byte   %11111111 ; |########|            $fbb9 (G)
    .byte   %10011001 ; |#  ##  #|            $fbba (G)
    .byte   %10011001 ; |#  ##  #|            $fbbb (G)
    .byte   %11111111 ; |########|            $fbbc (G)
    .byte   %11111111 ; |########|            $fbbd (G)
    .byte   %01111110 ; | ###### |            $fbbe (G)
    .byte   %00000000 ; |        |            $fbbf (G)
    
    .byte   BLACK0|$0                       ; $fbc0 (C)
    .byte   BLACK0|$b                       ; $fbc1 (C)
    .byte   BLACK0|$b                       ; $fbc2 (C)
    .byte   BLACK0|$b                       ; $fbc3 (C)
    .byte   BLACK0|$b                       ; $fbc4 (C)
    .byte   RED|$3                          ; $fbc5 (C)
    .byte   RED|$3                          ; $fbc6 (C)
    .byte   BLACK0|$0                       ; $fbc7 (C)
    
    .byte   %00000000 ; |        |            $fbc8 (G)
    .byte   %11111111 ; |########|            $fbc9 (G)
    .byte   %11111111 ; |########|            $fbca (G)
    .byte   %11111111 ; |########|            $fbcb (G)
    .byte   %10011001 ; |#  ##  #|            $fbcc (G)
    .byte   %10011001 ; |#  ##  #|            $fbcd (G)
    .byte   %11111111 ; |########|            $fbce (G)
    .byte   %11111111 ; |########|            $fbcf (G)
    .byte   %01111110 ; | ###### |            $fbd0 (G)
    .byte   %01111110 ; | ###### |            $fbd1 (G)
    .byte   %01100000 ; | ##     |            $fbd2 (G)
    .byte   %01100000 ; | ##     |            $fbd3 (G)
    .byte   %00000000 ; |        |            $fbd4 (G)
    .byte   %00000000 ; |        |            $fbd5 (G)
    .byte   %00000000 ; |        |            $fbd6 (G)
    .byte   %00000000 ; |        |            $fbd7 (G)
    .byte   %00000000 ; |        |            $fbd8 (G)
    .byte   %00000000 ; |        |            $fbd9 (G)
    
    .byte   BLACK0|$0                       ; $fbda (C)
    .byte   YELLOW|$b                       ; $fbdb (C)
    .byte   YELLOW|$b                       ; $fbdc (C)
    .byte   YELLOW|$b                       ; $fbdd (C)
    .byte   YELLOW|$b                       ; $fbde (C)
    .byte   YELLOW|$b                       ; $fbdf (C)
    .byte   YELLOW|$b                       ; $fbe0 (C)
    .byte   RED|$4                          ; $fbe1 (C)
    .byte   RED|$4                          ; $fbe2 (C)
    .byte   RED|$4                          ; $fbe3 (C)
    .byte   GREEN_YELLOW|$5                 ; $fbe4 (C)
    .byte   GREEN_YELLOW|$5                 ; $fbe5 (C)
    .byte   BLACK0|$0                       ; $fbe6 (C)
    .byte   BLACK0|$0                       ; $fbe7 (C)
    .byte   BLACK0|$0                       ; $fbe8 (C)
    .byte   BLACK0|$0                       ; $fbe9 (C)
    .byte   BLACK0|$0                       ; $fbea (C)
    .byte   BLACK0|$0                       ; $fbeb (C)
    
Lfbec
    .byte   $02,$08,$10                     ; $fbec (D)
Lfbef
    .byte   $01,$03,$07                     ; $fbef (D)
Lfbf2
    .byte   $fc,$fc,$fc                     ; $fbf2 (D)
Lfbf5
    .byte   $1f,$47,$8d                     ; $fbf5 (D)
Lfbf8
    .byte   $2f,$55,$96                     ; $fbf8 (D)
Lfbfb
    .byte   $27,$63,$9f                     ; $fbfb (D)
Lfbfe
    .byte   $37,$71,$a8                     ; $fbfe (D)
Lfc01
    .byte   $3f,$7f,$b1                     ; $fc01 (D)
Lfc04
    .byte   $07,$0d,$08                     ; $fc04 (D)
    
Lfc07
    .byte   BLACK1|$6                       ; $fc07 (CB)
    .byte   GREEN|$8                        ; $fc08 (CB)
    .byte   CYAN|$6                         ; $fc09 (CB)
    
    .byte   %00100100 ; |  #  #  |            $fc0a (G)
    .byte   %01000010 ; | #    # |            $fc0b (G)
    .byte   %11111111 ; |########|            $fc0c (G)
    .byte   %11111111 ; |########|            $fc0d (G)
    .byte   %11010000 ; |## #    |            $fc0e (G)
    .byte   %01010000 ; | # #    |            $fc0f (G)
    .byte   %00110000 ; |  ##    |            $fc10 (G)
    .byte   %01000010 ; | #    # |            $fc11 (G)
    .byte   %00100100 ; |  #  #  |            $fc12 (G)
    .byte   %11111111 ; |########|            $fc13 (G)
    .byte   %11111111 ; |########|            $fc14 (G)
    .byte   %11010000 ; |## #    |            $fc15 (G)
    .byte   %01010000 ; | # #    |            $fc16 (G)
    .byte   %00110000 ; |  ##    |            $fc17 (G)
    
    .byte   BLACK0|$0                       ; $fc18 (C)
    .byte   BLACK0|$0                       ; $fc19 (C)
    .byte   YELLOW|$5                       ; $fc1a (C)
    .byte   YELLOW|$5                       ; $fc1b (C)
    .byte   YELLOW|$5                       ; $fc1c (C)
    .byte   YELLOW|$5                       ; $fc1d (C)
    .byte   YELLOW|$5                       ; $fc1e (C)
    
    .byte   %00001000 ; |    #   |            $fc1f (G)
    .byte   %00010000 ; |   #    |            $fc20 (G)
    .byte   %01111111 ; | #######|            $fc21 (G)
    .byte   %11111111 ; |########|            $fc22 (G)
    .byte   %11100011 ; |###   ##|            $fc23 (G)
    .byte   %00110011 ; |  ##  ##|            $fc24 (G)
    .byte   %00011111 ; |   #####|            $fc25 (G)
    .byte   %00000000 ; |        |            $fc26 (G)
    .byte   %00010000 ; |   #    |            $fc27 (G)
    .byte   %00001000 ; |    #   |            $fc28 (G)
    .byte   %01111111 ; | #######|            $fc29 (G)
    .byte   %11111111 ; |########|            $fc2a (G)
    .byte   %11100011 ; |###   ##|            $fc2b (G)
    .byte   %00110011 ; |  ##  ##|            $fc2c (G)
    .byte   %00011111 ; |   #####|            $fc2d (G)
    .byte   %00000000 ; |        |            $fc2e (G)
    .byte   %00100000 ; |  #     |            $fc2f (G)
    .byte   %00010000 ; |   #    |            $fc30 (G)
    .byte   %11111110 ; |####### |            $fc31 (G)
    .byte   %11111110 ; |####### |            $fc32 (G)
    .byte   %00011110 ; |   #### |            $fc33 (G)
    .byte   %00110000 ; |  ##    |            $fc34 (G)
    .byte   %11100000 ; |###     |            $fc35 (G)
    .byte   %00000000 ; |        |            $fc36 (G)
    .byte   %00010000 ; |   #    |            $fc37 (G)
    .byte   %00100000 ; |  #     |            $fc38 (G)
    .byte   %11111110 ; |####### |            $fc39 (G)
    .byte   %11111110 ; |####### |            $fc3a (G)
    .byte   %00011110 ; |   #### |            $fc3b (G)
    .byte   %00110000 ; |  ##    |            $fc3c (G)
    .byte   %11100000 ; |###     |            $fc3d (G)
    .byte   %00000000 ; |        |            $fc3e (G)
    .byte   %00000000 ; |        |            $fc3f (G)
    .byte   %00000000 ; |        |            $fc40 (G)
    .byte   %10000101 ; |#    # #|            $fc41 (G)
    .byte   %10000101 ; |#    # #|            $fc42 (G)
    .byte   %10000101 ; |#    # #|            $fc43 (G)
    .byte   %10000101 ; |#    # #|            $fc44 (G)
    
    .byte   MAUVE|$5                        ; $fc45 (C)
    .byte   BLACK0|$0                       ; $fc46 (C)
    
    .byte   %01010000 ; | # #    |            $fc47 (G)
    .byte   %00001000 ; |    #   |            $fc48 (G)
    .byte   %00101000 ; |  # #   |            $fc49 (G)
    .byte   %00010100 ; |   # #  |            $fc4a (G)
    .byte   %00010100 ; |   # #  |            $fc4b (G)
    .byte   %00011111 ; |   #####|            $fc4c (G)
    .byte   %00111111 ; |  ######|            $fc4d (G)
    .byte   %01011111 ; | # #####|            $fc4e (G)
    .byte   %00001111 ; |    ####|            $fc4f (G)
    .byte   %00000111 ; |     ###|            $fc50 (G)
    .byte   %00000001 ; |       #|            $fc51 (G)
    .byte   %00000000 ; |        |            $fc52 (G)
    .byte   %00000000 ; |        |            $fc53 (G)
    .byte   %00000000 ; |        |            $fc54 (G)
    .byte   %00000000 ; |        |            $fc55 (G)
    .byte   %01010000 ; | # #    |            $fc56 (G)
    .byte   %10000000 ; |#       |            $fc57 (G)
    .byte   %10100000 ; |# #     |            $fc58 (G)
    .byte   %01000000 ; | #      |            $fc59 (G)
    .byte   %11000000 ; |##      |            $fc5a (G)
    .byte   %10000000 ; |#       |            $fc5b (G)
    .byte   %10000000 ; |#       |            $fc5c (G)
    .byte   %10000000 ; |#       |            $fc5d (G)
    .byte   %11010000 ; |## #    |            $fc5e (G)
    .byte   %11111000 ; |#####   |            $fc5f (G)
    .byte   %01110000 ; | ###    |            $fc60 (G)
    .byte   %01100000 ; | ##     |            $fc61 (G)
    .byte   %10010000 ; |#  #    |            $fc62 (G)
    .byte   %00001010 ; |    # # |            $fc63 (G)
    .byte   %00010100 ; |   # #  |            $fc64 (G)
    .byte   %00010100 ; |   # #  |            $fc65 (G)
    .byte   %00010100 ; |   # #  |            $fc66 (G)
    .byte   %00010101 ; |   # # #|            $fc67 (G)
    .byte   %00011111 ; |   #####|            $fc68 (G)
    .byte   %01011111 ; | # #####|            $fc69 (G)
    .byte   %00111111 ; |  ######|            $fc6a (G)
    .byte   %00001111 ; |    ####|            $fc6b (G)
    .byte   %00000111 ; |     ###|            $fc6c (G)
    .byte   %00000001 ; |       #|            $fc6d (G)
    .byte   %00000000 ; |        |            $fc6e (G)
    .byte   %00000000 ; |        |            $fc6f (G)
    .byte   %00000000 ; |        |            $fc70 (G)
    .byte   %10100000 ; |# #     |            $fc71 (G)
    .byte   %10100000 ; |# #     |            $fc72 (G)
    .byte   %10100000 ; |# #     |            $fc73 (G)
    .byte   %10100000 ; |# #     |            $fc74 (G)
    .byte   %01000000 ; | #      |            $fc75 (G)
    .byte   %11000000 ; |##      |            $fc76 (G)
    .byte   %10000000 ; |#       |            $fc77 (G)
    .byte   %10000000 ; |#       |            $fc78 (G)
    .byte   %10000000 ; |#       |            $fc79 (G)
    .byte   %11010000 ; |## #    |            $fc7a (G)
    .byte   %11111000 ; |#####   |            $fc7b (G)
    .byte   %01110000 ; | ###    |            $fc7c (G)
    .byte   %01100000 ; | ##     |            $fc7d (G)
    .byte   %10010000 ; |#  #    |            $fc7e (G)
    
    .byte   BLACK1|$8                       ; $fc7f (C)
    .byte   BLACK1|$8                       ; $fc80 (C)
    .byte   BLACK1|$8                       ; $fc81 (C)
    .byte   BLACK1|$8                       ; $fc82 (C)
    .byte   BLACK1|$8                       ; $fc83 (C)
    .byte   BLACK1|$8                       ; $fc84 (C)
    .byte   BLACK1|$8                       ; $fc85 (C)
    .byte   BLACK1|$8                       ; $fc86 (C)
    .byte   BLACK1|$8                       ; $fc87 (C)
    .byte   BLACK1|$8                       ; $fc88 (C)
    .byte   BLACK1|$8                       ; $fc89 (C)
    .byte   BLACK1|$8                       ; $fc8a (C)
    .byte   BLACK1|$8                       ; $fc8b (C)
    .byte   BLACK1|$8                       ; $fc8c (C)
    
    .byte   %00111111 ; |  ######|            $fc8d (G)
    .byte   %11111111 ; |########|            $fc8e (G)
    .byte   %11110111 ; |#### ###|            $fc8f (G)
    .byte   %11111111 ; |########|            $fc90 (G)
    .byte   %11111111 ; |########|            $fc91 (G)
    .byte   %01111110 ; | ###### |            $fc92 (G)
    .byte   %00001000 ; |    #   |            $fc93 (G)
    .byte   %00101010 ; |  # # # |            $fc94 (G)
    .byte   %00010100 ; |   # #  |            $fc95 (G)
    .byte   %11111100 ; |######  |            $fc96 (G)
    .byte   %11111110 ; |####### |            $fc97 (G)
    .byte   %11100001 ; |###    #|            $fc98 (G)
    .byte   %11000110 ; |##   ## |            $fc99 (G)
    .byte   %10001010 ; |#   # # |            $fc9a (G)
    .byte   %00000010 ; |      # |            $fc9b (G)
    .byte   %00000000 ; |        |            $fc9c (G)
    .byte   %00000000 ; |        |            $fc9d (G)
    .byte   %00000000 ; |        |            $fc9e (G)
    .byte   %00111111 ; |  ######|            $fc9f (G)
    .byte   %11111111 ; |########|            $fca0 (G)
    .byte   %11110111 ; |#### ###|            $fca1 (G)
    .byte   %11111111 ; |########|            $fca2 (G)
    .byte   %11111111 ; |########|            $fca3 (G)
    .byte   %01111110 ; | ###### |            $fca4 (G)
    .byte   %00000000 ; |        |            $fca5 (G)
    .byte   %00000000 ; |        |            $fca6 (G)
    .byte   %00000000 ; |        |            $fca7 (G)
    .byte   %11111100 ; |######  |            $fca8 (G)
    .byte   %11111110 ; |####### |            $fca9 (G)
    .byte   %11100001 ; |###    #|            $fcaa (G)
    .byte   %11000011 ; |##    ##|            $fcab (G)
    .byte   %10000101 ; |#    # #|            $fcac (G)
    .byte   %00000001 ; |       #|            $fcad (G)
    .byte   %00000000 ; |        |            $fcae (G)
    .byte   %00000000 ; |        |            $fcaf (G)
    .byte   %00000000 ; |        |            $fcb0 (G)
    
    .byte   BLACK0|$4                       ; $fcb1 (C)
    .byte   BLACK0|$4                       ; $fcb2 (C)
    .byte   BLACK0|$4                       ; $fcb3 (C)
    .byte   BLACK0|$4                       ; $fcb4 (C)
    .byte   BLACK0|$4                       ; $fcb5 (C)
    .byte   BLACK0|$4                       ; $fcb6 (C)
    .byte   BLACK0|$c                       ; $fcb7 (C)
    .byte   BLACK0|$c                       ; $fcb8 (C)
    .byte   BLACK0|$c                       ; $fcb9 (C)
    
    .byte   %01111110 ; | ###### |            $fcba (G)
    .byte   %11111111 ; |########|            $fcbb (G)
    .byte   %00010000 ; |   #    |            $fcbc (G)
    .byte   %00011100 ; |   ###  |            $fcbd (G)
    .byte   %00011100 ; |   ###  |            $fcbe (G)
    .byte   %00011000 ; |   ##   |            $fcbf (G)
    .byte   %00011000 ; |   ##   |            $fcc0 (G)
    .byte   %00010000 ; |   #    |            $fcc1 (G)
    
    .byte   BLUE_CYAN|$3                    ; $fcc2 (C)
    .byte   BLUE_CYAN|$3                    ; $fcc3 (C)
    .byte   BLACK0|$0                       ; $fcc4 (C)
    .byte   BLACK1|$b                       ; $fcc5 (C)
    .byte   BLACK1|$b                       ; $fcc6 (C)
    .byte   BLACK1|$b                       ; $fcc7 (C)
    .byte   BLACK1|$b                       ; $fcc8 (C)
    .byte   BLACK1|$b                       ; $fcc9 (C)
    
    .byte   %01111110 ; | ###### |            $fcca (G)
    .byte   %11111111 ; |########|            $fccb (G)
    .byte   %00010000 ; |   #    |            $fccc (G)
    .byte   %00011111 ; |   #####|            $fccd (G)
    .byte   %00011111 ; |   #####|            $fcce (G)
    .byte   %00011110 ; |   #### |            $fccf (G)
    .byte   %00011110 ; |   #### |            $fcd0 (G)
    .byte   %00011100 ; |   ###  |            $fcd1 (G)
    .byte   %00011100 ; |   ###  |            $fcd2 (G)
    .byte   %00011100 ; |   ###  |            $fcd3 (G)
    .byte   %00011000 ; |   ##   |            $fcd4 (G)
    .byte   %00011000 ; |   ##   |            $fcd5 (G)
    .byte   %00011000 ; |   ##   |            $fcd6 (G)
    .byte   %00010000 ; |   #    |            $fcd7 (G)
    .byte   %00010000 ; |   #    |            $fcd8 (G)
    
    .byte   GREEN_YELLOW|$5                 ; $fcd9 (C)
    .byte   GREEN_YELLOW|$5                 ; $fcda (C)
    .byte   BLACK0|$0                       ; $fcdb (C)
    .byte   BLUE_CYAN|$8                    ; $fcdc (C)
    .byte   BLUE_CYAN|$8                    ; $fcdd (C)
    .byte   BLUE_CYAN|$8                    ; $fcde (C)
    .byte   BLUE_CYAN|$8                    ; $fcdf (C)
    .byte   BLUE_CYAN|$8                    ; $fce0 (C)
    .byte   BLUE_CYAN|$8                    ; $fce1 (C)
    .byte   BLUE_CYAN|$8                    ; $fce2 (C)
    .byte   BLUE_CYAN|$8                    ; $fce3 (C)
    .byte   BLUE_CYAN|$8                    ; $fce4 (C)
    .byte   BLUE_CYAN|$8                    ; $fce5 (C)
    .byte   BLACK0|$0                       ; $fce6 (C)
    .byte   BLACK0|$0                       ; $fce7 (C)
    
    .byte   %00001100 ; |    ##  |            $fce8 (G)
    .byte   %00000100 ; |     #  |            $fce9 (G)
    .byte   %10001110 ; |#   ### |            $fcea (G)
    .byte   %01111101 ; | ##### #|            $fceb (G)
    .byte   %01001011 ; | #  # ##|            $fcec (G)
    .byte   %00001110 ; |    ### |            $fced (G)
    .byte   %00001000 ; |    #   |            $fcee (G)
    .byte   %01111000 ; | ####   |            $fcef (G)
    .byte   %00001100 ; |    ##  |            $fcf0 (G)
    .byte   %00000100 ; |     #  |            $fcf1 (G)
    .byte   %01001110 ; | #  ### |            $fcf2 (G)
    .byte   %01111101 ; | ##### #|            $fcf3 (G)
    .byte   %10001011 ; |#   # ##|            $fcf4 (G)
    .byte   %00001110 ; |    ### |            $fcf5 (G)
    .byte   %00001000 ; |    #   |            $fcf6 (G)
    .byte   %00001111 ; |    ####|            $fcf7 (G)
    
    .byte   BLACK0|$0                       ; $fcf8 (C)
    .byte   BLACK0|$0                       ; $fcf9 (C)
    .byte   BLACK1|$a                       ; $fcfa (C)
    .byte   BLACK1|$a                       ; $fcfb (C)
    .byte   BLACK1|$a                       ; $fcfc (C)
    .byte   BLACK1|$a                       ; $fcfd (C)
    .byte   BLACK1|$a                       ; $fcfe (C)
    .byte   GREEN_YELLOW|$3                 ; $fcff (C)
    
    .byte   %10010010 ; |#  #  # |            $fd00 (G)
    .byte   %11001100 ; |##  ##  |            $fd01 (G)
    .byte   %00111100 ; |  ####  |            $fd02 (G)
    .byte   %01011110 ; | # #### |            $fd03 (G)
    .byte   %00100011 ; |  #   ##|            $fd04 (G)
    .byte   %01001001 ; | #  #  #|            $fd05 (G)
    .byte   %00011011 ; |   ## ##|            $fd06 (G)
    .byte   %00001110 ; |    ### |            $fd07 (G)
    .byte   %10100001 ; |# #    #|            $fd08 (G)
    .byte   %01001100 ; | #  ##  |            $fd09 (G)
    .byte   %10111100 ; |# ####  |            $fd0a (G)
    .byte   %00011110 ; |   #### |            $fd0b (G)
    .byte   %01100011 ; | ##   ##|            $fd0c (G)
    .byte   %01001001 ; | #  #  #|            $fd0d (G)
    .byte   %00011011 ; |   ## ##|            $fd0e (G)
    .byte   %00001110 ; |    ### |            $fd0f (G)
    
    .byte   BLACK1|$3                       ; $fd10 (C)
    .byte   BLACK1|$3                       ; $fd11 (C)
    .byte   BLACK1|$3                       ; $fd12 (C)
    .byte   BLACK1|$3                       ; $fd13 (C)
    .byte   BLACK1|$3                       ; $fd14 (C)
    .byte   BLACK1|$3                       ; $fd15 (C)
    .byte   BLACK1|$3                       ; $fd16 (C)
    .byte   BLACK1|$3                       ; $fd17 (C)
    
    .byte   %00011000 ; |   ##   |            $fd18 (G)
    .byte   %00111100 ; |  ####  |            $fd19 (G)
    .byte   %01111110 ; | ###### |            $fd1a (G)
    .byte   %11111111 ; |########|            $fd1b (G)
    .byte   %11111111 ; |########|            $fd1c (G)
    .byte   %01111110 ; | ###### |            $fd1d (G)
    .byte   %00111100 ; |  ####  |            $fd1e (G)
    .byte   %00011000 ; |   ##   |            $fd1f (G)
    .byte   %00011000 ; |   ##   |            $fd20 (G)
    .byte   %00111100 ; |  ####  |            $fd21 (G)
    .byte   %01100110 ; | ##  ## |            $fd22 (G)
    .byte   %11111111 ; |########|            $fd23 (G)
    .byte   %11011011 ; |## ## ##|            $fd24 (G)
    .byte   %01111110 ; | ###### |            $fd25 (G)
    .byte   %00111100 ; |  ####  |            $fd26 (G)
    .byte   %00011000 ; |   ##   |            $fd27 (G)
    
    .byte   BLACK0|$8                       ; $fd28 (C)
    .byte   BLACK0|$8                       ; $fd29 (C)
    .byte   BLACK0|$8                       ; $fd2a (C)
    .byte   BLACK0|$8                       ; $fd2b (C)
    .byte   BLACK0|$8                       ; $fd2c (C)
    .byte   BLACK0|$8                       ; $fd2d (C)
    .byte   BLACK0|$8                       ; $fd2e (C)
    .byte   BLACK0|$8                       ; $fd2f (C)
    
    .byte   %00000000 ; |        |            $fd30 (G)
    .byte   %11111111 ; |########|            $fd31 (G)
    .byte   %11111111 ; |########|            $fd32 (G)
    .byte   %01111110 ; | ###### |            $fd33 (G)
    .byte   %01111110 ; | ###### |            $fd34 (G)
    .byte   %00111100 ; |  ####  |            $fd35 (G)
    .byte   %00011000 ; |   ##   |            $fd36 (G)
    
    .byte   BLACK0|$0                       ; $fd37 (C)
    .byte   BLACK0|$2                       ; $fd38 (C)
    .byte   BLACK0|$2                       ; $fd39 (C)
    .byte   BLACK0|$2                       ; $fd3a (C)
    .byte   BLACK0|$2                       ; $fd3b (C)
    .byte   BLACK0|$2                       ; $fd3c (C)
    .byte   BLACK0|$2                       ; $fd3d (C)
    
    .byte   %01000101 ; | #   # #|            $fd3e (G)
    .byte   %10101010 ; |# # # # |            $fd3f (G)
    .byte   %01011100 ; | # ###  |            $fd40 (G)
    .byte   %00111110 ; |  ##### |            $fd41 (G)
    .byte   %00101101 ; |  # ## #|            $fd42 (G)
    .byte   %11100000 ; |###     |            $fd43 (G)
    .byte   %01100000 ; | ##     |            $fd44 (G)
    .byte   %01010000 ; | # #    |            $fd45 (G)
    .byte   %00010100 ; |   # #  |            $fd46 (G)
    .byte   %00101010 ; |  # # # |            $fd47 (G)
    .byte   %01011101 ; | # ### #|            $fd48 (G)
    .byte   %00111110 ; |  ##### |            $fd49 (G)
    .byte   %00111100 ; |  ####  |            $fd4a (G)
    .byte   %11100000 ; |###     |            $fd4b (G)
    .byte   %01100000 ; | ##     |            $fd4c (G)
    .byte   %01010000 ; | # #    |            $fd4d (G)
    
    .byte   GREEN|$6                        ; $fd4e (C)
    .byte   GREEN|$6                        ; $fd4f (C)
    .byte   GREEN|$6                        ; $fd50 (C)
    .byte   GREEN|$6                        ; $fd51 (C)
    .byte   GREEN|$6                        ; $fd52 (C)
    .byte   GREEN|$6                        ; $fd53 (C)
    .byte   GREEN|$6                        ; $fd54 (C)
    .byte   GREEN|$6                        ; $fd55 (C)
    
Lfd56
    .byte   $02,$02,$02,$02,$02,$02,$04     ; $fd56 (D)
    
Lfd5d
    .byte   %11110000 ; |****    |            $fd5d (P)
    .byte   %11110000 ; |****    |            $fd5e (P)
    .byte   %11110000 ; |****    |            $fd5f (P)
    .byte   %11010000 ; |** *    |            $fd60 (P)
    .byte   %11000000 ; |**      |            $fd61 (P)
    .byte   %10000000 ; |*       |            $fd62 (P)
    .byte   %00000000 ; |        |            $fd63 (P)
Lfd64
    .byte   %11111111 ; |********|            $fd64 (P)
    .byte   %11111101 ; |****** *|            $fd65 (P)
    .byte   %11011101 ; |** *** *|            $fd66 (P)
    .byte   %11011100 ; |** ***  |            $fd67 (P)
    .byte   %01011000 ; | * **   |            $fd68 (P)
    .byte   %01001000 ; | *  *   |            $fd69 (P)
    .byte   %00001000 ; |    *   |            $fd6a (P)
Lfd6b
    .byte   %11111111 ; |********|            $fd6b (P)
    .byte   %11111110 ; |******* |            $fd6c (P)
    .byte   %11101110 ; |*** *** |            $fd6d (P)
    .byte   %11100110 ; |***  ** |            $fd6e (P)
    .byte   %11000110 ; |**   ** |            $fd6f (P)
    .byte   %10000100 ; |*    *  |            $fd70 (P)
    .byte   %10000000 ; |*       |            $fd71 (P)
    
Lfd72
    .byte   BLACK0|$4                       ; $fd72 (CB)
    .byte   GREEN_YELLOW|$8                 ; $fd73 (CB)
    .byte   BLACK1|$8                       ; $fd74 (CB)
    .byte   BLACK1|$8                       ; $fd75 (CB)
    .byte   YELLOW|$6                       ; $fd76 (CB)
    .byte   YELLOW|$6                       ; $fd77 (CB)
    .byte   ORANGE|$7                       ; $fd78 (CB)
    .byte   ORANGE|$7                       ; $fd79 (CB)
    .byte   ORANGE|$7                       ; $fd7a (CB)
    .byte   MAUVE|$a                        ; $fd7b (CB)
    .byte   MAUVE|$b                        ; $fd7c (CB)
    
Lfd7d
    .byte   %11110000 ; |****    |            $fd7d (P)
    .byte   %11110000 ; |****    |            $fd7e (P)
    .byte   %11000000 ; |**      |            $fd7f (P)
    .byte   %00000000 ; |        |            $fd80 (P)
    .byte   %00000000 ; |        |            $fd81 (P)
    .byte   %00000000 ; |        |            $fd82 (P)
    .byte   %00000000 ; |        |            $fd83 (P)
    .byte   %00000000 ; |        |            $fd84 (P)
Lfd85
    .byte   %11111111 ; |********|            $fd85 (P)
    .byte   %11111111 ; |********|            $fd86 (P)
    .byte   %11111111 ; |********|            $fd87 (P)
    .byte   %11111111 ; |********|            $fd88 (P)
    .byte   %11111111 ; |********|            $fd89 (P)
    .byte   %01111100 ; | *****  |            $fd8a (P)
    .byte   %00111000 ; |  ***   |            $fd8b (P)
    .byte   %00010000 ; |   *    |            $fd8c (P)
Lfd8d
    .byte   %11111111 ; |********|            $fd8d (P)
    .byte   %00111111 ; |  ******|            $fd8e (P)
    .byte   %00001111 ; |    ****|            $fd8f (P)
    .byte   %00000011 ; |      **|            $fd90 (P)
    .byte   %00000000 ; |        |            $fd91 (P)
    .byte   %00000000 ; |        |            $fd92 (P)
    .byte   %00000000 ; |        |            $fd93 (P)
    .byte   %00000000 ; |        |            $fd94 (P)
Lfd95
    .byte   %11111111 ; |********|            $fd95 (P)
    .byte   %11111111 ; |********|            $fd96 (P)
    .byte   %01111110 ; | ****** |            $fd97 (P)
    .byte   %01111110 ; | ****** |            $fd98 (P)
    .byte   %00111100 ; |  ****  |            $fd99 (P)
    .byte   %00111100 ; |  ****  |            $fd9a (P)
    .byte   %00011000 ; |   **   |            $fd9b (P)
    .byte   %00011000 ; |   **   |            $fd9c (P)
    .byte   %00000000 ; |        |            $fd9d (G)
    .byte   %00111100 ; |  ####  |            $fd9e (G)
    .byte   %00011100 ; |   ###  |            $fd9f (G)
    .byte   %00011100 ; |   ###  |            $fda0 (G)
    .byte   %00011100 ; |   ###  |            $fda1 (G)
    .byte   %00011100 ; |   ###  |            $fda2 (G)
    .byte   %00011100 ; |   ###  |            $fda3 (G)
    .byte   %00011100 ; |   ###  |            $fda4 (G)
    .byte   %00011100 ; |   ###  |            $fda5 (G)
    .byte   %00110110 ; |  ## ## |            $fda6 (G)
    .byte   %00101010 ; |  # # # |            $fda7 (G)
    .byte   %00101010 ; |  # # # |            $fda8 (G)
    .byte   %00101010 ; |  # # # |            $fda9 (G)
    .byte   %00101010 ; |  # # # |            $fdaa (G)
    .byte   %00101010 ; |  # # # |            $fdab (G)
    .byte   %00110110 ; |  ## ## |            $fdac (G)
    .byte   %00011100 ; |   ###  |            $fdad (G)
    .byte   %00111000 ; |  ###   |            $fdae (G)
    .byte   %00111100 ; |  ####  |            $fdaf (G)
    .byte   %00111100 ; |  ####  |            $fdb0 (G)
    .byte   %01111100 ; | #####  |            $fdb1 (G)
    .byte   %00111100 ; |  ####  |            $fdb2 (G)
    .byte   %11111110 ; |####### |            $fdb3 (G)
    .byte   %01111100 ; | #####  |            $fdb4 (G)
    .byte   %01111100 ; | #####  |            $fdb5 (G)
    .byte   %01111100 ; | #####  |            $fdb6 (G)
    .byte   %00111000 ; |  ###   |            $fdb7 (G)
    .byte   %00000000 ; |        |            $fdb8 (G)
    .byte   %01100110 ; | ##  ## |            $fdb9 (G)
    .byte   %11100011 ; |###   ##|            $fdba (G)
    .byte   %00100010 ; |  #   # |            $fdbb (G)
    .byte   %00110110 ; |  ## ## |            $fdbc (G)
    .byte   %00110110 ; |  ## ## |            $fdbd (G)
    .byte   %00011100 ; |   ###  |            $fdbe (G)
    .byte   %00011100 ; |   ###  |            $fdbf (G)
    .byte   %00011100 ; |   ###  |            $fdc0 (G)
    .byte   %00111110 ; |  ##### |            $fdc1 (G)
    .byte   %01011110 ; | # #### |            $fdc2 (G)
    .byte   %01101110 ; | ## ### |            $fdc3 (G)
    .byte   %00110110 ; |  ## ## |            $fdc4 (G)
    .byte   %00011010 ; |   ## # |            $fdc5 (G)
    .byte   %00101110 ; |  # ### |            $fdc6 (G)
    .byte   %00110110 ; |  ## ## |            $fdc7 (G)
    .byte   %00011100 ; |   ###  |            $fdc8 (G)
    .byte   %00111000 ; |  ###   |            $fdc9 (G)
    .byte   %00111100 ; |  ####  |            $fdca (G)
    .byte   %00111100 ; |  ####  |            $fdcb (G)
    .byte   %01111100 ; | #####  |            $fdcc (G)
    .byte   %00111100 ; |  ####  |            $fdcd (G)
    .byte   %11111110 ; |####### |            $fdce (G)
    .byte   %01111100 ; | #####  |            $fdcf (G)
    .byte   %01111100 ; | #####  |            $fdd0 (G)
    .byte   %01111100 ; | #####  |            $fdd1 (G)
    .byte   %00111000 ; |  ###   |            $fdd2 (G)
    
Lfdd3
    .byte   BLACK0|$0                       ; $fdd3 (C)
    .byte   BLACK0|$0                       ; $fdd4 (C)
    .byte   CYAN|$2                         ; $fdd5 (C)
    .byte   CYAN|$2                         ; $fdd6 (C)
    .byte   CYAN|$2                         ; $fdd7 (C)
    .byte   CYAN|$2                         ; $fdd8 (C)
    .byte   CYAN|$2                         ; $fdd9 (C)
    .byte   CYAN|$2                         ; $fdda (C)
    .byte   CYAN|$2                         ; $fddb (C)
    .byte   CYAN|$2                         ; $fddc (C)
    .byte   CYAN|$2                         ; $fddd (C)
    .byte   CYAN|$2                         ; $fdde (C)
    .byte   CYAN|$2                         ; $fddf (C)
    .byte   CYAN|$2                         ; $fde0 (C)
    .byte   CYAN|$2                         ; $fde1 (C)
    .byte   CYAN|$2                         ; $fde2 (C)
    .byte   CYAN|$2                         ; $fde3 (C)
    .byte   ORANGE|$6                       ; $fde4 (C)
    .byte   ORANGE|$6                       ; $fde5 (C)
    .byte   ORANGE|$6                       ; $fde6 (C)
    .byte   ORANGE|$6                       ; $fde7 (C)
    .byte   ORANGE|$6                       ; $fde8 (C)
    .byte   CYAN|$2                         ; $fde9 (C)
    .byte   CYAN|$2                         ; $fdea (C)
    .byte   CYAN|$2                         ; $fdeb (C)
    .byte   CYAN|$2                         ; $fdec (C)
    .byte   CYAN|$2                         ; $fded (C)
    
Lfdee
    .byte   %11001100 ; |**  **  |            $fdee (P)
    .byte   %01100110 ; | **  ** |            $fdef (P)
    .byte   %00110011 ; |  **  **|            $fdf0 (P)
    .byte   %10011001 ; |*  **  *|            $fdf1 (P)
Lfdf2
    .byte   %00110011 ; |  **  **|            $fdf2 (P)
    .byte   %01100110 ; | **  ** |            $fdf3 (P)
    .byte   %11001100 ; |**  **  |            $fdf4 (P)
    .byte   %10011001 ; |*  **  *|            $fdf5 (P)
Lfdf6
    .byte   %11011101 ; |** *** *|            $fdf6 (P)
    .byte   %10111011 ; |* *** **|            $fdf7 (P)
    .byte   %01110111 ; | *** ***|            $fdf8 (P)
    .byte   %11101110 ; |*** *** |            $fdf9 (P)
Lfdfa
    .byte   %10111011 ; |* *** **|            $fdfa (P)
    .byte   %11011101 ; |** *** *|            $fdfb (P)
    .byte   %11101110 ; |*** *** |            $fdfc (P)
    .byte   %01110111 ; | *** ***|            $fdfd (P)
    
Lfdfe
    .byte   RED|$4                          ; $fdfe (C)
    .byte   RED|$c                          ; $fdff (C)
    .byte   CYAN_GREEN|$4                   ; $fe00 (C)
    .byte   CYAN_GREEN|$c                   ; $fe01 (C)
    .byte   MAUVE|$4                        ; $fe02 (C)
    .byte   MAUVE|$c                        ; $fe03 (C)
    .byte   CYAN|$4                         ; $fe04 (C)
    .byte   CYAN|$c                         ; $fe05 (C)
    .byte   VIOLET|$4                       ; $fe06 (C)
    .byte   VIOLET|$c                       ; $fe07 (C)
    .byte   BLACK1|$c                       ; $fe08 (C)
    .byte   BLACK1|$4                       ; $fe09 (C)
    .byte   YELLOW|$4                       ; $fe0a (C)
    .byte   GREEN_YELLOW|$4                 ; $fe0b (C)
    .byte   ORANGE|$4                       ; $fe0c (C)
    .byte   GREEN|$4                        ; $fe0d (C)
Lfe0e
    .byte   BLACK0|$c                       ; $fe0e (C)
    .byte   BLACK1|$c                       ; $fe0f (C)
    .byte   BLUE_CYAN|$c                    ; $fe10 (C)
    .byte   CYAN|$c                         ; $fe11 (C)
    .byte   ORANGE|$c                       ; $fe12 (C)
    .byte   GREEN_YELLOW|$c                 ; $fe13 (C)
    
    .byte   $00,$7e,$3c,$3c,$18,$a5,$42,$00 ; $fe14 (*)
    
    .byte   %00000000 ; |        |            $fe1c (G)
    .byte   %00000000 ; |        |            $fe1d (G)
    .byte   %00000000 ; |        |            $fe1e (G)
    .byte   %00000000 ; |        |            $fe1f (G)
    .byte   %00000000 ; |        |            $fe20 (G)
    .byte   %00000000 ; |        |            $fe21 (G)
    .byte   %00000000 ; |        |            $fe22 (G)
    .byte   %00000000 ; |        |            $fe23 (G)
    .byte   %00000000 ; |        |            $fe24 (G)
    .byte   %00000000 ; |        |            $fe25 (G)
    .byte   %00000000 ; |        |            $fe26 (G)
    .byte   %00000000 ; |        |            $fe27 (G)
    .byte   %00000000 ; |        |            $fe28 (G)
    .byte   %00000000 ; |        |            $fe29 (G)
    .byte   %00000000 ; |        |            $fe2a (G)
    .byte   %00000000 ; |        |            $fe2b (G)
    .byte   %00000000 ; |        |            $fe2c (G)
    .byte   %00000000 ; |        |            $fe2d (G)
    .byte   %00000000 ; |        |            $fe2e (G)
    .byte   %00000000 ; |        |            $fe2f (G)
    .byte   %00000000 ; |        |            $fe30 (G)
    .byte   %00000000 ; |        |            $fe31 (G)
    .byte   %00000000 ; |        |            $fe32 (G)
    .byte   %00000000 ; |        |            $fe33 (G)
    .byte   %00000000 ; |        |            $fe34 (G)
    .byte   %00000000 ; |        |            $fe35 (G)
    .byte   %00000000 ; |        |            $fe36 (G)
    .byte   %00000000 ; |        |            $fe37 (G)
    .byte   %00000000 ; |        |            $fe38 (G)
    .byte   %00000000 ; |        |            $fe39 (G)
    .byte   %00000000 ; |        |            $fe3a (G)
    .byte   %00000000 ; |        |            $fe3b (G)
    .byte   %00000000 ; |        |            $fe3c (G)
    .byte   %00000000 ; |        |            $fe3d (G)
    .byte   %00000000 ; |        |            $fe3e (G)
    .byte   %00000000 ; |        |            $fe3f (G)
    .byte   %00000000 ; |        |            $fe40 (G)
    .byte   %00000000 ; |        |            $fe41 (G)
    .byte   %00000000 ; |        |            $fe42 (G)
    .byte   %00000000 ; |        |            $fe43 (G)
    .byte   %00000000 ; |        |            $fe44 (G)
    .byte   %00000000 ; |        |            $fe45 (G)
    .byte   %00000000 ; |        |            $fe46 (G)
    .byte   %00000000 ; |        |            $fe47 (G)
    .byte   %00000000 ; |        |            $fe48 (G)
    .byte   %00000000 ; |        |            $fe49 (G)
    .byte   %00000000 ; |        |            $fe4a (G)
    .byte   %00000000 ; |        |            $fe4b (G)
    .byte   %00000000 ; |        |            $fe4c (G)
    .byte   %00000000 ; |        |            $fe4d (G)
    .byte   %00000000 ; |        |            $fe4e (G)
    .byte   %00000000 ; |        |            $fe4f (G)
    .byte   %00000000 ; |        |            $fe50 (G)
    .byte   %00000000 ; |        |            $fe51 (G)
    .byte   %00000000 ; |        |            $fe52 (G)
    .byte   %00000000 ; |        |            $fe53 (G)
    
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fe54 (*)
    .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; $fe5c (*)
    
    .byte   %00111100 ; |  ####  |            $fe64 (G)
    .byte   %01100110 ; | ##  ## |            $fe65 (G)
    .byte   %01100110 ; | ##  ## |            $fe66 (G)
    .byte   %01100110 ; | ##  ## |            $fe67 (G)
    .byte   %01100110 ; | ##  ## |            $fe68 (G)
    .byte   %01100110 ; | ##  ## |            $fe69 (G)
    .byte   %01100110 ; | ##  ## |            $fe6a (G)
    .byte   %00111100 ; |  ####  |            $fe6b (G)
    .byte   %00111100 ; |  ####  |            $fe6c (G)
    .byte   %00011000 ; |   ##   |            $fe6d (G)
    .byte   %00011000 ; |   ##   |            $fe6e (G)
    .byte   %00011000 ; |   ##   |            $fe6f (G)
    .byte   %00011000 ; |   ##   |            $fe70 (G)
    .byte   %00011000 ; |   ##   |            $fe71 (G)
    .byte   %00111000 ; |  ###   |            $fe72 (G)
    .byte   %00011000 ; |   ##   |            $fe73 (G)
    .byte   %01111110 ; | ###### |            $fe74 (G)
    .byte   %01100000 ; | ##     |            $fe75 (G)
    .byte   %01100000 ; | ##     |            $fe76 (G)
    .byte   %00111100 ; |  ####  |            $fe77 (G)
    .byte   %00000110 ; |     ## |            $fe78 (G)
    .byte   %00000110 ; |     ## |            $fe79 (G)
    .byte   %01000110 ; | #   ## |            $fe7a (G)
    .byte   %00111100 ; |  ####  |            $fe7b (G)
    .byte   %00111100 ; |  ####  |            $fe7c (G)
    .byte   %01000110 ; | #   ## |            $fe7d (G)
    .byte   %00000110 ; |     ## |            $fe7e (G)
    .byte   %00001100 ; |    ##  |            $fe7f (G)
    .byte   %00001100 ; |    ##  |            $fe80 (G)
    .byte   %00000110 ; |     ## |            $fe81 (G)
    .byte   %01000110 ; | #   ## |            $fe82 (G)
    .byte   %00111100 ; |  ####  |            $fe83 (G)
    .byte   %00001100 ; |    ##  |            $fe84 (G)
    .byte   %00001100 ; |    ##  |            $fe85 (G)
    .byte   %00001100 ; |    ##  |            $fe86 (G)
    .byte   %01111110 ; | ###### |            $fe87 (G)
    .byte   %01001100 ; | #  ##  |            $fe88 (G)
    .byte   %00101100 ; |  # ##  |            $fe89 (G)
    .byte   %00011100 ; |   ###  |            $fe8a (G)
    .byte   %00001100 ; |    ##  |            $fe8b (G)
    .byte   %01111100 ; | #####  |            $fe8c (G)
    .byte   %01000110 ; | #   ## |            $fe8d (G)
    .byte   %00000110 ; |     ## |            $fe8e (G)
    .byte   %00000110 ; |     ## |            $fe8f (G)
    .byte   %01111100 ; | #####  |            $fe90 (G)
    .byte   %01100000 ; | ##     |            $fe91 (G)
    .byte   %01100000 ; | ##     |            $fe92 (G)
    .byte   %01111110 ; | ###### |            $fe93 (G)
    .byte   %00111100 ; |  ####  |            $fe94 (G)
    .byte   %01100110 ; | ##  ## |            $fe95 (G)
    .byte   %01100110 ; | ##  ## |            $fe96 (G)
    .byte   %01100110 ; | ##  ## |            $fe97 (G)
    .byte   %01111100 ; | #####  |            $fe98 (G)
    .byte   %01100000 ; | ##     |            $fe99 (G)
    .byte   %01100010 ; | ##   # |            $fe9a (G)
    .byte   %00111100 ; |  ####  |            $fe9b (G)
    .byte   %00011000 ; |   ##   |            $fe9c (G)
    .byte   %00011000 ; |   ##   |            $fe9d (G)
    .byte   %00011000 ; |   ##   |            $fe9e (G)
    .byte   %00011000 ; |   ##   |            $fe9f (G)
    .byte   %00001100 ; |    ##  |            $fea0 (G)
    .byte   %00000110 ; |     ## |            $fea1 (G)
    .byte   %01000010 ; | #    # |            $fea2 (G)
    .byte   %01111110 ; | ###### |            $fea3 (G)
    .byte   %00111100 ; |  ####  |            $fea4 (G)
    .byte   %01100110 ; | ##  ## |            $fea5 (G)
    .byte   %01100110 ; | ##  ## |            $fea6 (G)
    .byte   %00111100 ; |  ####  |            $fea7 (G)
    .byte   %00111100 ; |  ####  |            $fea8 (G)
    .byte   %01100110 ; | ##  ## |            $fea9 (G)
    .byte   %01100110 ; | ##  ## |            $feaa (G)
    .byte   %00111100 ; |  ####  |            $feab (G)
    .byte   %00111100 ; |  ####  |            $feac (G)
    .byte   %01000110 ; | #   ## |            $fead (G)
    .byte   %00000110 ; |     ## |            $feae (G)
    .byte   %00111110 ; |  ##### |            $feaf (G)
    .byte   %01100110 ; | ##  ## |            $feb0 (G)
    .byte   %01100110 ; | ##  ## |            $feb1 (G)
    .byte   %01100110 ; | ##  ## |            $feb2 (G)
    .byte   %00111100 ; |  ####  |            $feb3 (G)
Lfeb4
    .byte   %00001110 ; |    ### |            $feb4 (G)
    .byte   %00001110 ; |    ### |            $feb5 (G)
    .byte   %00010001 ; |   #   #|            $feb6 (G)
    .byte   %00001110 ; |    ### |            $feb7 (G)
    .byte   %00001110 ; |    ### |            $feb8 (G)
    .byte   %00010001 ; |   #   #|            $feb9 (G)
    .byte   %00001110 ; |    ### |            $feba (G)
    .byte   %00001110 ; |    ### |            $febb (G)
    
    .byte   $11,$0e,$0e,$11,$1f             ; $febc (D)
Lfec1
    .byte   $26,$26,$29,$37,$37,$3a,$26,$26 ; $fec1 (D)
    .byte   $29,$48,$48,$4b,$54             ; $fec9 (D)
Lfece
    .byte   $02,$02,$0d,$02,$02,$0d,$02,$02 ; $fece (D)
    .byte   $0d,$02,$02,$08,$06             ; $fed6 (D)
    .byte   $03                             ; $fedb (*)
Lfedc
    .byte   $f0,$f1,$f1,$f1,$f1             ; $fedc (D)
Lfee1
    .byte   $f4,$19,$3f,$61,$80             ; $fee1 (D)
Lfee6
    .byte   $fb,$fb,$fb,$fc,$fd             ; $fee6 (D)
Lfeeb
    .byte   $00,$1b,$30,$e8,$18             ; $feeb (D)
Lfef0
    .byte   $09,$22                         ; $fef0 (D)
    .byte   $30                             ; $fef2 (*)
    .byte   $f0,$20                         ; $fef3 (D)
Lfef5
    .byte   $12,$29,$30,$f8,$28             ; $fef5 (D)
Lfefa
    .byte   $00,$04,$00,$00,$07             ; $fefa (D)
Lfeff
    .byte   $08,$06,$0f,$07,$07             ; $feff (D)
    
Lff04
    .byte   CYAN|$b                         ; $ff04 (CB)
    .byte   CYAN|$9                         ; $ff05 (CB)
    .byte   BLACK0|$8                       ; $ff06 (CB)
    .byte   CYAN|$b                         ; $ff07 (CB)
    .byte   CYAN|$b                         ; $ff08 (CB)
    
Lff09
    .byte   $02,$10,$00,$02,$10,$01,$01,$03 ; $ff09 (D)
    .byte   $01,$00,$00,$01,$01,$01,$01,$01 ; $ff11 (D)
    .byte   $01,$03,$03,$03,$03,$0f,$03,$03 ; $ff19 (D)
    .byte   $01,$01,$01,$01,$0f             ; $ff21 (D)
    .byte   $0e                             ; $ff26 (A)
    .byte   $0f                             ; $ff27 (A)
    .byte   $0e                             ; $ff28 (A)
    .byte   $0e                             ; $ff29 (A)
    .byte   $0c                             ; $ff2a (A)
    .byte   $0e                             ; $ff2b (A)
    .byte   $0f                             ; $ff2c (A)
    .byte   $0e                             ; $ff2d (A)
    .byte   $13                             ; $ff2e (A)
    .byte   $11                             ; $ff2f (A)
    .byte   $0f                             ; $ff30 (A)
    .byte   $0e                             ; $ff31 (A)
    .byte   $0c                             ; $ff32 (A)
    .byte   $0e                             ; $ff33 (A)
    .byte   $0f                             ; $ff34 (A)
    .byte   $0e                             ; $ff35 (A)
    .byte   $0c                             ; $ff36 (A)
    .byte   $0c                             ; $ff37 (A)
    .byte   $0d                             ; $ff38 (A)
    .byte   $0c                             ; $ff39 (A)
    .byte   $0c                             ; $ff3a (A)
    .byte   $0b                             ; $ff3b (A)
    .byte   $0c                             ; $ff3c (A)
    .byte   $0d                             ; $ff3d (A)
    .byte   $0c                             ; $ff3e (A)
    .byte   $11                             ; $ff3f (A)
    .byte   $0f                             ; $ff40 (A)
    .byte   $0e                             ; $ff41 (A)
    .byte   $0c                             ; $ff42 (A)
    .byte   $0b                             ; $ff43 (A)
    .byte   $0c                             ; $ff44 (A)
    .byte   $0e                             ; $ff45 (A)
    .byte   $11                             ; $ff46 (A)
    .byte   $13                             ; $ff47 (A)
    .byte   $0a                             ; $ff48 (A)
    .byte   $0b                             ; $ff49 (A)
    .byte   $0a                             ; $ff4a (A)
    .byte   $0c                             ; $ff4b (A)
    .byte   $0b                             ; $ff4c (A)
    .byte   $0c                             ; $ff4d (A)
    .byte   $0e                             ; $ff4e (A)
    .byte   $11                             ; $ff4f (A)
    .byte   $13                             ; $ff50 (A)
    .byte   $11                             ; $ff51 (A)
    .byte   $0f                             ; $ff52 (A)
    .byte   $0e                             ; $ff53 (A)
    .byte   $0c                             ; $ff54 (A)
    .byte   $11                             ; $ff55 (A)
    .byte   $0e                             ; $ff56 (A)
    .byte   $0f                             ; $ff57 (A)
    .byte   $11                             ; $ff58 (A)
    .byte   $0f                             ; $ff59 (A)
    .byte   $0e                             ; $ff5a (A)
Lff5b
    .byte   $00                             ; $ff5b (*)
    .byte   $0c                             ; $ff5c (A)
    .byte   $09                             ; $ff5d (A)
    .byte   $0c                             ; $ff5e (A)
    .byte   $0e                             ; $ff5f (A)
Lff60
    .byte   $00                             ; $ff60 (*)
    .byte   $0a                             ; $ff61 (A)
    .byte   $09                             ; $ff62 (A)
    .byte   $0b                             ; $ff63 (A)
    .byte   $07                             ; $ff64 (A)
    
    .byte   %00000000 ; |        |            $ff65 (G)
    .byte   %01100110 ; | ##  ## |            $ff66 (G)
    .byte   %01000101 ; | #   # #|            $ff67 (G)
    .byte   %10111100 ; |# ####  |            $ff68 (G)
    .byte   %00111100 ; |  ####  |            $ff69 (G)
    .byte   %00101100 ; |  # ##  |            $ff6a (G)
    .byte   %01111010 ; | #### # |            $ff6b (G)
    .byte   %11110111 ; |#### ###|            $ff6c (G)
    .byte   %11011111 ; |## #####|            $ff6d (G)
    .byte   %11111011 ; |##### ##|            $ff6e (G)
    .byte   %10101111 ; |# # ####|            $ff6f (G)
    .byte   %01111010 ; | #### # |            $ff70 (G)
    .byte   %00111100 ; |  ####  |            $ff71 (G)
    .byte   %00111100 ; |  ####  |            $ff72 (G)
    .byte   %01010101 ; | # # # #|            $ff73 (G)
    .byte   %10101010 ; |# # # # |            $ff74 (G)
    .byte   %00111100 ; |  ####  |            $ff75 (G)
    .byte   %00111100 ; |  ####  |            $ff76 (G)
    .byte   %00111100 ; |  ####  |            $ff77 (G)
    .byte   %00111100 ; |  ####  |            $ff78 (G)
    .byte   %01010100 ; | # # #  |            $ff79 (G)
    .byte   %00101010 ; |  # # # |            $ff7a (G)
    .byte   %00011000 ; |   ##   |            $ff7b (G)
    .byte   %00111100 ; |  ####  |            $ff7c (G)
    .byte   %00111110 ; |  ##### |            $ff7d (G)
    .byte   %00110101 ; |  ## # #|            $ff7e (G)
    .byte   %01111100 ; | #####  |            $ff7f (G)
    .byte   %00111100 ; |  ####  |            $ff80 (G)
    .byte   %10011001 ; |#  ##  #|            $ff81 (G)
    .byte   %01111110 ; | ###### |            $ff82 (G)
    .byte   %00100100 ; |  #  #  |            $ff83 (G)
    .byte   %00000000 ; |        |            $ff84 (G)
    .byte   %00011100 ; |   ###  |            $ff85 (G)
    .byte   %00011010 ; |   ## # |            $ff86 (G)
    .byte   %00011000 ; |   ##   |            $ff87 (G)
    .byte   %00111100 ; |  ####  |            $ff88 (G)
    .byte   %00101100 ; |  # ##  |            $ff89 (G)
    .byte   %01111010 ; | #### # |            $ff8a (G)
    .byte   %11110111 ; |#### ###|            $ff8b (G)
    .byte   %11011111 ; |## #####|            $ff8c (G)
    .byte   %11111011 ; |##### ##|            $ff8d (G)
    .byte   %10101111 ; |# # ####|            $ff8e (G)
    .byte   %01111010 ; | #### # |            $ff8f (G)
    .byte   %00111100 ; |  ####  |            $ff90 (G)
    .byte   %00111100 ; |  ####  |            $ff91 (G)
    .byte   %01010101 ; | # # # #|            $ff92 (G)
    .byte   %10101010 ; |# # # # |            $ff93 (G)
    .byte   %00111100 ; |  ####  |            $ff94 (G)
    .byte   %00111100 ; |  ####  |            $ff95 (G)
    .byte   %00111100 ; |  ####  |            $ff96 (G)
    .byte   %00111100 ; |  ####  |            $ff97 (G)
    .byte   %01010100 ; | # # #  |            $ff98 (G)
    .byte   %00101010 ; |  # # # |            $ff99 (G)
    .byte   %00011000 ; |   ##   |            $ff9a (G)
    .byte   %00111100 ; |  ####  |            $ff9b (G)
    .byte   %00111110 ; |  ##### |            $ff9c (G)
    .byte   %00110101 ; |  ## # #|            $ff9d (G)
    .byte   %01111100 ; | #####  |            $ff9e (G)
    .byte   %00111100 ; |  ####  |            $ff9f (G)
    .byte   %10011001 ; |#  ##  #|            $ffa0 (G)
    .byte   %01111110 ; | ###### |            $ffa1 (G)
    .byte   %00100100 ; |  #  #  |            $ffa2 (G)
    .byte   %00000000 ; |        |            $ffa3 (G)
    .byte   %01100100 ; | ##  #  |            $ffa4 (G)
    .byte   %11000110 ; |##   ## |            $ffa5 (G)
    .byte   %00101001 ; |  # #  #|            $ffa6 (G)
    .byte   %01111110 ; | ###### |            $ffa7 (G)
    .byte   %11111111 ; |########|            $ffa8 (G)
    .byte   %11111111 ; |########|            $ffa9 (G)
    .byte   %01111110 ; | ###### |            $ffaa (G)
    .byte   %01010101 ; | # # # #|            $ffab (G)
    .byte   %10101010 ; |# # # # |            $ffac (G)
    .byte   %00111100 ; |  ####  |            $ffad (G)
    .byte   %00111100 ; |  ####  |            $ffae (G)
    .byte   %00111100 ; |  ####  |            $ffaf (G)
    .byte   %01010100 ; | # # #  |            $ffb0 (G)
    .byte   %00101010 ; |  # # # |            $ffb1 (G)
    .byte   %00011000 ; |   ##   |            $ffb2 (G)
    .byte   %00111100 ; |  ####  |            $ffb3 (G)
    .byte   %00111110 ; |  ##### |            $ffb4 (G)
    .byte   %00110101 ; |  ## # #|            $ffb5 (G)
    .byte   %01111100 ; | #####  |            $ffb6 (G)
    .byte   %00111100 ; |  ####  |            $ffb7 (G)
    .byte   %10011001 ; |#  ##  #|            $ffb8 (G)
    .byte   %01111110 ; | ###### |            $ffb9 (G)
    .byte   %00100100 ; |  #  #  |            $ffba (G)
    
    .byte   BLACK0|$0                       ; $ffbb (C)
    .byte   BLUE_CYAN|$8                    ; $ffbc (C)
    .byte   BLUE_CYAN|$8                    ; $ffbd (C)
    .byte   BLUE_CYAN|$8                    ; $ffbe (C)
    .byte   ORANGE|$3                       ; $ffbf (C)
    .byte   ORANGE|$3                       ; $ffc0 (C)
    .byte   ORANGE|$3                       ; $ffc1 (C)
    .byte   ORANGE|$3                       ; $ffc2 (C)
    .byte   ORANGE|$3                       ; $ffc3 (C)
    .byte   ORANGE|$3                       ; $ffc4 (C)
    .byte   ORANGE|$3                       ; $ffc5 (C)
    .byte   ORANGE|$3                       ; $ffc6 (C)
    .byte   ORANGE|$3                       ; $ffc7 (C)
    .byte   ORANGE|$3                       ; $ffc8 (C)
    .byte   BLACK1|$8                       ; $ffc9 (C)
    .byte   BLACK1|$8                       ; $ffca (C)
    .byte   ORANGE|$3                       ; $ffcb (C)
    .byte   ORANGE|$3                       ; $ffcc (C)
    .byte   ORANGE|$3                       ; $ffcd (C)
    .byte   ORANGE|$3                       ; $ffce (C)
    .byte   BLUE_CYAN|$8                    ; $ffcf (C)
    .byte   BLUE_CYAN|$8                    ; $ffd0 (C)
    .byte   ORANGE|$6                       ; $ffd1 (C)
    .byte   ORANGE|$6                       ; $ffd2 (C)
    .byte   ORANGE|$6                       ; $ffd3 (C)
    .byte   ORANGE|$6                       ; $ffd4 (C)
    .byte   ORANGE|$6                       ; $ffd5 (C)
    .byte   BLUE_CYAN|$8                    ; $ffd6 (C)
    .byte   BLUE_CYAN|$8                    ; $ffd7 (C)
    .byte   BLUE_CYAN|$8                    ; $ffd8 (C)
    .byte   BLUE_CYAN|$8                    ; $ffd9 (C)
    .byte   BLACK0|$0                       ; $ffda (C)
    .byte   BLUE_CYAN|$8                    ; $ffdb (C)
    .byte   BLUE_CYAN|$8                    ; $ffdc (C)
    .byte   BLUE_CYAN|$8                    ; $ffdd (C)
    .byte   ORANGE|$3                       ; $ffde (C)
    .byte   ORANGE|$3                       ; $ffdf (C)
    .byte   ORANGE|$3                       ; $ffe0 (C)
    .byte   ORANGE|$3                       ; $ffe1 (C)
    .byte   BLACK1|$8                       ; $ffe2 (C)
    .byte   BLACK1|$8                       ; $ffe3 (C)
    .byte   ORANGE|$3                       ; $ffe4 (C)
    .byte   ORANGE|$3                       ; $ffe5 (C)
    .byte   ORANGE|$3                       ; $ffe6 (C)
    .byte   BLUE_CYAN|$8                    ; $ffe7 (C)
    .byte   BLUE_CYAN|$8                    ; $ffe8 (C)
    .byte   ORANGE|$6                       ; $ffe9 (C)
    .byte   ORANGE|$6                       ; $ffea (C)
    .byte   ORANGE|$6                       ; $ffeb (C)
    .byte   ORANGE|$6                       ; $ffec (C)
    .byte   ORANGE|$6                       ; $ffed (C)
    .byte   BLUE_CYAN|$8                    ; $ffee (C)
    .byte   BLUE_CYAN|$8                    ; $ffef (C)
    .byte   BLUE_CYAN|$8                    ; $fff0 (C)
    .byte   BLUE_CYAN|$8                    ; $fff1 (C)
    .byte   BLUE_CYAN|$5                    ; $fff2 (C)
    .byte   VIOLET|$c                       ; $fff3 (C)
    .byte   BLUE|$7                         ; $fff4 (C)
    .byte   BLUE_CYAN|$5                    ; $fff5 (C)
    .byte   RED|$0                          ; $fff6 (C)
    .byte   VIOLET|$9                       ; $fff7 (C)
    .byte   BLACK0|$1                       ; $fff8 (C)
    .byte   BLUE|$0                         ; $fff9 (C)
    .byte   BLACK0|$2                       ; $fffa (C)
    .byte   VIOLET|$9                       ; $fffb (C)
    .byte   BLACK0|$0                       ; $fffc (C)
    .byte   BLACKF|$0                       ; $fffd (C)
    .byte   PURPLE|$3                       ; $fffe (C)
    
    .byte   $aa                             ; $ffff (*)
