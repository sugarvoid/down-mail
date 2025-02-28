dog = {}
dog.__index = dog
dogs = {}

local throw_times = {30*3,30*2,30*1}
local y_range = { 10, 90 }

function spawn_dog()
    local d = setmetatable({}, dog)
    d.x = rnd({113,7})
    d.y = 50
    d.w = 8
    d.h = 14
    d.facing_l = d.x < 128 / 2
    d.col = rnd({4,7})
    d.img = 19
    d.agro=1
    d.tmr_move = randsec_rang(6, 7)
    d.timer = 150
    d.time_on_screen = 0
    d.empty = true
    d.tmr_throw = throw_times[d.agro]
    d.damaged = false
    d.dir = 0
    d.dx = 1.3
    d.curr_y = 50
    d.is_moving = false
    d.in_play = true
    d.amplitude = 10
    d.frequency = 0.2
    


    if not d.facing_l then
        --d.x = 113
        --d.facing_r = true
        d.bone_x=114
    else
        --d.x = 5
       -- d.facing_r = false
        d.bone_x=11
    end


    add(dogs, d)
end

function dog:update()
    if self.in_play then
        self.time_on_screen+=1
        self.tmr_move -= 1 -- math.clamp(0, self.tmr_move - 1, 90)
        self.tmr_throw -= 1 --math.clamp(0, self.tmr_throw - 1, 90)

        if self.tmr_move <= 0 and self.agro < 3 then
            self:move( randi_rang(y_range[1], y_range[2]))
        end

        self.y += self.frequency

        if self.y <= self.curr_y - 2 then 
            self.frequency *=-1 
            
        elseif self.y >= self.curr_y + 2 then
            self.frequency *=-1
        end

        --self.y = self.curr_y + sin(self.frequency * self.curr_y) * self.amplitude

        if self.time_on_screen == 30*5 then
            self.time_on_screen = 0
            self.agro = mid(1, self.agro + 1, #throw_times)
            self.tmr_throw=throw_times[self.agro]
        end

        if self.tmr_throw == 0 then
            self:throw_bone()
        end

        for l in all(letters) do
            if is_colliding_pro(l, self) then
                sfx(10)
                del(letters, l)
                self:exit()
            end
        end
    end
end

function dog:take_damage()
    
end

function dog:enter()
    
end

function dog:move(new_y)
    --self.curr_animation = self.animations["climb"]
    self.y = new_y
    self.curr_y = new_y
    if self.y == new_y then
        --self.curr_animation = self.animations["idle"]
        self.tmr_move = randsec_rang(4, 8)
    end
end

function dog:throw_bone()
    --self.curr_animation = self.animations["throw"]
    sfx(1)
    self.tmr_throw = throw_times[self.agro]
    spawn_bone(self.bone_x, self.y+4, p1, self.facing_r)
end

function dog:exit()
    del(dogs, self)
end

function dog:draw()
    pal(14, self.col)
    spr(self.img, self.x, self.y, 1, 1, self.facing_l)
    pal()
    spr(3, self.x, self.y + 7, 1, 1, self.facing_l)
end


