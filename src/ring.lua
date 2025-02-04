rings = {}

ring = {}
ring.__index = ring

function ring:new()
    local _r = setmetatable({}, ring)
    _r.x = randi_rang(20, 100)
    _r.y = randi_rang(40, 60)
    _r.img = 141
    _r.life = randsec_rang(3, 5)
    _r.w = 8
    _r.value = 10
    _r.color = 11
    _r.speed = rnd({ 1, 2 })
    return _r
end

function spawn_ring()
    local _r = setmetatable({}, ring)
    _r.x = randi_rang(20, 90)
    _r.y = randi_rang(40, 60)
    _r.img = 141
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

    -- if is_colliding(p1, self) then
    --     del(rings, self)
    --     sfx(4)
    --     p1.score += (self.value / 2)
    -- end

    for l in all(letters) do
        if is_colliding_pro(self, l) then
            score += self.value
            explode(l.x, l.y, 2, 6, self.col)
            sfx(4)
            --del(letters, l)
            del(rings, self)
        end
    end
end

function ring:draw()
    pal(7, self.color)

    spr(140, self.x, self.y, 1, 1, false, false)
    spr(140, self.x, self.y + 8, 1, 1, false, true)
    self.h = 16

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

-- function update_rings()
--     for r in all(rings) do
--         r:update()
--     end
-- end
