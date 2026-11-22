CROWLIB_PATH ?= ../../../../crowlib
SEED ?= $(shell powershell -NoProfile -Command "[DateTimeOffset]::UtcNow.ToUnixTimeSeconds()")

include $(CROWLIB_PATH)/crowlib_ghdl.mk

clean:
	del *.cf *.fst *.o *.exe *.vpi *.dll

analyze::
	ghdl -a --std=08 ../hdl/game_of_life_cell.vhd \
                   ../hdl/game_of_life.vhd \
									 game_of_life_tb.vhd \
									 game_of_life_cfg.vhd

compile: analyze
	ghdl -e --std=08 game_of_life_cfg

sim:
	ghdl -r --std=08 game_of_life_cfg -gG_SEED=$(SEED) --ieee-asserts=disable-at-0 --vpi=sim_display.vpi --fst=wave.fst

view:
	gtkwave -a wave.gtkw wave.fst
