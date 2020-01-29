; vim: set et ts=8 sw=8 sts=8 syntax=64tass:
;
; @file         pui-base.s
; @brief        base functions
;





; @brief        Get screen vidram and colorram position based on @a X and @a Y
;
; @param X      xpos
; @param Y      ypos
;
; @return A     colram MSB
; @return X     colram/vidram LSB
; @return Y     vidram MSB
;
get_screenpos .proc
        txa
        clc
        adc data.vram_lo,y
        tax
        lda data.vram_hi,y
        adc data.screen
        tay
        and #$03
        ora #$d8
        rts
.pend


; @brief        Set text renderer screen position
;
; @param X      x position
; @param Y      y position
;
text_renderer_set_pos .proc
        stx data.text_xpos
        sty data.text_ypos
        rts
.pend

; @brief        Render PETSCII text
;
; Render text on screen. Call text_renderer_set_pos() first. Terminate text
; with $00.
;
; @param A      maximum number of characters per line (0 = ignore)
; @param X      text LSB
; @param Y      text MSB
;
text_renderer_render .proc

        vidram = PUI_ZP + 0
        colram = PUI_ZP + 2
        columns = PUI_ZP + 4

        sta columns
        jsr get_screenpos
        stx vidram + 0
        sty vidram + 1
        stx colram + 0
        sta colram + 1
        rts
.pend



