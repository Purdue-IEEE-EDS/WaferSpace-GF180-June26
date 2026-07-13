import re
import pya
import bisect

# Currently, the script DOES NOT cover:
# * Well and Metal resistors
# * BJTs
# * Diodes
# * Hierarchical Layouts (ask Eileen)
# * Anything 5/6V
# * 3-T(erminal) Transistors will be laid out as 4-T Transistors.

# If you want to see the specific configuration we are on, this is it:
# https://gf180mcu-pdk.readthedocs.io/en/latest/analog/layout/inter_specs/inter_specs_3_43.html
# ^ However, the MIMcaps are 2.0fF/um^2 instead of 1.5fF/um^2.

# Additionally here are the sheet resistances for resistors:
# https://gf180mcu-pdk.readthedocs.io/en/latest/analog/spice/elec_specs/elec_specs_5_1.html

# Here are the basic DRC rules, which may be outdated:
# https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_07_02.html

# If you want varactors, see this discussion:
# https://web.open-source-silicon.dev/t/8998736/u016em8l91b-are-nmoscaps-realized-as-poly-over-n-tap-inside-
# However, in our experience, this may be false.

# Other errata: Grid spacing might need to be 0.001um instead of 0.005um, but this can cause OFFGRID violations.
#               Instead you may create your layout with 0.005um and port it to 0.001um later.


# --- Configuration ---
# Must be in a function because other functions are used
#  as part of the configuration variables.
def init_cfg():
    global PDK_LIB_NAME, SCALE_FACTOR, SI_MULTIPLIERS, SKIP_SPICE_IGNORE, PARAM_ALIASES, DEVICE_MAP, PRINT_PDKS, PRINT_PCELLS

    # Returned from calling 'pya.Library.library_names()'.
    # See below for debugging options.
    PDK_LIB_NAME = "gf180mcu"

    # Device coordinates will be multiplied by this factor.
    SCALE_FACTOR = 16.0

    # The units will correspond to multiplying by this number.
    SI_MULTIPLIERS = {
        "t": 1e12, "g": 1e9, "meg": 1e6, "k": 1e3, "m": 1e-3,
        "u": 1e-6, "n": 1e-9, "p": 1e-12, "f": 1e-15, None: 1
    }

    # Skip placing devices with the parameter "spice_ignore=true".
    SKIP_SPICE_IGNORE = True
    
    # Add aliases for parameter names. First item in each list is the
    # "canonical name" used by the script, and other items are aliases.
    # *** Write the parameter names in ALL LOWERCASE! ***
    PARAM_ALIASES = [
        ["m", "mult"]  # Device multiplicity, lookup with 'm'.
    ]

    # Map each schematic model to either a placing function
    #  or an Exception to raise one upon parsing the symbol.
    # *** Write the model names in ALL LOWERCASE! ***
    DEVICE_MAP = {
        # MOSFET
        "pfet_03v3": place_nfet_pfet_03v3,
        "nfet_03v3": place_nfet_pfet_03v3,

        # MIMcap (Connects between Metal4 and Metal5 in WaferSpace tapeout)
        "cap_mim_2f0ff": gen_place_warn("SPICE model for cap_mim_2f0fF **may** differ from intended model cap_mim_2f0_m4m5_noshield.", place_cap_mim),
        "cap_mim_2f0_m4m5_noshield": place_cap_mim,

        # MOScap
        "cap_nmos_03v3": place_cap_nmos_pmos_03v3,
        "cap_nmos_03v3_b": place_cap_nmos_pmos_03v3,
        "cap_pmos_03v3": place_cap_nmos_pmos_03v3,
        "cap_pmos_03v3_b": place_cap_nmos_pmos_03v3,

        # Hi-Res Polyres
        "ppolyf_u_1k": place_npolyf_ppolyf,

        # Lo-Res Polyres
        "ppolyf_u": place_npolyf_ppolyf,
        "ppolyf_s": place_npolyf_ppolyf,
        "npolyf_u": place_npolyf_ppolyf,
        "npolyf_s": place_npolyf_ppolyf,

        # Diffusion res
        "pplus_u": place_nplus_pplus,
        "pplus_s": place_nplus_pplus,
        "nplus_u": place_nplus_pplus,
        "nplus_s": place_nplus_pplus,

        # Component jail
        "ppolyf_u_3k": ValueError("Can't use ppolyf_u_3k in WaferSpace tapeout"),
        "ppolyf_u_2k": ValueError("Can't use ppolyf_u_2k in WaferSpace tapeout"),
        "cap_mim_1f5ff": ValueError("Can't use cap_mim_1f5fF in WaferSpace tapeout"),
        "cap_mim_1f0ff": ValueError("Can't use cap_mim_1f0fF in WaferSpace tapeout"),
        "cap_mim_1f5_m2m3_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_1f0_m2m3_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_2f0_m2m3_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_1f5_m3m4_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_1f0_m3m4_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_2f0_m3m4_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_1f5_m4m5_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_1f0_m4m5_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_1f5_m5m6_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_1f0_m5m6_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog."),
        "cap_mim_2f0_m5m6_noshield": ValueError("Use cap_mim_2f0_m4m5_noshield as model for cap_mim_analog.")
    }

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
            elif candidates[1] is None and "top" in t.name.lower():
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
    except Exception as e:
        print(f"Could not list pcell names: {e}")
        return
    print(f"Available PCells in library '{lib.name()}': {available_pcells}")
    for x in available_pcells:
        params = lib.layout().pcell_declaration(x).get_parameters()
        print(x, end="\t")
        for y in params:
            print(y.name, end = " ")
        print()


def get_newline_indices(f_content):
    return [i for i, c in enumerate(f_content) if c == "\n"]


def get_line_number(newline_indices, i):
    return bisect.bisect_left(newline_indices, i)


def get_param_alias_map(param_aliases):
    # Generate a map that maps each parameter
    # alias to its canonical name.
    param_alias_map = dict()
    for pl in param_aliases:
        param_alias_map.update({p: pl[0] for p in pl[1:]})
    return param_alias_map


def parse_si_value(value, *, si_match_expr = re.compile(r"([+-]?\d+(?:\.\d+)?(?:e[+-]?\d+)?)\s*([a-zµ]+)?")):
    if not isinstance(value, str):
        return value

    value = value.strip().lower()
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


def parse_params(params, param_alias_map = {}, *, param_match_expr = re.compile(r"""(?P<key>[^=]*)=\s*(?P<value>"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|\S*)""")):
    params = params.strip().lower()  # Case-insensitive like SPICE
    parsed = dict()
    i = 0
    while i < len(params):
        m = param_match_expr.match(params, i)
        if m is None:
            print(f"Warning: Extra data at end of parameters: {params[i:]}")
            break
        k = m.group("key").strip()
        # Use param_alias_map to canonicalize parameter names
        parsed[param_alias_map.get(k, k)] = m.group("value").strip()
        i = m.end()
    return parsed


# --- Placing functions ---
def gen_place_warn(msg, place_func):
    def place_warn(lib, cv, ly, top, c, nl_inds):
        print(f"Warning: Line {get_line_number(nl_inds, c["spice_loc"])}: {msg}")
        return place_func(lib, cv, ly, top, c, nl_inds)
    return place_warn


def gen_place_err(err_t, msg):
    def place_err(lib, cv, ly, top, c, nl_inds):
        raise err_t(f"Line {get_line_number(nl_inds, c["spice_loc"])}: {msg}")
        return 0
    return place_err


def place_pass(lib, cv, ly, top, c, nl_inds):
    print(f"Skipping unmatched device model: {c["params"]["model"]}")
    return 0


def place_npolyf_ppolyf(lib, cv, ly, top, c, nl_inds):
    pcell_name = c["params"]["model"] \
                    .replace("1k", "high_Rs") \
                    .replace("2k", "high_Rs") \
                    .replace("3k", "high_Rs") \
                    + "_resistor"
    width = parse_si_value(c["params"]["w"]) * 1e6
    length = parse_si_value(c["params"]["l"]) * 1e6
    params = {
        "deepnwell": False,
        "pcmpgr": False,
        "w_res": width,
        "l_res": length,
        "array_x": 1,
        "array_y": int(c["params"]["m"]),
        "lbl": False
    }
    if "high_Rs" in pcell_name:
        params["volt"] = "3.3V"
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    inst = top.insert(pya.CellInstArray(cell, pos))
    inst.set_property(99, c["params"]["name"])  # User property for SPICE name
    print(f"Created a new resistor {c["params"]["name"]}.")
    return 1


def place_nfet_pfet_03v3(lib, cv, ly, top, c, nl_inds):
    pcell_name = "nfet" if c["params"]["model"] == "nfet_03v3" else "pfet"
    width = parse_si_value(c["params"]["w"]) * 1e6
    length = parse_si_value(c["params"]["l"]) * 1e6
    nfingers = int(c["params"]["nf"])
    params = {
        "deepnwell": False,
        "pcmpgr": False,
        "volt": "3.3V",
        "bulk": "Bulk Tie",
        "w_gate": width / nfingers,
        "l_gate": length,
        "nf": nfingers,
        "gate_con_pos": "top",  # work around klayout bug where it's actually "alternating" by default
        "con_bet_fin": False if nfingers == 1 else True,  # Disabling allows width to reach minimum @ 0.22u and fixes a KLayout bug where pmos has zero initial bbox (disappears initially).
        "lbl": False
    }
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    for _ in range(int(c["params"]["m"])):
        inst = top.insert(pya.CellInstArray(cell, pos))
        inst.set_property(99, c["params"]["name"])  # User property for SPICE name
        print(f"Created a new transistor {c["params"]["name"]}.")
        pos += pya.Vector(pya.DVector(width, -length) * SCALE_FACTOR * 3)
    return int(c["params"]["m"])


def place_cap_mim(lib, cv, ly, top, c, nl_inds):
    width = parse_si_value(c["params"]["w"]) * 1e6
    length = parse_si_value(c["params"]["l"]) * 1e6
    params = {
        "mim_option": "MIM-B",  # Use MIM-B option
        "metal_level": "M5",  # Between M4 and M5
        "wc": width,
        "lc": length,
        "lbl": False
    }
    cell = ly.create_cell("cap_mim", lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    for _ in range(int(c["params"]["m"])):
        inst = top.insert(pya.CellInstArray(cell, pos))
        inst.set_property(99, c["params"]["name"])  # User property for SPICE name
        print(f"Created a new mimcap {c["params"]["name"]}.")
        pos += pya.Vector(pya.DVector(width, -length) * SCALE_FACTOR * 3)
    return int(c["params"]["m"])


def place_cap_nmos_pmos_03v3(lib, cv, ly, top, c, nl_inds):
    pcell_name = c["params"]["model"].replace("_03v3", "")
    width = parse_si_value(c["params"]["w"]) * 1e6
    length = parse_si_value(c["params"]["l"]) * 1e6
    params = {
        "volt": "3.3V",
        "lc": width,
        "wc": length,
        "lbl": False
    }
    if not pcell_name.endswith("_b"):
        params["deepnwell"] = False
        params["pcmpgr"] = False
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    for _ in range(int(c["params"]["m"])):
        inst = top.insert(pya.CellInstArray(cell, pos))
        inst.set_property(99, c["params"]["name"])  # User property for SPICE name
        print(f"Created a new moscap {c["params"]["name"]}.")
        pos += pya.Vector(pya.DVector(width, -length) * SCALE_FACTOR * 3)
    return int(c["params"]["m"])


def place_nplus_pplus(lib, cv, ly, top, c, nl_inds):
    pcell_name = c["params"]["model"] + "_resistor"
    width = parse_si_value(c["params"]["w"]) * 1e6
    length = parse_si_value(c["params"]["l"]) * 1e6
    params = {
        "deepnwell": False,
        "pcmpgr": False,
        "w_res": width,
        "l_res": length,
        "array_x": 1,
        "array_y": int(c["params"]["m"]),
        "lbl": False
    }
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    inst = top.insert(pya.CellInstArray(cell, pos))
    inst.set_property(99, c["params"]["name"])  # User property for SPICE name
    print(f"Created a new resistor {c["params"]["name"]}.")
    return 1


# How to create a new place function:
# 1. Copy an existing function from above, modify it to suit your needs. The parameters are
#    "library", "cellview", "layout", "toplevel", (see KLayout docs)
#    "component" (see Line 411), "newline_indices" (see Line 167).
#  The return value is how many devices you created for this schematic symbol.
# 2. Add the relevant SPICE model name to DEVICE_MAP.

# In KLayout you can enable "Show parameter names" in
# [any PCell] -> [press Q] -> Instance Properties -> Options -> 'Show parameter names'.


# --- Main ---
def run_import():
    # 1. Get layout context, load library
    print("Initializing...")
    lib = resolve_lib(PDK_LIB_NAME)
    if lib is None:
        print(f"Could not find library '{PDK_LIB_NAME}'.")
        return

    cv = get_or_create_cellview()
    ly = cv.layout()
    top = get_or_create_top(ly)
    # This may not be the case anymore.
    # if ly.dbu != 0.005:
    #     # Efabless says to use 0.005um for gf180mcu.
    #    print("Warning: Layout database units are not 0.005um!")

    # 2. Choose file
    netlist_path = pya.FileDialog.ask_open_file_name("Choose Netlist", ".", "SPICE (*.spice *.sch *)")
    if not netlist_path:
        print("No file selected. Exiting.")
        return

    # 3. Parse devices
    print("Parsing devices...")
    with open(netlist_path, "r") as f:
        f_content = f.read()

    nl_inds = get_newline_indices(f_content)
    param_alias_map = get_param_alias_map(PARAM_ALIASES)

    components = []
    comp_regex = re.compile(r"C \{(?P<sym>[^}]*)\} (?P<x>-?[0-9]+) (?P<y>-?[0-9]+) (?P<b>-?[0-9]+) (?P<h>-?[0-9]+) \{(?P<params>[^}]*)\}")
    next_line = lambda content, pos: content.find("\n", pos) + 1
    map_model = lambda model: DEVICE_MAP.get(model, place_pass)

    i = 0
    while True:
        # Store target end index
        j = i
        try:
            # Lines containing components start with 'C'
            if not f_content.startswith("C ", i):
                continue

            m = comp_regex.match(f_content, i)
            c = {
                "sym": m.group("sym"),
                "x": parse_si_value(m.group("x")),
                "y": parse_si_value(m.group("y")),
                "b": parse_si_value(m.group("b")),
                "h": parse_si_value(m.group("h")),
                "params": parse_params(m.group("params"), param_alias_map),
                "spice_loc": i
            }
            j = m.end()

            # Only add devices with a 'model' parameter (aka PDK devices)
            if "model" not in c["params"]:
                print(f"Warning: Line {get_line_number(nl_inds, i)}: Skipping potentially ideal symbol: {c["sym"]}")
                continue

            # If desired, skip devices with spice_ignore=true
            if SKIP_SPICE_IGNORE and c["params"].get("spice_ignore", "false") == "true":
                continue

            # Detect and raise parse-time errors
            place_func = map_model(c["params"]["model"])
            if isinstance(place_func, Exception):
                place_func.add_note(f"(Line {get_line_number(nl_inds, i)})")
                raise place_func

            components.append(c)
        finally:
            # Continue to next line
            i = next_line(f_content, j)
            if i == 0:
                break

    # 4. Place devices
    print("Placing devices... This will take ~30s per unique device.")
    i = 0
    for c in components:
        i += map_model(c["params"]["model"])(lib, cv, ly, top, c, nl_inds)

    # 5. Inform user that import finished
    print(f"Import complete. Placed {i} devices.")


if __name__ == "__main__":
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
