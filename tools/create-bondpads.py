import gdspy
from math import floor

points = [
    (-1944.61000, -1257.50000),
    (-1957.50000, -1244.61000),
    (-1957.50000, 1244.61000),
    (-1944.61000, 1257.50000),
    (0, 1257.50000),
    (0, 1242.50000),
    (-1938.39000, 1242.50000),
    (-1942.50000, 1238.39000),
    (-1942.50000, -1238.39000),
    (-1938.39000, -1242.50000),
    (1938.39000, -1242.50000),
    (1942.50000, -1238.39000),
    (1942.50000, 1238.39000),
    (1938.39000, 1242.50000),
    (0, 1242.50000),
    (0, 1257.50000),
    (1944.61000, 1257.50000),
    (1957.50000, 1244.61000),
    (1957.50000, -1244.61000),
    (1944.61000, -1257.50000),
]

ringMetalLayers = [22, 31, 34, 36, 42, 46, 81, 167]
ringViaLayers = [35, 38, 40, 41]

gridRound = lambda x: round(x * 200) / 200

def main():
    guardRing = gdspy.Cell("guardRing")
    
    outer_points = [
        (-1944.61000, -1257.50000),
        (-1957.50000, -1244.61000),
        (-1957.50000, 1244.61000),
        (-1944.61000, 1257.50000),
        (1944.61000, 1257.50000),
        (1957.50000, 1244.61000),
        (1957.50000, -1244.61000),
        (1944.61000, -1257.50000),
    ]
    inner_points = [
        (-1938.39000, 1242.50000),
        (-1942.50000, 1238.39000),
        (-1942.50000, -1238.39000),
        (-1938.39000, -1242.50000),
        (1938.39000, -1242.50000),
        (1942.50000, -1238.39000),
        (1942.50000, 1238.39000),
        (1938.39000, 1242.50000),
    ]

    for layer in ringMetalLayers:
        if layer == 31:  # Pplus layer
            outer_poly = gdspy.Polygon(outer_points)
            inner_poly = gdspy.Polygon(inner_points)
            clean_ring = gdspy.boolean(outer_poly, inner_poly, 'not')
            ring = gdspy.offset(clean_ring, 0.05, layer=31)
            for poly in ring.polygons:
                for idx in range(len(poly)):
                    poly[idx][0] = gridRound(poly[idx][0])
                    poly[idx][1] = gridRound(poly[idx][1])
        else:
            ring = gdspy.Polygon(points, layer=layer)
        guardRing.add(ring)

    viaInternalSpacing = 0.28
    viaSize = 0.22
    horizontalDistance = 3876.78
    verticalDistance = 15
    viaHorizontalEdgeSpacing = 0
    viaVerticalEdgeSpacing = 0.07

    numberOfViasHorizontal = floor((horizontalDistance - 2*viaHorizontalEdgeSpacing) / (viaInternalSpacing + viaSize))
    horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if horizontalSpacing - (viaInternalSpacing + viaSize) > viaHorizontalEdgeSpacing*2:
        numberOfViasHorizontal += 1
        horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    horizontalShift = gridRound(horizontalSpacing / 2)

    numberOfViasVertical = floor((verticalDistance - 2*viaVerticalEdgeSpacing) / (viaInternalSpacing + viaSize))
    verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if verticalSpacing - (viaInternalSpacing + viaSize) > viaVerticalEdgeSpacing*2:
        numberOfViasVertical += 1
        verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    verticalShift = gridRound(verticalSpacing / 2)

    for hVia in range(numberOfViasHorizontal):
        for vVia in range(numberOfViasVertical):
            x = horizontalShift + (hVia * (viaInternalSpacing + viaSize)) - 1938.39
            y = verticalShift + (vVia * (viaInternalSpacing + viaSize)) + 1242.5
            via = gdspy.Rectangle((x, y), (x + viaSize, y + viaSize), layer=33)
            guardRing.add(via)

    numberOfViasHorizontal = floor((horizontalDistance - 2*viaHorizontalEdgeSpacing) / (viaInternalSpacing + viaSize))
    horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if horizontalSpacing - (viaInternalSpacing + viaSize) > viaHorizontalEdgeSpacing*2:
        numberOfViasHorizontal += 1
        horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    horizontalShift = gridRound(horizontalSpacing / 2)

    numberOfViasVertical = floor((verticalDistance - 2*viaVerticalEdgeSpacing) / (viaInternalSpacing + viaSize))
    verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if verticalSpacing - (viaInternalSpacing + viaSize) > viaVerticalEdgeSpacing*2:
        numberOfViasVertical += 1
        verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    verticalShift = gridRound(verticalSpacing / 2)

    for hVia in range(numberOfViasHorizontal):
        for vVia in range(numberOfViasVertical):
            x = horizontalShift + (hVia * (viaInternalSpacing + viaSize)) - 1938.39
            y = verticalShift + (vVia * (viaInternalSpacing + viaSize)) - 1257.5
            via = gdspy.Rectangle((x, y), (x + viaSize, y + viaSize), layer=33)
            guardRing.add(via)
    
    horizontalDistance = 15
    verticalDistance = 2476.78
    viaHorizontalEdgeSpacing = 0.07
    viaVerticalEdgeSpacing = 0

    numberOfViasHorizontal = floor((horizontalDistance - 2*viaHorizontalEdgeSpacing) / (viaInternalSpacing + viaSize))
    horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if horizontalSpacing - (viaInternalSpacing + viaSize) > viaHorizontalEdgeSpacing*2:
        numberOfViasHorizontal += 1
        horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    horizontalShift = gridRound(horizontalSpacing / 2)

    numberOfViasVertical = floor((verticalDistance - 2*viaVerticalEdgeSpacing) / (viaInternalSpacing + viaSize))
    verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if verticalSpacing - (viaInternalSpacing + viaSize) > viaVerticalEdgeSpacing*2:
        numberOfViasVertical += 1
        verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    verticalShift = gridRound(verticalSpacing / 2)

    for hVia in range(numberOfViasHorizontal):
        for vVia in range(numberOfViasVertical):
            x = horizontalShift + (hVia * (viaInternalSpacing + viaSize)) - 1957.5
            y = verticalShift + (vVia * (viaInternalSpacing + viaSize)) - 1238.39
            via = gdspy.Rectangle((x, y), (x + viaSize, y + viaSize), layer=33)
            guardRing.add(via)

    numberOfViasHorizontal = floor((horizontalDistance - 2*viaHorizontalEdgeSpacing) / (viaInternalSpacing + viaSize))
    horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if horizontalSpacing - (viaInternalSpacing + viaSize) > viaHorizontalEdgeSpacing*2:
        numberOfViasHorizontal += 1
        horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    horizontalShift = gridRound(horizontalSpacing / 2)

    numberOfViasVertical = floor((verticalDistance - 2*viaVerticalEdgeSpacing) / (viaInternalSpacing + viaSize))
    verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if verticalSpacing - (viaInternalSpacing + viaSize) > viaVerticalEdgeSpacing*2:
        numberOfViasVertical += 1
        verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    verticalShift = gridRound(verticalSpacing / 2)

    for hVia in range(numberOfViasHorizontal):
        for vVia in range(numberOfViasVertical):
            x = horizontalShift + (hVia * (viaInternalSpacing + viaSize)) + 1942.5
            y = verticalShift + (vVia * (viaInternalSpacing + viaSize)) - 1238.39
            via = gdspy.Rectangle((x, y), (x + viaSize, y + viaSize), layer=33)
            guardRing.add(via)

    viaInternalSpacing = 0.36
    viaSize = 0.26
    horizontalDistance = 3876.78
    verticalDistance = 15
    viaHorizontalEdgeSpacing = 0
    viaVerticalEdgeSpacing = 0.01

    numberOfViasHorizontal = floor((horizontalDistance - 2*viaHorizontalEdgeSpacing) / (viaInternalSpacing + viaSize))
    horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if horizontalSpacing - (viaInternalSpacing + viaSize) > viaHorizontalEdgeSpacing*2:
        numberOfViasHorizontal += 1
        horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    horizontalShift = gridRound(horizontalSpacing / 2)

    numberOfViasVertical = floor((verticalDistance - 2*viaVerticalEdgeSpacing) / (viaInternalSpacing + viaSize))
    verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if verticalSpacing - (viaInternalSpacing + viaSize) > viaVerticalEdgeSpacing*2:
        numberOfViasVertical += 1
        verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    verticalShift = gridRound(verticalSpacing / 2)

    for layer in ringViaLayers:
        for hVia in range(numberOfViasHorizontal):
            for vVia in range(numberOfViasVertical):
                x = horizontalShift + (hVia * (viaInternalSpacing + viaSize)) - 1938.39
                y = verticalShift + (vVia * (viaInternalSpacing + viaSize)) + 1242.5
                via = gdspy.Rectangle((x, y), (x + viaSize, y + viaSize), layer=layer)
                guardRing.add(via)

    numberOfViasHorizontal = floor((horizontalDistance - 2*viaHorizontalEdgeSpacing) / (viaInternalSpacing + viaSize))
    horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if horizontalSpacing - (viaInternalSpacing + viaSize) > viaHorizontalEdgeSpacing*2:
        numberOfViasHorizontal += 1
        horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    horizontalShift = gridRound(horizontalSpacing / 2)

    numberOfViasVertical = floor((verticalDistance - 2*viaVerticalEdgeSpacing) / (viaInternalSpacing + viaSize))
    verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if verticalSpacing - (viaInternalSpacing + viaSize) > viaVerticalEdgeSpacing*2:
        numberOfViasVertical += 1
        verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    verticalShift = gridRound(verticalSpacing / 2)

    for layer in ringViaLayers:
        for hVia in range(numberOfViasHorizontal):
            for vVia in range(numberOfViasVertical):
                x = horizontalShift + (hVia * (viaInternalSpacing + viaSize)) - 1938.39
                y = verticalShift + (vVia * (viaInternalSpacing + viaSize)) - 1257.5
                via = gdspy.Rectangle((x, y), (x + viaSize, y + viaSize), layer=layer)
                guardRing.add(via)

    horizontalDistance = 15
    verticalDistance = 2476.78
    viaHorizontalEdgeSpacing = 0.01
    viaVerticalEdgeSpacing = 0

    numberOfViasHorizontal = floor((horizontalDistance - 2*viaHorizontalEdgeSpacing) / (viaInternalSpacing + viaSize))
    horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if horizontalSpacing - (viaInternalSpacing + viaSize) > viaHorizontalEdgeSpacing*2:
        numberOfViasHorizontal += 1
        horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    horizontalShift = gridRound(horizontalSpacing / 2)

    numberOfViasVertical = floor((verticalDistance - 2*viaVerticalEdgeSpacing) / (viaInternalSpacing + viaSize))
    verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if verticalSpacing - (viaInternalSpacing + viaSize) > viaVerticalEdgeSpacing*2:
        numberOfViasVertical += 1
        verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    verticalShift = gridRound(verticalSpacing / 2)

    for layer in ringViaLayers:
        for hVia in range(numberOfViasHorizontal):
            for vVia in range(numberOfViasVertical):
                x = horizontalShift + (hVia * (viaInternalSpacing + viaSize)) - 1957.5
                y = verticalShift + (vVia * (viaInternalSpacing + viaSize)) - 1238.39
                via = gdspy.Rectangle((x, y), (x + viaSize, y + viaSize), layer=layer)
                guardRing.add(via)

    numberOfViasHorizontal = floor((horizontalDistance - 2*viaHorizontalEdgeSpacing) / (viaInternalSpacing + viaSize))
    horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if horizontalSpacing - (viaInternalSpacing + viaSize) > viaHorizontalEdgeSpacing*2:
        numberOfViasHorizontal += 1
        horizontalSpacing = horizontalDistance - (numberOfViasHorizontal * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    horizontalShift = gridRound(horizontalSpacing / 2)

    numberOfViasVertical = floor((verticalDistance - 2*viaVerticalEdgeSpacing) / (viaInternalSpacing + viaSize))
    verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    if verticalSpacing - (viaInternalSpacing + viaSize) > viaVerticalEdgeSpacing*2:
        numberOfViasVertical += 1
        verticalSpacing = verticalDistance - (numberOfViasVertical * (viaInternalSpacing + viaSize)) + viaInternalSpacing
    verticalShift = gridRound(verticalSpacing / 2)

    for layer in ringViaLayers:
        for hVia in range(numberOfViasHorizontal):
            for vVia in range(numberOfViasVertical):
                x = horizontalShift + (hVia * (viaInternalSpacing + viaSize)) + 1942.5
                y = verticalShift + (vVia * (viaInternalSpacing + viaSize)) - 1238.39
                via = gdspy.Rectangle((x, y), (x + viaSize, y + viaSize), layer=layer)
                guardRing.add(via)

    example = gdspy.GdsLibrary()
    example.add(guardRing)
    example.write_gds("top/guard-ring.gds")

if __name__ == "__main__":
    main()