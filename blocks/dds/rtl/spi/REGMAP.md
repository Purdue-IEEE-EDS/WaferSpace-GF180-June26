# SPI Register Map

Implemented v2 map for the shared SPI register interface. The public block is
`spi_slave`, which owns the SPI byte engine and instantiates `dds_regmap`
internally to emit decoded chip configuration signals.

SPI command byte format is `{R/W, ADDR[6:0]}`. Multi-byte registers are
little-endian: the lowest address holds the least significant byte. Reserved
addresses read as `0x00` and ignore writes.

## Address Map

| Address | Block | Register / exported port | Access | Width | Reset | Description |
|---|---|---|---|---:|---|---|
| `0x00` | DDS | `DEVID` | R | 8 | `0xD5` | Hardcoded device ID. CSV lists `0x67`; RTL currently uses `0xD5`. |
| `0x01` | DDS | `dds_mode`, `dds_auto_restart`, `dds_phase_rst_on_launch` | W | 4 | `0x0` | DDS control byte. See `CTRL` bit fields. |
| `0x02-0x05` | DDS | `dds_ftw_a` | W | 32 | `0x00000000` | Start frequency tuning word. |
| `0x06-0x09` | DDS | `dds_ftw_b` | W | 32 | `0x00000000` | End frequency tuning word. |
| `0x0A-0x0D` | DDS | `dds_ftw_step` | W | 32 | `0x00000000` | Per-sample frequency tuning word step. |
| `0x0E-0x10` | DDS | `dds_chirp_n` | W | `COUNT_W` | `0x000000` | Chirp segment length. Three-byte window; `COUNT_W` currently defaults to 20. |
| `0x11-0x15` | DDS | `dds_direct_i` | W | `DAC_SW_W` | `0x000000000` | Raw DAC I switch word. Five-byte window supports 33-40 bits; default width is 36. |
| `0x16-0x1A` | DDS | `dds_direct_q` | W | `DAC_SW_W` | `0x000000000` | Raw DAC Q switch word. Five-byte window supports 33-40 bits; default width is 36. |
| `0x1B` | DDS | `dds_direct_en` | W | 1 | `0x00` | Direct DAC control byte. Bit 0 is `dds_direct_en`. |
| `0x1C-0x3F` | DDS | `dds_cal_code[n]` | W | 4 each | `0x8` each | One byte per calibration cell, low nibble used. Address is `0x1C + n`; default cell count is 36. |
| `0x40-0x41` | PLL | `dds_spi_clk`, `pll_clk`, `pll_config` | W | 11 | `0x0400` | Packed PLL configuration. See `PLL_CFG` bit fields. |
| `0x42-0x4F` | PLL | Reserved | - | - | - | Reserved for future PLL controls. PLL owns the full 16-byte window `0x40-0x4F`. |
| `0x50-0x7F` | - | Reserved | - | - | - | Reserved for future blocks. |

## Byte Map

| Address | Write target |
|---|---|
| `0x00` | `DEVID` readback only |
| `0x01` | `CTRL[3:0] = {dds_phase_rst_on_launch, dds_auto_restart, dds_mode[1:0]}` |
| `0x02` | `dds_ftw_a[7:0]` |
| `0x03` | `dds_ftw_a[15:8]` |
| `0x04` | `dds_ftw_a[23:16]` |
| `0x05` | `dds_ftw_a[31:24]` |
| `0x06` | `dds_ftw_b[7:0]` |
| `0x07` | `dds_ftw_b[15:8]` |
| `0x08` | `dds_ftw_b[23:16]` |
| `0x09` | `dds_ftw_b[31:24]` |
| `0x0A` | `dds_ftw_step[7:0]` |
| `0x0B` | `dds_ftw_step[15:8]` |
| `0x0C` | `dds_ftw_step[23:16]` |
| `0x0D` | `dds_ftw_step[31:24]` |
| `0x0E` | `dds_chirp_n[7:0]` |
| `0x0F` | `dds_chirp_n[15:8]` |
| `0x10` | `dds_chirp_n[COUNT_W-1:16]` |
| `0x11` | `dds_direct_i[7:0]` |
| `0x12` | `dds_direct_i[15:8]` |
| `0x13` | `dds_direct_i[23:16]` |
| `0x14` | `dds_direct_i[31:24]` |
| `0x15` | `dds_direct_i[DAC_SW_W-1:32]` |
| `0x16` | `dds_direct_q[7:0]` |
| `0x17` | `dds_direct_q[15:8]` |
| `0x18` | `dds_direct_q[23:16]` |
| `0x19` | `dds_direct_q[31:24]` |
| `0x1A` | `dds_direct_q[DAC_SW_W-1:32]` |
| `0x1B` | `DIRECT_CTRL[0] = dds_direct_en` |
| `0x1C-0x3F` | `dds_cal_code[n]`, where `n = address - 0x1C`; low nibble is the cell code |
| `0x40` | `PLL_CFG[7:0] = {pll_config[7:6], pll_config[5:3], dds_spi_clk[2:0]}` |
| `0x41` | `wdata[0] -> pll_config[8]`, `wdata[1] -> pll_clk/pll_config[9]`, `wdata[2] -> pll_config[10]` |
| `0x42-0x4F` | Reserved for future PLL fields |

## `CTRL` Bit Fields

| Bit | Port / field | Reset | Description |
|---:|---|---|---|
| `[1:0]` | `dds_mode` | `2'b00` | DDS profile mode. Current RTL uses `3` for fixed test-tone profile. |
| `[2]` | `dds_auto_restart` | `1'b0` | Restart finite chirp profiles automatically. |
| `[3]` | `dds_phase_rst_on_launch` | `1'b0` | Reset phase on launch. |
| `[7:4]` | Reserved | `4'b0000` | Reserved, write as zero. |

## `DIRECT_CTRL` Bit Fields

| Bit | Port / field | Reset | Description |
|---:|---|---|---|
| `[0]` | `dds_direct_en` | `1'b0` | Enable direct DAC switch-word bypass. |
| `[7:1]` | Reserved | `7'b0000000` | Reserved, write as zero. |

## `PLL_CFG` Bit Fields

`PLL_CFG` is a packed SPI register, but RTL should still expose the decoded
signals as separately named ports.

| Bit | Exported port / field | Reset | Description |
|---:|---|---|---|
| `[2:0]` | `dds_spi_clk` | `3'b000` | SPI-programmed DDS clock selector. This is a config value, not the actual DDS `clk` port. |
| `[5:3]` | `pll_config[5:3]` | `3'b000` | PLL-owned FFT clock selector field. |
| `[8:6]` | `pll_config[8:6]` | `3'b000` | PLL-owned ADC clock selector field. |
| `[9]` | `pll_clk` and `pll_config[9]` | `1'b0` | PLL-owned clock source select bit. |
| `[10]` | `pll_config[10]` | `1'b1` | PLL-owned FFT data source select bit. |
| `[15:11]` | Reserved | `5'b00000` | Reserved, write as zero. |

## Address Formulas

| Port | Address formula | Byte / bit packing |
|---|---|---|
| `dds_cal_code[n]` | `0x1C + n` | `wdata[3:0]` maps to `dds_cal_code[n]`. |
| `dds_direct_i` | `0x11 + byte_idx` | Little-endian. Top byte uses only valid `DAC_SW_W` bits. |
| `dds_direct_q` | `0x16 + byte_idx` | Little-endian. Top byte uses only valid `DAC_SW_W` bits. |
| `PLL_CFG` | `0x40 + byte_idx` | Little-endian 16-bit register; only bits `[10:0]` are currently assigned. |
