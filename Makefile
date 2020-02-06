# vim: set noet ts=8 sw=8 sts=8:
#
# Makefile for the PETSCII-UI and its tests


TARGET = petscii-ui-test.prg

LABEL_FILE = labels.txt

ASM = 64tass
ASM_FLAGS = --case-sensitive --ascii --vice-labels --labels $(LABEL_FILE) \
	    -Wall -Walias -Waltmode -Wbranch-page -Wcase-symbol \
	    -Wno-leading-zeros \
	    -D PUI_ZEROPAGE='$$10' -D DEBUG=true


LIB_SOURCES = src/lib/pui-main.s src/lib/pui-base.s src/lib/pui-frame.s
LIB_INCLUDES = src/lib/pui-screencodes.inc


SOURCES = src/main.s $(LIB_INCLUDES) $(LIB_SOURCES)


$(TARGET): $(SOURCES)
	$(ASM) $(ASM_FLAGS) -o $@ $<


.PHONY: clean
clean:
	rm -f $(TARGET)
