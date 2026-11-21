CROWLIB_PATH ?= ../../../../crowlib

include $(CROWLIB_PATH)/crowlib_ghdl.mk

analyze::
	ghdl -a --std=08 ../hdl/game_of_life_cell.vhd \
                   ../hdl/game_of_life.vhd \
									 game_of_life_tb.vhd

compile: analyze
	ghdl -e --std=08 game_of_life_tb

sim:
	ghdl -r --std=08 game_of_life_tb --ieee-asserts=disable-at-0 --vpi=sim_display.vpi --fst=wave.fst

view:
	gtkwave -a wave.gtkw wave.fst
