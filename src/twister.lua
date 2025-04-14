twister = {}
twister.__index = twister

twisters = {}

function spawn_twister(x, y)
    local _t = setmetatable({}, twister)
    _t.x = x
    _t.y = y
    --_t.position = nil
    --_t.next_position = nil
    _t.life_timer = 120
    _t.move_timer = 60
    --_t.target = p1
    _t.anim = { 51, 52, 53 }
    _t.tick = 0
    _t.frame = 1
    _t.step = 3
    _t.img = 19
    _t.img = 51
    _t.dis = 0
    _t.angle = 0
    _t.speed = 0.05
    _t.prox = 0.2
    _t.hitbox = hitbox.new(_t, 15, 15)
    _t:move()
    add(twisters, _t)
end

function twister:set_target(obj)
    self.target = obj
end

function twister:update()

    self.x += (self.next_x - self.x) * self.speed
    self.y += (self.next_y - self.y) * self.speed

    self.tick = (self.tick + 1) % self.step
    if (self.tick == 0) then
        self.frame = self.frame % #self.anim + 1
    end
    self.life_timer -= 1
    if self.life_timer <= 0 then
        del(twisters, self)
        self.img = 38
        --self.target = nil --{ x = randi_rang(10,100), y = 125, type = "exit" }
        self.speed = 3
       -- self.prox = 0.8
    end
    self.move_timer -= 1
    if self.move_timer <= 0 then
        self.move_timer = 60
        self:move()
    end

    --if self.target then
    --    local _newangle = atan2(self.target.x - self.x, self.target.y - self.y)

        -- if _newangle <= 0.3 then
        --     local _t = self.target.type
        --     if _t == "exit" then
        --         del(twisters, self)
        --     elseif _t == "player" then
        --         -- p1.move_speed = 0.5
        --     end
        -- end

      --  self.angle = angle_lerp(self.angle, _newangle, self.prox)
      --  self.x += self.speed * cos(self.angle)
     --   self.y += self.speed * sin(self.angle)

     --   self.dis = dist(self.target, self)
   -- end

    
    --print_debug(self.dis)
    --self.hitbox:update()
    self.hitbox.x = self.x - 4
    self.hitbox.y = self.y - 4
end

function twister:draw()

    
    spr(self.anim[self.frame], self.x, self.y, 1, 1)

    draw_hb(self.hitbox)
end

function twister:move()
    self.next_x = randi_rang(20,100)
    self.next_y = randi_rang(20,90)
end