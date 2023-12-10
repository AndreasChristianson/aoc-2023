require "helpers"
require "classes"
local inspect = require('inspect')


lines = lines_from("input.txt")
pipes = {}

for row, line in ipairs(lines) do
    pipes[row] = {}
    for c in line:gmatch "." do
        local pipe = Pipe:create(c)
        table.insert(pipes[row], pipe)
    end
end
width = #pipes[1]
height = #pipes
print("width: " .. width .. ". Height: " .. height)

function getAt(row, col)
    if (row < 1 or col < 1) then
        return nil
    end
    if (row > height or col > width) then
        return nil
    end
    return pipes[row][col]
end

for i, pipeRow in ipairs(pipes) do
    for j, pipe in ipairs(pipeRow) do
        pipe.neighbors = {
            [Direction.N] = getAt(i - 1, j),
            [Direction.S] = getAt(i + 1, j),
            [Direction.E] = getAt(i, j + 1),
            [Direction.W] = getAt(i, j - 1)
        }
        if (pipe.start) then
            start = pipe
        end
    end
end

-- fill in start
foundDirections = {}
for direction, pipe in pairs(start.neighbors) do
    for i, dir in ipairs(pipe.connectedDirs) do
        if (dir == Direction:opposite(direction)) then
            table.insert(foundDirections, direction)
        end
    end

end

start.connectedDirs=getConnections(connectionsToChar(foundDirections))
start.internalNavigation=getNavigation(connectionsToChar(foundDirections))
start.distance=0

loopPipes = traversePipes(start)
for i, pipe in ipairs(loopPipes) do
    pipe.inLoop=true
end

labelOutside(getAt(1,1), Direction.NW)
inside = 0
for i, pipeRow in ipairs(pipes) do
    for j, pipe in ipairs(pipeRow) do
        if((not pipe.inLoop) and (not pipe.outside)) then
            inside=inside+1
        end
    end
end
print("inside: "..inside)
