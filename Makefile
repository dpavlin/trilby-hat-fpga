PROJ:=led
PROJ=i2c
TRELLIS?=/usr/share/trellis

all: ${PROJ}.bit

%.json: %.v
	yosys -p "synth_ecp5 -json $@" $<

%_out.config: %.json
	nextpnr-ecp5 --json $< --textcfg $@ --45k --package CABGA381 --lpf trilby.lpf

%.bit: %_out.config
	ecppack --compress --svf ${PROJ}.svf $< $@

${PROJ}.svf : ${PROJ}.bit

prog: ${PROJ}.svf
	openocd -f openocd/trilby.cfg -c "transport select jtag; init; svf $<; exit"

clean:
	rm -f *.svf *.bit *.config *.json

.PHONY: prog clean
