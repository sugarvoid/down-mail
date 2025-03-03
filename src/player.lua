player = {}
player.__index = player


function init_player()
    local _p = setmetatable({}, player)
    _p.x = 54
    _p.y = 54
    _p.w = 8
    _p.h = 8
    _p.letters = 12
    _p.max_letter = 12
    _p.selected_letter = 0
    _p.is_alive = true
    _p.sprite_a = 5
    _p.sprite_b = 6
    _p.img = nil
    _p.facing_l = false
    _p.is_chute_open = true
    _p.chute_spr = nil
    _p.chute_open_spr = 7
    _p.max_health = 3
    _p.life = _p.max_health
    _p.thr_anmi = 0
    _p.move_speed = 1.5
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
    if debug then
        print(deliveries_left, self.x, self.y+8)
    end
    
    if self.life >= 2 then
        spr(18, self.x, self.y, 1, 1, self.facing_l)
    end
    if self.life == 3 then
        spr(17, self.x, self.y, 1, 1, self.facing_l)
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

    if self:check_for_twisters() then
        self.move_speed = 0.5
      else
        self.move_speed = 1.5
      end

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

        self.is_alive = false
        goto_gameover(1)
        
        --change_state(gamestates.gameover)
        --self.img = 49
        -- TODO: add blood particales
        -- then go to game overload
    end
    --TODO: user goto_gameover funciton
    if self.y <= -30 or self.y >= 140 then
        
            self.is_alive = false
            goto_gameover(2)
            --change_state(gamestates.gameover)
        
    end

    -- if self.y <= -30 then
    --     self.is_alive = false
    --     end_text = endings[2]
    --     ending_idx = 2
    --     change_state(gamestates.gameover)
    -- end

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

function player:check_for_twisters()
    for t in all(twisters) do
      if t.dis < 30 then
        return true
      end
    end
    return false
  end

function player:take_damage()
    if (self.life == 3) then spawn_clothing(17) end
    if (self.life == 2) then spawn_clothing(18) end
    self.life -= 1
    self.chute_open_spr += 1
    sfx(16)
    if p1.life == 0 then
        --sfx(11)
        goto_gameover(1)
        --end_text = endings[2]
        --ending_idx = 1
        --change_state(gamestates.gameover)
    end
end

function player:throw()
    if self.letters > 0 then
        --self.img=02
        self.thr_anmi = 10
        if self.facing_l then
            spawn_letter(-1)
        else
            spawn_letter(1)
        end
        sfx(6)
    end
end
