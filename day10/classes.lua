local inspect = require('inspect')

Direction = {
    N = "N",
    S = "S",
    E = "E",
    W = "W",
    NE = "NE",
    SE = "SE",
    NW = "NW",
    SW = "SW",
}
function Direction:opposite(direction)
    local directionMap = {
        [Direction.S] = Direction.N,
        [Direction.N] = Direction.S,
        [Direction.E] = Direction.W,
        [Direction.W] = Direction.E,
    }
    return directionMap[direction]
end

Pipe = {}
Pipe.__index = Pipe
Pipe.inf = 999999

function getConnections(c)
    local directionMap = {
        ["-"] = { Direction.E, Direction.W },
        ["|"] = { Direction.N, Direction.S },
        ["L"] = { Direction.E, Direction.N },
        ["7"] = { Direction.W, Direction.S },
        ["J"] = { Direction.W, Direction.N },
        ["F"] = { Direction.E, Direction.S },
        ["S"] = { }
    }
    return directionMap[c] or {}
end

function getNavigation(c)
    local directionMap = {
        ["-"] = {
            [Direction.NW] = { Direction.NE },
            [Direction.SE] = { Direction.SW },
            [Direction.NE] = { Direction.NW },
            [Direction.SW] = { Direction.SE }
        },
        ["|"] = {
            [Direction.NW] = { Direction.SW },
            [Direction.SE] = { Direction.NE },
            [Direction.SW] = { Direction.NW },
            [Direction.NE] = { Direction.SE }
        },
        ["L"] = {
            [Direction.NW] = { Direction.SW, Direction.SE },
            [Direction.SW] = { Direction.NW, Direction.SE },
            [Direction.SE] = { Direction.SW, Direction.NW },
            [Direction.NE] = {}
        },
        ["7"] = {
            [Direction.NW] = { Direction.NE, Direction.SE },
            [Direction.NE] = { Direction.NW, Direction.SE },
            [Direction.SE] = { Direction.NE, Direction.NW },
            [Direction.SW] = {}
        },
        ["J"] = {
            [Direction.NE] = { Direction.SW, Direction.SE },
            [Direction.SW] = { Direction.NE, Direction.SE },
            [Direction.SE] = { Direction.SW, Direction.NE },
            [Direction.NW] = {}
        },
        ["F"] = {
            [Direction.NW] = { Direction.SW, Direction.NE },
            [Direction.SW] = { Direction.NW, Direction.NE },
            [Direction.NE] = { Direction.SW, Direction.NW },
            [Direction.SE] = {}
        }
    }
    return directionMap[c]
end

function Pipe:create(c)
    local pipe = {}
    setmetatable(pipe, Pipe)
    pipe.char = c
    pipe.connectedDirs = getConnections(c)
    pipe.distance = Pipe.inf
    pipe.start = c == "S"
    pipe.neighbors = {}
    pipe.inLoop = false
    pipe.seen = {}
    pipe.outside = false
    pipe.internalNavigation = getNavigation(c)
    return pipe
end

function Pipe:connect(from)
    return connectedDirs[from]
end

function Pipe:toString()
    return "Pipe [" .. self.char .. "]: inLoop: " .. tostring(self.inLoop) .. " links: " .. inspect(self.connectedDirs, { newline = '' })
end
function Pipe:extrapolateChar()

end