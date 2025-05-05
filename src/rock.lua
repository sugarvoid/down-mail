
rock = {}
rock.__index = rock

function spawn_rock(lane)
    local r = setmetatable({}, rock)
    r.x = lanes[lane][1]
    r.y = -40
    r.img = rnd({26, 27})
    r.speed = randf_rang(3, 5) --rnd({3, 4, 5})
    r.danger_time = 20
    r.lane = lane
    r.hitbox = hitbox.new(r, 6, 6)
    update_lane(lane, true)
    add(objects.front, r)
end

function rock:update()
    self.y += self.speed
    self.danger_time -= 2
    if self.y >= 130 then
        del(objects.front, self)
        update_lane(self.lane, false)
    end
    if is_colliding(p1.hitbox, self.hitbox) then
        offset = 0.1
        --shake(0.1)
        explode(self.x, self.y, 2, 5, 4)
        update_lane(self.lane, false)
        del(objects.front, self)
        p1:take_damage()
    end
    self.hitbox:update()
end

function rock:draw()
    spr(self.img, self.x, self.y)
    if self.danger_time >= 0 then
        spr(25, self.x, 10)
    end
end
