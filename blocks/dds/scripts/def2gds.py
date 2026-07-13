#!/usr/bin/env python3
"""Convert an OpenROAD DEF plus GF180 standard-cell GDS into a GDS."""

import os
import re
import sys

import pya


def rd_value(name, default=""):
    return str(globals().get(name, default) or "")


def fail(message):
    print(f"ERROR: {message}", file=sys.stderr)
    sys.exit(1)


def require_path(path, label):
    if not path:
        fail(f"missing {label}")
    if not os.path.exists(path):
        fail(f"{label} not found: {path}")
    return path


def split_paths(raw):
    paths = []
    for chunk in str(raw or "").replace(",", os.pathsep).split(os.pathsep):
        chunk = chunk.strip()
        if chunk:
            paths.append(chunk)
    return paths


def infer_lef_paths(in_gds):
    lib_dir = os.path.dirname(os.path.dirname(os.path.abspath(in_gds)))
    scl = os.path.splitext(os.path.basename(in_gds))[0]
    return (
        os.path.join(lib_dir, "techlef", f"{scl}__max.tlef"),
        os.path.join(lib_dir, "lef", f"{scl}.lef"),
    )


def infer_def_dbu(in_def):
    units_re = re.compile(r"^\s*UNITS\s+DISTANCE\s+MICRONS\s+(\d+)\s*;", re.IGNORECASE)
    with open(in_def, "r", encoding="utf-8", errors="replace") as def_file:
        for line in def_file:
            match = units_re.match(line)
            if match:
                return 1.0 / int(match.group(1))
    return None


def main():
    design_name = rd_value("design_name")
    in_def = require_path(rd_value("in_def"), "input DEF")
    in_gds = require_path(rd_value("in_gds"), "standard-cell GDS")
    out_gds = rd_value("out_gds")
    if not out_gds:
        fail("missing output GDS path")

    inferred_tech_lef, inferred_cell_lef = infer_lef_paths(in_gds)
    tech_lef = require_path(rd_value("tech_lef", inferred_tech_lef), "tech LEF")
    cell_lef = require_path(rd_value("cell_lef", inferred_cell_lef), "cell LEF")

    macro_gds_files = [in_gds] + split_paths(rd_value("seal_gds"))
    for macro_gds in macro_gds_files:
        require_path(macro_gds, "macro GDS")

    options = pya.LoadLayoutOptions()
    lefdef = options.lefdef_config
    lefdef.lef_files = [tech_lef, cell_lef]
    lefdef.macro_layout_files = macro_gds_files
    lefdef.read_lef_with_def = True

    def_dbu = infer_def_dbu(in_def)
    if def_dbu is not None:
        lefdef.dbu = def_dbu

    layout = pya.Layout()
    layout.read(in_def, options)

    if design_name:
        top = layout.cell(design_name)
        if top is None:
            tops = ", ".join(cell.name for cell in layout.top_cells())
            fail(f"top cell {design_name!r} not found after DEF import; top cells: {tops}")
    elif layout.top_cell() is None:
        fail("no top cell found after DEF import")

    out_dir = os.path.dirname(os.path.abspath(out_gds))
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)

    layout.write(out_gds)
    if not os.path.exists(out_gds) or os.path.getsize(out_gds) == 0:
        fail(f"KLayout did not create a non-empty GDS: {out_gds}")

    print(f"Wrote {out_gds}")


if __name__ == "__main__":
    main()
