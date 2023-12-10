print("Hello World")


--for i=1,N do
--    mt[i] = {}     -- create a new row
--    for j=1,M do
--        mt[i][j] = 0
--    end
--end

function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end


function Account:new (o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

lines = lines_from("example.txt")
print(lines)