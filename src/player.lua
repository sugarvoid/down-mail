player = {}
player.__index = player


function init_player()
    local _p = setmetatable({}, player)
    _p.in_vortex = false
    _p.x = 54
    _p.y = 54
    _p.w = 8
    _p.h = 8
    _p.selected_letter = 0
    _p.is_alive = true
    _p.sprite_a = 5
    _p.sprite_b = 6
    _p.img = 0
    _p.ring=16
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
    _p.throws = 0
    _p.misses = 0
    _p.a = 0
    _p.damaged_mb = 0
    _p.missed_mb = 0
    _p.deliveries = 0
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

        --spr_r(self.img, self.x, self.y, self.a, 1, 1)
        spr(self.img, self.x, self.y, 1, 1, self.facing_l)

        
        spr(self.chute_spr, self.x, self.y - 8)
        --pal()
    else
        spr(49, self.x, self.y)
    end
    
    
    if self.life >= 2 then
        spr(18, self.x, self.y, 1, 1, self.facing_l)
    end
    if self.life == 3 then
        --pal(7, self.colors[1])
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

    self.a-=10

    self.a = self.a%360 

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

        if self.ring<20 then
            self.ring+=2
        end
    end

    if test_wormhole then
        self.x = test_wormhole.x - 4
        self.y = test_wormhole.y - 4
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


function player:get_acc()
    if self.throws == 0 then
        return 0
    else
        return ceil(((self.throws - self.misses) / self.throws) * 100)
    end
end

function player:throw()
    if g_state == gamestates.game then
        self.throws += 1
    end
    --self.img=02
    self.thr_anmi = 10
    if self.facing_l then
        spawn_letter(-1)
    else
        spawn_letter(1)
    end
    sfx(6)
    
end
