
danger_y=10

rock={}
rock.__index=rock

function spawn_rock(lane)
    local _r=setmetatable({},rock)
    _r.x=lanes[lane][1]
    _r.y=-40
    _r.img=rnd({26,27})
    _r.speed=rnd({3,4,5})
    _r.danger_time=20
    _r.lane=lane
    update_lane(lane, true)
    add(objects.front,_r)
end

function rock:update()
    self.y+=self.speed
    self.danger_time-=2
    if self.y>=130 then
        del(objects.front,self)
        update_lane(self.lane, false)
    end
    if is_colliding(p1, self) then
        offset =0.1
        explode(self.x,self.y,2,5,4)
        update_lane(self.lane, false)
        del(objects.front, self)
        p1:take_damage()
    end
end

function rock:draw()
    spr(self.img,self.x,self.y)
    if self.danger_time>=0 then
        spr(25,self.x,danger_y)
    end
end
