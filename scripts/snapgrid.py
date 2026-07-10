import pya


# Enter list of number-datatype pairs or names
# THE INDEX IS NOT THE SAME AS THE NUMBER!
#LAYERS_TO_TOUCH = ["Metal1", "Contact (33/0)", [22, 0]]  # last one is COMP

# Looks like using strings to search for layers is broken. So...
LAYERS_TO_TOUCH = [[22, 0], [34, 0], [33, 0]]  # COMP, Metal1, Contact

TOUCH_ALL_LAYERS = True  # To ignore the above list and just snap all layers to grid

ROUNDING = 5  # in dbu, so 5 == 0.005um


# References: https://www.klayout.de/forum/discussion/1467/iterating-through-layers-with-particular-name
# https://www.klayout.de/doc-qt5/code/class_Shapes.html#method23
# https://www.klayout.org/klayout-pypi/overview/shapes/
# https://www.klayout.de/forum/discussion/1361/python-code-equivalent-of-converting-all-cells-to-static


def point_needs_rounding(pt, u = ROUNDING):
    return pt.x % u or pt.y % u


def round_coord(n, u = ROUNDING):
    m = n % u
    if m > u // 2:
        # round up
        return n - m + u
    elif m == u // 2 and not u % 2:
        # round to even
        if ((n - m) // u) % 2:
            return n - m + u
        return n - m
    else:
        # round down
        return n - m


def round_point(pt, u = ROUNDING):
    return pya.Point(round_coord(pt.x, u), round_coord(pt.y, u))


def round_edge(e, u = ROUNDING):
    return pya.Edge(round_point(e.p1, u), round_point(e.p2, u))


def round_edge_pair(ep, u = ROUNDING):
    # NOTE: this always sets symmetric = False, even when
    # the original edge pair had symmetric == True.
    return pya.EdgePair(round_edge(ep.first, u), round_edge(ep.second, u))


def main():
    cv = pya.CellView.active()
    if cv is None:
        print("No active cellview. Exiting.")
        return

    ly = cv.layout()
    if ly is None:
        print("No active layout. Exiting.")
        return

    assert ly.dbu == 0.001

    # Warn the user
    ok = pya.MessageBox.warning("You are about to screw up your layout irreversibly for the sake of appeasing the DRC gods",
                            "All your PCells will be IRREVERSIBLY flattened into static cells and you will be UNABLE TO EDIT THEM AFTER RUNNING THIS SCRIPT!\n\nAdditionally this script is unstable and will probably crash and burn and you will be very sad!\n\nSo, MAKE A BACKUP! Or SAVE and commit your old gds to git before running!",
                            pya.MessageBox.Abort | pya.MessageBox.Ok)
    if ok != pya.MessageBox.Ok:
        print("Aborting.")
        return

    # First step is to make all PCells static cells
    # so we can edit the vertices.
    cv_cells = dict()
    for c in ly.each_cell():
        # Try converting cell to static.
        # If cell is already static, then index will not change.
        ci = c.cell_index()
        ci_static = ly.convert_cell_to_static(ci)
        if ci_static != ci:
            # We can't convert instances to static here
            # because fuck you idk why man
            # (it just doesn't work, instances stay as old cell)
            cv_cells[ci] = ci_static

    # Now convert all eligible instances to static
    for c in ly.each_cell():
        # I don't know why but you have to write the loops
        # in this SPECIFIC way. You can't optimize by trying
        # to lift the if statement outside of the for loop,
        # and you can't merge this loop with the above loop either.
        for i in c.each_inst():
            if i.cell_index in cv_cells:
                i.cell_index = cv_cells[i.cell_index]

    # Delete original PCells
    for ci in cv_cells:
        ly.delete_cell(ci)
        pass


    # Second step is to get all the possible layers shapes can be on.
    # (Basically validating and converting list to indices)
    if TOUCH_ALL_LAYERS:
        touch_idx = ly.layer_indexes()
    else:
        touch_idx = set()
        for l in LAYERS_TO_TOUCH:
            fl = None
            if isinstance(l, str):
                fl = ly.find_layer(l)
            else:
                fl = ly.find_layer(l[0], l[1])
            if fl is not None:
                touch_idx.add(fl)
            else:
                print(f"Could not find layer {l}")
        touch_idx = list(touch_idx)


    # Last step is to iterate through each cell's shapes and snap if necessary.
    for c in ly.each_cell():
        for i in touch_idx:
            for s in c.each_shape(i):
                assert s.layer == i
                if s.is_box():
                    # Of course KLayout has a helper method for boxes ONLY...
                    if point_needs_rounding(s.box_p1):
                        s.box_p1 = round_point(s.box_p1)
                    if point_needs_rounding(s.box_p2):
                        s.box_p2 = round_point(s.box_p2)
                elif s.is_edge():
                    # Since returned object is const, we must replace
                    # the entire edge.
                    if point_needs_rounding(s.edge.p1) or point_needs_rounding(s.edge.p2):
                        s.edge = round_edge(s.edge)
                elif s.is_edge_pair():
                    # Since returned object is const, we must replace
                    # the entire edge pair.
                    if point_needs_rounding(s.edge_pair.first.p1) \
                            or point_needs_rounding(s.edge_pair.first.p2) \
                            or point_needs_rounding(s.edge_pair.second.p1) \
                            or point_needs_rounding(s.edge_pair.second.p2):
                        s.edge_pair = round_edge_pair(s.edge_pair)
                elif s.is_path():
                    for p in s.path.each_point():
                        if point_needs_rounding(p):
                            break
                    else:
                        if s.path_bgnext % ROUNDING:
                            print("I'm rounding a path begin extension!!!")
                        elif s.path_endext % ROUNDING:
                            print("I'm rounding a path end extension!!!")
                        elif s.path_width % ROUNDING:
                            pass
                        else:
                            continue
                    pts = [round_point(p) for p in s.path.each_point()]
                    bext = round_coord(s.path_bgnext)
                    eext = round_coord(s.path_endext)
                    w = round_coord(s.path_width)
                    s.path = pya.Path(pts, w, bext, eext, s.round_path)
                elif s.is_point():
                    if point_needs_rounding(s.point):
                        s.point = round_point(s.point)
                elif s.is_polygon():
                    # good luck
                    for p in s.polygon.each_point_hull():
                        if point_needs_rounding(p):
                            break
                    else:
                        for i in range(s.polygon.holes()):
                            for p in s.polygon.each_point_hole(i):
                                if point_needs_rounding(p):
                                    break
                            else:
                                continue
                            break
                        else:
                            continue
                    # aight time to fix the polygon
                    pts = [round_point(p) for p in s.polygon.each_point_hull()]
                    holes = [[round_point(p) for p in s.polygon.each_point_hole(i)]
                                for i in range(s.polygon.holes())]
                    p = pya.Polygon(pts)
                    for h in holes:
                        p.insert_hole(h)
                    s.polygon = p
                elif s.is_simple_polygon():
                    for p in s.simple_polygon.each_point():
                        if point_needs_rounding(p):
                            break
                    else:
                        continue
                    # aight time to fix the polygon
                    pts = [round_point(p) for p in s.polygon.each_point()]
                    s.simple_polygon = pya.SimplePolygon(pts)
                else:
                    print(f"Skipping weird shape at {s.dbbox()}")
    print("Done.")

if __name__ == "__main__":
    main()
