import std/strutils
import sequtils

type Point = object
  row: int
  col: int

type Galaxy = object
  location: Point


proc distance(self: Point, other: Point):int =
  return abs(self.col-other.col)+abs(self.row-other.row)
proc distance(self: Galaxy, other: Galaxy):int =
  return self.location.distance(other.location)

var
  galaxies: seq[Galaxy]
  allLines:seq[string]

for line in lines "example.txt":
  allLines.add(line)
for row, line in allLines:
  for col, char in toSeq(line.items):
    if char=='#':
      galaxies.add(Galaxy(location: Point(col:col,row:row)))


# stolen from https://forum.nim-lang.org/t/2812
proc comb[T](a: openarray[T]; n: int; use: seq[bool]): seq[seq[T]] =
  result = newSeq[seq[T]]()
  var use = use
  if n <= 0: return
  for i in 0  .. a.high:
    if not use[i]:
      if n == 1:
        result.add(@[a[i]])
      else:
        use[i] = true
        for j in comb(a, n - 1, use):
          result.add(a[i] & j)

proc combinations[T](a: openarray[T], n: int): seq[seq[T]] =
  var use = newSeq[bool](a.len)
  comb(a, n, use)

echo combinations(galaxies,2)

