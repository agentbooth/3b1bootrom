MAPRAM_START EQU $400000
MAPRAM_END   EQU $4007ff
VRAM_START   EQU $420000
VRAM_END     EQU $427fff
BSR0         EQU $430000
BSR1         EQU $440000
TSR          EQU $450000
DMACOUNT     EQU $460000
LPSTATUS     EQU $470000
LPSTATBYTE   EQU $470001
DISKCONTROL  EQU $4e0000
CSR          EQU $4c0000
MCR          EQU $4a0000
DMA_ADDR     EQU $4d0000
WD1010       EQU $e00000
WD2797       EQU $e10000
MODEM        EQU $e60000
KBC          EQU $e70000
ROMLMAP      EQU $e43000
ERRENABLE    EQU $e40000
PARENABLE    EQU $e41000
L1MODEM      EQU $e44000
L2MODEM      EQU $e45000

DISKCNTLSAVE EQU $5000
MCRSAVE      EQU $5002
DMASOMETHING EQU $5004


80001A: 33FC 8000 00E4 3000      move.w  #$8000, ROMLMAP.l        ; ROMLMAP: normal addressing
800022: 33FC 0F00 004A 0000      move.w  #$f00, MCR.l             ; turn off LEDs
80002A: 4286                     clr.l   D6
80002C: 5206                     addq.b  #1, D6
80002E: 2006                     move.l  D6, D0
800030: 4600                     not.b   D0
800032: E148                     lsl.w   #8, D0
800034: 33C0 004A 0000           move.w  D0, MCR.l                ; LEDs to 1
80003A: 13FC 0000 004C 0000      move.b  #$0, CSR.l
800042: 33FC 0018 00E5 0004      move.w  #$18, $e50004.l          ; Init 7201 serial controller
80004A: 33FC 0018 00E5 0006      move.w  #$18, $e50006.l
800052: 33FC 00F0 00E5 0004      move.w  #$f0, $e50004.l
80005A: 33FC 00F0 00E5 0006      move.w  #$f0, $e50006.l
800062: 33FC 0300 00E7 0000      move.w  #$300, KBC.l             ; Init 6850 keyboard controller
80006A: 33FC 9500 00E7 0000      move.w  #$9500, KBC.l
800072: 33FC 8000 00E4 4000      move.w  #$8000, L1MODEM.l        ; Init modem
80007A: 33FC 8000 00E4 5000      move.w  #$8000, L2MODEM.l
800082: 33FC 0001 00E6 0000      move.w  #$1, MODEM.l
80008A: 223C 0000 00FF           move.l  #$ff, D1
800090: 51C9 FFFE                dbra    D1, $800090
800094: 33FC 0000 00E6 0000      move.w  #$0, MODEM.l
80009C: 33FC 4000 0049 0000      move.w  #$4000, $490000.l        ; Init telephone line control
8000A4: 33FC 4000 0049 1000      move.w  #$4000, $491000.l
8000AC: 4280                     clr.l   D0
8000AE: 3039 0045 0000           move.w  TSR.l, D0
8000B4: 0240 0001                andi.w  #$1, D0
8000B8: 6700 0012                beq     $8000cc
8000BC: 33FC 4000 0049 2000      move.w  #$4000, $492000.l
8000C4: 33FC 4000 0049 6000      move.w  #$4000, $496000.l
8000CC: 33FC 0000 0049 4000      move.w  #$0, $494000.l
8000D4: 33FC 0000 0049 5000      move.w  #$0, $495000.l
8000DC: 33FC 4000 0049 3000      move.w  #$4000, $493000.l
8000E4: 33FC 4000 0049 7000      move.w  #$4000, $497000.l
8000EC: 33FC 0000 004F 0000      move.w  #$0, $4f0000.l           ; Clear printer interrupt
8000F4: 13FC 0000 004B 0400      move.b  #$0, $4b0400.l           ; Clear dialer chip
8000FC: 13FC 0000 004B 0800      move.b  #$0, $4b0800.l
800104: 33FC 0000 0046 0000      move.w  #$0, DMACOUNT.l          ; Reset disk DMA
80010C: 33FC 0000 004D 0000      move.w  #$0, DMA_ADDR.l
800114: 5206                     addq.b  #1, D6
800116: 2006                     move.l  D6, D0
800118: 4600                     not.b   D0
80011A: E148                     lsl.w   #8, D0
80011C: 33C0 004A 0000           move.w  D0, MCR.l                ; LEDs to 2
800122: 207C 0042 0000           movea.l #VRAM_START, A0          ; Test VRAM
800128: 2C7C 0042 7FFF           movea.l #VRAM_END, A6
80012E: 4283                     clr.l   D3
800130: 2848                     movea.l A0, A4
800132: 3883                     move.w  D3, (A4)
800134: B65C                     cmp.w   (A4)+, D3
800136: 6600 0032                bne     $80016a
80013A: B9CE                     cmpa.l  A6, A4
80013C: 6E00 0008                bgt     $800146
800140: 5243                     addq.w  #1, D3
800142: 6000 FFEE                bra     $800132
800146: 4283                     clr.l   D3
800148: 2848                     movea.l A0, A4
80014A: B654                     cmp.w   (A4), D3
80014C: 6600 001C                bne     $80016a
800150: 38C3                     move.w  D3, (A4)+
800152: 5243                     addq.w  #1, D3
800154: B9CE                     cmpa.l  A6, A4
800156: 6F00 FFF2                ble     $80014a
80015A: 4283                     clr.l   D3
80015C: 2848                     movea.l A0, A4
80015E: 28C3                     move.l  D3, (A4)+
800160: B9CE                     cmpa.l  A6, A4
800162: 6D00 FFFA                blt     $80015e
800166: 6000 0008                bra     $800170
80016A: 4E72 2700                stop    #$2700        ; fatal error

80016E: 60FA                     bra     $80016a
800170: 5206                     addq.b  #1, D6
800172: 2006                     move.l  D6, D0
800174: 4600                     not.b   D0
800176: E148                     lsl.w   #8, D0
800178: 33C0 004A 0000           move.w  D0, MCR.l              ; LEDs to 3
80017E: 207C 0040 0000           movea.l #MAPRAM_START, A0      ; Test Map RAM
800184: 2C7C 0040 07FF           movea.l #MAPRAM_END, A6
80018A: 4283                     clr.l   D3
80018C: 3083                     move.w  D3, (A0)
80018E: B658                     cmp.w   (A0)+, D3
800190: 6600 0026                bne     $8001b8
800194: 5243                     addq.w  #1, D3
800196: B1CE                     cmpa.l  A6, A0
800198: 6F00 FFF2                ble     $80018c
80019C: 4283                     clr.l   D3
80019E: 207C 0040 0000           movea.l #MAPRAM_START, A0
8001A4: B650                     cmp.w   (A0), D3
8001A6: 6600 0010                bne     $8001b8                ; Map RAM test fail
8001AA: 30C3                     move.w  D3, (A0)+
8001AC: 5243                     addq.w  #1, D3
8001AE: B1CE                     cmpa.l  A6, A0
8001B0: 6F00 FFF2                ble     $8001a4
8001B4: 6000 0024                bra     $8001da

8001B8: 207C 0042 0000           movea.l #VRAM_START, A0        ; Map RAM test fail
8001BE: 2C7C 0042 7FFF           movea.l #VRAM_END, A6
8001C4: 4283                     clr.l   D3
8001C6: 3C3C FFFF                move.w  #$ffff, D6
8001CA: 30C6                     move.w  D6, (A0)+
8001CC: 30C3                     move.w  D3, (A0)+
8001CE: B1CE                     cmpa.l  A6, A0
8001D0: 6D00 FFF8                blt     $8001ca
8001D4: 4E72 2700                stop    #$2700        ; fatal error

8001D8: 60F0                     bra     $8001ca
8001DA: 5206                     addq.b  #1, D6
8001DC: 2006                     move.l  D6, D0
8001DE: 4600                     not.b   D0
8001E0: E148                     lsl.w   #8, D0
8001E2: 33C0 004A 0000           move.w  D0, MCR.l         ; LEDs to 4
8001E8: 263C 0000 A000           move.l  #$a000, D3        ; set Map RAM = write enabled, present not accessed
8001EE: 207C 0040 0000           movea.l #MAPRAM_START, A0
8001F4: 203C 0000 03FF           move.l  #$3ff, D0
8001FA: 30C3                     move.w  D3, (A0)+
8001FC: 5243                     addq.w  #1, D3            ; unity mapped
8001FE: 51C8 FFFA                dbra    D0, $8001fa
800202: 5206                     addq.b  #1, D6
800204: 2006                     move.l  D6, D0
800206: 4600                     not.b   D0
800208: E148                     lsl.w   #8, D0
80020A: 33C0 004A 0000           move.w  D0, MCR.l        ; LEDs to 5
800210: 207C 0000 0000           movea.l #$0, A0
800216: 2C7C 0007 FFFF           movea.l #$7ffff, A6
80021C: 2248                     movea.l A0, A1
80021E: 2608                     move.l  A0, D3
800220: 2289                     move.l  A1, (A1)
800222: B699                     cmp.l   (A1)+, D3
800224: 6600 0022                bne     $800248                ; RAM test fail
800228: B3CE                     cmpa.l  A6, A1
80022A: 6E00 0008                bgt     $800234
80022E: 5883                     addq.l  #4, D3
800230: 6000 FFEE                bra     $800220
800234: 2248                     movea.l A0, A1
800236: B3D1                     cmpa.l  (A1), A1
800238: 6600 000E                bne     $800248                ; RAM test fail
80023C: 22C9                     move.l  A1, (A1)+
80023E: B3CE                     cmpa.l  A6, A1
800240: 6E00 0028                bgt     $80026a
800244: 6000 FFF0                bra     $800236

800248: 207C 0042 0000           movea.l #VRAM_START, A0        ; RAM test fail
80024E: 2C7C 0042 7FFF           movea.l #VRAM_END, A6
800254: 4283                     clr.l   D3
800256: 3C3C FFFF                move.w  #$ffff, D6
80025A: 30C6                     move.w  D6, (A0)+
80025C: 30C3                     move.w  D3, (A0)+
80025E: B1CE                     cmpa.l  A6, A0
800260: 6D00 FFF8                blt     $80025a
800264: 4E72 2700                stop    #$2700        ; fatal error

800268: 60F0                     bra     $80025a
80026A: 13FC 0000 004C 0000      move.b  #$0, CSR.l
800272: 5206                     addq.b  #1, D6
800274: 2006                     move.l  D6, D0
800276: 4600                     not.b   D0
800278: E148                     lsl.w   #8, D0
80027A: 33C0 004A 0000           move.w  D0, MCR.l           ; LEDs to 6
800280: 4EF9 0080 0E44           jmp     $800e44.l           ; do system initialization
800286: 5206                     addq.b  #1, D6
800288: 2006                     move.l  D6, D0
80028A: 4600                     not.b   D0
80028C: E148                     lsl.w   #8, D0
80028E: 33C0 004A 0000           move.w  D0, MCR.l           ; LEDs to 7
800294: 4EF9 0007 0000           jmp     $70000.l            ; run some code from RAM
80029A: 4028 2329                negx.b  ($2329,A0)
80029E: 7072                     moveq   #$72, D0
8002A0: 6F6D                     ble     $80030f
8002A2: 7033                     moveq   #$33, D0
8002A4: 0000 0000                ori.b   #$0, D0
8002A8: 4E56 FFFC                link    A6, #-$4
8002AC: 23FC 0080 077C 0000 5032 move.l  #$80077c, $5032.l
8002B6: 23FC 0080 087C 0000 503A move.l  #$80087c, $503a.l
8002C0: 33FC 0001 0000 501C      move.w  #$1, $501c.l
8002C8: 4279 0000 502C           clr.w   $502c.l
8002CE: 0CAE 0000 0002 0008      cmpi.l  #$2, ($8,A6)
8002D6: 6600 008E                bne     $800366
8002DA: 4EB9 0080 0DA2           jsr     $800da2.l
8002E0: 4EB9 0080 0C9A           jsr     $800c9a.l
8002E6: 4EB9 0080 0D32           jsr     $800d32.l        ; FDC reset
8002EC: 4EB9 0080 0D6A           jsr     $800d6a.l        ; HDC reset
8002F2: 4EB9 0080 0840           jsr     $800840.l        ; dfrdy()
8002F8: 2D40 FFFC                move.l  D0, (-$4,A6)
8002FC: 6708                     beq     $800306
8002FE: 202E FFFC                move.l  (-$4,A6), D0
800302: 6000 0124                bra     $800428
800306: 4EB9 0080 080C           jsr     $80080c.l
80030C: 2D40 FFFC                move.l  D0, (-$4,A6)
800310: 42A7                     clr.l   -(A7)
800312: 7001                     moveq   #$1, D0
800314: 2F00                     move.l  D0, -(A7)
800316: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
80031C: 508F                     addq.l  #8, A7
80031E: 42A7                     clr.l   -(A7)
800320: 7002                     moveq   #$2, D0
800322: 2F00                     move.l  D0, -(A7)
800324: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
80032A: 508F                     addq.l  #8, A7
80032C: 42A7                     clr.l   -(A7)
80032E: 7003                     moveq   #$3, D0
800330: 2F00                     move.l  D0, -(A7)
800332: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
800338: 508F                     addq.l  #8, A7
80033A: 2F2E 0010                move.l  ($10,A6), -(A7)
80033E: 2F3C 0000 5012           move.l  #$5012, -(A7)
800344: 2F3C 0000 5032           move.l  #$5032, -(A7)
80034A: 4EB9 0080 062E           jsr     $80062e.l
800350: DEFC 000C                adda.w  #$c, A7
800354: 2D40 FFFC                move.l  D0, (-$4,A6)
800358: 6708                     beq     $800362
80035A: 202E FFFC                move.l  (-$4,A6), D0
80035E: 6000 00C8                bra     $800428
800362: 6000 00C2                bra     $800426
800366: 42B9 0080 0014           clr.l   $800014.l        ; weird write attempt to ROM
80036C: 4EB9 0080 0CCE           jsr     $800cce.l
800372: 4EB9 0080 0D6A           jsr     $800d6a.l        ; HDC reset
800378: 4EB9 0080 0954           jsr     $800954.l
80037E: 2D40 FFFC                move.l  D0, (-$4,A6)
800382: 42A7                     clr.l   -(A7)
800384: 7001                     moveq   #$1, D0
800386: 2F00                     move.l  D0, -(A7)
800388: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
80038E: 508F                     addq.l  #8, A7
800390: 7001                     moveq   #$1, D0
800392: 2F00                     move.l  D0, -(A7)
800394: 7002                     moveq   #$2, D0
800396: 2F00                     move.l  D0, -(A7)
800398: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
80039E: 508F                     addq.l  #8, A7
8003A0: 42A7                     clr.l   -(A7)
8003A2: 7003                     moveq   #$3, D0
8003A4: 2F00                     move.l  D0, -(A7)
8003A6: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
8003AC: 508F                     addq.l  #8, A7
8003AE: 42A7                     clr.l   -(A7)
8003B0: 7004                     moveq   #$4, D0
8003B2: 2F00                     move.l  D0, -(A7)
8003B4: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
8003BA: 508F                     addq.l  #8, A7
8003BC: 42A7                     clr.l   -(A7)
8003BE: 7005                     moveq   #$5, D0
8003C0: 2F00                     move.l  D0, -(A7)
8003C2: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
8003C8: 508F                     addq.l  #8, A7
8003CA: 7020                     moveq   #$20, D0
8003CC: 2F00                     move.l  D0, -(A7)
8003CE: 7006                     moveq   #$6, D0
8003D0: 2F00                     move.l  D0, -(A7)
8003D2: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
8003D8: 508F                     addq.l  #8, A7
8003DA: 2F2E 0010                move.l  ($10,A6), -(A7)
8003DE: 2F3C 0000 5022           move.l  #$5022, -(A7)
8003E4: 2F3C 0000 503A           move.l  #$503a, -(A7)
8003EA: 4EB9 0080 062E           jsr     $80062e.l
8003F0: DEFC 000C                adda.w  #$c, A7
8003F4: 2D40 FFFC                move.l  D0, (-$4,A6)
8003F8: 6706                     beq     $800400
8003FA: 202E FFFC                move.l  (-$4,A6), D0
8003FE: 6028                     bra     $800428
800400: 2F2E 000C                move.l  ($c,A6), -(A7)
800404: 2F3C 0000 5022           move.l  #$5022, -(A7)
80040A: 2F3C 0000 503A           move.l  #$503a, -(A7)
800410: 4EB9 0080 0702           jsr     $800702.l
800416: DEFC 000C                adda.w  #$c, A7
80041A: 2D40 FFFC                move.l  D0, (-$4,A6)
80041E: 6706                     beq     $800426
800420: 202E FFFC                move.l  (-$4,A6), D0
800424: 6002                     bra     $800428
800426: 4280                     clr.l   D0
800428: 4E5E                     unlk    A6
80042A: 4E75                     rts

80042C: 4E56 0000                link    A6, #$0
800430: 23EE 0014 0000 500E      move.l  ($14,A6), $500e.l
800438: 0CAE 0000 0002 0014      cmpi.l  #$2, ($14,A6)
800440: 6628                     bne     $80046a
800442: 2F2E 000C                move.l  ($c,A6), -(A7)
800446: 2F2E 0018                move.l  ($18,A6), -(A7)
80044A: 2F2E 0010                move.l  ($10,A6), -(A7)
80044E: 2F2E 0008                move.l  ($8,A6), -(A7)
800452: 2F3C 0000 5012           move.l  #$5012, -(A7)
800458: 2F39 0000 5032           move.l  $5032.l, -(A7)
80045E: 4EB9 0080 0494           jsr     $800494.l
800464: DEFC 0018                adda.w  #$18, A7
800468: 6026                     bra     $800490
80046A: 2F2E 000C                move.l  ($c,A6), -(A7)
80046E: 2F2E 0018                move.l  ($18,A6), -(A7)
800472: 2F2E 0010                move.l  ($10,A6), -(A7)
800476: 2F2E 0008                move.l  ($8,A6), -(A7)
80047A: 2F3C 0000 5022           move.l  #$5022, -(A7)
800480: 2F39 0000 503A           move.l  $503a.l, -(A7)
800486: 4EB9 0080 0494           jsr     $800494.l
80048C: DEFC 0018                adda.w  #$18, A7
800490: 4E5E                     unlk    A6
800492: 4E75                     rts

800494: 4E56 FFF4                link    A6, #-$c
800498: 0CB9 0000 0002 0000 500E cmpi.l  #$2, $500e.l
8004A2: 660E                     bne     $8004b2
8004A4: 4EB9 0080 0CE8           jsr     $800ce8.l
8004AA: 4EB9 0080 0C9A           jsr     $800c9a.l
8004B0: 600C                     bra     $8004be
8004B2: 4EB9 0080 0CB4           jsr     $800cb4.l
8004B8: 4EB9 0080 0CCE           jsr     $800cce.l
8004BE: 202E 0014                move.l  ($14,A6), D0
8004C2: 53AE 0014                subq.l  #1, ($14,A6)
8004C6: 4A80                     tst.l   D0
8004C8: 6F00 015E                ble     $800628
8004CC: 23FC 0000 0005 0000 5006 move.l  #$5, $5006.l
8004D6: 23FC 0000 0003 0000 500A move.l  #$3, $500a.l
8004E0: 0CAE 0000 0001 0018      cmpi.l  #$1, ($18,A6)
8004E8: 663E                     bne     $800528
8004EA: 206E 000C                movea.l ($c,A6), A0
8004EE: 3028 0006                move.w  ($6,A0), D0
8004F2: 4281                     clr.l   D1
8004F4: 3200                     move.w  D0, D1
8004F6: 2F01                     move.l  D1, -(A7)
8004F8: 2F2E 0010                move.l  ($10,A6), -(A7)
8004FC: 4EB9 0080 10F8           jsr     $8010f8.l
800502: 508F                     addq.l  #8, A7
800504: 2D40 FFF8                move.l  D0, (-$8,A6)
800508: 206E 000C                movea.l ($c,A6), A0
80050C: 3028 0006                move.w  ($6,A0), D0
800510: 4281                     clr.l   D1
800512: 3200                     move.w  D0, D1
800514: 2F01                     move.l  D1, -(A7)
800516: 2F2E 0010                move.l  ($10,A6), -(A7)
80051A: 4EB9 0080 110A           jsr     $80110a.l
800520: 508F                     addq.l  #8, A7
800522: 2D40 FFF4                move.l  D0, (-$c,A6)
800526: 603C                     bra     $800564
800528: 206E 000C                movea.l ($c,A6), A0
80052C: 3028 0004                move.w  ($4,A0), D0
800530: 4281                     clr.l   D1
800532: 3200                     move.w  D0, D1
800534: 2F01                     move.l  D1, -(A7)
800536: 2F2E 0010                move.l  ($10,A6), -(A7)
80053A: 4EB9 0080 10F8           jsr     $8010f8.l
800540: 508F                     addq.l  #8, A7
800542: 2D40 FFF8                move.l  D0, (-$8,A6)
800546: 206E 000C                movea.l ($c,A6), A0
80054A: 3028 0004                move.w  ($4,A0), D0
80054E: 4281                     clr.l   D1
800550: 3200                     move.w  D0, D1
800552: 2F01                     move.l  D1, -(A7)
800554: 2F2E 0010                move.l  ($10,A6), -(A7)
800558: 4EB9 0080 110A           jsr     $80110a.l
80055E: 508F                     addq.l  #8, A7
800560: 2D40 FFF4                move.l  D0, (-$c,A6)
800564: 2F2E 001C                move.l  ($1c,A6), -(A7)
800568: 206E 000C                movea.l ($c,A6), A0
80056C: 3028 000A                move.w  ($a,A0), D0
800570: 4281                     clr.l   D1
800572: 3200                     move.w  D0, D1
800574: D2AE FFF4                add.l   (-$c,A6), D1
800578: 2F01                     move.l  D1, -(A7)
80057A: 206E 000C                movea.l ($c,A6), A0
80057E: 3028 0002                move.w  ($2,A0), D0
800582: 4281                     clr.l   D1
800584: 3200                     move.w  D0, D1
800586: 2F01                     move.l  D1, -(A7)
800588: 2F2E FFF8                move.l  (-$8,A6), -(A7)
80058C: 4EB9 0080 110A           jsr     $80110a.l
800592: 508F                     addq.l  #8, A7
800594: 2F00                     move.l  D0, -(A7)
800596: 206E 000C                movea.l ($c,A6), A0
80059A: 3028 0002                move.w  ($2,A0), D0
80059E: 4281                     clr.l   D1
8005A0: 3200                     move.w  D0, D1
8005A2: 2F01                     move.l  D1, -(A7)
8005A4: 2F2E FFF8                move.l  (-$8,A6), -(A7)
8005A8: 4EB9 0080 10F8           jsr     $8010f8.l
8005AE: 508F                     addq.l  #8, A7
8005B0: 2F00                     move.l  D0, -(A7)
8005B2: 206E 0008                movea.l ($8,A6), A0
8005B6: 4E90                     jsr     (A0)
8005B8: DEFC 0010                adda.w  #$10, A7
8005BC: 2D40 FFFC                move.l  D0, (-$4,A6)
8005C0: 674E                     beq     $800610
8005C2: 2039 0000 5006           move.l  $5006.l, D0
8005C8: 53B9 0000 5006           subq.l  #1, $5006.l
8005CE: 4A80                     tst.l   D0
8005D0: 6692                     bne     $800564
8005D2: 2039 0000 500A           move.l  $500a.l, D0
8005D8: 53B9 0000 500A           subq.l  #1, $500a.l
8005DE: 4A80                     tst.l   D0
8005E0: 6728                     beq     $80060a
8005E2: 23FC 0000 0005 0000 5006 move.l  #$5, $5006.l
8005EC: 0CB9 0000 0002 0000 500E cmpi.l  #$2, $500e.l
8005F6: 6608                     bne     $800600
8005F8: 4EB9 0080 080C           jsr     $80080c.l
8005FE: 6006                     bra     $800606
800600: 4EB9 0080 0954           jsr     $800954.l
800606: 6000 FF5C                bra     $800564
80060A: 202E FFFC                move.l  (-$4,A6), D0
80060E: 601A                     bra     $80062a
800610: 206E 000C                movea.l ($c,A6), A0
800614: 3028 0008                move.w  ($8,A0), D0
800618: 4281                     clr.l   D1
80061A: 3200                     move.w  D0, D1
80061C: D3AE 001C                add.l   D1, ($1c,A6)
800620: 52AE 0010                addq.l  #1, ($10,A6)
800624: 6000 FE98                bra     $8004be
800628: 4280                     clr.l   D0
80062A: 4E5E                     unlk    A6
80062C: 4E75                     rts

80062E: 4E56 FFF8                link    A6, #-$8
800632: 2D6E 0010 FFF8           move.l  ($10,A6), (-$8,A6)
800638: 2F2E 0010                move.l  ($10,A6), -(A7)
80063C: 206E 000C                movea.l ($c,A6), A0
800640: 3028 000A                move.w  ($a,A0), D0
800644: 4281                     clr.l   D1
800646: 3200                     move.w  D0, D1
800648: 2F01                     move.l  D1, -(A7)
80064A: 42A7                     clr.l   -(A7)
80064C: 42A7                     clr.l   -(A7)
80064E: 206E 0008                movea.l ($8,A6), A0
800652: 2050                     movea.l (A0), A0
800654: 4E90                     jsr     (A0)
800656: DEFC 0010                adda.w  #$10, A7
80065A: 2D40 FFFC                move.l  D0, (-$4,A6)
80065E: 6708                     beq     $800668
800660: 202E FFFC                move.l  (-$4,A6), D0
800664: 6000 0098                bra     $8006fe
800668: 202E 0010                move.l  ($10,A6), D0
80066C: 0680 0000 0200           addi.l  #$200, D0
800672: 2F00                     move.l  D0, -(A7)
800674: 206E 000C                movea.l ($c,A6), A0
800678: 3028 000A                move.w  ($a,A0), D0
80067C: 4281                     clr.l   D1
80067E: 3200                     move.w  D0, D1
800680: 5281                     addq.l  #1, D1
800682: 2F01                     move.l  D1, -(A7)
800684: 42A7                     clr.l   -(A7)
800686: 42A7                     clr.l   -(A7)
800688: 206E 0008                movea.l ($8,A6), A0
80068C: 2050                     movea.l (A0), A0
80068E: 4E90                     jsr     (A0)
800690: DEFC 0010                adda.w  #$10, A7
800694: 2D40 FFFC                move.l  D0, (-$4,A6)
800698: 6706                     beq     $8006a0
80069A: 202E FFFC                move.l  (-$4,A6), D0
80069E: 605E                     bra     $8006fe
8006A0: 206E FFF8                movea.l (-$8,A6), A0
8006A4: 226E 000C                movea.l ($c,A6), A1
8006A8: 32A8 000E                move.w  ($e,A0), (A1)
8006AC: 206E FFF8                movea.l (-$8,A6), A0
8006B0: 226E 000C                movea.l ($c,A6), A1
8006B4: 3368 0010 0002           move.w  ($10,A0), ($2,A1)
8006BA: 206E FFF8                movea.l (-$8,A6), A0
8006BE: 3028 0012                move.w  ($12,A0), D0
8006C2: 4281                     clr.l   D1
8006C4: 3200                     move.w  D0, D1
8006C6: 0241 FFFE                andi.w  #$fffe, D1
8006CA: 206E 000C                movea.l ($c,A6), A0
8006CE: 3141 0004                move.w  D1, ($4,A0)
8006D2: 206E FFF8                movea.l (-$8,A6), A0
8006D6: 226E 000C                movea.l ($c,A6), A1
8006DA: 3368 0012 0006           move.w  ($12,A0), ($6,A1)
8006E0: 206E FFF8                movea.l (-$8,A6), A0
8006E4: 226E 000C                movea.l ($c,A6), A1
8006E8: 3368 0018 0008           move.w  ($18,A0), ($8,A1)
8006EE: 206E FFF8                movea.l (-$8,A6), A0
8006F2: 226E 000C                movea.l ($c,A6), A1
8006F6: 1368 0017 000C           move.b  ($17,A0), ($c,A1)
8006FC: 4280                     clr.l   D0
8006FE: 4E5E                     unlk    A6
800700: 4E75                     rts

800702: 4E56 FFFC                link    A6, #-$4
800706: 2F2E 0010                move.l  ($10,A6), -(A7)
80070A: 206E 000C                movea.l ($c,A6), A0
80070E: 3028 000A                move.w  ($a,A0), D0
800712: 4281                     clr.l   D1
800714: 3200                     move.w  D0, D1
800716: 5481                     addq.l  #2, D1
800718: 2F01                     move.l  D1, -(A7)
80071A: 42A7                     clr.l   -(A7)
80071C: 42A7                     clr.l   -(A7)
80071E: 206E 0008                movea.l ($8,A6), A0
800722: 2050                     movea.l (A0), A0
800724: 4E90                     jsr     (A0)
800726: DEFC 0010                adda.w  #$10, A7
80072A: 2D40 FFFC                move.l  D0, (-$4,A6)
80072E: 6706                     beq     $800736
800730: 202E FFFC                move.l  (-$4,A6), D0
800734: 6042                     bra     $800778
800736: 202E 0010                move.l  ($10,A6), D0
80073A: 0680 0000 0200           addi.l  #$200, D0
800740: 2F00                     move.l  D0, -(A7)
800742: 206E 000C                movea.l ($c,A6), A0
800746: 3028 000A                move.w  ($a,A0), D0
80074A: 4281                     clr.l   D1
80074C: 3200                     move.w  D0, D1
80074E: 5681                     addq.l  #3, D1
800750: 2F01                     move.l  D1, -(A7)
800752: 42A7                     clr.l   -(A7)
800754: 42A7                     clr.l   -(A7)
800756: 206E 0008                movea.l ($8,A6), A0
80075A: 2050                     movea.l (A0), A0
80075C: 4E90                     jsr     (A0)
80075E: DEFC 0010                adda.w  #$10, A7
800762: 2D40 FFFC                move.l  D0, (-$4,A6)
800766: 6706                     beq     $80076e
800768: 202E FFFC                move.l  (-$4,A6), D0
80076C: 600A                     bra     $800778
80076E: 23EE 0010 0080 0014      move.l  ($10,A6), $800014.l        ; weird write attempt to ROM
800776: 4280                     clr.l   D0
800778: 4E5E                     unlk    A6
80077A: 4E75                     rts

80077C: 4E56 FFFC                link    A6, #-$4
800780: 2F2E 0008                move.l  ($8,A6), -(A7)
800784: 4EB9 0080 07E6           jsr     $8007e6.l
80078A: 588F                     addq.l  #4, A7
80078C: 2D40 FFFC                move.l  D0, (-$4,A6)
800790: 6706                     beq     $800798
800792: 202E FFFC                move.l  (-$4,A6), D0
800796: 604A                     bra     $8007e2
800798: 7001                     moveq   #$1, D0
80079A: 2F00                     move.l  D0, -(A7)
80079C: 2F3C 0000 0200           move.l  #$200, -(A7)
8007A2: 2F2E 0014                move.l  ($14,A6), -(A7)
8007A6: 4EB9 0080 0B56           jsr     $800b56.l               ; off to do something with DMA
8007AC: DEFC 000C                adda.w  #$c, A7
8007B0: 2F2E 0010                move.l  ($10,A6), -(A7)
8007B4: 7002                     moveq   #$2, D0
8007B6: 2F00                     move.l  D0, -(A7)
8007B8: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
8007BE: 508F                     addq.l  #8, A7
8007C0: 2D40 FFFC                move.l  D0, (-$4,A6)
8007C4: 202E 000C                move.l  ($c,A6), D0
8007C8: D080                     add.l   D0, D0
8007CA: 0040 0088                ori.w   #$88, D0
8007CE: 2F00                     move.l  D0, -(A7)
8007D0: 42A7                     clr.l   -(A7)
8007D2: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
8007D8: 508F                     addq.l  #8, A7
8007DA: 2D40 FFFC                move.l  D0, (-$4,A6)
8007DE: 202E FFFC                move.l  (-$4,A6), D0
8007E2: 4E5E                     unlk    A6
8007E4: 4E75                     rts

8007E6: 4E56 0000                link    A6, #$0
8007EA: 2F2E 0008                move.l  ($8,A6), -(A7)
8007EE: 7003                     moveq   #$3, D0
8007F0: 2F00                     move.l  D0, -(A7)
8007F2: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
8007F8: 508F                     addq.l  #8, A7
8007FA: 7010                     moveq   #$10, D0
8007FC: 2F00                     move.l  D0, -(A7)
8007FE: 42A7                     clr.l   -(A7)
800800: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
800806: 508F                     addq.l  #8, A7
800808: 4E5E                     unlk    A6
80080A: 4E75                     rts

80080C: 4E56 0000                link    A6, #$0
800810: 7003                     moveq   #$3, D0
800812: 2F00                     move.l  D0, -(A7)
800814: 42A7                     clr.l   -(A7)
800816: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
80081C: 508F                     addq.l  #8, A7
80081E: 4E5E                     unlk    A6
800820: 4E75                     rts

800822: 4E56 0000                link    A6, #$0
800826: 2F3C 0000 00D8           move.l  #$d8, -(A7)
80082C: 42A7                     clr.l   -(A7)
80082E: 4EB9 0080 0A72           jsr     $800a72.l        ; wait for FDC int
800834: 508F                     addq.l  #8, A7
800836: 4EB9 0080 0D32           jsr     $800d32.l        ; floppy reset
80083C: 4E5E                     unlk    A6
80083E: 4E75                     rts

800840: 4E56 FFF8                link    A6, #-$8         ; dfrdy(): floppy drive ready?
800844: 48EE 00C0 FFF8           movem.l D6-D7, (-$8,A6)
80084A: 4287                     clr.l   D7
80084C: 0C87 0000 C350           cmpi.l  #$c350, D7       ; read FDC status up to 50000 times while NOT READY
800852: 6C1C                     bge     $800870
800854: 42A7                     clr.l   -(A7)            ; offset 0 (status reg) passed to rd2797()
800856: 4EB9 0080 0B16           jsr     $800b16.l        ; read (status) reg from FDC
80085C: 588F                     addq.l  #4, A7
80085E: 2C00                     move.l  D0, D6
800860: 0286 0000 0080           andi.l  #$80, D6         ; check for NOT READY flag
800866: 6704                     beq     $80086c          ; if ready, return FDC status
800868: 5287                     addq.l  #1, D7
80086A: 6002                     bra     $80086e
80086C: 6002                     bra     $800870
80086E: 60DC                     bra     $80084c
800870: 2006                     move.l  D6, D0
800872: 4CEE 00C0 FFF8           movem.l (-$8,A6), D6-D7
800878: 4E5E                     unlk    A6
80087A: 4E75                     rts

80087C: 4E56 FFFC                link    A6, #-$4
800880: 4AB9 0080 0014           tst.l   $800014.l
800886: 6716                     beq     $80089e
800888: 486E 0010                pea     ($10,A6)
80088C: 486E 000C                pea     ($c,A6)
800890: 486E 0008                pea     ($8,A6)
800894: 4EB9 0080 096C           jsr     $80096c.l
80089A: DEFC 000C                adda.w  #$c, A7
80089E: 7001                     moveq   #$1, D0
8008A0: 2F00                     move.l  D0, -(A7)
8008A2: 2F3C 0000 0200           move.l  #$200, -(A7)
8008A8: 2F2E 0014                move.l  ($14,A6), -(A7)
8008AC: 4EB9 0080 0B56           jsr     $800b56.l            ; off to do something with DMA
8008B2: DEFC 000C                adda.w  #$c, A7
8008B6: 2F2E 000C                move.l  ($c,A6), -(A7)
8008BA: 4EB9 0080 0D02           jsr     $800d02.l
8008C0: 588F                     addq.l  #4, A7
8008C2: 202E 000C                move.l  ($c,A6), D0
8008C6: 0280 0000 0007           andi.l  #$7, D0
8008CC: 0040 0020                ori.w   #$20, D0
8008D0: 2F00                     move.l  D0, -(A7)
8008D2: 7006                     moveq   #$6, D0
8008D4: 2F00                     move.l  D0, -(A7)
8008D6: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
8008DC: 508F                     addq.l  #8, A7
8008DE: 2D40 FFFC                move.l  D0, (-$4,A6)
8008E2: 302E 000A                move.w  ($a,A6), D0
8008E6: 4281                     clr.l   D1
8008E8: 3200                     move.w  D0, D1
8008EA: 2F01                     move.l  D1, -(A7)
8008EC: 7004                     moveq   #$4, D0
8008EE: 2F00                     move.l  D0, -(A7)
8008F0: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
8008F6: 508F                     addq.l  #8, A7
8008F8: 2D40 FFFC                move.l  D0, (-$4,A6)
8008FC: 202E 0008                move.l  ($8,A6), D0
800900: E080                     asr.l   #8, D0
800902: 0280 0000 0003           andi.l  #$3, D0
800908: 4281                     clr.l   D1
80090A: 3200                     move.w  D0, D1
80090C: 2F01                     move.l  D1, -(A7)
80090E: 7005                     moveq   #$5, D0
800910: 2F00                     move.l  D0, -(A7)
800912: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
800918: 508F                     addq.l  #8, A7
80091A: 2D40 FFFC                move.l  D0, (-$4,A6)
80091E: 302E 0012                move.w  ($12,A6), D0
800922: 4281                     clr.l   D1
800924: 3200                     move.w  D0, D1
800926: 2F01                     move.l  D1, -(A7)
800928: 7003                     moveq   #$3, D0
80092A: 2F00                     move.l  D0, -(A7)
80092C: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
800932: 508F                     addq.l  #8, A7
800934: 2D40 FFFC                move.l  D0, (-$4,A6)
800938: 7028                     moveq   #$28, D0
80093A: 2F00                     move.l  D0, -(A7)
80093C: 7007                     moveq   #$7, D0
80093E: 2F00                     move.l  D0, -(A7)
800940: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
800946: 508F                     addq.l  #8, A7
800948: 2D40 FFFC                move.l  D0, (-$4,A6)
80094C: 202E FFFC                move.l  (-$4,A6), D0
800950: 4E5E                     unlk    A6
800952: 4E75                     rts

800954: 4E56 0000                link    A6, #$0
800958: 7010                     moveq   #$10, D0
80095A: 2F00                     move.l  D0, -(A7)
80095C: 7007                     moveq   #$7, D0
80095E: 2F00                     move.l  D0, -(A7)
800960: 4EB9 0080 0ADE           jsr     $800ade.l        ; write to HDC
800966: 508F                     addq.l  #8, A7
800968: 4E5E                     unlk    A6
80096A: 4E75                     rts

80096C: 4E56 FFF8                link    A6, #-$8
800970: 48EE 2000 FFF8           movem.l A5, (-$8,A6)
800976: 2A79 0080 0014           movea.l $800014.l, A5
80097C: 508D                     addq.l  #8, A5
80097E: 2D7C 0000 0001 FFFC      move.l  #$1, (-$4,A6)
800986: 0CAE 0000 007F FFFC      cmpi.l  #$7f, (-$4,A6)
80098E: 6C00 00BC                bge     $800a4c
800992: 4A55                     tst.w   (A5)
800994: 6608                     bne     $80099e
800996: 4A6D 0002                tst.w   ($2,A5)
80099A: 6700 00B0                beq     $800a4c
80099E: 4280                     clr.l   D0
8009A0: 3015                     move.w  (A5), D0
8009A2: 206E 0008                movea.l ($8,A6), A0
8009A6: B090                     cmp.l   (A0), D0
8009A8: 6600 0098                bne     $800a42
8009AC: 3039 0000 5028           move.w  $5028.l, D0
8009B2: 3040                     movea.w D0, A0
8009B4: 2F08                     move.l  A0, -(A7)
8009B6: 302D 0002                move.w  ($2,A5), D0
8009BA: 3040                     movea.w D0, A0
8009BC: 2F08                     move.l  A0, -(A7)
8009BE: 4EB9 0080 10F8           jsr     $8010f8.l
8009C4: 508F                     addq.l  #8, A7
8009C6: 206E 000C                movea.l ($c,A6), A0
8009CA: B090                     cmp.l   (A0), D0
8009CC: 6674                     bne     $800a42
8009CE: 3039 0000 5028           move.w  $5028.l, D0
8009D4: 3040                     movea.w D0, A0
8009D6: 2F08                     move.l  A0, -(A7)
8009D8: 302D 0002                move.w  ($2,A5), D0
8009DC: 3040                     movea.w D0, A0
8009DE: 2F08                     move.l  A0, -(A7)
8009E0: 4EB9 0080 110A           jsr     $80110a.l
8009E6: 508F                     addq.l  #8, A7
8009E8: 206E 0010                movea.l ($10,A6), A0
8009EC: B090                     cmp.l   (A0), D0
8009EE: 6652                     bne     $800a42
8009F0: 4280                     clr.l   D0
8009F2: 3039 0000 5024           move.w  $5024.l, D0
8009F8: 2F00                     move.l  D0, -(A7)
8009FA: 4280                     clr.l   D0
8009FC: 302D 0004                move.w  ($4,A5), D0
800A00: 2F00                     move.l  D0, -(A7)
800A02: 4EB9 0080 10F8           jsr     $8010f8.l
800A08: 508F                     addq.l  #8, A7
800A0A: 206E 0008                movea.l ($8,A6), A0
800A0E: 2080                     move.l  D0, (A0)
800A10: 4280                     clr.l   D0
800A12: 3039 0000 5024           move.w  $5024.l, D0
800A18: 2F00                     move.l  D0, -(A7)
800A1A: 4280                     clr.l   D0
800A1C: 302D 0004                move.w  ($4,A5), D0
800A20: 2F00                     move.l  D0, -(A7)
800A22: 4EB9 0080 110A           jsr     $80110a.l
800A28: 508F                     addq.l  #8, A7
800A2A: 206E 000C                movea.l ($c,A6), A0
800A2E: 2080                     move.l  D0, (A0)
800A30: 4280                     clr.l   D0
800A32: 3039 0000 5028           move.w  $5028.l, D0
800A38: 5380                     subq.l  #1, D0
800A3A: 206E 0010                movea.l ($10,A6), A0
800A3E: 2080                     move.l  D0, (A0)
800A40: 600A                     bra     $800a4c
800A42: 508D                     addq.l  #8, A5
800A44: 52AE FFFC                addq.l  #1, (-$4,A6)
800A48: 6000 FF3C                bra     $800986
800A4C: 4CEE 2000 FFF8           movem.l (-$8,A6), A5
800A52: 4E5E                     unlk    A6
800A54: 4E75                     rts

800A56: 4E56 FFFC                link    A6, #-$4        ; delay - loop 1000 times
800A5A: 42AE FFFC                clr.l   (-$4,A6)
800A5E: 0CAE 0000 03E8 FFFC      cmpi.l  #$3e8, (-$4,A6)
800A66: 6C06                     bge     $800a6e
800A68: 52AE FFFC                addq.l  #1, (-$4,A6)
800A6C: 60F0                     bra     $800a5e
800A6E: 4E5E                     unlk    A6
800A70: 4E75                     rts

800A72: 4E56 FFFC                link    A6, #-$4
800A76: 4280                     clr.l   D0
800A78: 302E 000A                move.w  ($a,A6), D0         ; offset to FDC reg passed in?
800A7C: D080                     add.l   D0, D0
800A7E: 0680 00E1 0000           addi.l  #WD2797, D0
800A84: 2040                     movea.l D0, A0
800A86: 30AE 000E                move.w  ($e,A6), (A0)       ; write to FDC
800A8A: 4A6E 000A                tst.w   ($a,A6)             ; what FDC reg written to?
800A8E: 6646                     bne     $800ad6             ; skip waiting for IRQ if ??? and return D0 = 0
800A90: 4EB9 0080 0E14           jsr     $800e14.l           ; wait for FDC IRQ
800A96: 2D40 FFFC                move.l  D0, (-$4,A6)        ; local var = incremented DMA count or 0 (hword), FDC read (lword)
800A9A: 082E 0007 000F           btst    #$7, ($f,A6)        ; var passed in? is bit 7 set?
800AA0: 661A                     bne     $800abc             ; if bit 7 set, also check for HEAD LOADED and TRK00, go to 800ABC
800AA2: 202E FFFC                move.l  (-$4,A6), D0
800AA6: 0280 8000 0098           andi.l  #$80000098, D0      ; check FDC read bits: 1001 1000 (NOT READY, SEEK ERROR, CRC ERROR), check DMA count rollover? (aka done?)
800AAC: 670C                     beq     $800aba             ; if none set, return (D0 = 0)
800AAE: 202E FFFC                move.l  (-$4,A6), D0
800AB2: 0280 8000 0098           andi.l  #$80000098, D0      ; if some bits set, return (D0 = FDC bits set, DMA count rollover bit?)
800AB8: 6020                     bra     $800ada
800ABA: 6018                     bra     $800ad4
800ABC: 202E FFFC                move.l  (-$4,A6), D0        ; local var -> D0
800AC0: 0280 8000 00BC           andi.l  #$800000bc, D0      ; check FDC read bits: 1011 1100, check DMA count rollover? (aka done?)
800AC6: 670C                     beq     $800ad4             ; if none set, return (D0 = 0)
800AC8: 202E FFFC                move.l  (-$4,A6), D0        ; FDC status: b7=NOT READY, b5=HEAD LOADED, b4=SEEK ERROR, b3=CRC ERROR, b2=TRK00
800ACC: 0280 8000 00BC           andi.l  #$800000bc, D0      ; if some bits set, return (D0 = FDC bits set, DMA count rollover bit?)
800AD2: 6006                     bra     $800ada
800AD4: 6004                     bra     $800ada
800AD6: 4280                     clr.l   D0
800AD8: 4E71                     nop
800ADA: 4E5E                     unlk    A6
800ADC: 4E75                     rts

800ADE: 4E56 0000                link    A6, #$0
800AE2: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l
800AEC: 4280                     clr.l   D0
800AEE: 302E 000A                move.w  ($a,A6), D0
800AF2: D080                     add.l   D0, D0
800AF4: 0680 00E0 0000           addi.l  #WD1010, D0
800AFA: 2040                     movea.l D0, A0
800AFC: 30AE 000E                move.w  ($e,A6), (A0)    ; write to HDC
800B00: 0C6E 0007 000A           cmpi.w  #$7, ($a,A6)
800B06: 6608                     bne     $800b10
800B08: 4EB9 0080 0DD6           jsr     $800dd6.l        ; wait for HDC IRQ
800B0E: 6002                     bra     $800b12
800B10: 4280                     clr.l   D0
800B12: 4E5E                     unlk    A6
800B14: 4E75                     rts

800B16: 4E56 0000                link    A6, #$0               ; rd2797 (REG)
800B1A: 4280                     clr.l   D0
800B1C: 302E 000A                move.w  ($a,A6), D0           ; ($a,A6) has FDC offset to read from
800B20: D080                     add.l   D0, D0
800B22: 0680 00E1 0000           addi.l  #WD2797, D0
800B28: 2040                     movea.l D0, A0
800B2A: 3010                     move.w  (A0), D0              ; read word from FDC -> D0
800B2C: 4281                     clr.l   D1
800B2E: 3200                     move.w  D0, D1
800B30: 2001                     move.l  D1, D0
800B32: 4E5E                     unlk    A6
800B34: 4E75                     rts

800B36: 4E56 0000                link    A6, #$0
800B3A: 4280                     clr.l   D0
800B3C: 302E 000A                move.w  ($a,A6), D0           ; ($a,A6) has FDC offset to read from
800B40: D080                     add.l   D0, D0
800B42: 0680 00E0 0000           addi.l  #WD1010, D0
800B48: 2040                     movea.l D0, A0
800B4A: 3010                     move.w  (A0), D0              ; read word from HDC -> D0
800B4C: 4281                     clr.l   D1
800B4E: 3200                     move.w  D0, D1
800B50: 2001                     move.l  D1, D0
800B52: 4E5E                     unlk    A6
800B54: 4E75                     rts

800B56: 4E56 FFFC                link    A6, #-$4              ; going to do something with DMA
800B5A: 202E 000C                move.l  ($c,A6), D0
800B5E: E280                     asr.l   #1, D0
800B60: 5280                     addq.l  #1, D0
800B62: 4480                     neg.l   D0
800B64: 3D40 FFFE                move.w  D0, (-$2,A6)
800B68: 202E 0008                move.l  ($8,A6), D0
800B6C: 0280 0000 01FE           andi.l  #$1fe, D0
800B72: 4281                     clr.l   D1
800B74: 3200                     move.w  D0, D1
800B76: 0681 004D 0000           addi.l  #DMA_ADDR, D1
800B7C: 2041                     movea.l D1, A0
800B7E: 4210                     clr.b   (A0)
800B80: 202E 0008                move.l  ($8,A6), D0
800B84: E080                     asr.l   #8, D0
800B86: 0280 0000 1FFE           andi.l  #$1ffe, D0
800B8C: 4281                     clr.l   D1
800B8E: 3200                     move.w  D0, D1
800B90: 0681 004D 4000           addi.l  #$4d4000, D1
800B96: 2041                     movea.l D1, A0
800B98: 4210                     clr.b   (A0)
800B9A: 4A2E 0013                tst.b   ($13,A6)
800B9E: 6626                     bne     $800bc6
800BA0: 0079 4000 0000 5002      ori.w   #$4000, MCRSAVE.l        ; set to Disk DMA read
800BA8: 33F9 0000 5002 004A 0000 move.w  MCRSAVE.l, MCR.l
800BB2: 4280                     clr.l   D0
800BB4: 302E FFFE                move.w  (-$2,A6), D0
800BB8: 0040 C000                ori.w   #$c000, D0
800BBC: 33C0 0046 0000           move.w  D0, DMACOUNT.l
800BC2: 6000 0084                bra     $800c48
800BC6: 0279 BFFF 0000 5002      andi.w  #$bfff, MCRSAVE.l        ; set to Disk DMA write
800BCE: 33F9 0000 5002 004A 0000 move.w  MCRSAVE.l, MCR.l
800BD8: 4280                     clr.l   D0
800BDA: 302E FFFE                move.w  (-$2,A6), D0
800BDE: 0040 8000                ori.w   #$8000, D0
800BE2: 0240 BFFF                andi.w  #$bfff, D0
800BE6: 33C0 0046 0000           move.w  D0, DMACOUNT.l
800BEC: 4280                     clr.l   D0
800BEE: 302E FFFE                move.w  (-$2,A6), D0
800BF2: 0040 8000                ori.w   #$8000, D0
800BF6: 4281                     clr.l   D1
800BF8: 3239 0046 0000           move.w  DMACOUNT.l, D1
800BFE: B081                     cmp.l   D1, D0
800C00: 67EA                     beq     $800bec
800C02: 202E 0008                move.l  ($8,A6), D0
800C06: 0280 0000 01FE           andi.l  #$1fe, D0
800C0C: 4281                     clr.l   D1
800C0E: 3200                     move.w  D0, D1
800C10: 0681 004D 0000           addi.l  #DMA_ADDR, D1
800C16: 2041                     movea.l D1, A0
800C18: 4210                     clr.b   (A0)
800C1A: 202E 0008                move.l  ($8,A6), D0
800C1E: E080                     asr.l   #8, D0
800C20: 0280 0000 1FFE           andi.l  #$1ffe, D0
800C26: 4281                     clr.l   D1
800C28: 3200                     move.w  D0, D1
800C2A: 0681 004D 4000           addi.l  #$4d4000, D1
800C30: 2041                     movea.l D1, A0
800C32: 4210                     clr.b   (A0)
800C34: 4280                     clr.l   D0
800C36: 302E FFFE                move.w  (-$2,A6), D0
800C3A: 0040 8000                ori.w   #$8000, D0
800C3E: 0240 BFFF                andi.w  #$bfff, D0
800C42: 33C0 0046 0000           move.w  D0, DMACOUNT.l
800C48: 33FC FFFF 0000 5004      move.w  #$ffff, $5004.l     ; set $5004 to FFFF
800C50: 4E5E                     unlk    A6
800C52: 4E75                     rts

800C54: 4E56 FFFC                link    A6, #-$4            ; HDC/FDC IRQ service
800C58: 48EE 0080 FFFC           movem.l D7, (-$4,A6)        ; save D7
800C5E: 4A79 0000 5004           tst.w   $5004.l             ; checking $5004 = 0000
800C64: 6604                     bne     $800c6a             ; if not 0, do the DMA
800C66: 4280                     clr.l   D0
800C68: 6026                     bra     $800c90             ; if 0, not time to do DMA, return with D0 = 0
800C6A: 4279 0000 5004           clr.w   $5004.l             ; $5004 = 0000, start/continue DMA transfer?
800C70: 4287                     clr.l   D7
800C72: 3E39 0046 0000           move.w  DMACOUNT.l, D7      ; DMACOUNT -> D7
800C78: 4279 0046 0000           clr.w   DMACOUNT.l          ; DMACOUNT = 0
800C7E: 4239 004D 0000           clr.b   DMA_ADDR.l          ; clear bottom byte of DMA_ADDR (512 byte transfer?)
800C84: 5287                     addq.l  #1, D7              ; increment DMACOUNT -> D7
800C86: 2007                     move.l  D7, D0              ; incremented DMACOUNT -> D0
800C88: 0240 3FFF                andi.w  #$3fff, D0          ; strip off top two bits of incremented DMACOUNT -> D0
800C8C: 4840                     swap    D0                  ; incremented DMACOUNT & 0x3fff << 16 -> D0
800C8E: 4240                     clr.w   D0                  ; D0.h = (incremented DMACOUNT & 0x3fff), D0.l = 0000
800C90: 4CEE 0080 FFFC           movem.l (-$4,A6), D7        ; restore D7
800C96: 4E5E                     unlk    A6
800C98: 4E75                     rts

800C9A: 4E56 0000                link    A6, #$0
800C9E: 0079 0040 0000 5000      ori.w   #$40, DISKCNTLSAVE.l        ; floppy selected
800CA6: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l
800CB0: 4E5E                     unlk    A6
800CB2: 4E75                     rts

800CB4: 4E56 0000                link    A6, #$0
800CB8: 0279 FFBF 0000 5000      andi.w  #$ffbf, DISKCNTLSAVE.l      ; floppy deselected
800CC0: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l
800CCA: 4E5E                     unlk    A6
800CCC: 4E75                     rts

800CCE: 4E56 0000                link    A6, #$0
800CD2: 0079 0008 0000 5000      ori.w   #$8, DISKCNTLSAVE.l         ; hard drive selected
800CDA: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l
800CE4: 4E5E                     unlk    A6
800CE6: 4E75                     rts

800CE8: 4E56 0000                link    A6, #$0
800CEC: 0279 FFF7 0000 5000      andi.w  #$fff7, DISKCNTLSAVE.l      ; hard drive deselected
800CF4: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l
800CFE: 4E5E                     unlk    A6
800D00: 4E75                     rts

800D02: 4E56 0000                link    A6, #$0
800D06: 0279 FFF8 0000 5000      andi.w  #$fff8, DISKCNTLSAVE.l      ; clear the head select
800D0E: 202E 0008                move.l  ($8,A6), D0          ; set head select bits
800D12: 0280 0000 0007           andi.l  #$7, D0
800D18: 0280 0000 FFFF           andi.l  #$ffff, D0
800D1E: 8179 0000 5000           or.w    D0, DISKCNTLSAVE.l
800D24: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l  ; set head select
800D2E: 4E5E                     unlk    A6
800D30: 4E75                     rts

800D32: 4E56 0000                link    A6, #$0
800D36: 0279 FF7F 0000 5000      andi.w  #$ff7f, DISKCNTLSAVE.l
800D3E: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l  ; floppy reset
800D48: 4EB9 0080 0A56           jsr     $800a56.l               ; delay
800D4E: 0079 0080 0000 5000      ori.w   #$80, DISKCNTLSAVE.l
800D56: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l  ; floppy no reset
800D60: 4EB9 0080 0A56           jsr     $800a56.l               ; delay
800D66: 4E5E                     unlk    A6
800D68: 4E75                     rts

800D6A: 4E56 0000                link    A6, #$0
800D6E: 0279 FFEF 0000 5000      andi.w  #$ffef, DISKCNTLSAVE.l
800D76: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l  ; hard drive reset
800D80: 4EB9 0080 0A56           jsr     $800a56.l               ; delay
800D86: 0079 0010 0000 5000      ori.w   #$10, DISKCNTLSAVE.l
800D8E: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l  ; hard drive no reset
800D98: 4EB9 0080 0A56           jsr     $800a56.l               ; delay
800D9E: 4E5E                     unlk    A6
800DA0: 4E75                     rts

800DA2: 4E56 0000                link    A6, #$0
800DA6: 0079 0020 0000 5000      ori.w   #$20, DISKCNTLSAVE.l           ; floppy motor ON
800DAE: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l
800DB8: 4E5E                     unlk    A6
800DBA: 4E75                     rts

800DBC: 4E56 0000                link    A6, #$0
800DC0: 0279 FFDF 0000 5000      andi.w  #$ffdf, DISKCNTLSAVE.l         ; floppy motor OFF
800DC8: 33F9 0000 5000 004E 0000 move.w  DISKCNTLSAVE.l, DISKCONTROL.l
800DD2: 4E5E                     unlk    A6
800DD4: 4E75                     rts

800DD6: 4E56 FFFC                link    A6, #-$4
800DDA: 0839 0002 0047 0001      btst    #$2, LPSTATBYTE.l       ; wait loop for HDC interrupt
800DE2: 6602                     bne     $800de6
800DE4: 60F4                     bra     $800dda                 ; loop until HDC IRQ
800DE6: 4EB9 0080 0C54           jsr     $800c54.l
800DEC: 2D40 FFFC                move.l  D0, (-$4,A6)            ; incremented DMA count in high word, or 0 -> local var
800DF0: 7007                     moveq   #$7, D0
800DF2: 2F00                     move.l  D0, -(A7)
800DF4: 4EB9 0080 0B36           jsr     $800b36.l               ; read HDC status
800DFA: 588F                     addq.l  #4, A7
800DFC: 0280 0000 0001           andi.l  #$1, D0                 ; isolate ERR flag
800E02: 81AE FFFC                or.l    D0, (-$4,A6)            ; OR in the ERROR flag from HDC status
800E06: 4EB9 0080 0D6A           jsr     $800d6a.l               ; HDC reset
800E0C: 202E FFFC                move.l  (-$4,A6), D0            ; return status in D0
800E10: 4E5E                     unlk    A6
800E12: 4E75                     rts

800E14: 4E56 FFFC                link    A6, #-$4
800E18: 0839 0003 0047 0001      btst    #$3, LPSTATBYTE.l       ; wait loop for FDC interrupt
800E20: 6602                     bne     $800e24
800E22: 60F4                     bra     $800e18                 ; loop until FDC IRQ
800E24: 4EB9 0080 0C54           jsr     $800c54.l               ; read DMA count?
800E2A: 2D40 FFFC                move.l  D0, (-$4,A6)            ; incremented DMA count in high word, or 0 -> local var
800E2E: 42A7                     clr.l   -(A7)
800E30: 4EB9 0080 0B16           jsr     $800b16.l               ; read (status?) word from FDC -> D0
800E36: 588F                     addq.l  #4, A7
800E38: 81AE FFFC                or.l    D0, (-$4,A6)            ; local var |= word read from FDC
800E3C: 202E FFFC                move.l  (-$4,A6), D0            ; D0.h = incremented DMA count (or 0), D0.l = (status?) word read from FDC
800E40: 4E5E                     unlk    A6
800E42: 4E75                     rts

800E44: 4E56 FFF4                link    A6, #-$c                ; Initialization that occurs after RAM tests
800E48: 48EE 20C0 FFF4           movem.l D6-D7/A5, (-$c,A6)
800E4E: 7C04                     moveq   #$4, D6
800E50: 2A79 0080 000C           movea.l $80000c.l, A5
800E56: 42B9 0000 5046           clr.l   $5046.l
800E5C: 23F9 0000 5046 0000 5042 move.l  $5046.l, $5042.l
800E66: 4EB9 0080 0F44           jsr     $800f44.l
800E6C: 5586                     subq.l  #2, D6
800E6E: 4A86                     tst.l   D6
800E70: 6C08                     bge     $800e7a
800E72: 4EB9 0080 0F44           jsr     $800f44.l
800E78: 7C02                     moveq   #$2, D6
800E7A: 2F39 0080 000C           move.l  $80000c.l, -(A7)
800E80: 2F39 0080 0010           move.l  $800010.l, -(A7)
800E86: 2F06                     move.l  D6, -(A7)
800E88: 4EB9 0080 02A8           jsr     $8002a8.l
800E8E: DEFC 000C                adda.w  #$c, A7
800E92: 2E00                     move.l  D0, D7
800E94: 4A87                     tst.l   D7
800E96: 66D4                     bne     $800e6c
800E98: 4A86                     tst.l   D6
800E9A: 6726                     beq     $800ec2
800E9C: 4EB9 0080 0CE8           jsr     $800ce8.l
800EA2: 2F39 0080 000C           move.l  $80000c.l, -(A7)
800EA8: 2F3C 0000 5012           move.l  #$5012, -(A7)
800EAE: 2F3C 0000 5032           move.l  #$5032, -(A7)
800EB4: 4EB9 0080 062E           jsr     $80062e.l
800EBA: DEFC 000C                adda.w  #$c, A7
800EBE: 2E00                     move.l  D0, D7
800EC0: 6024                     bra     $800ee6
800EC2: 4EB9 0080 0CB4           jsr     $800cb4.l
800EC8: 2F39 0080 000C           move.l  $80000c.l, -(A7)
800ECE: 2F3C 0000 5022           move.l  #$5022, -(A7)
800ED4: 2F3C 0000 503A           move.l  #$503a, -(A7)
800EDA: 4EB9 0080 062E           jsr     $80062e.l
800EE0: DEFC 000C                adda.w  #$c, A7
800EE4: 2E00                     move.l  D0, D7
800EE6: 4A87                     tst.l   D7
800EE8: 6682                     bne     $800e6c
800EEA: 4A6D 005E                tst.w   ($5e,A5)
800EEE: 6604                     bne     $800ef4
800EF0: 6000 FF7A                bra     $800e6c
800EF4: 42A7                     clr.l   -(A7)
800EF6: 2F06                     move.l  D6, -(A7)
800EF8: 4280                     clr.l   D0
800EFA: 302D 005E                move.w  ($5e,A5), D0
800EFE: D080                     add.l   D0, D0
800F00: 2F00                     move.l  D0, -(A7)
800F02: 2F3C 0007 0000           move.l  #$70000, -(A7)
800F08: 202D 005A                move.l  ($5a,A5), D0
800F0C: D080                     add.l   D0, D0
800F0E: 2F00                     move.l  D0, -(A7)
800F10: 4EB9 0080 042C           jsr     $80042c.l
800F16: DEFC 0014                adda.w  #$14, A7
800F1A: 2E00                     move.l  D0, D7
800F1C: 4A87                     tst.l   D7
800F1E: 6600 FF4C                bne     $800e6c
800F22: 4EB9 0080 0DBC           jsr     $800dbc.l
800F28: 4EB9 0080 0CB4           jsr     $800cb4.l
800F2E: 4EB9 0080 0CE8           jsr     $800ce8.l
800F34: 4EB9 0080 0286           jsr     $800286.l
800F3A: 4CEE 20C0 FFF4           movem.l (-$c,A6), D6-D7/A5
800F40: 4E5E                     unlk    A6
800F42: 4E75                     rts

800F44: 4E56 FFFC                link    A6, #-$4
800F48: 3D79 0000 5044 FFFE      move.w  $5044.l, (-$2,A6)
800F50: 4280                     clr.l   D0
800F52: 302E FFFE                move.w  (-$2,A6), D0
800F56: 2239 0000 5042           move.l  $5042.l, D1
800F5C: 5C81                     addq.l  #6, D1
800F5E: B081                     cmp.l   D1, D0
800F60: 625A                     bhi     $800fbc
800F62: 2F3C 0000 FFFF           move.l  #$ffff, -(A7)
800F68: 2039 0000 5046           move.l  $5046.l, D0
800F6E: 5880                     addq.l  #4, D0
800F70: 2F00                     move.l  D0, -(A7)
800F72: 2F39 0000 5046           move.l  $5046.l, -(A7)
800F78: 4280                     clr.l   D0
800F7A: 302E FFFE                move.w  (-$2,A6), D0
800F7E: 2F00                     move.l  D0, -(A7)
800F80: 4EB9 0080 0FF8           jsr     $800ff8.l
800F86: DEFC 0010                adda.w  #$10, A7
800F8A: 42A7                     clr.l   -(A7)
800F8C: 2039 0000 5046           move.l  $5046.l, D0
800F92: 0680 0000 0009           addi.l  #$9, D0
800F98: 2F00                     move.l  D0, -(A7)
800F9A: 2039 0000 5046           move.l  $5046.l, D0
800FA0: 5A80                     addq.l  #5, D0
800FA2: 2F00                     move.l  D0, -(A7)
800FA4: 4280                     clr.l   D0
800FA6: 302E FFFE                move.w  (-$2,A6), D0
800FAA: 2F00                     move.l  D0, -(A7)
800FAC: 4EB9 0080 0FF8           jsr     $800ff8.l
800FB2: DEFC 0010                adda.w  #$10, A7
800FB6: 526E FFFE                addq.w  #1, (-$2,A6)
800FBA: 6094                     bra     $800f50
800FBC: 06B9 0000 000A 0000 5046 addi.l  #$a, $5046.l
800FC6: 0CB9 0000 02D0 0000 5046 cmpi.l  #$2d0, $5046.l
800FD0: 6D22                     blt     $800ff4
800FD2: 42B9 0000 5046           clr.l   $5046.l
800FD8: 06B9 0000 000C 0000 5042 addi.l  #$c, $5042.l
800FE2: 0CB9 0000 015C 0000 5042 cmpi.l  #$15c, $5042.l
800FEC: 6D06                     blt     $800ff4
800FEE: 42B9 0000 5042           clr.l   $5042.l
800FF4: 4E5E                     unlk    A6
800FF6: 4E75                     rts

800FF8: 4E56 FFFC                link    A6, #-$4
800FFC: 3D6E 000E FFFC           move.w  ($e,A6), (-$4,A6)
801002: 302E FFFC                move.w  (-$4,A6), D0
801006: B06E 0012                cmp.w   ($12,A6), D0
80100A: 6224                     bhi     $801030
80100C: 2F2E 0014                move.l  ($14,A6), -(A7)
801010: 4280                     clr.l   D0
801012: 302E 000A                move.w  ($a,A6), D0
801016: 2F00                     move.l  D0, -(A7)
801018: 4280                     clr.l   D0
80101A: 302E FFFC                move.w  (-$4,A6), D0
80101E: 2F00                     move.l  D0, -(A7)
801020: 4EB9 0080 1034           jsr     $801034.l
801026: DEFC 000C                adda.w  #$c, A7
80102A: 526E FFFC                addq.w  #1, (-$4,A6)
80102E: 60D2                     bra     $801002
801030: 4E5E                     unlk    A6
801032: 4E75                     rts

801034: 4E56 FFF8                link    A6, #-$8
801038: 322E 000E                move.w  ($e,A6), D1
80103C: C2FC 005A                mulu.w  #$5a, D1
801040: 0681 0042 0000           addi.l  #VRAM_START, D1
801046: 4280                     clr.l   D0
801048: 302E 000A                move.w  ($a,A6), D0
80104C: E888                     lsr.l   #4, D0
80104E: D080                     add.l   D0, D0
801050: D280                     add.l   D0, D1
801052: 2D41 FFFC                move.l  D1, (-$4,A6)
801056: 4280                     clr.l   D0
801058: 302E 000A                move.w  ($a,A6), D0
80105C: 4281                     clr.l   D1
80105E: 322E 000A                move.w  ($a,A6), D1
801062: E889                     lsr.l   #4, D1
801064: E989                     lsl.l   #4, D1
801066: 9081                     sub.l   D1, D0
801068: 3D40 FFFA                move.w  D0, (-$6,A6)
80106C: 4280                     clr.l   D0
80106E: 302E FFFA                move.w  (-$6,A6), D0
801072: 2F00                     move.l  D0, -(A7)
801074: 4EB9 0080 10A2           jsr     $8010a2.l
80107A: 588F                     addq.l  #4, A7
80107C: 3D40 FFFA                move.w  D0, (-$6,A6)
801080: 4AAE 0010                tst.l   ($10,A6)
801084: 670C                     beq     $801092
801086: 206E FFFC                movea.l (-$4,A6), A0
80108A: 302E FFFA                move.w  (-$6,A6), D0
80108E: 8150                     or.w    D0, (A0)
801090: 600C                     bra     $80109e
801092: 302E FFFA                move.w  (-$6,A6), D0
801096: 4640                     not.w   D0
801098: 206E FFFC                movea.l (-$4,A6), A0
80109C: C150                     and.w   D0, (A0)
80109E: 4E5E                     unlk    A6
8010A0: 4E75                     rts

8010A2: 4E56 FFFC                link    A6, #-$4
8010A6: 3D7C 0001 FFFE           move.w  #$1, (-$2,A6)
8010AC: 4280                     clr.l   D0
8010AE: 302E FFFE                move.w  (-$2,A6), D0
8010B2: 4281                     clr.l   D1
8010B4: 322E 000A                move.w  ($a,A6), D1
8010B8: E3A8                     lsl.l   D1, D0
8010BA: 3D40 FFFE                move.w  D0, (-$2,A6)
8010BE: 302E FFFE                move.w  (-$2,A6), D0
8010C2: 4E5E                     unlk    A6
8010C4: 4E75                     rts

8010C6: 0000 2F01                ori.b   #$1, D0
8010CA: 4280                     clr.l   D0
8010CC: 302F 000A                move.w  ($a,A7), D0
8010D0: C0EF 000E                mulu.w  ($e,A7), D0
8010D4: 4281                     clr.l   D1
8010D6: 322F 0008                move.w  ($8,A7), D1
8010DA: C2EF 000E                mulu.w  ($e,A7), D1
8010DE: 4841                     swap    D1
8010E0: 4241                     clr.w   D1
8010E2: D081                     add.l   D1, D0
8010E4: 4281                     clr.l   D1
8010E6: 322F 000C                move.w  ($c,A7), D1
8010EA: C2EF 000A                mulu.w  ($a,A7), D1
8010EE: 4841                     swap    D1
8010F0: 4241                     clr.w   D1
8010F2: D081                     add.l   D1, D0
8010F4: 221F                     move.l  (A7)+, D1
8010F6: 4E75                     rts

8010F8: 2F01                     move.l  D1, -(A7)
8010FA: 4280                     clr.l   D0
8010FC: 202F 0008                move.l  ($8,A7), D0
801100: 81EF 000E                divs.w  ($e,A7), D0
801104: 48C0                     ext.l   D0
801106: 221F                     move.l  (A7)+, D1
801108: 4E75                     rts

80110A: 2F01                     move.l  D1, -(A7)
80110C: 4280                     clr.l   D0
80110E: 202F 0008                move.l  ($8,A7), D0
801112: 81EF 000E                divs.w  ($e,A7), D0
801116: E080                     asr.l   #8, D0
801118: E080                     asr.l   #8, D0
80111A: 221F                     move.l  (A7)+, D1
80111C: 4E75                     rts
