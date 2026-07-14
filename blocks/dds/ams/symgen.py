#!/usr/bin/env python3
from __future__ import annotations
import argparse
import re
from pathlib import Path


def pin_list_arg(s: str) -> list[str]:
    """
    Accepts:
      clk
      clk,rst,en
      "clk rst en"
    """
    s = s.replace(",", " ")
    pins = [p.strip() for p in s.split() if p.strip()]
    if not pins:
        raise argparse.ArgumentTypeError("pin list cannot be empty")
    return pins


def xschem_pin_name(pin: str) -> str:
    """
    Convert Verilog-style bus syntax to the xschem/XSPICE form used in
    existing local code-model symbols:

      foo[35:0] -> foo[35..0]
    """
    match = re.fullmatch(r"([^\[\]]+)\[([^\[\]:]+):([^\[\]:]+)\]", pin)
    if match is None:
        return pin
    base, msb, lsb = match.groups()
    return f"{base}[{msb}..{lsb}]"


def xschem_symbol(
    device: str,
    inputs: list[str],
    outputs: list[str],
    instance_name: str = "a1",
    verilog_file: str | None = None,
) -> str:
    """
    Generate an xschem primitive symbol for an XSPICE/Verilog code model.

    Netlist format emitted:

      a1 [ input0 input1 ... ] [ output0 output1 ... ] device_name

    Example:

      a1 [ clk ] [ sclk data load ] cal_dac_codegen
    """

    # XSPICE array-style grouping
    x_inputs = [xschem_pin_name(pin) for pin in inputs]
    x_outputs = [xschem_pin_name(pin) for pin in outputs]

    input_group = " ".join(f"@@{p}" for p in x_inputs)
    output_group = " ".join(f"@@{p}" for p in x_outputs)

    fmt = f'format="@name [ {input_group} ] [ {output_group} ] @model"'

    # Geometry
    box_left = -60
    box_right = 60

    pitch = 15
    n_inputs = len(x_inputs)
    n_outputs = len(x_outputs)
    n_pins = max(n_inputs, n_outputs)

    half_height = max(25, ((n_pins - 1) * pitch) // 2 + 15)

    def y_positions(n: int) -> list[int]:
        if n == 1:
            return [0]
        start = -((n - 1) * pitch) / 2
        return [int(round(start + i * pitch)) for i in range(n)]

    input_ys = y_positions(n_inputs)
    output_ys = y_positions(n_outputs)

    lines = []

    lines.append("v {xschem version=3.4.8RC file_version=1.3}")
    lines.append("G {}")
    lines.append("K {type=primitive")
    lines.append(fmt)
    lines.append(f'template="name={instance_name} model={device}"')
    lines.append("}")
    lines.append("V {}")
    lines.append("S {}")
    lines.append("F {}")
    lines.append("E {}")
    lines.append("")

    # Pin wires
    for y in input_ys:
        lines.append(f"L 4 -80 {y} -60 {y} {{}}")

    for y in output_ys:
        lines.append(f"L 4 60 {y} 80 {y} {{}}")

    lines.append("")

    # Pin boxes
    for pin, y in zip(x_inputs, input_ys):
        lines.append(
            f"B 5 -82.5 {y - 2.5} -77.5 {y + 2.5} "
            f"{{name={pin} dir=in}}"
        )

    for pin, y in zip(x_outputs, output_ys):
        lines.append(
            f"B 5 77.5 {y - 2.5} 82.5 {y + 2.5} "
            f"{{name={pin} dir=out}}"
        )

    lines.append("")

    # Main body
    lines.append(
        f"P 4 5 {box_right} {-half_height} {box_left} {-half_height} "
        f"{box_left} {half_height} {box_right} {half_height} "
        f"{box_right} {-half_height} {{}}"
    )

    # Small digital/code icon
    icon_y0 = half_height + 10
    lines.append(
        f"P 4 8 -10 {icon_y0} -10 {icon_y0 + 20} -20 {icon_y0 + 20} "
        f"-5 {icon_y0 + 35} 10 {icon_y0 + 20} 0 {icon_y0 + 20} "
        f"0 {icon_y0} -10 {icon_y0} {{}}"
    )

    lines.append("")

    # Text labels
    lines.append(f"T {{@symname}} -78 {-half_height - 21} 0 0 0.3 0.3 {{}}")
    lines.append(f"T {{@name}} 35 {-half_height - 17} 0 0 0.2 0.2 {{}}")
    lines.append("")

    for pin, y in zip(x_inputs, input_ys):
        lines.append(f"T {{{pin}}} -55 {y - 4} 0 0 0.2 0.2 {{}}")

    for pin, y in zip(x_outputs, output_ys):
        lines.append(f"T {{{pin}}} 55 {y - 4} 0 1 0.2 0.2 {{}}")

    lines.append("")

    if verilog_file is None:
        verilog_file = f"{device}.v"

    lines.append(
        f'T {{tcleval([read_data $netlist_dir/{verilog_file}])}} '
        f'-145 {half_height + 55} 0 0 0.2 0.2 '
        f'{{layer=4 font="courier new" weight=bold}}'
    )

    return "\n".join(lines) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate an xschem .sym file for an XSPICE/Verilog code model."
    )

    parser.add_argument(
        "--device",
        "--model",
        required=True,
        help="Device/model/module name, e.g. cal_dac_codegen",
    )

    parser.add_argument(
        "--input",
        "--inputs",
        required=True,
        type=pin_list_arg,
        help='Input pins. Examples: --input clk OR --input "clk rst en" OR --input clk,rst,en',
    )

    parser.add_argument(
        "--output",
        "--outputs",
        required=True,
        type=pin_list_arg,
        help='Output pins. Examples: --output "sclk data load" OR --output sclk,data,load',
    )

    parser.add_argument(
        "--file",
        "--sym",
        default=None,
        help="Output .sym filename. Default: <device>.sym",
    )

    parser.add_argument(
        "--instance",
        default="a1",
        help="Default instance name in xschem template. Default: a1",
    )

    parser.add_argument(
        "--verilog",
        default=None,
        help="Verilog file to embed with read_data. Default: <device>.v",
    )

    parser.add_argument(
        "--cat",
        action="store_true",
        help="Print generated symbol contents to stdout after writing file.",
    )

    args = parser.parse_args()

    out_file = Path(args.file if args.file else f"{args.device}.sym")

    text = xschem_symbol(
        device=args.device,
        inputs=args.input,
        outputs=args.output,
        instance_name=args.instance,
        verilog_file=args.verilog,
    )

    out_file.write_text(text)

    print(f"wrote {out_file}")
    print(f"cat {out_file}")

    if args.cat:
        print()
        print(text, end="")

if __name__ == "__main__":
    main()
