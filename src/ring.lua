rings = {}

ring = {}
ring.__index = ring

function spawn_ring()
    local _r = setmetatable({}, ring)
    _r.x = randi_rang(20, 90)
    _r.y = randi_rang(40, 60)
    _r.img = 48
    _r.life = randsec_rang(3, 5)
    _r.w = 8
    _r.value = 10
    _r.color = rnd({ 11, 10, 12 })
    _r.speed = rnd({ 1, 2 })
    _r.h = 16
    add(rings, _r)
    reset_ring_timer()
end

function ring:update()
    self.life -= 1

    if self.life <= 0 then
        del(rings, self)
    end

    for l in all(letters) do
        if is_colliding_pro(self, l) then
            self:on_letter_contact(l)
        end
    end
end

function ring:on_letter_contact(letter)
    score += self.value
    explode(self.x, self.y+6, 3, 4, self.color)
    explode(self.x, self.y+10, 3, 4, 7)
    

    sfx(15)
    del(rings, self)
end

function ring:draw()
    pal(7, self.color)
    spr(self.img, self.x, self.y, 1, 1, false, false)
    spr(self.img, self.x, self.y + 8, 1, 1, false, true)
    pal()
end

function reset_ring_timer()
    next_ring = randsec_rang(2, 5)
end

function draw_rings()
    for r in all(rings) do
        r:draw()
    end
end
