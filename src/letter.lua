letter = {}
letter.__index = letter
letters = {}

function spawn_letter(_dir)
    local l = setmetatable({}, letter)
    l.t = 0
    l.w = 8
    l.h = 8
    l.score_mul = 1
    l.tossed = true
    l.img = 32
    l.dir = _dir
    print_debug(_dir)
    l.speed = 1
    l.accel = 0.5
    l.x = p1.x
    l.y = p1.y
    l.hitbox = hitbox.new(l, 8, 8)
    add(letters, l)
end

function letter:update()
    if self.tossed then
        self.score_mul += 0.2
        self.speed = mid(-4, self.speed + self.accel, 4)
        self.x += self.speed * self.dir
        self.t += 1
        if self.t >= 3 then
            self.t = 0
            self.img += 1
        end
        if self.img == 35 then
            self.img = 32
        end

        for mb in all(mailboxes) do
            if is_colliding_pro(self.hitbox, mb.hitbox) and not mb.damaged and mb.empty then
                if mb.facing_l and self.dir == 1 then
                --if self.x <= mb.x then
                    --if mb.facing_l and self.dir == 1 then
                    mb:on_good_letter(self.score_mul)
                --else
                  --  explode(self.x, self.y, 2, 2, 7, 10)
                --end
                
                elseif not mb.facing_l and self.dir == -1 then
                    --if not mb.facing_l then
                        mb:on_good_letter(self.score_mul)
                    --else
                        
                else explode(self.x, self.y, 2, 2, 7, 10)
                    
                end
                --end
                del(letters, self)
            end
        end

        if self.x <= 0 or self.x >= 120 then
            if g_state == gamestates.game then
                p1.misses += 1
                if #twisters < 10 then
                   spawn_twister(self.x, self.y) 
                   sfx(14)
                end
                explode(self.x, self.y, 3, 4, 4, 10)
            end
            del(letters, self)
        end
    else
        self.y -= 2
    end
    self.hitbox:update()
end

function letter:draw()
    spr(self.img, self.x, self.y)
    draw_hb(self.hitbox)
end

function update_letters()
    for l in all(letters) do
        l:update()
    end
end

function draw_letters()
    for l in all(letters) do
        l:draw()
    end
end
