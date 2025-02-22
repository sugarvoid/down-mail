demon = {}
demon.__index = demon

local next_demon = 70
local y_range = { 10, 90 }
local off_screen_y = 138
local demons = {}

local thing_on_left = false
local thing_on_right = false

local throw_times = {30*3,30*2,30*1}

function demon:new(side)
    local _demon = setmetatable({}, demon)
    _demon.animations = {
        idle = {f={}, loop=true, done=false},
        climb = {f={}, loop=true, done=false},
        throw = {f={}, loop=true, done=false},
        grow_head = {f={}, loop=true, done=false},
    }
    _demon.img=14
    _demon.agro=1
    _demon.next_y = 50
    _demon.tmr_move = randsec_rang(6, 7)
    _demon.tmr_throw = throw_times[_demon.agro]
    _demon.timer = 150
    _demon.time_on_screen = 0
    _demon.in_play = false
    _demon.w = 8
    _demon.h = 24
    _demon.y = off_screen_y
   -- _demon.curr_animation = _demon.animations["idle"]
    _demon.skull_x=0

    _demon.facing_r = false

    if side == "right" then
        _demon.x = 117
        _demon.facing_r = true
        _demon.skull_x=117
    elseif side == "left" then
        _demon.x = 3
        _demon.facing_r = false
        _demon.skull_x=11
    end

    return _demon
end

function demon:draw()
     sspr(0, 64, 8, 24, self.x, self.y, 8, 24, self.facing_r)
end

function demon:update()
    if self.in_play then
        self.time_on_screen+=1
        self.tmr_move -= 1 -- math.clamp(0, self.tmr_move - 1, 90)
        self.tmr_throw -= 1 --math.clamp(0, self.tmr_throw - 1, 90)

        if self.tmr_move <= 0 then
            self:move( randi_rang(y_range[1], y_range[2]))
        end

        if self.time_on_screen == 30*5 then
            self.time_on_screen = 0
            self.agro = mid(1, self.agro + 1, #throw_times)
            self.tmr_throw=throw_times[self.agro]
        end

        if self.tmr_throw == 0 then
            self:throw_skull()
        end

        for l in all(letters) do
            if is_colliding_pro(l, self) then
                sfx(10)
                del(letters, l)
                self:die()
            end
        end
    end
end

function demon:reset()

end

function demon:move(new_y)
    --self.curr_animation = self.animations["climb"]
    self.y = new_y
    if self.y == new_y then
        --self.curr_animation = self.animations["idle"]
        self.tmr_move = randsec_rang(4, 8)
    end
end

function demon:crawl_on_screen()
    self.in_play = true
   -- self.curr_animation = self.animations["climb"]
    local _y = rnd({y_range[1], y_range[2]})
    self.y = _y
end

function demon:die()
    del(demons, self)
    self.in_play = false
    --self.curr_animation = self.animations["climb"]
    thing_on_left = false
    thing_on_right = false
    self.tmr_move = -1
    self.tmr_throw = -1
end

function demon:throw_skull()
    --self.curr_animation = self.animations["throw"]
    self.tmr_throw = throw_times[self.agro]
    spawn_skull(self.skull_x, self.y, p1, self.facing_r)
end

function update_demon_spawner()
    next_demon = next_demon - 1
    if next_demon <= 0 then
        spawn_rock()
    end
end

function spawn_demon()
    if not thing_on_left and not thing_on_right then
        local _side
        if flr(rnd(2)) + 1 == 1 then
            _side = "left"
            thing_on_left = true
        else
            _side = "right"
            thing_on_right = true
        end

        local _demon = demon:new(_side)
        add(demons, _demon)
        _demon:crawl_on_screen()
    else
        print_debug("there was already a thing on screen")
    end
end


function update_demons()
    for d in all(demons) do
        d:update()
    end
end

function draw_demons()
    for d in all(demons) do
        d:draw()
    end
end
