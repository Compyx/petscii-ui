; vim: set et ts=8 sw=8 sts=8 syntax=64tass:
;

        PUI_ZP_TMP = PUI_ZP + $10


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

        vidram = PUI_ZP

        ldy #0
        sty vidram + 0
        lda data.screen
        sta vidram + 1
        lda #$ff
        ldx #3
-       sta (vidram),y
        iny
        bne -
        inc vidram + 1
        dex
        bne -
-       sta (vidram),y
        iny
        cpy #$e8
        bne -
        rts
.pend

base    .binclude "pui-base.s"
frame   .binclude "pui-frame.s"




