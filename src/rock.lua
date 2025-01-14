
danger_y=10

rock={}
rock.__index=rock

function rock:new()
    local _r=setmetatable({},rock)
    _r.x=0
    _r.y=-40
    _r.img=rnd({26,27})
    _r.speed=rnd({2,3,4})
    _r.danger_time=20
    return _r
end

function rock:update()
    self.y+=self.speed
    self.danger_time-=2
    if self.y>=130 then
        del(objects.front,self)
    end
    if is_colliding(p1, self) then
        explode(self.x,self.y,2,5,4)
        del(objects.front, self)
        p1:take_damage()
    end
    if self.x<=5 then
    end
end

function rock:draw()
    spr(self.img,self.x,self.y)
    if self.danger_time>=0 then
        spr(25,self.x,danger_y)
    end
end

function rock:in_range()
    return x_val>=self.x-10 and x_val<=self.x+10
end

function spawn_rock()
    --get random x
    -- make sure there isn't already a mailbox with that x

    --spawn rock higher than 0,
    -- show indicator
    -- hide indicator

    new_rock=rock:new()
    new_rock.x=rnd(avil_yx)
    --flr(rnd(108))+10

    add(objects.front,new_rock)
    reset_rock_timer()
end

function reset_rock_timer()
    next_rock=70+rnd(10)
end

function in_range(x_val)
    if x_val>=1 and x_val<=20 then
        print 'it is!'
    end
end
