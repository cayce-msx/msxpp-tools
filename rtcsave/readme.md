# RTCSAVE

Saves [MSX RTC](https://www.msx.org/wiki/Real_Time_Clock_Programming) (Real Time Clock) settings _inside_ `OCM-BIOS.DAT` on SD card.

This solves the issue of not having a battery to retain CMOS memory, as found on regular MSX computers.

See also the accompanying [RTC helper tool in BASIC](rtcsetup.asc).


## installation
1. Create an SD card with OCM-BIOS.
2. Copy `RTCSAVE.COM` and optionally `RTCSETUP.ASC` to it.


## requirements
`RTCSAVE` runs on OCM/MSX++ devices with OCM-PLD v2.4 or higher.

Use MegaSD with MSX-DOS2, or Nextor.
MSX-DOS1 is not supported.

An SD-BIOS file must be present in the root directory of the SD card, 
and named `OCM-BIOS.DA?` with `?` being `T` or `0`-`9`. 


## user manual
Syntax: `rtcsave [{/|-}option]`

See a [more extensive manual](https://github.com/cayce-msx/msxpp-quick-ref/wiki/Howtos#how-to-save-rtc-data) in the MSX++ quickref.

### MAIN-ROM COLOR
Default settings without no parameter:
* if SCREEN 0  set COLOR foregr,backgr,backgr from RTC
* if SCREEN 1  set COLOR foregr,backgr,border from RTC

Custom settings through options:
* /a  COLOR foregr,border,border from RTC
* /b  COLOR white,black,black (15,0,0)
* /c  COLOR from System Variables in RAM
* /x  exclude MAIN-ROM from saving

### SUB-ROM RTC CODE
Perform `SET SCREEN` from BASIC before saving the RTC code


## potential future improvements
* Handle fragmented `OCM-BIOS.DA?` files.
  Running this tool on a fragmented file will damage files on disk.
  To verify, first run `CONCLUS.COM`.
  Note that OCM-PLD 3.9.1 and below _also_ do not support fragmented files.
  OCM-PLD 3.9.2 _might_ support it.


## license
This tool is **NOT** GPLv3.

RTCSAVE has a [custom license](rtcsave.asm) in the header of its source file.


## origins & releases
RTCSAVE was created for OneChipMSX (OCM) by NYYRIKKI in 2008.

KdL upgraded it for OCM-PLD in 2017-2019.
Released (source+binary) in the OCM-PLD Pack, folder `msxtools/rtcsave`.

Brought up to par with OCM-PLD 3.9.1 by Cayce & KdL 2024 in this github repo.

## BIOS patch
RTCSAVE requires a patched MSX Sub-ROM BIOS.

Source of that patch is provided at `rtcpatch.gen`. 

## changelog
* Revision 3.1 (Cayce & KdL 2024.10) 
  * support `OCM-BIOS.DAT` files stored at any sector
    * before, the hardcoded assumption was that `OCM-BIOS.DAT` starts at the very first sector after the FAT; an assumption that no longer holds since OCM-PLD v3.9.1
    * the update is compatible with OCM-PLD devices with an older firmware
  * support `OCM-BIOS.DAi` with i=0-9
    * the first matching file is used; equivalent to OCM-PLD IPL-ROM behaviour
  * support Nextor
  * print name of file being patched
* Revision 3.0 (KdL 2019.05.20)
  * Added MAIN-ROM color options.
  * Text corrections and some additions.
  * Fully revised source code.
* Revision 2.2 (KdL 2017.09.18)
  * Auto-scanning for RTC patch on any "custom BIOS" up to 1024 kB.
  * Changed the string UNEXPECTED ERROR! into UNSUPPORTED KERNEL FOUND!
* Revision 1.0 (NYYRIKKI)
  * First public release.


## development
RTCSAVE is coded in TASM80 v3.2ud w/ TWZ'CA3.
Compile with [TASM v3.2 for DOS/Windows](https://www.ticalc.org/pub/dos/asm/tasm32.zip) (9-Jan-2001) from [ticalc.org](https://www.ticalc.org).
(`TASM.EXE`, SHA1: `fc6ba13acb01fac4825af407bed1f47e7ee223e7`)

Source of `tasm80.tab` (the table that delivers "ud w/ TWZ'CA3" features) is unknown.
See `make/dev/tasm/tasm80.tab` of [KdL's OCM-SDBIOS Pack](https://gnogni.altervista.org/) for the one used for `RTCSAVE`.
(22611 Bytes, SHA1 `bc9f9b6f452ae5ff9c3e42cce922549ff01993be`)

Compilation under Linux: `[xvfb-run] wine tasm.exe -i -e -a13 -80 -b rtcsave.asm rtcsave.com`
See also [GNU Makefile](Makefile).
(Should also work with DOSbox instead of Wine.)


## code style & other restrictions
The `[RTCSAVE.COM]` marker at the end must be 16B-aligned.
Verify with a hex-editor (Linux: `xxd rtcsave.com`) whether `startFill` must be enabled or not.

Try to keep line length to max 130 chars.

Most texts are obfuscated on purpose.
The program is protected against binary editing the copyright notice.
You are most welcome to fork and/or contribute code.


## testing
To test in openMSX using the [OCM_MegaSD extension](../OpenMSX-MegaSD-extension/readme.md), apply this patch locally:
```
@@ -260,7 +260,7 @@
             in    a,(c)
             cp    255-OCM_IO
             ld    hl,noOCMMsg             ; 'OCM device not found!'
-            jp    nz,lastDisp
+            ;jp    nz,lastDisp            ; OpenMSX: don't jump (until OCM-PLD switched IO device is supported)
; ----------------------------------------
             ld    bc,$5A00+_DOSVER        ; check for Nextor
             ld    hl,$1234
@@ -651,7 +651,7 @@
setrwSectorMegaSD:
             ccf                           ; CCF = read sector, NOP = write sector
             rst   30
-            .DB   %10001011               ; slot 3-2
+            .DB   %10001101               ; slot 1-3 -ext OCM_MegaSD
             .DW   $4010
             ld    c,LF+ONE                ; init 'call strDisp' to use
             ret
@@ -681,7 +681,7 @@
; ----------------------------------------
rRTC:
             rst   30
-            .DB   %10000111               ; slot 3-1
+            .DB   %10000011               ; slot 3-0 NMS8250
             .DW   REDCLK
             ret
; ----------------------------------------
```
This matches with the [Makefile](Makefile) definitions for `make megasd` & `make nextor`.
