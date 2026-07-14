import bisect
import importlib
import os
import re
import shlex

import pya

# TODO: Maybe running "File -> Refresh Libraries" fixes the pfet issue


# --- Configuration ---
# Must be in a function because other functions are used
# as part of the configuration variables.
def init_cfg():
    global PDK_LIB_NAME, SCALE_FACTOR, SI_MULTIPLIERS, SKIP_SPICE_IGNORE
    global DEVICE_MAP, SPICE_MODEL_ALIASES
    global PRINT_PDKS, PRINT_PCELLS
    global AUTOPLACE_COLUMNS, AUTOPLACE_STEP_X, AUTOPLACE_STEP_Y

    # Returned from calling 'pya.Library.library_names()'.
    # See below for debugging options.
    PDK_LIB_NAME = "gf180mcu"

    # Device coordinates will be multiplied by this factor.
    SCALE_FACTOR = 16.0

    # The units will correspond to multiplying by this number.
    SI_MULTIPLIERS = {
        "t": 1e12,
        "g": 1e9,
        "meg": 1e6,
        "k": 1e3,
        "m": 1e-3,
        "u": 1e-6,
        "µ": 1e-6,
        "n": 1e-9,
        "p": 1e-12,
        "f": 1e-15,
        None: 1,
    }

    # Skip placing devices with the parameter "spice_ignore=true".
    SKIP_SPICE_IGNORE = True

    # Map each schematic symbol to either a placing function
    # or an Exception to raise one upon parsing the symbol.
    # Symbols not mapped are ignored.
    DEVICE_MAP = {
        "ppolyf_u_1k.sym": place_npolyf_ppolyf,
        "pfet_03v3.sym": place_nfet_pfet_03v3,
        "nfet_03v3.sym": place_nfet_pfet_03v3,
        "cap_mim_2f0ff.sym": gen_place_warn(
            "SPICE model for cap_mim_2f0fF may differ from intended model cap_mim_2f0_m4m5_noshield.",
            place_cap_mim_1f5fF,
        ),
        "cap_mim_analog.sym": place_cap_mim_1f5fF,
        "ppolyf_u.sym": place_npolyf_ppolyf,
        "ppolyf_s.sym": place_npolyf_ppolyf,
        "npolyf_u.sym": place_npolyf_ppolyf,
        "npolyf_s.sym": place_npolyf_ppolyf,
        "cap_nmos_03v3.sym": place_cap_nmos_pmos_03v3,
        "cap_nmos_03v3_b.sym": place_cap_nmos_pmos_03v3,
        "cap_pmos_03v3.sym": place_cap_nmos_pmos_03v3,
        "cap_pmos_03v3_b.sym": place_cap_nmos_pmos_03v3,
        "res.sym": gen_place_warn("Ideal component: res.sym", place_pass),
        "capa-2.sym": gen_place_warn("Ideal component: capa-2.sym", place_pass),
        "ppolyf_u_3k.sym": ValueError("Can't use ppolyf_u_3k in WaferSpace tapeout"),
        "ppolyf_u_2k.sym": ValueError("Can't use ppolyf_u_2k in WaferSpace tapeout"),
        "cap_mim_1f5ff.sym": ValueError("Can't use cap_mim_1f5fF in WaferSpace tapeout"),
        "cap_mim_1f0ff.sym": ValueError("Can't use cap_mim_1f0fF in WaferSpace tapeout"),
    }

    # Models that appear in SPICE but do not map 1:1 to the schematic symbols.
    SPICE_MODEL_ALIASES = {
        "cap_mim_2f0_m3m4_noshield": {
            "sym": "cap_mim_analog.sym",
            "props": {"metal_level": "M4"},
        },
        "cap_mim_2f0_m4m5_noshield": {
            "sym": "cap_mim_analog.sym",
            "props": {"metal_level": "M5"},
        },
        "cap_mim_analog": {
            "sym": "cap_mim_analog.sym",
            "props": {"metal_level": "M5"},
        },
    }

    # SPICE netlists do not carry placement coordinates, so place them on a grid.
    AUTOPLACE_COLUMNS = 8
    AUTOPLACE_STEP_X = 80.0
    AUTOPLACE_STEP_Y = 60.0

    # Debug: Print available PDKs, then exit.
    PRINT_PDKS = False

    # Debug: Print all pcells and parameters, then exit.
    PRINT_PCELLS = False


# --- Util functions ---
def resolve_lib(name):
    for lib_id in pya.Library.library_ids():
        lib = pya.Library.library_by_id(lib_id)
        if lib.name() == name:
            return lib
    return None


def get_nested_attr(obj, path):
    current = obj
    for name in path:
        current = getattr(current, name, None)
        if current is None:
            return None
    return current


def ensure_active_gf180_pdk():
    try:
        import gdsfactory as gf
    except Exception as exc:
        print(f"Warning: Could not import gdsfactory for PDK activation: {exc}")
        return False

    get_active = getattr(gf, "get_active_pdk", None)
    if get_active is None:
        try:
            from gdsfactory.pdk import get_active_pdk as get_active
        except Exception:
            get_active = None

    if get_active is not None:
        try:
            active = get_active()
        except Exception:
            active = None
        if active is not None:
            active_name = getattr(active, "name", repr(active))
            print(f"Using active gdsfactory PDK: {active_name}")
            return True

    candidates = [
        ("gf180mcu", ("PDK",)),
        ("gf180mcu", ("tech", "PDK")),
        ("gf180mcuD", ("PDK",)),
        ("gf180mcuD", ("tech", "PDK")),
        ("gf180", ("PDK",)),
        ("gf180", ("tech", "PDK")),
    ]
    errors = []

    for module_name, attr_path in candidates:
        try:
            module = importlib.import_module(module_name)
            pdk = get_nested_attr(module, attr_path)
            if pdk is None or not hasattr(pdk, "activate"):
                continue
            pdk.activate()
            pdk_name = getattr(pdk, "name", f"{module_name}.{'.'.join(attr_path)}")
            print(f"Activated gdsfactory PDK: {pdk_name}")
            return True
        except Exception as exc:
            errors.append(f"{module_name}.{'.'.join(attr_path)} -> {exc}")

    print("Warning: Could not activate a gdsfactory GF180 PDK automatically.")
    for err in errors[:4]:
        print(f"  {err}")
    return False


def get_or_create_cellview():
    cv = pya.CellView.active()
    if cv is None or cv.layout() is None:
        pya.MainWindow.instance().create_layout(0)
        cv = pya.CellView.active()
    return cv


def get_or_create_top(ly):
    available_tops = ly.top_cells()
    if available_tops and len(available_tops) > 1:
        # Pick a top cell in the following order:
        # 1) It's named TOP
        # 2) It contains the substring "TOP"
        # 3) Use the first one in the list.
        candidates = [None] * 3
        for t in available_tops:
            if t.name.lower() == "top":
                candidates[0] = t
                break
            if candidates[1] is None and "top" in t.name.lower():
                candidates[1] = t
            elif candidates[2] is None:
                candidates[2] = t

        top = next(c for c in candidates if c is not None)
    elif len(available_tops) == 1:
        top = available_tops[0]
    else:
        top = ly.create_cell("TOP")
    return top


def print_pcells(lib):
    try:
        available_pcells = list(lib.layout().pcell_names())
    except Exception as exc:
        print(f"Could not list pcell names: {exc}")
        return

    print(f"Available PCells in library '{lib.name()}': {available_pcells}")
    for name in available_pcells:
        params = lib.layout().pcell_declaration(name).get_parameters()
        print(name, end="\t")
        for param in params:
            print(param.name, end=" ")
        print()


def get_newline_indices(f_content):
    return [i for i, c in enumerate(f_content) if c == "\n"]


def get_line_number(newline_indices, i):
    return bisect.bisect_left(newline_indices, i) + 1


def strip_matching_quotes(value):
    if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
        return value[1:-1]
    return value


def parse_si_value(value, *, si_match_expr=re.compile(r"([+-]?\d+(?:\.\d+)?(?:e[+-]?\d+)?)\s*([a-zµ]+)?", re.I)):
    if not isinstance(value, str):
        return value

    value = strip_matching_quotes(value.strip()).lower()
    match = si_match_expr.fullmatch(value)
    if not match:
        print(f"Could not parse SI value: {value}. Setting to 0.0.")
        return 0.0

    number = float(match.group(1))
    suffix = match.group(2)
    if suffix not in SI_MULTIPLIERS:
        print(f"Unrecognized suffix: {suffix}. Assuming no suffix.")
        suffix = 1.0
    else:
        suffix = SI_MULTIPLIERS[suffix]
    return number * suffix


def parse_int_value(value, default=0):
    try:
        return int(float(strip_matching_quotes(str(value).strip())))
    except (TypeError, ValueError):
        return default


def parse_props(
    props,
    *,
    prop_match_expr=re.compile(
        r"""(?P<key>[^=]*)=\s*(?P<value>"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|\S*)"""
    ),
):
    props = props.strip().lower()
    parsed = {}
    i = 0
    while i < len(props):
        match = prop_match_expr.match(props, i)
        if match is None:
            print(f"Warning: Extra data at end of properties: {props[i:]}")
            break
        parsed[match.group("key").strip()] = match.group("value").strip()
        i = match.end()
    return parsed


def resolve_param_reference(value, params):
    resolved = value
    seen = set()

    while isinstance(resolved, str):
        stripped = strip_matching_quotes(resolved.strip())
        match = re.fullmatch(r"\{\s*([^{}]+)\s*\}", stripped)
        if match is None:
            return stripped

        key = match.group(1).strip().lower()
        if key in seen:
            print(f"Warning: Recursive parameter reference {{{key}}}.")
            return stripped
        if key not in params:
            print(f"Warning: Could not resolve parameter {{{key}}}.")
            return stripped

        seen.add(key)
        resolved = params[key]

    return resolved


def parse_key_value_tokens(tokens, params):
    parsed = {}
    for token in tokens:
        if "=" not in token:
            continue
        key, value = token.split("=", 1)
        resolved = resolve_param_reference(value, params)
        if isinstance(resolved, str):
            resolved = resolved.strip().lower()
        parsed[key.strip().lower()] = resolved
    return parsed


def resolve_device_symbol(model):
    model = model.lower()
    symbol = model if model.endswith(".sym") else f"{model}.sym"
    if symbol in DEVICE_MAP:
        return symbol, {}

    alias = SPICE_MODEL_ALIASES.get(model)
    if alias is not None:
        return alias["sym"], dict(alias.get("props", {}))

    return None, {}


def build_component(sym, props, spice_loc):
    props = dict(props)
    props["model"] = props.get("model", "").lower()
    props.setdefault("name", os.path.basename(sym))
    props.setdefault("m", "1")
    props.setdefault("nf", "1")
    props.setdefault("spice_ignore", "false")
    return {
        "sym": sym,
        "x": 0.0,
        "y": 0.0,
        "b": 0.0,
        "h": 0.0,
        "props": props,
        "spice_loc": spice_loc,
    }


def autoplace_components(components):
    for index, component in enumerate(components):
        row, col = divmod(index, AUTOPLACE_COLUMNS)
        component["x"] = col * AUTOPLACE_STEP_X
        component["y"] = row * AUTOPLACE_STEP_Y


def iter_spice_statements(f_content):
    current = None
    current_loc = 0
    offset = 0

    for raw_line in f_content.splitlines(keepends=True):
        line = raw_line.rstrip("\r\n")
        stripped = line.lstrip()

        if current is not None and stripped.startswith("+"):
            current += " " + stripped[1:].strip()
        else:
            if current is not None:
                yield current_loc, current
            current = line
            current_loc = offset

        offset += len(raw_line)

    if current is not None:
        yield current_loc, current


def get_spice_instance_kind(name):
    lower = name.lower()
    if lower.startswith("xm") or lower.startswith("m"):
        return "mos"
    if lower.startswith("xr") or lower.startswith("r"):
        return "res"
    if lower.startswith("xc") or lower.startswith("c"):
        return "cap"
    return None


def parse_spice_param_statement(statement, params):
    try:
        tokens = shlex.split(statement, posix=True)
    except ValueError as exc:
        print(f"Warning: Could not parse .param statement '{statement}': {exc}")
        return
    params.update(parse_key_value_tokens(tokens[1:], params))


def parse_spice_mos(tokens, spice_loc, params):
    if len(tokens) < 6:
        return None

    model = tokens[5].lower()
    sym, extra_props = resolve_device_symbol(model)
    if sym is None:
        return None

    props = parse_key_value_tokens(tokens[6:], params)
    props.update(extra_props)
    props.update({
        "name": tokens[0],
        "model": model,
    })
    props.setdefault("w", "0")
    props.setdefault("l", "0")
    props.setdefault("nf", "1")
    props.setdefault("m", "1")
    return build_component(sym, props, spice_loc)


def parse_spice_passive(tokens, spice_loc, params, *, kind):
    if len(tokens) < 4:
        return None

    body = tokens[1:]
    prop_start = next((i for i, token in enumerate(body) if "=" in token), len(body))
    if prop_start < 2:
        return None

    model = body[prop_start - 1].lower()
    sym, extra_props = resolve_device_symbol(model)
    if sym is None:
        return None

    props = parse_key_value_tokens(body[prop_start:], params)
    props.update(extra_props)
    props.update({
        "name": tokens[0],
        "model": model,
        "m": props.get("m", "1"),
    })

    if kind == "res":
        props["w"] = props.get("r_width", props.get("w", "0"))
        props["l"] = props.get("r_length", props.get("l", "0"))
    else:
        props["w"] = props.get("c_width", props.get("w", "0"))
        props["l"] = props.get("c_length", props.get("l", "0"))

    return build_component(sym, props, spice_loc)


def parse_spice_primitive(statement, spice_loc, params):
    try:
        tokens = shlex.split(statement, posix=True)
    except ValueError as exc:
        print(f"Warning: Could not parse SPICE line {statement!r}: {exc}")
        return None

    if not tokens:
        return None

    kind = get_spice_instance_kind(tokens[0])
    if kind == "mos":
        return parse_spice_mos(tokens, spice_loc, params)
    if kind == "res":
        return parse_spice_passive(tokens, spice_loc, params, kind="res")
    if kind == "cap":
        return parse_spice_passive(tokens, spice_loc, params, kind="cap")
    return None


def parse_xschem_components(f_content):
    components = []
    comp_regex = re.compile(
        r"C \{(?P<sym>[^}]*)\} (?P<x>-?[0-9]+) (?P<y>-?[0-9]+) (?P<b>-?[0-9]+) (?P<h>-?[0-9]+) \{(?P<props>[^}]*)\}"
    )
    offset = 0

    for raw_line in f_content.splitlines(keepends=True):
        line = raw_line.rstrip("\r\n")
        if line.startswith("C "):
            match = comp_regex.fullmatch(line)
            if match is None:
                print(f"Warning: Could not parse component line near byte {offset}.")
            else:
                components.append({
                    "sym": match.group("sym"),
                    "x": parse_si_value(match.group("x")),
                    "y": parse_si_value(match.group("y")),
                    "b": parse_si_value(match.group("b")),
                    "h": parse_si_value(match.group("h")),
                    "props": parse_props(match.group("props")),
                    "spice_loc": offset,
                })
        offset += len(raw_line)

    return components


def parse_spice_components(f_content, nl_inds):
    print("Detected SPICE netlist. Auto-placing top-level primitives on a grid.")

    params = {}
    components = []
    in_subckt = False

    for spice_loc, statement in iter_spice_statements(f_content):
        stripped = statement.strip()
        lower = stripped.lower()

        if not stripped or stripped.startswith("*"):
            continue
        if lower.startswith(".subckt"):
            in_subckt = True
            continue
        if lower.startswith(".ends"):
            in_subckt = False
            continue
        if in_subckt:
            continue
        if lower.startswith(".param"):
            parse_spice_param_statement(stripped, params)
            continue

        component = parse_spice_primitive(stripped, spice_loc, params)
        if component is None:
            continue
        components.append(component)

    autoplace_components(components)
    print(f"Parsed {len(components)} top-level SPICE primitives.")
    return components


def map_sym(sym):
    return DEVICE_MAP.get(os.path.basename(sym).lower(), place_pass)


def finalize_components(components, nl_inds):
    finalized = []
    for component in components:
        if SKIP_SPICE_IGNORE and component["props"].get("spice_ignore", "false") == "true":
            continue

        place_func = map_sym(component["sym"])
        if isinstance(place_func, Exception):
            place_func.add_note(f"(Line {get_line_number(nl_inds, component['spice_loc'])})")
            raise place_func

        finalized.append(component)
    return finalized


def parse_components(f_content, nl_inds):
    if re.search(r"(?m)^C \{", f_content):
        print("Detected Xschem schematic. Using component coordinates from the file.")
        components = parse_xschem_components(f_content)
    else:
        components = parse_spice_components(f_content, nl_inds)
    return finalize_components(components, nl_inds)


# --- Placing functions ---
def gen_place_warn(msg, place_func):
    def place_warn(lib, cv, ly, top, c, nl_inds):
        print(f"Warning: Line {get_line_number(nl_inds, c['spice_loc'])}: {msg}")
        return place_func(lib, cv, ly, top, c, nl_inds)

    return place_warn


def gen_place_err(err_t, msg):
    def place_err(lib, cv, ly, top, c, nl_inds):
        raise err_t(f"Line {get_line_number(nl_inds, c['spice_loc'])}: {msg}")

    return place_err


def place_pass(lib, cv, ly, top, c, nl_inds):
    return 0


def place_npolyf_ppolyf(lib, cv, ly, top, c, nl_inds):
    pcell_name = (
        c["props"]["model"]
        .replace("1k", "high_Rs")
        .replace("2k", "high_Rs")
        .replace("3k", "high_Rs")
        + "_resistor"
    )
    width = parse_si_value(c["props"]["w"]) * 1e6
    length = parse_si_value(c["props"]["l"]) * 1e6
    params = {
        "deepnwell": False,
        "pcmpgr": False,
        "w_res": width,
        "l_res": length,
        "array_x": 1,
        "array_y": parse_int_value(c["props"]["m"], 1),
        "lbl": False,
    }
    if "high_Rs" in pcell_name:
        params["volt"] = "3.3V"
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    inst = top.insert(pya.CellInstArray(cell, pos))
    inst.set_property(99, c["props"]["name"])  # User property for SPICE name
    print(f"Created a new resistor {c['props']['name']}.")
    return 1


def place_nfet_pfet_03v3(lib, cv, ly, top, c, nl_inds):
    pcell_name = "nfet" if c["props"]["model"] == "nfet_03v3" else "pfet"
    width = parse_si_value(c["props"]["w"]) * 1e6
    length = parse_si_value(c["props"]["l"]) * 1e6
    nfingers = parse_int_value(c["props"]["nf"], 1)
    params = {
        "deepnwell": False,
        "pcmpgr": False,
        "volt": "3.3V",
        "bulk": "Bulk Tie",
        "w_gate": width / nfingers,
        "l_gate": length,
        "nf": nfingers,
        "con_bet_fin": nfingers != 1,  # Disabling allows width to reach minimum @ 0.22u
        "lbl": False,
    }
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    count = parse_int_value(c["props"]["m"], 1)
    for _ in range(count):
        inst = top.insert(pya.CellInstArray(cell, pos))
        inst.set_property(99, c["props"]["name"])  # User property for SPICE name
        print(f"Created a new transistor {c['props']['name']}.")
        pos += pya.Vector(pya.DVector(width, -length) * SCALE_FACTOR * 3)
    return count


def place_cap_mim_1f5fF(lib, cv, ly, top, c, nl_inds):
    # ref: https://gf180mcu-pdk.readthedocs.io/en/latest/analog/layout/inter_specs/inter_specs_3_43.html
    width = parse_si_value(c["props"]["w"]) * 1e6
    length = parse_si_value(c["props"]["l"]) * 1e6
    params = {
        "mim_option": "MIM-B",
        "metal_level": c["props"].get("metal_level", "M5"),
        "wc": width,
        "lc": length,
        "lbl": False,
    }
    cell = ly.create_cell("cap_mim", lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    count = parse_int_value(c["props"]["m"], 1)
    for _ in range(count):
        inst = top.insert(pya.CellInstArray(cell, pos))
        inst.set_property(99, c["props"]["name"])  # User property for SPICE name
        print(f"Created a new mimcap {c['props']['name']}.")
        pos += pya.Vector(pya.DVector(width, -length) * SCALE_FACTOR * 3)
    return count


def place_cap_nmos_pmos_03v3(lib, cv, ly, top, c, nl_inds):
    pcell_name = c["props"]["model"].replace("_03v3", "")
    width = parse_si_value(c["props"]["w"]) * 1e6
    length = parse_si_value(c["props"]["l"]) * 1e6
    params = {
        "volt": "3.3V",
        "lc": width,
        "wc": length,
        "lbl": False,
    }
    if not pcell_name.endswith("_b"):
        params["deepnwell"] = False
        params["pcmpgr"] = False
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    count = parse_int_value(c["props"]["m"], 1)
    for _ in range(count):
        inst = top.insert(pya.CellInstArray(cell, pos))
        inst.set_property(99, c["props"]["name"])  # User property for SPICE name
        print(f"Created a new capacitor {c['props']['name']}.")
        pos += pya.Vector(pya.DVector(width, -length) * SCALE_FACTOR * 3)
    return count


# --- Main ---
def run_import():
    # 1. Get layout context, load library
    print("Initializing...")
    ensure_active_gf180_pdk()
    lib = resolve_lib(PDK_LIB_NAME)
    if lib is None:
        print(f"Could not find library '{PDK_LIB_NAME}'.")
        return

    cv = get_or_create_cellview()
    ly = cv.layout()
    top = get_or_create_top(ly)
    if ly.dbu != 0.005:
        # Efabless says to use 0.005um for gf180mcu.
        print("Warning: Layout database units are not 0.005um!")

    # 2. Choose file
    netlist_path = pya.FileDialog.ask_open_file_name(
        "Choose Netlist",
        ".",
        "Netlists (*.spice *.sp *.cir *.cdl *.sch)",
    )
    if not netlist_path:
        print("No file selected. Exiting.")
        return

    # 3. Parse devices
    print("Parsing devices...")
    with open(netlist_path, "r", encoding="utf-8") as f:
        f_content = f.read()

    nl_inds = get_newline_indices(f_content)
    components = parse_components(f_content, nl_inds)

    # 4. Place devices
    print("Placing devices... This will take ~30s per unique device.")
    placed = 0
    for component in components:
        placed += map_sym(component["sym"])(lib, cv, ly, top, component, nl_inds)

    # 5. Inform user that import finished
    print(f"Import complete. Placed {placed} devices.")


if __name__ == "__main__":
    import gf180mcu
    gf180mcu.PDK.activate()

    init_cfg()
    if PRINT_PDKS:
        print(f"Library names detected by pya:\n{pya.Library.library_names()}")
    elif PRINT_PCELLS:
        lib = resolve_lib(PDK_LIB_NAME)
        if lib is None:
            print(f"Could not find library '{PDK_LIB_NAME}'.")
        else:
            print_pcells(lib)
    else:
        run_import()
