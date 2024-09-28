target_file = rtcsave
target = $(target_file).com

%.com: %.asm
	xvfb-run wine tasm.exe -i -e -a13 -80 -b $< $@

all: $(target) git-commit.txt

git-commit.txt:
	git rev-parse HEAD | cut -c1-8 | awk '{print ".DB $$"substr($$0,1,2)",$$"substr($$0,3,2)",$$"substr($$0,5,2)",$$"substr($$0,7,2)}' > $@

clean:
	rm -f $(target) $(target_file).lst git-commit.txt

megasd:
	openmsx -machine Philips_NMS_8250 -ext OCM_MegaSD -hda rtcsave-test.img -diska .

nextor:
	openmsx -machine Philips_NMS_8250 -ext OCM_Nextor -hda rtcsave-test.img -diska .
