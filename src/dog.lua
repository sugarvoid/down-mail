dog = {}
dog.__index = dog
dogs = {}

local throw_times = {30*1,30*2,30*1}

function spawn_dog()
    local d = setmetatable({}, dog)
    d.x = rnd({113, 7})
    d.curr_y = -10
    d.y = d.curr_y
    d.hitbox = hitbox.new(d, 8, 14)
    d.facing_l = d.x < 128 / 2
    d.col = rnd({4,7})
    d.img = 61
    d.agro=1
    d.anmi_t = 0
    d.tmr_move = randsec_rang(6, 7)
    d.time_on_screen = 0
    d.tmr_throw = throw_times[d.agro]
    d.damaged = false
    d.dst_y = randi_rang(20, 80)
    d.start_y = -10
    d.is_moving = false
    d.in_play = false
    d.bob = 0.2
    d.y_high = 0
    d.y_low = 0
    d.firerate = 2
    d.bone_clock = clock.new()
    d.bone_clock:start()
    
    if not d.facing_l then
        d.shield_x = -8
        d.shield_y_mid = -2
        d.bone_x=114
    else
       d.shield_y_out = 6
        d.shield_y_mid = 2
        d.shield_x = 8
        d.bone_x=11
    end

    sfx(0, 3)
    add(dogs, d)
end

function dog:update()

    self.anmi_t+=1

    if self.y <= self.dst_y and not self.in_play then
        self.y += 2
    else
        sfx(-2, 3)
        self.in_play = true
        self.y_high =  self.dst_y - 2
        self.y_low = self.dst_y + 2
    end

    if self.in_play then
        self.bone_clock:update()
        self.time_on_screen+=1
        self.tmr_move -= 1
        self.tmr_throw -= 1

        if self.tmr_move <= 0 and self.agro < 3 then
            --self:move( randi_rang(y_range[1], y_range[2]))
        end

        self.y += self.bob

        if self.y <= self.y_low then 
            self.bob *=-1 
        end
        if self.y >= self.y_high then
            self.bob *=-1
        end

        if self.time_on_screen == 30*4 then
            self.time_on_screen = 0
            self.agro = mid(1, self.agro + 1, #throw_times)
            self.tmr_throw=throw_times[self.agro]
        end

        if self.bone_clock.seconds == self.firerate then
            self.bone_clock:restart()
            self:throw_bone()
        end

        for l in all(letters) do
            if is_colliding(l.hitbox, self.hitbox) then
                sfx(10)
                del(letters, l)
                self:exit()
            end
        end
    end
    self.hitbox:update()
end

function dog:move(new_y)
    self.y = new_y
    self.curr_y = new_y
    if self.y == new_y then
        self.tmr_move = randsec_rang(4, 8)
    end
end

function dog:throw_bone()
    sfx(1)
    self.tmr_throw = throw_times[self.agro]
    spawn_bone(self.bone_x, self.y+4, p1)
end

function dog:exit()
    del(dogs, self)
end

function dog:draw()
    pal(14, self.col)
    spr(self.img, self.x, self.y, 1, 1, self.facing_l)
    pal()
    spr(3+self.anmi_t%15\7.5, self.x, self.y + 7, 1, 1, self.facing_l)
    if not self.in_play then
        self:draw_shield()
    end
end

function dog:draw_shield()
    spr(31, self.x + self.shield_x, self.y - 5, 1, 1, self.facing_l)
    spr(47, self.x + self.shield_x, self.y + 3  , 1, 1, self.facing_l)
    spr(31, self.x + self.shield_x, self.y + 11, 1, 1, self.facing_l, true)
end


