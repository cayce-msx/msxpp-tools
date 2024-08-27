# RTCSAVE

Saves [MSX RTC](https://www.msx.org/wiki/Real_Time_Clock_Programming) (Real Time Clock) settings _inside_ `OCM-BIOS.DAT` on SD card.

See also [BASIC helper tool](rtcsetup.asc).


## installation
Create an SD card with OCM-BIOS. 
Copy `RTCSAVE.COM` and optionally `RTCSETUP.ASC` to it.


## manual
Syntax: `rtcsave [{/|-}option]`

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
Perform SET SCREEN from BASIC before saving the RTC code


## license
Not GPLv3 - see [custom license](rtcsave.asm) (header of source file).


## development
Coded in TASM80 v3.2ud w/ TWZ'CA3

TASM for Windows is at http://www.ticalc.org

Compilation under Linux: `[xvfb-run] wine tasm.exe -i -e -a13 -80 -b rtcsave.asm rtcsave.com`
See also [GNU Makefile](Makefile).
