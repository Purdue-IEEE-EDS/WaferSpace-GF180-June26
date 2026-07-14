#!/usr/bin/env python3
import argparse
import math

PHASE_W_DEFAULT = 32

def freq_to_ftw(freq_hz: float, sample_rate_hz: float, phase_w: int) -> int:
    return int(round(freq_hz / sample_rate_hz * (1 << phase_w))) & ((1 << phase_w) - 1)

def ftw_to_freq(ftw: int, sample_rate_hz: float, phase_w: int) -> float:
    return ftw / float(1 << phase_w) * sample_rate_hz

def parse_num(s: str) -> float:
    s = s.strip().lower().replace("_", "")
    scale = 1.0

    if s.endswith("ghz"):
        scale = 1e9
        s = s[:-3]
    elif s.endswith("mhz"):
        scale = 1e6
        s = s[:-3]
    elif s.endswith("khz"):
        scale = 1e3
        s = s[:-3]
    elif s.endswith("hz"):
        scale = 1.0
        s = s[:-2]
    elif s.endswith("g"):
        scale = 1e9
        s = s[:-1]
    elif s.endswith("m"):
        scale = 1e6
        s = s[:-1]
    elif s.endswith("k"):
        scale = 1e3
        s = s[:-1]

    return float(s) * scale

def parse_int(s: str) -> int:
    s = s.strip().lower().replace("_", "")
    return int(s, 16) if s.startswith("0x") else int(s, 0)

def main() -> int:
    p = argparse.ArgumentParser(description="DDS frequency <-> FTW hex calculator")
    p.add_argument("--fs", "--sample-rate", required=True, type=parse_num,
                   help="DDS sample rate, e.g. 500e6, 500MHz")
    p.add_argument("--phase-w", type=int, default=PHASE_W_DEFAULT,
                   help="Phase accumulator width, default 32")

    g = p.add_mutually_exclusive_group(required=True)
    g.add_argument("--freq", "-f", type=parse_num,
                   help="Output frequency, e.g. 15.625MHz")
    g.add_argument("--ftw", type=parse_int,
                   help="FTW as decimal or hex, e.g. 0x08000000")

    args = p.parse_args()

    if args.freq is not None:
        ftw = freq_to_ftw(args.freq, args.fs, args.phase_w)
        actual_freq = ftw_to_freq(ftw, args.fs, args.phase_w)
        err_hz = actual_freq - args.freq

        print(f"fs_hz        = {args.fs:.12g}")
        print(f"phase_w      = {args.phase_w}")
        print(f"target_hz    = {args.freq:.12f}")
        print(f"ftw_dec      = {ftw}")
        print(f"ftw_hex      = 0x{ftw:08X}")
        print(f"actual_hz    = {actual_freq:.12f}")
        print(f"actual_mhz   = {actual_freq / 1e6:.12f}")
        print(f"error_hz     = {err_hz:.12f}")
        print(f"error_ppm    = {err_hz / args.freq * 1e6 if args.freq != 0 else math.nan:.6f}")

    else:
        freq = ftw_to_freq(args.ftw, args.fs, args.phase_w)
        print(f"fs_hz        = {args.fs:.12g}")
        print(f"phase_w      = {args.phase_w}")
        print(f"ftw_dec      = {args.ftw}")
        print(f"ftw_hex      = 0x{args.ftw:08X}")
        print(f"freq_hz      = {freq:.12f}")
        print(f"freq_mhz     = {freq / 1e6:.12f}")

    return 0

if __name__ == "__main__":
    raise SystemExit(main())
