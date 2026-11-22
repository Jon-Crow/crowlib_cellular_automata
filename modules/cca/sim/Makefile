CROWLIB_PATH ?= ../../../../crowlib
WIDTH        ?= 64
HEIGHT       ?= 64
SEED         ?= $(shell powershell -NoProfile -Command "[DateTimeOffset]::UtcNow.ToUnixTimeSeconds()")

include $(CROWLIB_PATH)/crowlib_ghdl.mk

clean:
	del *.cf *.fst *.o *.exe *.vpi *.dll

analyze::
	ghdl -a --std=08 ../hdl/cca_cell.vhd \
                   cca_tb.vhd          \
									 cca_cfg.vhd

compile: analyze
	ghdl -e --std=08 cca_cfg

sim:
	ghdl -r --std=08 cca_cfg -gG_WIDTH=$(WIDTH) -gG_HEIGHT=$(HEIGHT) -gG_SEED=$(SEED) --ieee-asserts=disable-at-0 --vpi=sim_display.vpi --fst=wave.fst

view:
	gtkwave -a wave.gtkw wave.fst
