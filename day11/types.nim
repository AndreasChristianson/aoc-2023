import std/strutils
import std/algorithm
import sequtils
include combinatorics

type Point = object
  row: int
  col: int

proc distance(self: Point, other: Point):int =
  return abs(self.col-other.col)+abs(self.row-other.row)
proc add(self: Point, other: Point):Point =
  return Point(row:self.row+other.row, col:self.col+other.col)

type Galaxy = object
  location: Point

proc distance(self: Galaxy, other: Galaxy):int =
  return self.location.distance(other.location)
proc shift(self: Galaxy, delta: Point):Galaxy =
  Galaxy(location:self.location.add(delta))

var
  galaxies: seq[Galaxy]
  allLines:seq[string]
  height: int
  width: int

for line in lines "input.txt":
  allLines.add(line)

height=allLines.len

for row, line in allLines:
  width=toSeq(line.items).len
  for col, char in toSeq(line.items):
    if char=='#':
      galaxies.add(Galaxy(location: Point(col:col,row:row)))

proc expand(amount:int, oldGalaxies:seq[Galaxy]): seq[Galaxy]=
  var
    newGalaxies: seq[Galaxy]
    rowsToExpand:seq[int]
    colsToExpand:seq[int]
  let
    down=Point(row:amount, col:0)
    right=Point(row:0, col:amount)

  for row in 0 ..< height:
    if galaxies.allIt(it.location.row != row):
      # echo "expanding row: ", row
      rowsToExpand.add(row)
  for col in 0 ..< width:
    if galaxies.allIt(it.location.col != col):
      # echo "expanding col: ", col
      colsToExpand.add(col)

  for oldGalaxy in oldGalaxies:
    var newGalaxy=oldGalaxy
    for row in rowsToExpand:
      if oldGalaxy.location.row>row:
        newGalaxy = newGalaxy.shift(down)
    for col in colsToExpand:
      if oldGalaxy.location.col>col:
        newGalaxy = newGalaxy.shift(right)
    newGalaxies.add(newGalaxy)

  return newGalaxies

var sum=0
let expandedBy1 = expand(1, galaxies)
for seq in combinations(expandedBy1,2):
  sum += seq[0].distance(seq[1])
echo "+1: ", sum
let expandedBy1000000 = expand(999999, galaxies)
sum=0
for seq in combinations(expandedBy1000000,2):
  sum += seq[0].distance(seq[1])
echo "+1000000: ", sum
