#ifndef MEGASD_HH
#define MEGASD_HH

#include "MSXDevice.hh"
#include "AmdFlash.hh"
#include <array>
#include <memory>

namespace openmsx {

class SdCard;

class MegaSD final : public MSXDevice
{
public:
	explicit MegaSD(const DeviceConfig& config);
	~MegaSD() override;

	void powerUp(EmuTime::param time) override;
	void reset(EmuTime::param time) override;
	[[nodiscard]] byte peekMem(word address, EmuTime::param time) const override;
	[[nodiscard]] byte readMem(word address, EmuTime::param time) override;
	[[nodiscard]] const byte* getReadCacheLine(word address) const override;
	void writeMem(word address, byte value, EmuTime::param time) override;
	[[nodiscard]] byte* getWriteCacheLine(word address) const override;

	template<typename Archive>
	void serialize(Archive& ar, unsigned version);

private:
	void updateConfigReg(byte value);

	[[nodiscard]] byte getSubSlot(unsigned addr) const;

	/**
	 * Writes to flash only if it was not write protected.
	 */
	void writeToFlash(unsigned addr, byte value);
	AmdFlash flash;
	byte subslotReg;

	byte configReg = 3; // avoid UMR
	[[nodiscard]] bool isSlotExpanderEnabled()         const { return  (configReg & 0x04) == 0; }
	[[nodiscard]] bool isFlashRomBlockProtectEnabled() const { return  (configReg & 0x02) != 0; }
	[[nodiscard]] bool isFlashRomWriteEnabled()        const { return  (configReg & 0x01) != 0; }

	// subslot 3
	[[nodiscard]] byte readMemSubSlot3(word address, EmuTime::param time);
	[[nodiscard]] byte peekMemSubSlot3(word address, EmuTime::param time) const;
	[[nodiscard]] const byte* getReadCacheLineSubSlot3(word address) const;
	[[nodiscard]] byte* getWriteCacheLineSubSlot3(word address) const;
	void writeMemSubSlot3(word address, byte value, EmuTime::param time);
	[[nodiscard]] unsigned getFlashAddrSubSlot3(unsigned addr) const;

	std::array<byte, 4> bankRegsSubSlot3;

	byte selectedCard;
	std::array<std::unique_ptr<SdCard>, 2> sdCard;
};

} // namespace openmsx

#endif
