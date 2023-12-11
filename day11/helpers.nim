proc expand(amount: int, oldGalaxies: seq[Galaxy], height: int, width: int): seq[Galaxy] =
  var
    newGalaxies: seq[Galaxy]
    rowsToExpand: seq[int]
    colsToExpand: seq[int]
  let
    down = Point(row: amount, col: 0)
    right = Point(row: 0, col: amount)

  for row in 0 ..< height:
    if oldGalaxies.allIt(it.location.row != row):
      # echo "expanding row: ", row
      rowsToExpand.add(row)
  for col in 0 ..< width:
    if oldGalaxies.allIt(it.location.col != col):
      # echo "expanding col: ", col
      colsToExpand.add(col)

  for oldGalaxy in oldGalaxies:
    var newGalaxy = oldGalaxy
    for row in rowsToExpand:
      if oldGalaxy.location.row > row:
        newGalaxy = newGalaxy.shift(down)
    for col in colsToExpand:
      if oldGalaxy.location.col > col:
        newGalaxy = newGalaxy.shift(right)
    newGalaxies.add(newGalaxy)

  return newGalaxies
