demon = {}
demon.__index = demon

local next_demon = 70
local y_range = { 10, 90 }
local off_screen_y = 138
local things = {}

local thing_on_left = false
local thing_on_right = false

function demon:new(side)
    local _demon = setmetatable({}, demon)
    _demon.animations = {
        idle = {f={}, loop=true, done=false},
        climb = {f={}, loop=true, done=false},
        throw = {f={}, loop=true, done=false},
        grow_head = {f={}, loop=true, done=false},
    }
    _demon.img=14
    _demon.next_y = 50
    _demon.tmr_move = -1
    _demon.tmr_throw = -1
    _demon.timer = 150
    _demon.time_on_screen = nil -- TODO: longer on screen, throw more often
    _demon.in_play = false
    _demon.w = 16
    _demon.h = 24
    _demon.y = off_screen_y
    _demon.curr_animation = _demon.animations["idle"]

    if side == "right" then
        _demon.x = 208
        _demon.facing_dir = 1
    elseif side == "left" then
        _demon.x = 3
        _demon.facing_dir = -1
        for _, a in pairs(_demon.animations) do
            a:flipH()
        end
    end

    return _demon
end

function demon:draw()
    --self.curr_animation:draw(thing_sheet, self.x, self.y)
    --x = get_distance()
    --if is_debug_on then
     --   draw_hitbox(self)
     spr(self.img, self.x, self.y)
    --end
    --love.graphics.draw(image, self.x, self.y, 0, self.facing_dir, 1, 4, 1)
    --self.curr_animation:draw(thing_sheet, self.x, self.y, 0, self.facing_dir, 1, 16)
    
end

function demon:update(dt)
    for a in all(self.curr_animation.f) do
        self.img=a
    end

    if self.curr_animation == self.animations["throw"] and self.curr_animation.done then

        --spawn_skull(self.x - (8 * self.facing_dir), self.y + 7, p1, self.facing_dir)
        --self.animations["throw"]:resume()
        --self.animations["throw"]:gotoFrame(1)
        self.curr_animation = self.animations["grow_head"]
    end
    if self.curr_animation == self.animations["grow_head"] and self.curr_animation.done then
        --self.animations["grow_head"]:resume()
        --self.animations["grow_head"]:gotoFrame(1)
        self.curr_animation = self.animations["idle"]
    end

    if self.in_play then
        self.tmr_move -= 1 -- math.clamp(0, self.tmr_move - 1, 90)
        self.tmr_throw -= 1 --math.clamp(0, self.tmr_throw - 1, 90)
        if self.tmr_move == 0 then
            self:move(math.random(y_range[1], y_range[2]))
        end

        if self.tmr_throw == 0 then
            self:throw_skull()
        end

        for _, l in ipairs(all_letters) do
            if is_colliding(l, self) then
                table.remove_item(all_letters, l)
                self:die()
            end
        end
    end
end

function demon:reset()

end

function demon:move(new_y)
    self.curr_animation = self.animations["climb"]
    self.tw_move = flux.to(self, 1, { y = new_y }):ease("linear"):oncomplete(
        function()
            self.tmr_move = get_next_time(1, 4)
            self.curr_animation = self.animations["idle"]
        end
    )
end

function demon:crawl_on_screen()
    self.in_play = true
    self.curr_animation = self.animations["climb"]
    local _y = rnd({y_range[1], y_range[2]})
    -- flux.to(self, 1, { y = _y }):ease("linear"):oncomplete(
    --     function()
    --         --self:move_up()

    --         self.curr_animation = self.animations["idle"]
    --         self.tmr_move = get_next_time(1, 4)
    --     end
    -- )
end

function demon:die()
    self.in_play = false
    self.curr_animation = self.animations["climb"]
    --FIXME: Sometimes the "thing" will not slide down, it just disappears.

    self.twn_move = flux.to(self, 0.5, { y = off_screen_y }):ease("linear"):oncomplete(
        function()
            thing_on_left = false
            thing_on_right = false
            del(things, self)
            self.tmr_move = -1
            self.tmr_throw = -1
        end
    )
end

function demon:throw_skull()
    self.curr_animation = self.animations["throw"]
    self.tmr_throw = 60
    --sfx_skull:play()
    --spawn_skull(self.x-(17*self.facing_dir), self.y+7, player, self.facing_dir)
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
        table.insert(things, _demon)
        _demon:crawl_on_screen()
    else
        print_debug("there was already a thing on screen")
    end
end

function init_demons()

end

function update_demons()
    for d in all(things) do
        d:update()
    end
end

function draw_demons()
    for d in all(things) do
        d:draw()
    end
end
