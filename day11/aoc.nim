import std/strutils
import std/algorithm
import sequtils
include combinatorics
include types
include helpers

var
  galaxies: seq[Galaxy]
  allLines: seq[string]

for line in lines "input.txt":
  allLines.add(line)

var
  height = allLines.len
  width: int

for row, line in allLines:
  width = toSeq(line.items).len
  for col, char in toSeq(line.items):
    if char == '#':
      galaxies.add(Galaxy(location: Point(col: col, row: row)))

proc addDistances(galaxiesToAdd: seq[Galaxy]): int =
  var sum = 0
  for seq in combinations(galaxiesToAdd, 2):
    sum += seq[0].distance(seq[1])
  return sum

echo "      +1: ", addDistances(expand(1, galaxies, height, width))
echo "+1000000: ", addDistances(expand(999999, galaxies, height, width))
