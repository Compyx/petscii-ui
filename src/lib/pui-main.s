; vim: set et ts=8 sw=8 sts=8 syntax=64tass:
;

; Allocate zero page 'variables'
;
; Use some zp locations for often reused data and thus make them survive
; between routines so we can avoid having to calculate the data again, both
; speeding up the code and making it smaller
;
; Use other zp locations for data that should persist from the top of a call
; stack of a dialog routine and finally use some zp locations as scratch space:
; these locations are expected to only be used/valid inside a routine.

        pui_vram = PUI_ZEROPAGE         ; PUI_ZEROPAGE+0/PUI_ZEROPAGE+1
        pui_cram = pui_vram + 2         ; PUI_ZEROPAGE+2/PUI_ZEROPAGE+3
        pui_zp   = pui_cram + 2         ; PUI_ZEROPAGE+4/PUI_ZEROPAGE+5

        pui_zp_tmp = PUI_ZEROPAGE + $18


.include "pui-screencodes.inc"


        jmp init

data .block

        ; Mutable data, this obviously won't work when using this code in a
        ; cart or so
        ;
        screen          .byte $04       ; screen MSB
        dialogs         .word $00       ; table of dialog pointers
        frame_xpos      .byte $ff       ; frame xpos
        frame_ypos      .byte $ff       ; frame ypos
        frame_width     .byte $ff       ; frame width
        frame_height    .byte $ff       ; frame height
        frame_color     .byte $ff       ; frame color
        text_xpos       .byte $ff
        text_ypos       .byte $ff
        text_color      .byte $ff

        ; Immutable data
        ;

        ; vidram row offsets
        _ := range(0, 1000, 40)
        vram_lo .byte <_
        vram_hi .byte >_


.bend


; @brief        Initialize UI
;
; @param A      screen MSB
; @param X      dialog table LSB
; @param Y      dialog table MSB
;
init .proc
        sta data.screen
        stx data.dialogs
        sty data.dialogs + 1
        rts
.pend


; @brief        Clear screen
;
; @clobbers     A,X,Y
; @zeropage     2
;
clear_screen .proc

        ldy #0
        sty pui_vram + 0
        lda data.screen
        sta pui_vram + 1
        lda #$ff
        ldx #3
-       sta (pui_vram),y
        iny
        bne -
        inc pui_vram + 1
        dex
        bne -
-       sta (pui_vram),y
        iny
        cpy #$e8
        bne -
        rts
.pend

.dsection base
.section base
base    .binclude "pui-base.s"
.send
.dsection frame
.section frame
frame   .binclude "pui-frame.s"
.send



