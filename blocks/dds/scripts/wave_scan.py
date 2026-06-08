#!/usr/bin/env python3
"""Analyze serialized DDS DAC switching sequences in the ideal analog-current domain.

Flow intentionally mirrors the real question being asked:

  1. Read the serialized output switch words from the simulation CSV.
  2. Decode each 36-bit DAC switch word as physical DAC current:
       b0..b4 = 10, 20, 40, 80, 160 uA
       u0..u30 = 31 unary cells, 320 uA each
  3. Sum the selected switch currents into ideal analog DAC currents.
  4. Compare actual-vs-expected switch words and actual-vs-expected currents.
  5. FFT the ideal analog waveform reconstructed from the ACTUAL switching sequence.

This is a digital switching-sequence correctness analysis, not a transistor-level
DAC model. It assumes every selected DAC cell contributes its ideal current.
"""

from __future__ import annotations

import argparse
import csv
import json
import math
import os
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parents[1]
LOCAL_CACHE = Path(tempfile.gettempdir()) / "dds_wave_scan_match_cache"
LOCAL_CACHE.mkdir(parents=True, exist_ok=True)
(LOCAL_CACHE / "matplotlib").mkdir(parents=True, exist_ok=True)
(LOCAL_CACHE / "fontconfig").mkdir(parents=True, exist_ok=True)
os.environ.setdefault("XDG_CACHE_HOME", str(LOCAL_CACHE))
os.environ.setdefault("MPLCONFIGDIR", str(LOCAL_CACHE / "matplotlib"))

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np


PHASE_W = 32
UNARY_BITS = 5
BINARY_BITS = 5
N_UNARY = (1 << UNARY_BITS) - 1
DAC_WORD_W = BINARY_BITS + N_UNARY
FULL_SCALE_PHASE = float(1 << PHASE_W)

# Physical ideal DAC weights.  The serialized word is interpreted as:
#   bit[0]   -> binary b0 = 10 uA
#   bit[1]   -> binary b1 = 20 uA
#   bit[2]   -> binary b2 = 40 uA
#   bit[3]   -> binary b3 = 80 uA
#   bit[4]   -> binary b4 = 160 uA
#   bit[5+i] -> unary ui = 320 uA, i=0..30
BINARY_WEIGHTS_UA = np.array([10.0, 20.0, 40.0, 80.0, 160.0], dtype=float)
UNARY_WEIGHT_UA = 320.0
POSITIVE_FULL_SCALE_UA = float(np.sum(BINARY_WEIGHTS_UA) + N_UNARY * UNARY_WEIGHT_UA)  # 10230 uA
DIFF_FULL_SCALE_PEAK_UA = POSITIVE_FULL_SCALE_UA
DIFF_FULL_SCALE_PP_UA = 2.0 * DIFF_FULL_SCALE_PEAK_UA
CURRENT_ERR_TOL_UA = 1e-9

# Historical TB scenario labels.  Prefer phase-derived FTW when possible.
SCENARIO_FTWS = {
    "cw_frac_5mhz": 0x028F_5C29,
    "cw_15p625mhz": 0x0800_0000,
    "cw_frac_37mhz": 0x12F1_A9FC,
    "cw_46p875mhz": 0x1800_0000,
    "cw_frac_67p42mhz": 0x2284_DFCE,
    "cw_75mhz": 0x2666_6666,
    "cw_100mhz": 0x3333_3333,
    "cw_frac_123p456789mhz": 0x3F35_BA6E,
    "cw_175mhz": 0x5999_999A,
    "cw_frac_211p75mhz": 0x6C6A_7EFA,
    "cw_frac_237p125mhz": 0x7968_72B0,
    "cw_240mhz": 0x7AE1_47AE,
    "cw_245mhz": 0x7D70_A3D7,
    "cw_frac_248p75mhz": 0x7F5C_28F6,
    "cw_frac_249p9mhz": 0x7FF2_E48F,
}


@dataclass(frozen=True)
class ScenarioData:
    name: str
    sample_idx: np.ndarray
    exp_phase: np.ndarray
    exp_i: np.ndarray
    act_i: np.ndarray
    exp_q: np.ndarray
    act_q: np.ndarray


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--csv", type=Path, default=Path("sim/tb_dds_wave_scan_match.csv"))
    parser.add_argument("--outdir", type=Path, default=Path("sim/wave_scan_match_analysis"))
    parser.add_argument("--sample-rate-hz", type=float, default=312_500_000.0)
    parser.add_argument("--wave-samples", type=int, default=256)
    parser.add_argument("--fft-samples", type=int, default=0, help="0 means use all samples in each scenario.")
    parser.add_argument("--run-sim", action="store_true")
    parser.add_argument("--make-target", default="sim_wave_scan_match")
    parser.add_argument("--fail-on-mismatch", action="store_true", default=True)
    parser.add_argument("--no-fail-on-mismatch", dest="fail_on_mismatch", action="store_false")
    return parser.parse_args()


def repo_root() -> Path:
    return REPO_ROOT


def run_simulation(target: str) -> None:
    subprocess.run(["make", target], cwd=repo_root(), check=True)


def parse_hex_column(rows: list[dict[str, str]], key: str) -> np.ndarray:
    return np.array([int(row[key], 16) for row in rows], dtype=np.uint64)


def load_scenarios(csv_path: Path) -> list[ScenarioData]:
    with csv_path.open(newline="") as f:
        reader = csv.DictReader(f)
        required = {"scenario", "sample_idx", "exp_phase", "exp_dac_i", "act_dac_i", "exp_dac_q", "act_dac_q"}
        missing = required - set(reader.fieldnames or [])
        if missing:
            raise ValueError(f"CSV missing required columns: {sorted(missing)}")

        grouped: dict[str, list[dict[str, str]]] = {}
        for row in reader:
            grouped.setdefault(row["scenario"], []).append(row)

    scenarios: list[ScenarioData] = []
    for name, rows in grouped.items():
        rows.sort(key=lambda row: int(row["sample_idx"]))
        scenarios.append(
            ScenarioData(
                name=name,
                sample_idx=np.array([int(row["sample_idx"]) for row in rows], dtype=int),
                exp_phase=parse_hex_column(rows, "exp_phase"),
                exp_i=parse_hex_column(rows, "exp_dac_i"),
                act_i=parse_hex_column(rows, "act_dac_i"),
                exp_q=parse_hex_column(rows, "exp_dac_q"),
                act_q=parse_hex_column(rows, "act_dac_q"),
            )
        )
    return scenarios


def switch_word_to_bit_matrix(sw: np.ndarray, width: int = DAC_WORD_W) -> np.ndarray:
    sw = sw.astype(np.uint64, copy=False)
    return ((sw[:, None] >> np.arange(width, dtype=np.uint64)) & 1).astype(np.uint8)


def switch_word_to_bitstring(sw: int, width: int = DAC_WORD_W) -> str:
    # MSB-left string for human inspection: u30..u0 b4..b0.
    return format(int(sw), f"0{width}b")


def decode_switch_word_positive_uA(sw: np.ndarray) -> np.ndarray:
    """Return ideal single-ended selected current, 0..10230 uA."""
    bits = switch_word_to_bit_matrix(sw, width=DAC_WORD_W).astype(float)
    bin_current = bits[:, :BINARY_BITS] @ BINARY_WEIGHTS_UA
    unary_current = np.sum(bits[:, BINARY_BITS:], axis=1) * UNARY_WEIGHT_UA
    return bin_current + unary_current


def decode_switch_word_diff_uA(sw: np.ndarray) -> np.ndarray:
    """Return ideal differential current centered about zero, -10230..+10230 uA.

    This corresponds to an ideal complementary current-steering interpretation:
        I_diff = I_pos - I_neg = 2*I_pos - I_full_scale
    """
    positive_uA = decode_switch_word_positive_uA(sw)
    return 2.0 * positive_uA - POSITIVE_FULL_SCALE_UA


def unary_counts(sw: np.ndarray) -> np.ndarray:
    bits = switch_word_to_bit_matrix(sw, width=DAC_WORD_W)
    return np.sum(bits[:, BINARY_BITS:], axis=1).astype(int)


def binary_code(sw: np.ndarray) -> np.ndarray:
    bits = switch_word_to_bit_matrix(sw, width=DAC_WORD_W)
    weights = (1 << np.arange(BINARY_BITS, dtype=np.uint64)).astype(np.uint64)
    return (bits[:, :BINARY_BITS].astype(np.uint64) @ weights).astype(int)


def thermometer_violation_count(sw: np.ndarray) -> int:
    """Count rows whose unary field is not thermometer-coded as 111..000 from u0 upward.

    If the design intentionally scrambles unary cells, this metric should be ignored.
    It is still useful for catching lane/order/bit-slice errors in a conventional encoder.
    """
    bits = switch_word_to_bit_matrix(sw, width=DAC_WORD_W)[:, BINARY_BITS:]
    counts = np.sum(bits, axis=1).astype(int)
    ideal = np.zeros_like(bits)
    for row, count in enumerate(counts):
        ideal[row, :count] = 1
    return int(np.count_nonzero(np.any(bits != ideal, axis=1)))


def hamming_distance(a: np.ndarray, b: np.ndarray) -> np.ndarray:
    x = np.bitwise_xor(a.astype(np.uint64), b.astype(np.uint64))
    out = np.zeros(x.shape, dtype=int)
    for bit in range(DAC_WORD_W):
        out += ((x >> bit) & 1).astype(int)
    return out


def infer_ftw_from_phase(phase: np.ndarray) -> int | None:
    if len(phase) < 2:
        return None
    mask = np.uint64((1 << PHASE_W) - 1)
    diffs = (phase[1:].astype(np.uint64) - phase[:-1].astype(np.uint64)) & mask
    values, counts = np.unique(diffs, return_counts=True)
    if len(values) == 0:
        return None
    return int(values[np.argmax(counts)])


def scenario_ftw(name: str, phase: np.ndarray) -> int | None:
    inferred = infer_ftw_from_phase(phase)
    if inferred not in (None, 0):
        return inferred
    return SCENARIO_FTWS.get(name)


def safe_db20(num: float, den: float) -> float:
    return 20.0 * math.log10(max(abs(num), 1e-300) / max(abs(den), 1e-300))


def fft_spectrum_real_dbfs(signal_uA: np.ndarray, sample_rate_hz: float) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    signal = np.asarray(signal_uA, dtype=float)
    n = len(signal)
    freqs = np.fft.rfftfreq(n, d=1.0 / sample_rate_hz)
    window = np.hanning(n)
    coherent_gain = max(np.sum(window) / 2.0, 1e-300)
    spectrum = np.fft.rfft((signal - np.mean(signal)) * window)
    amp_peak_uA = np.abs(spectrum) / coherent_gain
    dbfs = 20.0 * np.log10(np.maximum(amp_peak_uA, 1e-300) / DIFF_FULL_SCALE_PEAK_UA)
    return freqs, amp_peak_uA, dbfs


def fft_spectrum_complex_dbfs(i_uA: np.ndarray, q_uA: np.ndarray, sample_rate_hz: float) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    z = np.asarray(i_uA, dtype=float) + 1j * np.asarray(q_uA, dtype=float)
    z = z - np.mean(z)
    n = len(z)
    window = np.hanning(n)
    coherent_gain = max(np.sum(window), 1e-300)
    spectrum = np.fft.fftshift(np.fft.fft(z * window))
    freqs = np.fft.fftshift(np.fft.fftfreq(n, d=1.0 / sample_rate_hz))
    amp_peak_uA = np.abs(spectrum) / coherent_gain
    dbfs = 20.0 * np.log10(np.maximum(amp_peak_uA, 1e-300) / DIFF_FULL_SCALE_PEAK_UA)
    return freqs, amp_peak_uA, dbfs


def spectrum_metrics_real(signal_uA: np.ndarray, sample_rate_hz: float, expected_hz: float | None) -> dict[str, Any]:
    freqs, amp_peak_uA, dbfs = fft_spectrum_real_dbfs(signal_uA, sample_rate_hz)
    if len(amp_peak_uA) <= 1 or np.all(amp_peak_uA[1:] <= 0):
        return empty_spectrum_metrics()

    if expected_hz is not None:
        bin_width = sample_rate_hz / len(signal_uA)
        base_bin = int(round(expected_hz / bin_width))
        search_lo = max(1, base_bin - 2)
        search_hi = min(len(freqs) - 1, base_bin + 2)
        fund_bin = search_lo + int(np.argmax(amp_peak_uA[search_lo : search_hi + 1]))
    else:
        fund_bin = 1 + int(np.argmax(amp_peak_uA[1:]))

    mask = np.ones_like(amp_peak_uA, dtype=bool)
    mask[0] = False
    mask[max(0, fund_bin - 1) : min(len(mask), fund_bin + 2)] = False
    spur_bin = int(np.argmax(np.where(mask, amp_peak_uA, 0.0)))

    fund = float(amp_peak_uA[fund_bin])
    spur = float(amp_peak_uA[spur_bin])
    noise_bins = mask.copy()
    if spur_bin < len(noise_bins):
        noise_bins[spur_bin] = False
    noise_rms = float(np.sqrt(np.sum((amp_peak_uA[noise_bins] / np.sqrt(2.0)) ** 2)))

    return {
        "fundamental_bin": int(fund_bin),
        "fundamental_hz": float(freqs[fund_bin]),
        "fundamental_dbfs": float(dbfs[fund_bin]),
        "fundamental_peak_uA": fund,
        "spur_bin": int(spur_bin),
        "spur_hz": float(freqs[spur_bin]),
        "spur_dbfs": float(dbfs[spur_bin]),
        "spur_peak_uA": spur,
        "sfdr_dbc": safe_db20(fund, spur),
        "noise_rms_uA_excl_dc_fund_spur": noise_rms,
        "snr_excl_spur_db": safe_db20(fund / math.sqrt(2.0), noise_rms),
    }


def spectrum_metrics_complex(i_uA: np.ndarray, q_uA: np.ndarray, sample_rate_hz: float, expected_hz: float | None) -> dict[str, Any]:
    freqs, amp_peak_uA, dbfs = fft_spectrum_complex_dbfs(i_uA, q_uA, sample_rate_hz)
    if len(amp_peak_uA) <= 1 or np.all(amp_peak_uA <= 0):
        return empty_spectrum_metrics()

    if expected_hz is not None:
        fund_target = expected_hz
        fund_bin = int(np.argmin(np.abs(freqs - fund_target)))
        lo = max(0, fund_bin - 2)
        hi = min(len(freqs) - 1, fund_bin + 2)
        fund_bin = lo + int(np.argmax(amp_peak_uA[lo : hi + 1]))
    else:
        dc_bin = int(np.argmin(np.abs(freqs)))
        tmp = amp_peak_uA.copy()
        tmp[max(0, dc_bin - 1) : min(len(tmp), dc_bin + 2)] = 0.0
        fund_bin = int(np.argmax(tmp))

    mask = np.ones_like(amp_peak_uA, dtype=bool)
    dc_bin = int(np.argmin(np.abs(freqs)))
    mask[max(0, dc_bin - 1) : min(len(mask), dc_bin + 2)] = False
    mask[max(0, fund_bin - 1) : min(len(mask), fund_bin + 2)] = False
    spur_bin = int(np.argmax(np.where(mask, amp_peak_uA, 0.0)))

    fund = float(amp_peak_uA[fund_bin])
    spur = float(amp_peak_uA[spur_bin])
    image_target_bin = int(np.argmin(np.abs(freqs + freqs[fund_bin])))
    image = float(amp_peak_uA[image_target_bin])

    return {
        "fundamental_bin": int(fund_bin),
        "fundamental_hz": float(freqs[fund_bin]),
        "fundamental_dbfs": float(dbfs[fund_bin]),
        "fundamental_peak_uA": fund,
        "spur_bin": int(spur_bin),
        "spur_hz": float(freqs[spur_bin]),
        "spur_dbfs": float(dbfs[spur_bin]),
        "spur_peak_uA": spur,
        "sfdr_dbc": safe_db20(fund, spur),
        "image_hz": float(freqs[image_target_bin]),
        "image_dbfs": float(dbfs[image_target_bin]),
        "image_rejection_dbc": safe_db20(fund, image),
    }


def empty_spectrum_metrics() -> dict[str, Any]:
    return {
        "fundamental_bin": None,
        "fundamental_hz": None,
        "fundamental_dbfs": None,
        "fundamental_peak_uA": None,
        "spur_bin": None,
        "spur_hz": None,
        "spur_dbfs": None,
        "spur_peak_uA": None,
        "sfdr_dbc": None,
    }


def first_mismatch_indices(exp: np.ndarray, act: np.ndarray, limit: int = 8) -> list[int]:
    idx = np.flatnonzero(exp != act)
    return [int(v) for v in idx[:limit]]


def relpath(path: Path) -> str:
    try:
        return str(path.relative_to(repo_root()))
    except ValueError:
        return str(path)


def make_current_waveform_plot(
    scenario: ScenarioData,
    exp_i_uA: np.ndarray,
    act_i_uA: np.ndarray,
    exp_q_uA: np.ndarray,
    act_q_uA: np.ndarray,
    out_path: Path,
    samples_to_show: int,
    output_hz: float | None,
) -> None:
    n = min(samples_to_show, len(scenario.sample_idx))
    x = scenario.sample_idx[:n]
    ei = exp_i_uA[:n] / 1000.0
    ai = act_i_uA[:n] / 1000.0
    eq = exp_q_uA[:n] / 1000.0
    aq = act_q_uA[:n] / 1000.0

    fig, axes = plt.subplots(4, 1, figsize=(14, 10), sharex=True)
    axes[0].step(x, ai, where="mid", linewidth=1.0, label="Actual I from switch sum")
    axes[0].step(x, ei, where="mid", linewidth=0.8, linestyle="--", label="Expected I from switch sum")
    axes[0].set_ylabel("I diff current (mA)")
    axes[0].legend(loc="upper right")
    axes[0].grid(True, alpha=0.25)

    axes[1].step(x, aq, where="mid", linewidth=1.0, label="Actual Q from switch sum")
    axes[1].step(x, eq, where="mid", linewidth=0.8, linestyle="--", label="Expected Q from switch sum")
    axes[1].set_ylabel("Q diff current (mA)")
    axes[1].legend(loc="upper right")
    axes[1].grid(True, alpha=0.25)

    axes[2].step(x, act_i_uA[:n] - exp_i_uA[:n], where="mid", linewidth=1.0, label="I current error")
    axes[2].step(x, act_q_uA[:n] - exp_q_uA[:n], where="mid", linewidth=1.0, label="Q current error")
    axes[2].set_ylabel("Error (uA)")
    axes[2].legend(loc="upper right")
    axes[2].grid(True, alpha=0.25)

    axes[3].step(x, unary_counts(scenario.act_i[:n]), where="mid", linewidth=1.0, label="I unary count")
    axes[3].step(x, binary_code(scenario.act_i[:n]), where="mid", linewidth=1.0, label="I binary code")
    axes[3].step(x, unary_counts(scenario.act_q[:n]), where="mid", linewidth=0.9, linestyle="--", label="Q unary count")
    axes[3].step(x, binary_code(scenario.act_q[:n]), where="mid", linewidth=0.9, linestyle="--", label="Q binary code")
    axes[3].set_ylabel("Decoded code")
    axes[3].set_xlabel("Serialized sample index")
    axes[3].legend(loc="upper right", ncol=2)
    axes[3].grid(True, alpha=0.25)

    title = f"{scenario.name}: ideal analog current reconstructed from serialized switch words"
    if output_hz is not None:
        title += f" | f_out={output_hz / 1e6:.6f} MHz"
    fig.suptitle(title)
    fig.tight_layout()
    fig.savefig(out_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def make_switch_activity_plot(scenario: ScenarioData, out_path: Path, samples_to_show: int) -> None:
    n = min(samples_to_show, len(scenario.sample_idx))
    x = scenario.sample_idx[:n]
    act_i_bits = switch_word_to_bit_matrix(scenario.act_i[:n], width=DAC_WORD_W).T
    act_q_bits = switch_word_to_bit_matrix(scenario.act_q[:n], width=DAC_WORD_W).T
    i_toggles = np.diff(switch_word_to_bit_matrix(scenario.act_i[:n], width=DAC_WORD_W), axis=0, prepend=0).T != 0
    q_toggles = np.diff(switch_word_to_bit_matrix(scenario.act_q[:n], width=DAC_WORD_W), axis=0, prepend=0).T != 0

    fig, axes = plt.subplots(4, 1, figsize=(14, 11), sharex=True, sharey=True)
    mats = [
        (act_i_bits, "Actual I switch state: b0..b4, u0..u30"),
        (i_toggles.astype(int), "Actual I switch toggles per output sample"),
        (act_q_bits, "Actual Q switch state: b0..b4, u0..u30"),
        (q_toggles.astype(int), "Actual Q switch toggles per output sample"),
    ]
    for ax, (mat, title) in zip(axes, mats):
        ax.imshow(mat, aspect="auto", interpolation="nearest", vmin=0, vmax=1, origin="lower")
        ax.set_title(title, fontsize=10)
        ax.set_ylabel("Switch bit")
        ax.set_yticks([0, BINARY_BITS - 1, BINARY_BITS, DAC_WORD_W - 1])
        ax.set_yticklabels(["b0", "b4", "u0", "u30"])
    axes[-1].set_xlabel("Serialized sample index")
    xticks = np.linspace(0, max(n - 1, 0), num=min(10, max(n, 1)), dtype=int)
    axes[-1].set_xticks(xticks)
    axes[-1].set_xticklabels([str(int(x[idx])) for idx in xticks])
    fig.suptitle(f"{scenario.name}: actual output switching sequence and activity")
    fig.tight_layout()
    fig.savefig(out_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def make_spectrum_plot(
    scenario: ScenarioData,
    act_i_uA: np.ndarray,
    act_q_uA: np.ndarray,
    sample_rate_hz: float,
    output_hz: float | None,
    i_metrics: dict[str, Any],
    q_metrics: dict[str, Any],
    iq_metrics: dict[str, Any],
    out_path: Path,
    fft_samples: int,
) -> None:
    if fft_samples and fft_samples > 0:
        act_i_uA = act_i_uA[:fft_samples]
        act_q_uA = act_q_uA[:fft_samples]

    fi, _, i_dbfs = fft_spectrum_real_dbfs(act_i_uA, sample_rate_hz)
    fq, _, q_dbfs = fft_spectrum_real_dbfs(act_q_uA, sample_rate_hz)
    fz, _, z_dbfs = fft_spectrum_complex_dbfs(act_i_uA, act_q_uA, sample_rate_hz)

    fig, axes = plt.subplots(3, 1, figsize=(14, 11))
    axes[0].plot(fi / 1e6, i_dbfs, linewidth=0.9)
    axes[0].set_title("I-channel ideal-current FFT from actual switch words")
    axes[0].set_ylabel("dBFS")
    axes[0].set_ylim(-140, 5)
    axes[0].grid(True, alpha=0.25)

    axes[1].plot(fq / 1e6, q_dbfs, linewidth=0.9)
    axes[1].set_title("Q-channel ideal-current FFT from actual switch words")
    axes[1].set_ylabel("dBFS")
    axes[1].set_ylim(-140, 5)
    axes[1].grid(True, alpha=0.25)

    axes[2].plot(fz / 1e6, z_dbfs, linewidth=0.9)
    axes[2].set_title("Complex I+jQ FFT from actual switch words")
    axes[2].set_ylabel("dBFS")
    axes[2].set_xlabel("Frequency (MHz)")
    axes[2].set_ylim(-140, 5)
    axes[2].grid(True, alpha=0.25)

    def annotate(ax: Any, m: dict[str, Any], prefix: str) -> None:
        if m.get("fundamental_hz") is None:
            return
        text = (
            f"{prefix} fund {m['fundamental_hz'] / 1e6:.6f} MHz, {m['fundamental_dbfs']:.1f} dBFS\n"
            f"spur {m['spur_hz'] / 1e6:.6f} MHz, {m['spur_dbfs']:.1f} dBFS\n"
            f"SFDR {m['sfdr_dbc']:.1f} dBc"
        )
        ax.text(0.01, 0.05, text, transform=ax.transAxes, fontsize=9, va="bottom", ha="left", bbox={"alpha": 0.75, "facecolor": "white"})
        ax.axvline(m["fundamental_hz"] / 1e6, linewidth=0.8, linestyle="--")
        ax.axvline(m["spur_hz"] / 1e6, linewidth=0.8, linestyle=":")

    annotate(axes[0], i_metrics, "I")
    annotate(axes[1], q_metrics, "Q")
    annotate(axes[2], iq_metrics, "IQ")

    title = f"{scenario.name}: FFT after ideal DAC current reconstruction"
    if output_hz is not None:
        title += f" | expected near {output_hz / 1e6:.6f} MHz"
    fig.suptitle(title)
    fig.tight_layout()
    fig.savefig(out_path, dpi=180, bbox_inches="tight")
    plt.close(fig)


def write_decoded_sequence_csv(
    scenario: ScenarioData,
    exp_i_uA: np.ndarray,
    act_i_uA: np.ndarray,
    exp_q_uA: np.ndarray,
    act_q_uA: np.ndarray,
    out_path: Path,
) -> None:
    exp_i_pos = decode_switch_word_positive_uA(scenario.exp_i)
    act_i_pos = decode_switch_word_positive_uA(scenario.act_i)
    exp_q_pos = decode_switch_word_positive_uA(scenario.exp_q)
    act_q_pos = decode_switch_word_positive_uA(scenario.act_q)

    with out_path.open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(
            [
                "sample_idx",
                "exp_phase_hex",
                "exp_i_hex",
                "act_i_hex",
                "exp_q_hex",
                "act_q_hex",
                "act_i_bits_msb_left",
                "act_q_bits_msb_left",
                "act_i_binary_code",
                "act_i_unary_count",
                "act_q_binary_code",
                "act_q_unary_count",
                "exp_i_pos_uA",
                "act_i_pos_uA",
                "exp_i_diff_uA",
                "act_i_diff_uA",
                "i_error_diff_uA",
                "exp_q_pos_uA",
                "act_q_pos_uA",
                "exp_q_diff_uA",
                "act_q_diff_uA",
                "q_error_diff_uA",
                "i_switch_match",
                "q_switch_match",
                "i_hamming_distance",
                "q_hamming_distance",
            ]
        )
        hd_i = hamming_distance(scenario.exp_i, scenario.act_i)
        hd_q = hamming_distance(scenario.exp_q, scenario.act_q)
        i_bin = binary_code(scenario.act_i)
        q_bin = binary_code(scenario.act_q)
        i_unary = unary_counts(scenario.act_i)
        q_unary = unary_counts(scenario.act_q)
        for idx in range(len(scenario.sample_idx)):
            writer.writerow(
                [
                    int(scenario.sample_idx[idx]),
                    f"0x{int(scenario.exp_phase[idx]):08X}",
                    f"0x{int(scenario.exp_i[idx]):09X}",
                    f"0x{int(scenario.act_i[idx]):09X}",
                    f"0x{int(scenario.exp_q[idx]):09X}",
                    f"0x{int(scenario.act_q[idx]):09X}",
                    switch_word_to_bitstring(int(scenario.act_i[idx])),
                    switch_word_to_bitstring(int(scenario.act_q[idx])),
                    int(i_bin[idx]),
                    int(i_unary[idx]),
                    int(q_bin[idx]),
                    int(q_unary[idx]),
                    f"{exp_i_pos[idx]:.3f}",
                    f"{act_i_pos[idx]:.3f}",
                    f"{exp_i_uA[idx]:.3f}",
                    f"{act_i_uA[idx]:.3f}",
                    f"{(act_i_uA[idx] - exp_i_uA[idx]):.3f}",
                    f"{exp_q_pos[idx]:.3f}",
                    f"{act_q_pos[idx]:.3f}",
                    f"{exp_q_uA[idx]:.3f}",
                    f"{act_q_uA[idx]:.3f}",
                    f"{(act_q_uA[idx] - exp_q_uA[idx]):.3f}",
                    int(scenario.exp_i[idx] == scenario.act_i[idx]),
                    int(scenario.exp_q[idx] == scenario.act_q[idx]),
                    int(hd_i[idx]),
                    int(hd_q[idx]),
                ]
            )


def analyze_scenario(scenario: ScenarioData, sample_rate_hz: float, outdir: Path, wave_samples: int, fft_samples: int) -> dict[str, Any]:
    exp_i_uA = decode_switch_word_diff_uA(scenario.exp_i)
    act_i_uA = decode_switch_word_diff_uA(scenario.act_i)
    exp_q_uA = decode_switch_word_diff_uA(scenario.exp_q)
    act_q_uA = decode_switch_word_diff_uA(scenario.act_q)

    i_err = act_i_uA - exp_i_uA
    q_err = act_q_uA - exp_q_uA
    mism_i = scenario.exp_i != scenario.act_i
    mism_q = scenario.exp_q != scenario.act_q
    hd_i = hamming_distance(scenario.exp_i, scenario.act_i)
    hd_q = hamming_distance(scenario.exp_q, scenario.act_q)

    ftw = scenario_ftw(scenario.name, scenario.exp_phase)
    output_hz = None if ftw is None else float(ftw) / FULL_SCALE_PHASE * sample_rate_hz

    fft_i = act_i_uA[:fft_samples] if fft_samples and fft_samples > 0 else act_i_uA
    fft_q = act_q_uA[:fft_samples] if fft_samples and fft_samples > 0 else act_q_uA
    i_metrics = spectrum_metrics_real(fft_i, sample_rate_hz, output_hz)
    q_metrics = spectrum_metrics_real(fft_q, sample_rate_hz, output_hz)
    iq_metrics = spectrum_metrics_complex(fft_i, fft_q, sample_rate_hz, output_hz)

    scenario_dir = outdir / scenario.name
    scenario_dir.mkdir(parents=True, exist_ok=True)

    current_plot = scenario_dir / "ideal_current_from_switches.png"
    activity_plot = scenario_dir / "actual_switch_activity.png"
    spectrum_plot = scenario_dir / "ideal_current_fft.png"
    decoded_csv = scenario_dir / "decoded_switch_sequence.csv"

    make_current_waveform_plot(scenario, exp_i_uA, act_i_uA, exp_q_uA, act_q_uA, current_plot, wave_samples, output_hz)
    make_switch_activity_plot(scenario, activity_plot, wave_samples)
    make_spectrum_plot(scenario, act_i_uA, act_q_uA, sample_rate_hz, output_hz, i_metrics, q_metrics, iq_metrics, spectrum_plot, fft_samples)
    write_decoded_sequence_csv(scenario, exp_i_uA, act_i_uA, exp_q_uA, act_q_uA, decoded_csv)

    item = {
        "scenario": scenario.name,
        "samples": int(len(scenario.sample_idx)),
        "ftw_hex": None if ftw is None else f"0x{ftw:08X}",
        "sample_rate_hz": float(sample_rate_hz),
        "output_hz": output_hz,
        "dac_model": {
            "binary_weights_uA_b0_to_b4": [float(v) for v in BINARY_WEIGHTS_UA],
            "unary_cells": int(N_UNARY),
            "unary_weight_uA": float(UNARY_WEIGHT_UA),
            "positive_full_scale_uA": float(POSITIVE_FULL_SCALE_UA),
            "differential_full_scale_pp_uA": float(DIFF_FULL_SCALE_PP_UA),
        },
        "switch_match": {
            "mismatch_i_count": int(np.count_nonzero(mism_i)),
            "mismatch_q_count": int(np.count_nonzero(mism_q)),
            "first_i_mismatch_rows": first_mismatch_indices(scenario.exp_i, scenario.act_i),
            "first_q_mismatch_rows": first_mismatch_indices(scenario.exp_q, scenario.act_q),
            "max_i_hamming_distance": int(np.max(hd_i)) if len(hd_i) else 0,
            "max_q_hamming_distance": int(np.max(hd_q)) if len(hd_q) else 0,
        },
        "analog_error_from_switch_sum": {
            "max_abs_i_error_uA": float(np.max(np.abs(i_err))) if len(i_err) else 0.0,
            "max_abs_q_error_uA": float(np.max(np.abs(q_err))) if len(q_err) else 0.0,
            "rms_i_error_uA": float(np.sqrt(np.mean(i_err**2))) if len(i_err) else 0.0,
            "rms_q_error_uA": float(np.sqrt(np.mean(q_err**2))) if len(q_err) else 0.0,
        },
        "switch_sanity": {
            "actual_i_thermometer_violation_count": thermometer_violation_count(scenario.act_i),
            "actual_q_thermometer_violation_count": thermometer_violation_count(scenario.act_q),
            "actual_i_mean_unary_count": float(np.mean(unary_counts(scenario.act_i))),
            "actual_q_mean_unary_count": float(np.mean(unary_counts(scenario.act_q))),
            "actual_i_mean_binary_code": float(np.mean(binary_code(scenario.act_i))),
            "actual_q_mean_binary_code": float(np.mean(binary_code(scenario.act_q))),
        },
        "actual_ideal_current_stats": {
            "i_mean_uA": float(np.mean(act_i_uA)),
            "q_mean_uA": float(np.mean(act_q_uA)),
            "i_rms_uA": float(np.sqrt(np.mean(act_i_uA**2))),
            "q_rms_uA": float(np.sqrt(np.mean(act_q_uA**2))),
            "i_peak_to_peak_uA": float(np.max(act_i_uA) - np.min(act_i_uA)),
            "q_peak_to_peak_uA": float(np.max(act_q_uA) - np.min(act_q_uA)),
        },
        "i_fft_actual_ideal_current": i_metrics,
        "q_fft_actual_ideal_current": q_metrics,
        "iq_fft_actual_ideal_current": iq_metrics,
        "files": {
            "decoded_switch_sequence_csv": relpath(decoded_csv),
            "ideal_current_from_switches_plot": relpath(current_plot),
            "actual_switch_activity_plot": relpath(activity_plot),
            "ideal_current_fft_plot": relpath(spectrum_plot),
        },
    }
    item["check"] = scenario_check(item)
    return item


def write_summary_files(outdir: Path, summaries: list[dict[str, Any]]) -> None:
    ordered = sorted(summaries, key=summary_sort_key)
    (outdir / "summary.json").write_text(json.dumps(ordered, indent=2) + "\n")
    with (outdir / "summary.csv").open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(
            [
                "scenario",
                "check_status",
                "check_pass",
                "samples",
                "ftw_hex",
                "sample_rate_hz",
                "output_hz",
                "mismatch_i_count",
                "mismatch_q_count",
                "max_abs_i_error_uA",
                "max_abs_q_error_uA",
                "rms_i_error_uA",
                "rms_q_error_uA",
                "i_fundamental_hz",
                "i_fundamental_dbfs",
                "i_spur_hz",
                "i_spur_dbfs",
                "i_sfdr_dbc",
                "q_fundamental_hz",
                "q_fundamental_dbfs",
                "q_spur_hz",
                "q_spur_dbfs",
                "q_sfdr_dbc",
                "iq_fundamental_hz",
                "iq_fundamental_dbfs",
                "iq_spur_hz",
                "iq_spur_dbfs",
                "iq_sfdr_dbc",
                "iq_image_rejection_dbc",
                "actual_i_thermometer_violation_count",
                "actual_q_thermometer_violation_count",
                "decoded_switch_sequence_csv",
                "ideal_current_from_switches_plot",
                "actual_switch_activity_plot",
                "ideal_current_fft_plot",
            ]
        )
        for item in ordered:
            writer.writerow(
                [
                    item["scenario"],
                    item["check"]["status"],
                    int(item["check"]["pass"]),
                    item["samples"],
                    item["ftw_hex"],
                    item["sample_rate_hz"],
                    item["output_hz"],
                    item["switch_match"]["mismatch_i_count"],
                    item["switch_match"]["mismatch_q_count"],
                    item["analog_error_from_switch_sum"]["max_abs_i_error_uA"],
                    item["analog_error_from_switch_sum"]["max_abs_q_error_uA"],
                    item["analog_error_from_switch_sum"]["rms_i_error_uA"],
                    item["analog_error_from_switch_sum"]["rms_q_error_uA"],
                    item["i_fft_actual_ideal_current"].get("fundamental_hz"),
                    item["i_fft_actual_ideal_current"].get("fundamental_dbfs"),
                    item["i_fft_actual_ideal_current"].get("spur_hz"),
                    item["i_fft_actual_ideal_current"].get("spur_dbfs"),
                    item["i_fft_actual_ideal_current"].get("sfdr_dbc"),
                    item["q_fft_actual_ideal_current"].get("fundamental_hz"),
                    item["q_fft_actual_ideal_current"].get("fundamental_dbfs"),
                    item["q_fft_actual_ideal_current"].get("spur_hz"),
                    item["q_fft_actual_ideal_current"].get("spur_dbfs"),
                    item["q_fft_actual_ideal_current"].get("sfdr_dbc"),
                    item["iq_fft_actual_ideal_current"].get("fundamental_hz"),
                    item["iq_fft_actual_ideal_current"].get("fundamental_dbfs"),
                    item["iq_fft_actual_ideal_current"].get("spur_hz"),
                    item["iq_fft_actual_ideal_current"].get("spur_dbfs"),
                    item["iq_fft_actual_ideal_current"].get("sfdr_dbc"),
                    item["iq_fft_actual_ideal_current"].get("image_rejection_dbc"),
                    item["switch_sanity"]["actual_i_thermometer_violation_count"],
                    item["switch_sanity"]["actual_q_thermometer_violation_count"],
                    item["files"]["decoded_switch_sequence_csv"],
                    item["files"]["ideal_current_from_switches_plot"],
                    item["files"]["actual_switch_activity_plot"],
                    item["files"]["ideal_current_fft_plot"],
                ]
            )


def fmt_metric(v: Any, suffix: str = "") -> str:
    if v is None:
        return "n/a"
    if isinstance(v, float):
        return f"{v:.3f}{suffix}"
    return f"{v}{suffix}"


def summary_sort_key(item: dict[str, Any]) -> tuple[float, str]:
    output_hz = item.get("output_hz")
    return (float(output_hz) if output_hz is not None else float("inf"), item["scenario"])


def scenario_check(item: dict[str, Any], current_err_tol_uA: float = CURRENT_ERR_TOL_UA) -> dict[str, Any]:
    mism_i = int(item["switch_match"]["mismatch_i_count"])
    mism_q = int(item["switch_match"]["mismatch_q_count"])
    max_i_err = float(item["analog_error_from_switch_sum"]["max_abs_i_error_uA"])
    max_q_err = float(item["analog_error_from_switch_sum"]["max_abs_q_error_uA"])
    passed = (
        mism_i == 0
        and mism_q == 0
        and max_i_err <= current_err_tol_uA
        and max_q_err <= current_err_tol_uA
    )
    return {
        "pass": passed,
        "status": "PASS" if passed else "FAIL",
        "criteria": {
            "max_switch_mismatches": 0,
            "max_abs_current_error_uA": current_err_tol_uA,
        },
    }


def print_summary(summaries: list[dict[str, Any]]) -> None:
    print("Switch-sequence -> ideal-DAC-current analysis summary")
    print(f"DAC weights: b0..b4={BINARY_WEIGHTS_UA.tolist()} uA, unary={N_UNARY} x {UNARY_WEIGHT_UA:.1f} uA")
    for item in sorted(summaries, key=summary_sort_key):
        out_mhz = None if item["output_hz"] is None else item["output_hz"] / 1e6
        i_fft = item["i_fft_actual_ideal_current"]
        q_fft = item["q_fft_actual_ideal_current"]
        iq_fft = item["iq_fft_actual_ideal_current"]
        print(
            f"- {item['check']['status']}: {item['scenario']}: samples={item['samples']} ftw={item['ftw_hex']} "
            f"f_out={fmt_metric(out_mhz, ' MHz')} "
            f"mismatches I/Q={item['switch_match']['mismatch_i_count']}/{item['switch_match']['mismatch_q_count']} "
            f"max_err I/Q={item['analog_error_from_switch_sum']['max_abs_i_error_uA']:.1f}/"
            f"{item['analog_error_from_switch_sum']['max_abs_q_error_uA']:.1f} uA "
            f"SFDR I/Q/IQ={fmt_metric(i_fft.get('sfdr_dbc'), ' dBc')}/"
            f"{fmt_metric(q_fft.get('sfdr_dbc'), ' dBc')}/"
            f"{fmt_metric(iq_fft.get('sfdr_dbc'), ' dBc')} "
            f"IQ image rej={fmt_metric(iq_fft.get('image_rejection_dbc'), ' dBc')}"
        )
        if item["switch_match"]["mismatch_i_count"] or item["switch_match"]["mismatch_q_count"]:
            print(f"  first I mismatch rows: {item['switch_match']['first_i_mismatch_rows']}")
            print(f"  first Q mismatch rows: {item['switch_match']['first_q_mismatch_rows']}")
    pass_count = sum(1 for item in summaries if item["check"]["pass"])
    overall_pass = pass_count == len(summaries)
    print(
        f"Check: {'PASS' if overall_pass else 'FAIL'} "
        f"({pass_count}/{len(summaries)} scenarios met zero-mismatch and zero-error criteria)"
    )


def main() -> int:
    args = parse_args()
    root = repo_root()
    csv_path = (root / args.csv).resolve() if not args.csv.is_absolute() else args.csv
    outdir = (root / args.outdir).resolve() if not args.outdir.is_absolute() else args.outdir

    if args.run_sim:
        run_simulation(args.make_target)

    scenarios = load_scenarios(csv_path)
    if not scenarios:
        raise RuntimeError(f"No scenarios found in {csv_path}")

    outdir.mkdir(parents=True, exist_ok=True)
    summaries = [
        analyze_scenario(
            scenario=scenario,
            sample_rate_hz=args.sample_rate_hz,
            outdir=outdir,
            wave_samples=args.wave_samples,
            fft_samples=args.fft_samples,
        )
        for scenario in scenarios
    ]

    write_summary_files(outdir, summaries)
    print_summary(summaries)

    overall_pass = all(item["check"]["pass"] for item in summaries)
    mismatch_total = sum(
        int(item["switch_match"]["mismatch_i_count"]) + int(item["switch_match"]["mismatch_q_count"])
        for item in summaries
    )
    print(f"Wrote analysis to {outdir}")
    if not overall_pass and args.fail_on_mismatch:
        print(
            f"FAIL: {sum(not item['check']['pass'] for item in summaries)} scenario(s) failed "
            f"the zero-mismatch / zero-error check; serialized switch mismatches={mismatch_total}",
            file=sys.stderr,
        )
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
