player = {}
player.__index = player

function init_player()
    local p = setmetatable({}, player)
    p.x = 54
    p.y = 54
    p.is_alive = true
    p.sprite_a = 5
    p.sprite_b = 6
    p.img = 0
    p.facing_l = false
    p.is_chute_open = true
    p.chute_spr = nil
    p.chute_open_spr = 7
    p.life = 3
    p.thr_anmi = 0
    p.move_speed = 1.5
    p.speed = 1
    p.accel = 0.1
    p.throws = 0
    p.misses = 0
    p.death_timer = 40
    p.letters = 20
    p.hitbox = hitbox.new(p, 6, 8)
    return p
end

function player:move(dir)
    if dir == "l" then
        self.x = mid(6, self.x - self.move_speed, 115)
        self.facing_l = true
    elseif dir == "r" then
        self.x = mid(6, self.x + self.move_speed, 115)
        self.facing_l = false
    end
end

function player:draw()
    if self.is_alive then
        spr(self.img, self.x, self.y, 1, 1, self.facing_l)
        spr(self.chute_spr, self.x, self.y - 8)

        if self.life >= 2 then
            spr(18, self.x, self.y, 1, 1, self.facing_l)
        end
        if self.life == 3 then
            spr(17, self.x, self.y, 1, 1, self.facing_l)
        end
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
    if self.is_alive then
        if self:check_for_twisters() then
            self.move_speed = 0.5
            self.speed = 0.5
        else
            self.move_speed = 1.5
            self.speed = 2
        end

        if self.is_chute_open then
            self.chute_spr = self.chute_open_spr
        else
            self.chute_spr = 24
        end

        if self.is_chute_open then
            self.speed = mid(-3, self.speed + self.accel, 3)
            self.y -= self.speed
        else
            self.speed = mid(-4, self.speed + self.accel, 4)
            self.y += self.speed
        end

        if self.y <= -30 or self.y >= 140 then
            goto_gameover(2)
        end


        if self.thr_anmi > 0 then
            self.thr_anmi -= 1
        end
        if self.thr_anmi == 0 then
            self.img = self.sprite_a
        else
            self.img = self.sprite_b
        end
        self.hitbox:update()
    else
        self.death_timer -= 1
        if self.death_timer == 0 then
            goto_gameover(1)
        end
    end
end

function player:check_for_twisters()
    for t in all(twisters) do
        if is_colliding(self.hitbox, t.hitbox) then
            return true
        end
    end
    return false
end

function player:take_damage()
    if self.life == 3 then spawn_clothing(17) end
    if self.life == 2 then spawn_clothing(18) end
    self.life -= 1
    self.chute_open_spr += 1
    sfx(16)
    if self.life == 0 then
        self:die()
    end
end

function player:throw()
    sfx(6)
    if g_state == gamestates.game and self.letters > 0 and not show_results then
        self.letters -= 1
        if self.facing_l then
            spawn_letter(-1)
        else
            spawn_letter(1)
        end
    end
    self.thr_anmi = 10
end

function player:die()
    -- body
    self.is_alive = false
    explode(self.x + 2, self.y - 1, 3, 4, 8, 10)
    explode(self.x - 1, self.y + 2, 3, 4, 8, 10)
    explode(self.x, self.y + 3, 3, 4, 8, 10)
    explode(self.x, self.y, 3, 4, 8, 10)
end
