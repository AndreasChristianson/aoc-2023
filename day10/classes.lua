
function lines_from(file)
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end


--function Account:new (o)
--    o = o or {}   -- create object if user does not provide one
--    setmetatable(o, self)
--    self.__index = self
--    return o
--end

