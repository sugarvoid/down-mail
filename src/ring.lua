rings = {}

ring = {}
ring.__index = ring

function ring:new()
    local _r = setmetatable({}, ring)
    _r.x = 0
    _r.y = 130
    _r.img = 141
    _r.size = 0
    _r.value = 10
    _r.color = 11
    _r.speed = rnd({ 1, 2})
    return _r
end

function ring:update()
    self.y -= self.speed

    if self.y <= -20 then
        del(rings, self)
    end

    if is_colliding(p1, self) then
        del(rings, self)
        sfx(4)
        p1.score += (self.value / 2)
    end

    for l in all(letters) do
        if is_colliding(self, l) then
            p1.score += self.value
            explode(l.x, l.y, 2, 6, self.col)
            sfx(4)
            del(letters, l)
            del(rings, self)
        end
    end
end

function ring:draw()
    pal(7, self.color)
    if self.size == 1 then
        spr(self.img, self.x, self.y)
    else
        spr(140, self.x, self.y, 1, 1, false, false)
        spr(140, self.x, self.y+8, 1, 1, false, true)
    end
    pal()
end

function spawn_ring(size)
    new_ring = ring:new()
    new_ring.size = size
    new_ring.h = 8 * size
    new_ring.x = rnd(avil_yx)
    add(rings, new_ring)
    reset_ring_timer()
end

function reset_ring_timer()
    next_ring = 70 + rnd(10)
end

function draw_rings()
    for r in all(rings) do
        r:draw()
    end
end

function update_rings()
    for r in all(rings) do
        r:update()
    end
end
