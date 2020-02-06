; vim: set et ts=8 sw=8 sts=8 syntax=64tass:
;
; @brief        Frame handling for dialogs
;


; @brief        Set frame position
;
; @param X      xpos
; @param Y      ypos
;
set_pos .proc
        stx data.frame_xpos
        sty data.frame_ypos
        rts
.pend


; @brief        Set frame color
;
; @param A      frame color
;
set_color .proc
        sta data.frame_color
        rts
.pend


; @brief        Set frame height size
;
; @param X      width
; @param Y      height
;
set_size .proc
        stx data.frame_width
        sty data.frame_height
        rts
.pend


; @brief        Render frame with optional title
;
; Pass 0 in X and Y to disable title rendering.
;
; @param X      title LSB
; @param Y      title MSB
;
; @zeropage     8
;
render .proc

;        pui_vram = PUI_ZP + 0
;        pui_cram = PUI_ZP + 2
        title = pui_zp
        content_height = pui_zp + 2
        content_width = pui_zp + 3
        color = pui_zp + 4

        stx title + 0
        sty title + 1

        ldx data.frame_xpos
        ldy data.frame_ypos
        jsr base.get_screenpos_zp
.if DEBUG
        sta $0400
        stx $0401
        sty $0402
.endif
        ldx data.frame_width
.if DEBUG
        stx $0404
.endif
        dex
        dex
        stx content_width
.if DEBUG
        stx $0406
.endif
        ldy data.frame_height
        dey
        dey
        sty content_height
.if DEBUG
        sty $0407
.endif

        ; render top-left corner
        ldy #0
        lda #SCRCODES.FRAME_TOP_LEFT
        sta (pui_vram),y
        lda data.frame_color
        sta (pui_cram),y

        ; render top border
        ldx content_width

        lda title + 0
        ora title + 1
        beq title_done
        lda (title),y
        sta color
-       iny
        lda (title),y
        beq title_done
        sta (pui_vram),y
        lda color
        sta (pui_cram),y
        dex
        bne -
        iny
title_done
-       lda #SCRCODES.FRAME_TOP_MIDDLE
        sta (pui_vram),y
        lda data.frame_color
        sta (pui_cram),y
        iny
        dex
        bne -

        ; render top-right corner
        sta (pui_cram),y
        lda #SCRCODES.FRAME_TOP_RIGHT
        sta (pui_vram),y

        ; render left and right border and wipe frame content
        lda pui_vram + 0
        clc
        adc #40
        sta pui_vram + 0
        sta pui_cram + 0
        bcc +
        inc pui_vram + 1
        inc pui_cram + 1
+       ldx content_height
.if DEBUG
        stx $0408
.endif

more_rows
        ; render left border
        ldy #0
        lda #SCRCODES.FRAME_MID_LEFT
        sta (pui_vram),y
        lda data.frame_color
        sta (pui_cram),y

        ; fill frame content with spaces
        lda #$20
-       iny
        sta (pui_vram),y
        cpy content_width
        bne -
        ; render right border
        iny
        lda #SCRCODES.FRAME_MID_RIGHT
        sta (pui_vram),y
        lda data.frame_color
        sta (pui_cram),y

        ; update pui_vram/pui_cram pointers
        lda pui_vram + 0
        clc
        adc #40
        sta pui_vram + 0
        sta pui_cram + 0
        bcc +
        inc pui_vram + 1
        inc pui_cram + 1
+
        dex
        bne more_rows

        ; render lower border

        ; bottom-left corner
        ldy #0
        lda #SCRCODES.FRAME_BOT_LEFT
        sta (pui_vram),y
        lda data.frame_color
        sta (pui_cram),y

        ; bottom middle
        iny
        ldx content_width
-
        lda #SCRCODES.FRAME_BOT_MIDDLE
        sta (pui_vram),y
        lda data.frame_color
        sta (pui_cram),y
        iny
        dex
        bne -

        ; lower-left corner
        sta (pui_cram),y
        lda #SCRCODES.FRAME_BOT_RIGHT
        sta (pui_vram),y
        rts
.pend

