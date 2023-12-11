
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
