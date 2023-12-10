local uuid = require("uuid")
function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function map(tbl, f)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function traversePipes(startingPipe)
    local touched = { startingPipe }
    local toDoList = { startingPipe }
    local distance = 0
    while #toDoList > 0 do
        --print("Distance: " .. distance .. " Todolist length: " .. #toDoList)
        local newTodoList = {}
        for _, pipe in ipairs(toDoList) do
            for _, to in ipairs(pipe.connectedDirs) do
                local potential = pipe.neighbors[to]
                if (potential and potential.distance > 1 + distance) then
                    --print("Found " .. potential:toString())
                    table.insert(newTodoList, potential)
                    table.insert(touched, potential)
                    potential.distance = distance + 1
                end
            end
        end
        distance = distance + 1
        toDoList = newTodoList
    end
    print("final distance: " .. distance - 1)
    return touched
end

local function otherCorners(direction)
    local directionMap = {
        [Direction.NE] = { Direction.SE, Direction.NW, Direction.SW },
        [Direction.SE] = { Direction.NE, Direction.NW, Direction.SW },
        [Direction.SW] = { Direction.SE, Direction.NW, Direction.NE },
        [Direction.NW] = { Direction.SE, Direction.NE, Direction.SW },
    }
    return directionMap[direction]
end
local function cornerComponents(direction)
    local directionMap = {
        [Direction.NE] = { { Direction.N, Direction.SE }, { Direction.E, Direction.NW } },
        [Direction.SE] = { { Direction.S, Direction.NE }, { Direction.E, Direction.SW } },
        [Direction.SW] = { { Direction.S, Direction.NW }, { Direction.W, Direction.SE } },
        [Direction.NW] = { { Direction.N, Direction.SW }, { Direction.W, Direction.NE } },
    }
    return directionMap[direction]
end

function labelOutside(startingPipe, startingCorner)
    local cornerCount = 0
    local toDoList = { { startingPipe, startingCorner } }
    while #toDoList > 0 do
        --print("Todolist length: " .. #toDoList)
        local newTodoList = {}
        for _, tuple in ipairs(toDoList) do
            local pipe = tuple[1]
            local corner = tuple[2]
            if (not (pipe.seen[corner])) then
                pipe.seen[corner] = true
                cornerCount = cornerCount + 1
                if (not pipe.inLoop) then
                    pipe.outside = true
                    for _, dir in ipairs(otherCorners(corner)) do
                        table.insert(newTodoList, { pipe, dir })
                    end
                else
                    for _, dir in ipairs(pipe.internalNavigation[corner]) do
                        table.insert(newTodoList, { pipe, dir })
                    end
                end
                for _, cardAndCorner in ipairs(cornerComponents(corner)) do
                    local card = cardAndCorner[1]
                    local newCorner = cardAndCorner[2]
                    local newPipe = pipe.neighbors[card]
                    if (newPipe) then

                        table.insert(newTodoList, { newPipe, newCorner })
                    end
                end
            end

        end
        toDoList = newTodoList
    end
    print("Saw " .. cornerCount .. " corners.")
end

function connectionsToChar(connections)
    if connections[1] == Direction.N and connections[2] == Direction.S then
        return "|"
    end
    if connections[2] == Direction.N and connections[1] == Direction.S then
        return "|"
    end

    if connections[1] == Direction.N and connections[2] == Direction.W then
        return "J"
    end
    if connections[2] == Direction.N and connections[1] == Direction.W then
        return "J"
    end

    if connections[1] == Direction.N and connections[2] == Direction.E then
        return "L"
    end
    if connections[2] == Direction.N and connections[1] == Direction.E then
        return "L"
    end

    if connections[1] == Direction.W and connections[2] == Direction.E then
        return "-"
    end
    if connections[2] == Direction.W and connections[1] == Direction.E then
        return "-"
    end

    if connections[1] == Direction.S and connections[2] == Direction.E then
        return "F"
    end
    if connections[2] == Direction.S and connections[1] == Direction.E then
        return "F"
    end

    if connections[1] == Direction.S and connections[2] == Direction.W then
        return "7"
    end
    if connections[2] == Direction.S and connections[1] == Direction.W then
        return "7"
    end
end