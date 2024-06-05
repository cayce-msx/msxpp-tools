#include "MegaSD.hh"
#include "MSXCPUInterface.hh"
#include "CacheLine.hh"
#include "SdCard.hh"
#include "SRAM.hh"
#include "enumerate.hh"
#include "narrow.hh"
#include "ranges.hh"
#include "serialize.hh"
#include "xrange.hh"
#include <array>
#include <memory>

/******************************************************************************
 * DOCUMENTATION AS PROVIDED BY MANUEL PAZOS, WHO DEVELOPED THE CARTRIDGE     *
 ******************************************************************************

--------------------------------------------------------------------------------
MegaFlashROM SCC+ SD Technical Details
(c) Manuel Pazos 24-02-2014
--------------------------------------------------------------------------------

[Cartridge layout]
    - Subslot 3: MegaSD - 64K (ASC8 mapper)

--------------------------------------------------------------------------------
[FlashROM layout]

#000000+----------------+
       |     MegaSD     | 64K - Subslot 3
       |                |
#010000+----------------+

--------------------------------------------------------------------------------
[Subslot 3: MegaSD]

  Mapper type: ASCII8

  Default mapper values:
    Bank0 = 0
    Bank1 = 1
    Bank2 = 0
    Bank3 = 0

  Memory range 64K: Banks #00-#07 are mirrored in #80-#87 (except registers bank #40)

  Memory registers area (Bank #40):
    #4000-#57FF: SD card access (R/W)
                 #4000-#4FFF: /CS signal = 0 - SD enabled
                 #5000-#5FFF: /CS signal = 1 - SD disabled

    #5800-#5FFF: SD slot select (bit 0: 0 = SD slot 1, 1 = SD slot 2)

  Cards work in SPI mode.
  Signals used: CS, DI, DO, SCLK
  When reading, 8 bits are read from DO
  When writing, 8 bits are written to DI

  SD specifications: https://www.sdcard.org/downloads/pls/simplified_specs/part1_410.pdf

******************************************************************************/

namespace openmsx {

static constexpr auto sectorInfo = [] {
	// 8 * 8kB
	using Info = AmdFlash::SectorInfo;
	std::array<Info, 8 > result = {};
	std::fill(result.begin(), result.begin() + 8, Info{ 8 * 1024, false});
	return result;
}();


MegaSD::MegaSD(const DeviceConfig& config)
	: MSXDevice(config)
	, flash("MegaSD ESE-RAM", sectorInfo, 0x207E,
	        AmdFlash::Addressing::BITS_12, config)
{
	powerUp(getCurrentTime());

	sdCard[0] = std::make_unique<SdCard>(DeviceConfig(config, config.findChild("sdcard1")));
	// OCM & descendants have only a single uSD slot - but let's instantiate a second one. There original ESE MegaSD had dual SD slots, anyway.
	sdCard[1] = std::make_unique<SdCard>(DeviceConfig(config, config.findChild("sdcard2")));
}

MegaSD::~MegaSD()
{
	updateConfigReg(3);
}

void MegaSD::powerUp(EmuTime::param time)
{
	reset(time);
}

void MegaSD::reset(EmuTime::param time)
{
	updateConfigReg(3);
	subslotReg = 0;

	flash.reset();

	for (auto [bank, reg] : enumerate(bankRegsSubSlot3)) {
		reg = (bank == 1) ? 1 : 0;
	}

	selectedCard = 0;

	invalidateDeviceRWCache(); // flush all to be sure
}

byte MegaSD::getSubSlot(unsigned addr) const
{
	return isSlotExpanderEnabled() ?
		(subslotReg >> (2 * (addr >> 14))) & 3 : 1;
}

void MegaSD::writeToFlash(unsigned addr, byte value)
{
	if (isFlashRomWriteEnabled()) {
	    // difference MegaFlashRom SCC+ SD vs. MegaSD
		flash.getRam()->write(addr, value);
	} else {
		// flash is write protected, this is implemented by not passing
		// writes to flash at all.
	}
}

byte MegaSD::peekMem(word addr, EmuTime::param time) const
{
	if (isSlotExpanderEnabled() && (addr == 0xFFFF)) {
		// read subslot register
		return subslotReg ^ 0xFF;
	}

	switch (getSubSlot(addr)) {
		case 3: return peekMemSubSlot3(addr, time);
		default: return 0; // removed UNREACHABLE - otherwise switch-case match seems to be optimized away, and MegaSD is active on all subslots!
	}
}

byte MegaSD::readMem(word addr, EmuTime::param time)
{
	if (isSlotExpanderEnabled() && (addr == 0xFFFF)) {
		// read subslot register
		return subslotReg ^ 0xFF;
	}

	switch (getSubSlot(addr)) {
		case 3: return readMemSubSlot3(addr, time);
		default: return 0;
	}
}

const byte* MegaSD::getReadCacheLine(word addr) const
{
	if (isSlotExpanderEnabled() &&
		((addr & CacheLine::HIGH) == (0xFFFF & CacheLine::HIGH))) {
		// read subslot register
		return nullptr;
	}

	switch (getSubSlot(addr)) {
		case 3: return getReadCacheLineSubSlot3(addr);
		default: return nullptr;
	}
}

void MegaSD::writeMem(word addr, byte value, EmuTime::param time)
{
	if (isSlotExpanderEnabled() && (addr == 0xFFFF)) {
		// write subslot register
		byte diff = value ^ subslotReg;
		subslotReg = value;
		for (auto i : xrange(4)) {
			if (diff & (3 << (2 * i))) {
				invalidateDeviceRWCache(0x4000 * i, 0x4000);
			}
		}
	}

	switch (getSubSlot(addr)) {
		case 3: writeMemSubSlot3(addr, value, time); break;
		default: UNREACHABLE;
	}
}

byte* MegaSD::getWriteCacheLine(word addr) const
{
	if (isSlotExpanderEnabled() &&
		((addr & CacheLine::HIGH) == (0xFFFF & CacheLine::HIGH))) {
		// read subslot register
		return nullptr;
	}

	switch (getSubSlot(addr)) {
		case 3: return getWriteCacheLineSubSlot3(addr);
		default: UNREACHABLE; return nullptr;
	}
}

void MegaSD::updateConfigReg(byte value)
{
	configReg = value;
	flash.setVppWpPinLow(isFlashRomBlockProtectEnabled());
	invalidateDeviceRWCache(); // flush all to be sure
}

/////////////////////// sub slot 3 ////////////////////////////////////////////

unsigned MegaSD::getFlashAddrSubSlot3(unsigned addr) const
{
	unsigned page8kB = (addr >> 13) - 2;
	return (bankRegsSubSlot3[page8kB] & 0x7f) * 0x2000 + (addr & 0x1fff);
}

byte MegaSD::readMemSubSlot3(word addr, EmuTime::param /*time*/)
{
    byte v;
	if (((bankRegsSubSlot3[0] & 0xC0) == 0x40) && ((0x4000 <= addr) && (addr < 0x6000))) {
		// transfer from SD card
		v=sdCard[selectedCard]->transfer(0xFF, (addr & 0x1000) != 0);
//        char c='_';
//		if (v>=32) c=v;
//        printf("read SD card %d [%04x=]%02x ('%c') %s\n", selectedCard, addr,v,c, (addr & 0x1000) != 0 ? "disabled": "");
		return v;
	}

	if ((0x4000 <= addr) && (addr < 0xC000)) {
		// read (flash)rom content
		unsigned flashAddr = getFlashAddrSubSlot3(addr);
		v=flash.read(flashAddr);
//        printf("read flash %04x>%08x=%02x\n", addr,flashAddr,v);
		return v;
	} else {
		// unmapped read
		return 0xFF;
	}
}

byte MegaSD::peekMemSubSlot3(word addr, EmuTime::param /*time*/) const
{
	if ((0x4000 <= addr) && (addr < 0xC000)) {
		// read (flash)rom content
//        printf("flash peek %04x\n", addr);
		unsigned flashAddr = getFlashAddrSubSlot3(addr);
		return flash.peek(flashAddr);
	} else {
		// unmapped read
		return 0xFF;
	}
}

const byte* MegaSD::getReadCacheLineSubSlot3(word addr) const
{
	if (((bankRegsSubSlot3[0] & 0xC0) == 0x40) && ((0x4000 <= addr) && (addr < 0x6000))) {
		return nullptr;
	}

	if ((0x4000 <= addr) && (addr < 0xC000)) {
//        printf("flash read cache line %04x\n", addr);
		// (flash)rom content
		unsigned flashAddr = getFlashAddrSubSlot3(addr);
		return flash.getReadCacheLine(flashAddr);
	} else {
		return unmappedRead.data();
	}
}

void MegaSD::writeMemSubSlot3(word addr, byte value, EmuTime::param /*time*/)
{
	if (((bankRegsSubSlot3[0] & 0xC0) == 0x40) && ((0x4000 <= addr) && (addr < 0x6000))) {
		if (addr >= 0x5800) {
			selectedCard = value & 1;
		} else {
			// transfer to SD card
//            printf("write SD card %d [%04x=]%02x %s\n", selectedCard, addr, value, (addr & 0x1000) != 0 ? "disabled": "");
			sdCard[selectedCard]->transfer(value, (addr & 0x1000) != 0); // ignore return value
		}
	}

	// write to flash (first, before modifying bank regs)
	// additional condition, compared to MegaFlashRom SCC+ SD
	if ((0x4000 <= addr) && (addr < 0xC000) && (bankRegsSubSlot3[(addr >> 13) - 2] & 0x80)) {
		unsigned flashAddr = getFlashAddrSubSlot3(addr);
//        byte page8kB = (addr >> 13) - 2;
//        printf("write flash %04x(page %02xx)>%08x=%02x\n", addr, bankRegsSubSlot3[page8kB], flashAddr, value);
		writeToFlash(flashAddr, value);
	}

	// ASCII-8 mapper
	if ((0x6000 <= addr) && (addr < 0x8000)) {
		byte page8kB = (addr >> 11) & 0x03;
		bankRegsSubSlot3[page8kB] = value;
//		const char *s="";
//	    if (page8kB==0 && ((bankRegsSubSlot3[0] & 0xC0) == 0x40)) s="SD bank";
//	    else if (value & 0x80) s="write";
//        printf("set page %d=%02x (addr %04x) %s => %d %d %d %d\n", page8kB, value, addr, s,
//            bankRegsSubSlot3[0], bankRegsSubSlot3[1], bankRegsSubSlot3[2], bankRegsSubSlot3[3]);
		invalidateDeviceRWCache(0x4000 + 0x2000 * page8kB, 0x2000);
	}
}

byte* MegaSD::getWriteCacheLineSubSlot3(word /*addr*/) const
{
	return nullptr; // flash isn't cacheable
}

template<typename Archive>
void MegaSD::serialize(Archive& ar, unsigned /*version*/)
{
	// skip MSXRom base class
	ar.template serializeBase<MSXDevice>(*this);

	// overall
	ar.serialize("flash",      flash,
	             "subslotReg", subslotReg);

	ar.serialize("configReg",  configReg);

	// subslot 3 stuff
	ar.serialize("bankRegsSubSlot3", bankRegsSubSlot3,
	             "selectedCard",     selectedCard,
	             "sdCard0",          *sdCard[0],
	             "sdCard1",          *sdCard[1]);
}
INSTANTIATE_SERIALIZE_METHODS(MegaSD);
REGISTER_MSXDEVICE(MegaSD, "MegaSD");

} // namespace openmsx
