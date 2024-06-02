# MegaSD partition tool

In 8.3 naming: `MSDPAR.COM`.

Based on `PARSET` v1.1 & `PARLIST` by Konamiman, 1998-1999.


## Purpose
On OCM/MSX++ with MegaSD: set a partition, determine which one is set, or list the disk's partitions.

FAT16 partition support in MegaSD is limited - see section _"FAT12 vs. FAT16"_. 
This tool cannot improve upon that.

This tool will NOT create partition tables. 
For that, use Nextor `_FDISK` in BASIC (after booting to Nextor) or any modern computer and a partition tool capable of 
partitioning MBRs & formatting FAT12.

This tool is NOT compatible with MegaSCSI (because it uses MMC SPI) 
nor with MegaFlashROM SCC+ SD (because OCM's ESE-RAM and MegaFlashROM have incompatible ways of enabling writes).

This tool does NOT work on Nextor. For Nextor, use its own tool `MAPDRV`.

### Disclaimer
This program comes with ABSOLUTELY NO WARRANTY.
See COPYING for more information.


## Usage
Issue one of the following commands:
```
TYPE MSDPAR.COM                  # show name & version
MSDPAR [/?|H]                    # show usage
MSDPAR [<drive>]:                # show mapped partition
MSDPAR [<drive>:]a|p-<0|e> [/Q]  # map partition
MSDPAR /L                        # list disk partition
MSDPAR [<drive>:] /Ei            # Enable i MegaSD drives (i=1-8)
```

Partition selection:
* `a`: absolute partition number 1-255
* `p-0`: primary partition 1-4
* `p-e`: logical partition, e.g., `3-2` to select second extended partition in primary partition 3.

Options:
* `/Q`: quiet - don't print anything
* `/Ei`: enable _i_ drives, with _i_ being a number between 1 and 8 (inclusive). 
    The drive parameter, when specified, must indicate a drive managed by MegaSD.
  * by default, 1 or 2 drives (`A:` & `B:`) are enabled, depending on the EPBIOS/SDBIOS in use.
  * Please RESET (warm boot) to activate the drive change.
    Don't power off or cold boot; all MegaSD configuration will then revert to default.
  * this can also be done with the original `ESET.COM`, but that's more cumbersome

### default mapping
When starting up, MegaSD scans the partition table and maps the first FAT12 or FAT16 partition ir finds.
However, it sets the length to the maximum value of FF.FFFFh, which (with a sector size of 512 Bytes) is almost 8GiB.
And not even possible with FAT16, which supports 4GiB max!

`MSDPAR A:` will therefore print `WARNING: Drive size and partition size are not equal`.
This only happens for the drive automapped by MegaSD; not for partitions mapped by `MSDPAR`.

It doesn't seem to be harmful, but the warning can be resolved by remapping:
`MSDPAR A:1-0` (or another partition, depending on your disk).

### FAT12 vs. FAT16
Mapping multiple partitions, all FAT12, works fine.
Remember, FAT12 partitions can be max. 32MiB in size.

However, when mapping any FAT16 partition (4GiB max) and then accessing it, MegaSD behaves in an unexpected way:
both the mapped drive and `A:` will point to the _first partition on disk_ (`1-0`),
irrespective whether it's FAT12 or FAT16.
This means that if your first partition is FAT12, you cannot access any FAT16 partition at all, since the mapping is undone by MegaSD.

What it comes down to: when using FAT16, it's best to have it take up the whole disk, and not bother with partitions at all.
**This tool is only useful when all mapped partitions are FAT12.**

This also means any space beyond 4GiB on a micro-SD card cannot be used.
(Unless you create more than 128 FAT12 partitions🙂)

A bit disappointing, but there you have it. 
Use Nextor if you need more flexibility or storage.

### hardware
The Device ID is always 0 for MegaSD.

The MegaSD slot is autodetected based on the specified drive.
For those interested: it'll be slot 1-3 or 2-3 using openMSX, and 3-2 using OCM-PLD.

### reset & reboot
OCM/MSX++ does not have persistent memory like MegaSCSI's ESE-RAM.
Any mappings or configuration made will only survive a soft reset, e.g. by invoking `RESET` in MSX-DOS.
Except drive `A:`: that's always reinitialized to the first partition on disk, even after soft reset.

Mappings (`B:`~`H:`) & config will, however, _not_ survive a cold boot/hard reset or power down.
MegaSD, like Nextor, maps the first supported partition it finds to `A:` at boot.
No other partitions are automapped.

Consider invoking `MSDPAR` with option `/Q` in `AUTOEXEC.BAT` to (quietly) map additional partitions at boot.

### error handling
Errors are printed to screen, unless option `/Q` is provided.

A DOS2 user error code is also returned:
* 1 (silent): an error situation that led to showing usage instructions
* 2 (silent): invalid input or mismatch with disk configuration
* 3 (silent): internal error
* 32 or higher (printed by DOS): MegaSCSI API error

Use `ECHO %_ERROR%` to show the error code, or use it in a batch file.


## Changelog
* Jun-2024: MSDPAR v1.0
  * Translate Spanish to English (comments, macros & most labels)
  * port to sjasm v0.42c+GNU make
  * require MegaSD signature with version: "MEGASCSI ver2.15"
  * default device ID 0; the only one supported on OCM/MSX++ with MegaSD BIOS
  * drop ESE-RAMdisk handling; not implemented on OCM/MSX++
  * merge in PARLIST for partition listing
  * replace SCSI Inquiry by MMC command 10 (SEND_CID)
  * define constants & add URLs to information
  * support `TYPE MSDPAR.COM`
  * support LBA partition types, in sync with Nextor 2.1.2
  * some command line options
  * option to set # drives
  * size grows from 4494 to about 6K
* 1999: PARSET for Mega-SCSI v1.1 created by N&eacute;stor Soriano (Konami Man)
* 1998: PARLIST for Mega-SCSI created by N&eacute;stor Soriano (Konami Man)


## Nice to have
These features might be added in the future:
* when mapping `A:`, print a warning that user should ensure `COMMAND(2).COM` is present on newly mapped partition
* show warning when mapping a FAT16 partition
* detect mapping a partition twice; print a warning
* `/L`: indicate drive for partitions that are mapped
* starting `MSDPAR` from BASIC via `BLOAD` or `CALL`.
* option to show all mapped drives at once
* support `/[R]eset` option for `/Ei` (drive count adjust)


## License
Everything in this repository is GPLv3.
See COPYING for more information.


## Developing
MSDPAR is developed on Linux using Sjasm 0.42c (patched to compile on Linux) and GNU make.

Execute `make` to compile.

Any feedback on my Z80 assembly code style? 
Please send PRs, with comments.
It's almost 35 years back since I coded Z80, and didn't really develop a code style back then.
I focused on understandability, hence the equs & URLs.

## Testing
With some modifications, openMSX extension 'MegaFlashROM_SCC+_SD' will behave like OCM/MSX++ MegaSD.
This enables testing & debugging on that emulator.

File `test-images.zip` contains two 1-MiB files with skeleton 'SD card' images with various (tiny & unformatted) partitions to verify `MSDPAR /L`.

Execute `make run` to start openMSX.
In the default setup, your local folder is mapped to drive `C:`, so `C:MSDPAR` should start your compiled code. 

⚠️ With the standard openMSX extension 'MegaFlashROM_SCC+_SD', MegaSD will not boot at all.
So you will need to compile openMSX yourself.

`MSDPAR` is tested on a modified openMSX emulator, 
and on a real SX1-mini+ with OCM-PLD 3.9 
and a real SX2 with OCM-PLD 3.9.1, both with their predelivered EPBIOSes.
