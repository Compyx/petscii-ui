; vim: set et ts=8 sw=8 sts=8 syntax=64tass:
;
; @file         pui-base.s
; @brief        base functions
;





;; @brief       Get vidram and colram position based on @a X and @a Y
;
; Doesn't touch pui_vram/pui_cram zero page locations, to store result in
; the pui_vram/pui_cram zero page locations, use @ref get_screenpos_zp.
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


;; @brief       Get vidram and colram position based on @a X and @a Y
;
; Stores result in the pui_vram/pui_cram zero page locations,
; use @ref get_screenpos to avoid that.
;
; @param X      xpos
; @param Y      ypos
;
; @return A     colram MSB
; @return X     colram/vidram LSB
; @return Y     vidram MSB
;

get_screenpos_zp .proc
        jsr get_screenpos
        stx pui_vram + 0
        sty pui_vram + 1
        stx pui_cram + 0
        sta pui_cram + 1
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

        columns = pui_zp

        sta columns
        jsr get_screenpos_zp
        rts
.pend



