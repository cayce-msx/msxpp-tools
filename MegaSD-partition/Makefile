# https://www.gnu.org/software/make/manual/make.html

target_file = msdpar
target = $(target_file).com

%.com: %.asm
	sjasm $< $@

all: $(target)

clean:
	rm $(target) $(target_file).lst

run:
	openmsx -machine Philips_NMS_8250 -ext MegaFlashROM_SCC+_SD -diska .
