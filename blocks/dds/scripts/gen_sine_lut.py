#!/usr/bin/env python3
"""
gen_sine_lut.py — Generate quarter-wave sine ROM hex file for DDS

Outputs a .hex file compatible with Verilog $readmemh().
Stores unsigned magnitude = round(MAG_MAX * sin(theta))
where MAG_MAX = 2^MAG_W - 1.

The magnitude splits at the DAC segmentation boundary:
  M[MAG_W-1 : BINARY_BITS]  → unary offset from midscale (thermometer)
  M[BINARY_BITS-1 : 0]      → binary sub-DAC switch pattern (wire)

Usage:
    python3 gen_sine_lut.py [TRUNC_W] [MAG_W] [output_file]

Defaults:
    TRUNC_W    = 12  →  quarter-wave depth = 2^(12-2) = 1024 entries
    MAG_W      = 9   →  max magnitude = 511  (5+5 segmentation: 31 unary, 5 binary)
    output_file = sine_lut.hex
"""

import sys
import math


def generate_lut(trunc_w, mag_w, outfile):
    addr_w  = trunc_w - 2
    depth   = 1 << addr_w
    mag_max = (1 << mag_w) - 1
    hex_w   = (mag_w + 3) // 4            # hex digits per entry

    with open(outfile, "w") as f:
        for i in range(depth):
            theta = i * (math.pi / 2.0) / depth
            val   = int(round(mag_max * math.sin(theta)))
            val   = min(val, mag_max)     # clamp (shouldn't be needed)
            f.write(f"{val:0{hex_w}x}\n")

    print(f"  {outfile}: {depth} entries, {mag_w}-bit (max={mag_max}), "
          f"{hex_w} hex digits/entry")
    print(f"  ROM[0]      = {0:0{hex_w}x}  (sin 0)")
    mid = depth // 2
    mid_theta = mid * (math.pi / 2.0) / depth
    mid_val = int(round(mag_max * math.sin(mid_theta)))
    print(f"  ROM[{mid}]   = {mid_val:0{hex_w}x}  (sin {math.degrees(mid_theta):.1f}°)")
    top_theta = (depth - 1) * (math.pi / 2.0) / depth
    top_val = int(round(mag_max * math.sin(top_theta)))
    print(f"  ROM[{depth-1}] = {top_val:0{hex_w}x}  (sin {math.degrees(top_theta):.1f}°)")


if __name__ == "__main__":
    trunc_w = int(sys.argv[1]) if len(sys.argv) > 1 else 12
    mag_w   = int(sys.argv[2]) if len(sys.argv) > 2 else 9
    outfile = sys.argv[3]      if len(sys.argv) > 3 else "sine_lut.hex"

    print(f"Generating quarter-wave sine LUT:")
    print(f"  TRUNC_W={trunc_w}, MAG_W={mag_w}")
    generate_lut(trunc_w, mag_w, outfile)
