lizard = {}
lizard.__index = lizard

local next_lizard = 70
local y_range = { 10, 90 }
local off_screen_y = 138
local lizards = {}

local thing_on_left = false
local thing_on_right = false

local throw_times = {30*3,30*2,30*1}

function lizard:new(side)
    local _lizard = setmetatable({}, lizard)
    _lizard.animations = {
        idle = {f={}, loop=true, done=false},
        climb = {f={}, loop=true, done=false},
        throw = {f={}, loop=true, done=false},
    }
    _lizard.img=14
    _lizard.agro=1
    _lizard.next_y = 50
    _lizard.tmr_move = randsec_rang(6, 7)
    _lizard.tmr_throw = throw_times[_lizard.agro]
    _lizard.timer = 150
    _lizard.time_on_screen = 0
    _lizard.in_play = false
    _lizard.w = 8
    _lizard.h = 24
    _lizard.y = off_screen_y
   -- _lizard.curr_animation = _lizard.animations["idle"]
    _lizard.skull_x=0

    _lizard.facing_r = false

    if side == "right" then
        _lizard.x = 117
        _lizard.facing_r = true
        _lizard.skull_x=117
    elseif side == "left" then
        _lizard.x = 3
        _lizard.facing_r = false
        _lizard.skull_x=11
    end

    return _lizard
end

function lizard:draw()
     sspr(0, 64, 8, 24, self.x, self.y, 8, 24, self.facing_r)
end

function lizard:update()
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

function lizard:reset()

end

function lizard:move(new_y)
    --self.curr_animation = self.animations["climb"]
    self.y = new_y
    if self.y == new_y then
        --self.curr_animation = self.animations["idle"]
        self.tmr_move = randsec_rang(4, 8)
    end
end

function lizard:crawl_on_screen()
    self.in_play = true
   -- self.curr_animation = self.animations["climb"]
    local _y = rnd({y_range[1], y_range[2]})
    self.y = _y
end

function lizard:die()
    del(lizards, self)
    self.in_play = false
    --self.curr_animation = self.animations["climb"]
    thing_on_left = false
    thing_on_right = false
    self.tmr_move = -1
    self.tmr_throw = -1
end

function lizard:throw_skull()
    --self.curr_animation = self.animations["throw"]
    self.tmr_throw = throw_times[self.agro]
    spawn_skull(self.skull_x, self.y, p1, self.facing_r)
end

function update_lizard_spawner()
    next_lizard = next_lizard - 1
    if next_lizard <= 0 then
        spawn_rock()
    end
end

function spawn_lizard()
    if not thing_on_left and not thing_on_right then
        local _side
        if flr(rnd(2)) + 1 == 1 then
            _side = "left"
            thing_on_left = true
        else
            _side = "right"
            thing_on_right = true
        end

        local _lizard = lizard:new(_side)
        add(lizards, _lizard)
        _lizard:crawl_on_screen()
    else
        print_debug("there was already a thing on screen")
    end
end


function update_lizards()
    for d in all(lizards) do
        d:update()
    end
end

function draw_lizards()
    for d in all(lizards) do
        d:draw()
    end
end
