; vim: set et ts=8 sw=8 sts=8 syntax=64tass:
;


        * = $0801

        .word (+), 2020
        .null $9e, format("%d", start)
+        .word 0


start

        lda #$04
        ldx #<dialogs
        ldy #>dialogs
        jsr pui.init
        jsr pui.clear_screen


        jsr test_frame
        rts


test_frame .proc
        ldx #08
        ldy #04
        jsr pui.frame.set_pos
        lda #$03
        jsr pui.frame.set_color
        ldx #20
        ldy #08
        jsr pui.frame.set_size
        ldx #<test_frame_title
        ldy #>test_frame_title
        jsr pui.frame.render
        rts
.pend

test_frame_title
        .enc "screen"

        .byte $01
        .text "hello world!", 0




dialogs
        .word 0


        * = $1000


pui     .binclude "lib/pui-main.s"

