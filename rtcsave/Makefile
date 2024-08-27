target_file = rtcsave
target = $(target_file).com

%.com: %.asm
	xvfb-run wine tasm.exe -i -e -a13 -80 -b $< $@

all: $(target)

clean:
	rm $(target) $(target_file).lst

run:
	openmsx -machine Philips_NMS_8250 -ext OCM_MegaSD -hda rtcsave-test.img -diska .
