twister = {}
twister.__index = twister

twisters = {}

function spawn_twister(x, y)
    local t = setmetatable({}, twister)
    t.x = x
    t.y = y
    t.life_timer = 120
    t.move_timer = 60
    t.anim = { 51, 52, 53 }
    t.tick = 0
    t.frame = 1
    t.step = 3
    t.img = 51
    t.speed = 0.04
    t.hitbox = hitbox.new(t, 15, 15)
    t:move()
    add(twisters, t)
end

function twister:set_target(obj)
    self.target = obj
end

function twister:update()

    self.move_timer -= 1
    self.life_timer -= 1

    self.x += (self.next_x - self.x) * self.speed
    self.y += (self.next_y - self.y) * self.speed

    self.tick = (self.tick + 1) % self.step
    if (self.tick == 0) then
        self.frame = self.frame % #self.anim + 1
    end

    
    if self.life_timer <= 0 then
        del(twisters, self)
    end


    if self.move_timer <= 0 then
        self.move_timer = 60
        self:move()
    end

    self.hitbox.x = self.x - 4
    self.hitbox.y = self.y - 4
end

function twister:draw()
    spr(self.anim[self.frame], self.x, self.y, 1, 1)
end

function twister:move()
    self.next_x = randi_rang(20,100)
    self.next_y = randi_rang(20,90)
end