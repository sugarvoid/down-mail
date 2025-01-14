player = {}
player.__index = player

function init_player()
    local _p = setmetatable({}, player)
    _p.type = "player"
    _p.x = 54
    _p.y = 54
    _p.w = 8
    _p.h = 8
    _p.score = 0
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
    _p.life = 3
    _p.thr_anmi = 0
    return _p
end

function player:get_input()
    if btn(➡️) then
        self.x += 1.5
        self.facing_l = false
    elseif btn(⬅️) then
        self.x -= 1.5
        self.facing_l = true
    end

    if btnp(⬆️) then
        self.is_chute_open = true
    elseif btnp(⬇️) then
        self.is_chute_open = false
    end

    if btnp(🅾️) then
        self:throw()
        --explode(p.x,p.y,3,4,7)
    end
    if btnp(❎) then
        --p.ring = 0
        --p.letters += 1
        spawn_package()
        --swap(font_col)
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

function player:update()
    self:get_input()
    if self.is_chute_open then
        self.chute_spr = self.chute_open_spr
    else
        self.chute_spr = 24
    end

    if self.is_chute_open then
        self.y -= 1.5
    else
        self.y += 2.5
    end

    if self.x <= 4 or self.x >= 118 then
        sfx(12)
        self.is_alive = false
        end_text = endings[2]
        g_state = gamestates.gameover
        --self.img = 49

        --
        --[[
TODO: add blood particales
then go to game over
]]
    end
    --TODO: user goto_gameover funciton
    if self.y >= 130 then
        self.is_alive = false
        end_text = endings[1]
        g_state = gamestates.gameover
    end
    if self.y <= -10 then
        self.is_alive = false
        end_text = endings[3]
        g_state = gamestates.gameover
    end

    if self.is_alive then
        if self.thr_anmi > 0 then
            self.thr_anmi -= 1
        end
        if self.thr_anmi == 0 then
            --and self.img==self.sprite_b then
            self.img = self.sprite_a
        else
            self.img = self.sprite_b
        end
        --if self.ring<20 then
        --    self.ring+=2
        --end
    end
end

-- p1={
--     type="player",
--     x=54,
--     y=54,
--     score=0,
--     letters=12,
--     max_letter = 12,
--     selected_letter=0,
--     is_alive=true,
--     sprite_a=1,
--     sprite_b=2,
--     img=nil,
--     facing_l=false,
--     is_chute_open=true,
--     chute_spr=nil,
--     chute_open_spr=7,
--     life=3,
--     thr_anmi=0,
--     --ring=16,
--     draw=function(self)
--         if self.is_alive then
--             --if self.ring<=15 then
--             --circ(self.x+4,self.y,self.ring,font_col[1])
--             --end
--             --pal(7,font_col[1])
--             spr(self.img,self.x,self.y,1,1,self.facing_l)
--             spr(self.chute_spr,self.x,self.y-8)
--             --pal()
--         else
--             spr(49,self.x,self.y)
--         end
--     end,

--     update=function(self)
--         get_input(self)
--         if self.is_chute_open then
--             self.chute_spr=self.chute_open_spr
--         else
--             self.chute_spr=24
--         end

--         if self.is_chute_open then
--             self.y-=1.5
--         else
--             self.y+=2.5
--         end

--         if self.x<=4 or self.x>=118 then
--             sfx(12)
--             self.is_alive=false
--             end_text=endings[2]
--             g_state=gamestates.gameover
--             --self.img = 49

--             --
--             --[[
-- TODO: add blood particales
-- then go to game over
-- ]]
--         end
--         --TODO: user goto_gameover funciton
--         if self.y>=130 then
--             self.is_alive=false
--             end_text=endings[1]
--             g_state=gamestates.gameover
--         end
--         if self.y<=-10 then
--             self.is_alive=false
--             end_text=endings[3]
--             g_state=gamestates.gameover
--         end

--         if self.is_alive then
--             if self.thr_anmi>0 then
--                 self.thr_anmi-=1
--             end
--             if self.thr_anmi==0 then
--                 --and self.img==self.sprite_b then
--                 self.img=self.sprite_a
--             else
--                 self.img=self.sprite_b
--             end
--             --if self.ring<20 then
--             --    self.ring+=2
--             --end
--         end
--     end,

--     throw=function(self)
--         if self.letters>0 then
--             --self.img=02
--             if g_state == gamestates.game then
--                 self:update_letters(-1)
--             end

--             --self.letters = mid(0,self.letters - 1,max_letter)
--             self.thr_anmi=10
--             if self.facing_l then
--                 spawn_letter(-1)
--             else
--                 spawn_letter(1)
--             end
--             sfx(6)
--         end
--     end,
--     take_damage=function(self)
--         if (self.life==3) then spawn_clothing(17) end
--         if (self.life==2) then spawn_clothing(18) end
--         self.life-=1

--         self.chute_open_spr+=1
--         --self.chute = 39
--         sfx(10)
--         self.sprite_a+=2
--         self.sprite_b+=2
--     end,
--     update_letters=function(self,amount)
--         self.letters=mid(0,self.letters+amount,self.max_letter)
--     end
-- }

function player:update_letters(amount)
    self.letters = mid(0, self.letters + amount, self.max_letter)
end

function player:take_damage()
    if (self.life == 3) then spawn_clothing(17) end
    if (self.life == 2) then spawn_clothing(18) end
    self.life -= 1

    self.chute_open_spr += 1
    --self.chute = 39
    sfx(10)
    self.sprite_a += 2
    self.sprite_b += 2
end

function player:throw()
    if self.letters > 0 then
        --self.img=02
        if g_state == gamestates.game then
            self:update_letters(-1)
        end

        --self.letters = mid(0,self.letters - 1,max_letter)
        self.thr_anmi = 10
        if self.facing_l then
            spawn_letter(-1)
        else
            spawn_letter(1)
        end
        sfx(6)
    end
end
