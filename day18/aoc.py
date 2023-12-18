import sys
import re
from enum import Enum

import shapely
from shapely.geometry import Polygon
from shapely.ops import transform

print(sys.argv)


# 0 means R, 1 means D, 2 means L, and 3 means U.
class Direction(Enum):
    U = 3
    D = 1
    L = 2
    R = 0


class Instruction:
    def __init__(self, line: str):
        matches = re.search("([RLUD]) (\\d+) \\(#(.{6})\\)", line)
        self.dir = Direction[matches[1]]
        self.length = int(matches[2])
        self.color = matches[3]

    def __str__(self):
        return f'Instruction: {self.dir} {self.length}: {self.color}'

    def maximize(self):
        self.dir = Direction(int(self.color[-1]))
        self.length = int(self.color[:-1], 16)


def readfile():
    with open(sys.argv[1]) as file:
        lines = [line.rstrip() for line in file]
        return list(map(Instruction, lines))


class Lagoon:
    def __init__(self, instructions: list[Instruction]):
        self.instructions = instructions
        self.grid: dict[tuple[int, int], int] = {}  # coord -> depth
        self.min_col = 0
        self.max_col = 0
        self.min_row = 0
        self.max_row = 0
        self.points:list[(int,int)]= []

    def dig_inside(self):
        start = ((self.max_row - self.min_row) // 2 + self.min_row, (self.max_col - self.min_col) // 2 + self.min_col)
        assert self.grid.get(start, 0) == 0
        search: list[(int, int)] = [start]
        while len(search) > 0:
            location = search.pop()
            if self.grid.get(location, 0) == 0:
                self.grid[location] = 1
                row, col = location
                search.insert(0, (row + 1, col))
                search.insert(0, (row - 1, col))
                search.insert(0, (row, col - 1))
                search.insert(0, (row, col + 1))

    def dig_outline(self):
        current = (0, 0)

        self.grid[(0, 0)] = 1
        for i in self.instructions:
            row, col = current
            self.max_col = max(self.max_col, col)
            self.min_col = min(self.min_col, col)
            self.max_row = max(self.max_row, row)
            self.min_row = min(self.min_row, row)
            match i.dir:
                case Direction.D:
                    for delta_row in range(1, i.length + 1):
                        self.grid[(row + delta_row, col)] = 1
                    current = (row + i.length, col)
                case Direction.U:
                    for delta_row in range(1, i.length + 1):
                        self.grid[(row - delta_row, col)] = 1
                    current = (row - i.length, col)
                case Direction.R:
                    for delta_col in range(1, i.length + 1):
                        self.grid[(row, col + delta_col)] = 1
                    current = (row, col + i.length)
                case Direction.L:
                    for delta_col in range(1, i.length + 1):
                        self.grid[(row, col - delta_col)] = 1
                    current = (row, col - i.length)

    def __str__(self):
        ret = ""
        for row in range(self.min_row, self.max_row + 1):
            for col in range(self.min_col, self.max_col + 1):
                ret += f'{str(self.grid.get((row, col), 0)) :3}'
            ret += '\n'
        return f'Lagoon: \n{ret}'

    def volume(self):
        ret = 0
        for row in range(self.min_row, self.max_row + 1):
            for col in range(self.min_col, self.max_col + 1):
                ret += self.grid.get((row, col), 0)
        return ret

    def plan_outline(self):
        current = (0, 0)

        for i in self.instructions:
            self.points.append(current)
            row, col = current
            match i.dir:
                case Direction.D:
                    current = (row + i.length, col)
                case Direction.U:
                    current = (row - i.length, col)
                case Direction.R:
                    current = (row, col + i.length)
                case Direction.L:
                    current = (row, col - i.length)

def Area(points): # shoelace
    n = len(points)
    area = 0.0
    for i in range(n):
        j = (i + 1) % n
        area += points[i][0] * points[j][1]
        area -= points[j][0] * points[i][1]
    area = abs(area) / 2.0
    return area

lagoon_instructions = readfile()
for instruction in lagoon_instructions:
    print(instruction)
lagoon = Lagoon(lagoon_instructions)
lagoon.dig_outline()
# print(lagoon)
print(lagoon.volume())
lagoon.dig_inside()
# print(lagoon)
print(lagoon.volume())

for instruction in lagoon_instructions:
    instruction.maximize()
    print(instruction)
big_lagoon=Lagoon(lagoon_instructions)
big_lagoon.plan_outline()
big_poly=Polygon(big_lagoon.points).buffer(.5,cap_style="flat",join_style="mitre")
print(big_poly.area)
