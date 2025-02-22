twister = {}
twister.__index = twister

twisters = {}

function spawn_twister(x, y)
    local _t = setmetatable({}, twister)
    _t.x = x
    _t.y = y
    _t.timer = 120
    _t.target = p1
    _t.facing_l = nil
    _t.anim = { 51, 52, 53 }
    _t.tick = 0
    _t.frame = 1
    _t.step = 3
    _t.img = 19
    _t.img = 51
    _t.angle = 0
    _t.speed = 1.5
    _t.prox = 0.2
    add(twisters, _t)
end

function twister:set_target(obj)
    self.target = obj
end

function twister:update()
    self.tick = (self.tick + 1) % self.step
    if (self.tick == 0) then
        self.frame = self.frame % #self.anim + 1
    end
    self.timer -= 1
    if self.timer == 0 then
        self.target = { x = randi_rang(10,100), y = 125, type = "exit" }
        self.speed = 3
        self.prox = 0.8
        p1.move_speed = 1.5
    end
    
    local _newangle = atan2(self.target.x - self.x, self.target.y - self.y)

    if _newangle <= 0.3 then
        local _t = self.target.type
        if _t == "exit" then
            del(twisters, self)
        elseif _t == "player" then
            p1.move_speed = 0.5
        end
    end

    self.angle = angle_lerp(self.angle, _newangle, self.prox)
    self.x += self.speed * cos(self.angle)
    self.y += self.speed * sin(self.angle)
end

function twister:draw()
    spr(self.anim[self.frame], self.x, self.y, 1, 1, self.facing_l)
end
