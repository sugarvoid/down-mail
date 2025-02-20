player = {}
player.__index = player

local max_health = 3

function init_player()
    local _p = setmetatable({}, player)
    _p.type = "player"
    _p.x = 54
    _p.y = 54
    _p.w = 8
    _p.h = 8
    --_p.score = 0
    _p.letters = 12
    _p.max_letter = 12
    _p.selected_letter = 0
    _p.is_alive = true
    _p.sprite_a = 1
    _p.sprite_b = 2
    _p.img = nil
    _p.facing_l = false
    _p.is_chute_open = true
    _p.chute_spr = nil
    _p.chute_open_spr = 7
    _p.life = max_health
    _p.thr_anmi = 0
    _p.move_speed = 1.5
    _p.twister_count = 0
    _p.speed = 1
    _p.accel = 0.1
    return _p
end

function player:move(dir)
    if dir == "l" then
        self.x -= self.move_speed
        self.facing_l = true
    elseif dir == "r" then
        self.x += self.move_speed
        self.facing_l = false
    end
end

function player:draw()
    if self.is_alive then
        spr(self.img, self.x, self.y, 1, 1, self.facing_l)
        spr(self.chute_spr, self.x, self.y - 8)
    else
        spr(49, self.x, self.y)
    end
end

function player:update_chute(open)
    
    self.is_chute_open = open
    if open then
        self.speed = 1
    else
        self.speed = 2
    end
end

function player:update()
    if self.is_chute_open then
        self.chute_spr = self.chute_open_spr
    else
        self.chute_spr = 24
    end

    if self.is_chute_open then
        self.speed  = mid(-3, self.speed + self.accel, 3)
        self.y -= self.speed
    else
        self.speed  = mid(-4, self.speed + self.accel, 4)
        self.y += self.speed
    end

    if self.x <= 4 or self.x >= 118 then
        sfx(12)
        self.is_alive = false
        end_text = endings[1]
        ending_idx = 1
        g_state = gamestates.gameover
        --self.img = 49
        -- TODO: add blood particales
        -- then go to game overload
    end
    --TODO: user goto_gameover funciton
    if self.y >= 140 then
        if g_state == gamestates.bonus then
            bouns_timer = 0
        else
            self.is_alive = false
            end_text = endings[2]
            ending_idx = 2
            change_state(gamestates.gameover)
        end
        
    end

    if self.y <= -30 then
        self.is_alive = false
        end_text = endings[2]
        ending_idx = 2
        change_state(gamestates.gameover)
    end

    if self.is_alive then
        if self.thr_anmi > 0 then
            self.thr_anmi -= 1
        end
        if self.thr_anmi == 0 then
            self.img = self.sprite_a
        else
            self.img = self.sprite_b
        end
    end
end

function player:update_letters(amount)
    self.letters = mid(0, self.letters + amount, self.max_letter)
end

function player:take_damage()
    if (self.life == 3) then spawn_clothing(17) end
    if (self.life == 2) then spawn_clothing(18) end
    self.life -= 1
    self.chute_open_spr += 1
    --self.chute = 39
    sfx(16)
    self.sprite_a += 2
    self.sprite_b += 2
    if p1.life == 0 then
        sfx(11)
        end_text = endings[2]
        ending_idx = 1
        change_state(gamestates.gameover)
    end
end

function player:throw()
    if self.letters > 0 then
        --self.img=02
        if g_state == gamestates.game then
            self:update_letters(-1)
        end
        self.thr_anmi = 10
        if self.facing_l then
            spawn_letter(-1)
        else
            spawn_letter(1)
        end
        sfx(6)
    end
end

-- function player:reset()
--     self.life = max_health
--     self.x=54
--     self.y=54
--     self.is_alive=true
--     self.letters = 12
-- end
