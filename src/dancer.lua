dancer = {}
dancer.__index = dancer

function dancer:new()
    local _d = setmetatable({}, dancer)
    _d.x = 0
    _d.y = 130
    _d.anim = { 10, 11}
    _d.tick = 0
    _d.frame = 1
    _d.step = 5
    _d.img = 41
    _d.speed = 1
    _d.amplitude = 10
    _d.frequency = 0.02
    return _d
end

function dancer:update()
    self.tick = (self.tick + 1) % self.step
    if (self.tick == 0) then
        self.frame = self.frame % #self.anim + 1
    end

    self.x = 64 + sin(self.frequency * self.y) * self.amplitude

    self.y += self.speed
    if self.y >= 130 then
        del(objects.front, self)
    end
    if is_colliding(p1, self) then
        del(objects.front, self)
        player:take_damage()
    end
end

function dancer:draw()
    spr(self.anim[self.frame], self.x, self.y)
end

function spawn_dancer()
    if p1.letters < p1.max_letter / 2 then
        new_dancer = dancer:new()
        new_dancer.x = randi_rang(20, 100)
        add(objects.front, new_dancer)
    end

    reset_dancer_timer()
end

function reset_dancer_timer()
    next_dancer = randsec_rang(2, 8)
end
