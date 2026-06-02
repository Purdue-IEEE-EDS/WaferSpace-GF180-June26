import os
import re
import pya


# --- Configuration ---
# Must be in a function because other functions are used
#  as part of the configuration variables.
def init_cfg():
    global PDK_LIB_NAME, SCALE_FACTOR, SI_MULTIPLIERS, DEVICE_MAP, PRINT_PDKS, PRINT_PCELLS

    # Returned from calling 'pya.Library.library_names()'.
    # See below for debugging options.
    PDK_LIB_NAME = "gf180mcu"

    # Device coordinates will be multiplied by this factor.
    SCALE_FACTOR = 32.0

    # The units will correspond to multiplying by this number.
    SI_MULTIPLIERS = {
        "t": 1e12, "g": 1e9, "meg": 1e6, "k": 1e3, "m": 1e-3,
        "u": 1e-6, "n": 1e-9, "p": 1e-12, "f": 1e-15, None: 1
    }

    # Map each schematic symbol to either a placing function
    #  or an Exception to raise one upon parsing the symbol.
    # Symbols not mapped are ignored.
    DEVICE_MAP = {
        "ppolyf_u_1k.sym": place_polyres,
        "pfet_03v3.sym": place_nfet_pfet_03v3,
        "nfet_03v3.sym": place_nfet_pfet_03v3,
        "cap_mim_1f5fF.sym": place_cap_mim_1f5fF,
        "ppolyf_u.sym": place_polyres,
        "ppolyf_s.sym": place_polyres,
        "npolyf_u.sym": place_polyres,
        "npolyf_s.sym": place_polyres,
    
        "res.sym": gen_place_warn("Ideal component: res.sym"),
        "capa-2.sym": gen_place_warn("Ideal component: capa-2.sym"),
    
        "ppolyf_u_3k.sym": ValueError("Can't use in WaferSpace tapeout"),
        "ppolyf_u_2k.sym": ValueError("Can't use in WaferSpace tapeout"),
        "cap_mim_2f0fF.sym": ValueError("Can't use in WaferSpace tapeout"),
        "cap_mim_1f0fF.sym": ValueError("Can't use in WaferSpace tapeout")
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
            print(t)
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


def parse_si_value(value, *, si_match_expr = re.compile(r"([+-]?\d+(?:\.\d+)?(?:e[+-]?\d+)?)\s*([a-zµ]+)?")):
    if not isinstance(value, str):
        return value
    
    match = si_match_expr.fullmatch(value.strip().lower())
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


def parse_props(props, *, prop_match_expr = re.compile(r"""(?P<key>[^=]*)=\s*(?P<value>"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|\S*)""")):
    props = props.strip()
    parsed = dict()
    i = 0
    while i < len(props):
        m = prop_match_expr.match(props, i)
        if m is None:
            print(f"Warning: Extra data at end of properties: {props[i:]}")
            break
        parsed[m.group("key").strip()] = m.group("value").strip()
        i = m.end()
    return parsed


def map_sym(sym, *, default = place_pass):
    return DEVICE_MAP.get(os.path.basename(sym), default)


# --- Placing functions ---
def gen_place_warn(msg):
    def place_warn(lib, cv, ly, top, c):
        print(f"Warning: Char {c['spice_loc']}: {msg}")
        return 0
    return place_warn


def gen_place_err(err_t, msg):
    def place_err(lib, cv, ly, top, c):
        raise err_t(f"Char {c['spice_loc']}: {msg}")
        return 0
    return place_err


def place_pass(lib, cv, ly, top, c):
    # print(f"Skipping: {c['sym']}")
    return 0


def place_polyres(lib, cv, ly, top, c):
    pcell_name = c["props"]["model"] \
                    .replace("1k", "high_Rs") \
                    .replace("2k", "high_Rs") \
                    .replace("3k", "high_Rs") \
                    + "_resistor"
    width = parse_si_value(c["props"]["W"]) * 1e6
    length = parse_si_value(c["props"]["L"]) * 1e6
    params = {
        "deepnwell": False,
        "pcmpgr": False,
        "w_res": width,
        "l_res": length,
        "array_x": 1,
        "array_y": int(c["props"]["m"]),
        "lbl": False
    }
    if "high_Rs" in pcell_name:
        params["volt"] = "3.3V"
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    inst = top.insert(pya.CellInstArray(cell, pos))
    inst.set_property(99, c["props"]["name"])  # User property for SPICE name
    print(f"Created a new resistor {c["props"]["name"]}.")
    return 1


def place_nfet_pfet_03v3(lib, cv, ly, top, c):
    pcell_name = "nfet" if c["props"]["model"] == "nfet_03v3" else "pfet"
    width = parse_si_value(c["props"]["W"]) * 1e6
    length = parse_si_value(c["props"]["L"]) * 1e6
    nfingers = int(c["props"]["nf"])
    params = {
        "deepnwell": False,
        "pcmpgr": False,
        "volt": "3.3V",
        "bulk": "Bulk Tie",
        "w_gate": width,
        "l_gate": length,
        "nf": nfingers,
        "con_bet_fin": False if nfingers == 1 else True,  # Disabling allows width to reach minimum @ 0.22u
        "lbl": False
    }
    # Idk man
    # lib.refresh()
    # Always create nfet first to work around klayout bug
    #  where pfets do not appear.
    # cell = ly.create_cell("nfet", lib.name(), params)
    cell = ly.create_cell(pcell_name, lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    for _ in range(int(c["props"]["m"])):
        # If the instance is outdated click File -> Refresh Libraries
        #  or just restart KLayout. Some weird cache issue I haven't yet
        #  figured out (maybe the result of the way I use ly.create_cell)
        inst = top.insert(pya.CellInstArray(cell, pos))
        inst.set_property(99, c["props"]["name"])  # User property for SPICE name
        # Evidently, if you have ran this script, the workaround
        #  does not actually work-around the problem, but the code
        #  is staying in case a future fix can use it.
        # inst.cell.change_ref(lib.name(), "pfet")
        # inst.cell.change_ref(lib.name(), "nfet")
        # inst.cell.change_ref(lib.name(), pcell_name)
        # This is what's broken, but KLayout doesn't let us fix it.
        # print("BBox", inst.dbbox())
        if pcell_name == "pfet":
            print("\tKLayout sucks so your pfet may be invisible. " +
                  "Fix it by going to Instance Properties (select, press Q) -> Cell " +
                  "then changing to nfet and back to pfet.")
        print(f"Created a new transistor {c["props"]["name"]}.")
        pos += pya.Vector(pya.DVector(width, -length) * SCALE_FACTOR * 3)
    return int(c["props"]["m"])


def place_cap_mim_1f5fF(lib, cv, ly, top, c):
    # ref: https://gf180mcu-pdk.readthedocs.io/en/latest/analog/layout/inter_specs/inter_specs_3_43.html
    width = parse_si_value(c["props"]["W"]) * 1e6
    length = parse_si_value(c["props"]["L"]) * 1e6
    params = {
        "mim_option": "MIM-B",  # Use MIM-B option
        "metal_level": "M5",  # Between M4 and M5
        "wc": width,
        "lc": length,
        "lbl": False
    }
    cell = ly.create_cell("cap_mim", lib.name(), params)
    pos = pya.Vector(pya.DVector(c["x"], -c["y"]) * SCALE_FACTOR)
    for _ in range(int(c["props"]["m"])):
        inst = top.insert(pya.CellInstArray(cell, pos))
        inst.set_property(99, c["props"]["name"])  # User property for SPICE name
        print(f"Created a new mimcap {c["props"]["name"]}.")
        pos += pya.Vector(pya.DVector(width, -length) * SCALE_FACTOR * 3)
    return int(c["props"]["m"])


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
    if ly.dbu != 0.005:
        # # Efabless says to use 0.005um for gf180mcu.
        print(f"Warning: Layout database units are not 0.005um!")

    # 2. Choose file
    netlist_path = pya.FileDialog.ask_open_file_name("Choose Netlist", '.', "SPICE (*.spice *.sch)")
    if not netlist_path:
        return

    # 3. Parse devices
    print("Parsing devices...")
    with open(netlist_path, 'r') as f:
        f_content = f.read()

    components = []
    comp_regex = re.compile(r"C \{(?P<sym>[^}]*)\} (?P<x>-?[0-9]+) (?P<y>-?[0-9]+) (?P<b>-?[0-9]+) (?P<h>-?[0-9]+) \{(?P<props>[^}]*)\}")
    next_line = lambda content, pos: content.find("\n", pos) + 1
    
    i = 0
    while True:
        # Lines containing components start with 'C'
        if f_content.startswith('C ', i):
            m = comp_regex.match(f_content, i)
            components.append({
                "sym": m.group("sym"),
                "x": parse_si_value(m.group("x")),
                "y": parse_si_value(m.group("y")),
                "b": parse_si_value(m.group("b")),
                "h": parse_si_value(m.group("h")),
                "props": parse_props(m.group("props")),
                "spice_loc": i
            })
            i = m.end()
            
            # Detect and raise parse-time errors
            m = map_sym(m.group("sym"))
            if isinstance(m, Exception):
                raise m

        # Continue to next line
        i = next_line(f_content, i)
        if i == 0:
            break

    # 4. Place devices
    print("Placing devices... This will take ~30s per unique device.")
    i = 0
    for c in components:
        i += map_sym(c['sym'])(lib, cv, ly, top, c)

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
