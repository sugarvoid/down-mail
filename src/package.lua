package = {}
package.__index = package

function package:new()
    local _r = setmetatable({}, package)
    _r.x = 0
    _r.y = 130
    _r.anim = { 55, 56, 57, 58 }
    _r.tick = 0
    _r.frame = 1
    _r.step = 5
    _r.img = 41
    _r.speed = 1
    _r.amplitude = 10
    _r.frequency = 0.02
    return _r
end

function package:update()
    self.tick = (self.tick + 1) % self.step
    if (self.tick == 0) then
        self.frame = self.frame % #self.anim + 1
    end

    self.x = 64 + sin(self.frequency * self.y) * self.amplitude

    self.y -= self.speed
    if self.y <= -4 then
        del(objects.front, self)
    end
    if is_colliding(p1, self) then
        del(objects.front, self)
        p1:update_letters(p1.max_letter)
    end
end

function package:draw()
    spr(self.anim[self.frame], self.x, self.y)
end

function spawn_package()
    if p1.letters < p1.max_letter / 2 then
        new_package = package:new()
        new_package.x = randi_rang(20, 100)  --rnd(avil_yx)
        add(objects.front, new_package)
    end

    reset_package_timer()
end

function reset_package_timer()
    next_package = randsec_rang(2, 8) --70 + rnd(10)
end
