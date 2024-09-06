# OpenMSX MegaSD extension for OneChipMSX

This extension is a customization of the existing extension `MegaFlashRomSCCPlusSD`.

MegaFlashRom SCC+ SD by Manuel Pazos (2013) appears to be based on ESE MegaSD (2006).
Or at least the addition of SD to the pre-existing MegaFlashROM SCC & SCC+ devices, which were released in 2003 & 2010.
Luckily, that also means the emulation of both devices is similar.
The MMC/SD interface is the same for both.

Writing to FlashRom vs. ESE-RAM, however, differs.
This is important, since MegaSD writes configuration to ESE-RAM.
(In comparison, Nextor does not do that.)
See lines 170 & 332 of the patch file for the required code changes.

Additionally, the code related to subslots 0, 1 & 2 has been removed, 
but MegaSD would run fine even with that code intact.

The patch provided here contains some commented printf-debugging code.

I'm hesistant to file a proper PR for this extension to the openMSX developers,
since this is a bit of a hack - I'm opening up a direct path to the SRAM underneath the
FlashRom. 

## Applying this to your local openMSX
1. apply patch file `OpenMSX_OCM_MegaSD_extension.patch`
   * no need to copy `MegaSD.cc/hh` separately; those are included in the patch.
     And separately in this directory just in case you're interested.
2. compile & install openMSX, basically: `./configure && make && sudo make install`
3. copy `OCM_MegaSD.xml` to your local `extensions` directory, e.g., `/opt/openMSX/share/extensions/`
4. copy `megasd1s.rom` and/or `megasd2s.rom` (from [KdL's OCM-SDBIOS Pack](https://gnogni.altervista.org/)) to the openMSX systemrom folder, e.g., `~/.openMSX/share/systemroms/`
5. run `openmsx -ext OCM_MegaSD`, optionally with `-hda some_disk_image`

Two files will be created in, e.g., `~/.openMSX/persistent/OCM_MegaSD/untitled1`:
* `megasd.sram`
* `SDcard1.sdc`

Note that this extension was developed & tested on Linux; for Windows other changes (and other paths) might apply.

## Nextor
You can also run Nextor on top of the MegaSD hardware emulation.

First make sure you've patched, compiled & installed openMSX; see above. 
Then:
1. copy `OCM_Nextor.xml` to your local `extensions` directory, e.g., `/opt/openMSX/share/extensions/`
2. copy `Nextor-2.1.2.OCM.ROM` (from [Nextor releases](https://github.com/Konamiman/Nextor/releases)) to the openMSX systemrom folder, e.g., `~/.openMSX/share/systemroms/`
3. run `openmsx -ext OCM_Nextor`, optionally with `-hda some_disk_image`
