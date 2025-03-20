letter = {}
letter.__index = letter
letters = {}

function spawn_letter(_dir)
    local _l = setmetatable({}, letter)
    _l.t = 0
    _l.w = 8
    _l.h = 8
    _l.score_mul = 1
    _l.tossed = true
    _l.img = 32
    _l.dir = _dir
    _l.speed = 1
    _l.accel = 0.5
    _l.x = p1.x
    _l.y = p1.y
    add(letters, _l)
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
            if is_colliding(self, mb) and not mb.damaged and mb.empty then
                if self.x < mb.x then
                    if mb.facing_l then
                        mb:on_good_letter(self.score_mul)
                    else
                        explode(self.x, self.y, 2, 2, 7, 10)
                    end
                else
                    if not mb.facing_l then
                        mb:on_good_letter(self.score_mul)
                    else
                        explode(self.x, self.y, 2, 2, 7, 10)
                    end
                end
                del(letters, self)
            end
        end

        if self.x <= 0 or self.x >= 120 then
            if g_state == gamestates.game then
                p1.misses += 1
                if #twisters < 3 then
                   spawn_twister(self.x, self.y) 
                   sfx(14)
                elseif #twisters == 3 then
                    --test_wormhole = worm_hole.new(p1.x, p1.y)
                    --twisters = {}
                end
                explode(self.x, self.y, 3, 4, 4, 10)
            end
            del(letters, self)
        end
    else
        self.y -= 2
    end
end

function letter:draw()
    spr(self.img, self.x, self.y)
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
