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
; @TODO         implement rendering title
;
render .proc

        vidram = PUI_ZP + 0
        colram = PUI_ZP + 2
        title = PUI_ZP + 4
        content_height = PUI_ZP + 6
        content_width = PUI_ZP + 7
        color = PUI_ZP + 8

        stx title + 0
        sty title + 1

        ldx data.frame_xpos
        ldy data.frame_ypos
        jsr base.get_screenpos
.if DEBUG
        sta $0400
        stx $0401
        sty $0402
.endif
        sta colram + 1
        stx vidram + 0
        stx colram + 0
        sty vidram + 1

        ldx data.frame_width
        stx $0404
        dex
        dex
        stx content_width
        stx $0406
        ldy data.frame_height
        dey
        dey
        sty content_height
        sty $0407

        ; render top-left corner
        ldy #0
        lda #SCRCODES.FRAME_TOP_LEFT
        sta (vidram),y
        lda data.frame_color
        sta (colram),y

        ; render top border
        ldx content_width
-       iny
        lda #SCRCODES.FRAME_TOP_MIDDLE
        sta (vidram),y
        lda data.frame_color
        sta (colram),y
        dex
        bne -

        ; render top-right corner
        iny
        sta (colram),y
        lda #SCRCODES.FRAME_TOP_RIGHT
        sta (vidram),y


        ; render left and right border and wipe frame content
        lda vidram + 0
        clc
        adc #40
        sta vidram + 0
        sta colram + 0
        bcc +
        inc vidram + 1
        inc colram + 1
+

        ldx content_height
        stx $0408
;        ldx #5
more_rows
        ; render left border
        ldy #0
        lda #SCRCODES.FRAME_MID_LEFT
        sta (vidram),y
        lda data.frame_color
        sta (colram),y

        ; fill frame content with spaces
        lda #$20
-       iny
        sta (vidram),y
        cpy content_width
        bne -
        ; render right border
        iny
        lda #SCRCODES.FRAME_MID_RIGHT
        sta (vidram),y
        lda data.frame_color
        sta (colram),y

        ; update vidram/colram pointers
        lda vidram + 0
        clc
        adc #40
        sta vidram + 0
        sta colram + 0
        bcc +
        inc vidram + 1
        inc colram + 1
+
        dex
        bne more_rows

        ; render lower border

        ; bottom-left corner
        ldy #0
        lda #SCRCODES.FRAME_BOT_LEFT
        sta (vidram),y
        lda data.frame_color
        sta (colram),y

        ; bottom middle
        iny
        ldx content_width
-
        lda #SCRCODES.FRAME_BOT_MIDDLE
        sta (vidram),y
        lda data.frame_color
        sta (colram),y
        iny
        dex
        bne -

        ; lower-left corner
        sta (colram),y
        lda #SCRCODES.FRAME_BOT_RIGHT
        sta (vidram),y

        lda title + 0
        ora title + 1
        beq done

        ; render title
        ldx data.frame_xpos
        ldy data.frame_ypos
        jsr base.get_screenpos

        sta colram + 1
        stx vidram + 0
        stx colram + 0
        sty vidram + 1

        ldy #0
        lda (title),y
        sta color

        ; move vidram/colram pos one right AND skip the color byte
-       iny
        ; render 0-terminated screencodes as title
        lda (title),y
        beq done
        sta (vidram),y
        lda color
        sta (colram),y
        jmp -
done
        rts
.pend

