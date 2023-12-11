import std/strutils
import std/algorithm
import sequtils
include combinatorics


type Point = object
  row: int
  col: int

type Galaxy = ref object
  location*: Point

iterator countDownFrom(n: int): int =
  var i = n
  while i >= 0:
    yield i
    dec i


proc distance(self: Point, other: Point):int =
  return abs(self.col-other.col)+abs(self.row-other.row)
proc add(self: Point, other: Point):Point =
  return Point(row:self.row+other.row, col:self.col+other.col)
proc distance(self: Galaxy, other: Galaxy):int =
  return self.location.distance(other.location)
proc shift(self: Galaxy, delta: Point) =
  self.location=self.location.add(delta)

var
  galaxies: seq[Galaxy]
  allLines:seq[string]
  height: int
  width: int

let
  down=Point(row:999999, col:0)
  right=Point(row:0, col:999999)

for line in lines "input.txt":
  allLines.add(line)
height=allLines.len

for row, line in allLines:
  width=toSeq(line.items).len
  for col, char in toSeq(line.items):
    if char=='#':
      galaxies.add(Galaxy(location: Point(col:col,row:row)))

for row in countDownFrom(height-1):
  if galaxies.allIt(it.location.row != row):
    echo "expanding row: ", row
    for galaxy in galaxies:
      if galaxy.location.row>row:
        galaxy.shift(down)
for col in countDownFrom(width-1):
  if galaxies.allIt(it.location.col != col):
    echo "expanding col: ", col
    for galaxy in galaxies:
      if galaxy.location.col>col:
        galaxy.shift(right)
var sum=0
for seq in combinations(galaxies,2):
  sum += seq[0].distance(seq[1])
echo sum

echo galaxies