
clock = {}
clock.__index = clock

function clock.new()
    local c = setmetatable({}, clock)
    c.seconds = 0
    c.t = 0
    c.is_running = false
    return c
end


function clock:tick()
    self.seconds += 1
    self.t = 0
end

function clock:update()
    if self.is_running then
        self.t += 1
        if self.t >= 30 then
            self:tick()
        end
    end
end

function clock:stop()
    self.is_running = false
end

function clock:start()
    self.is_running = true
end

function clock:restart()
    self.t = 0
    self.seconds = 0
end
