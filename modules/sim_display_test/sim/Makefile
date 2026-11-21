CROWLIB_PATH ?= ../../../../crowlib

include $(CROWLIB_PATH)/crowlib_ghdl.mk

analyze::
	ghdl -a --std=08 sim_display_tb.vhd

compile: analyze
	ghdl -e --std=08 sim_display_tb

sim:
	ghdl -r --std=08 sim_display_tb --vpi=sim_display.vpi --fst=wave.fst

view:
	gtkwave -a wave.gtkw wave.fst
