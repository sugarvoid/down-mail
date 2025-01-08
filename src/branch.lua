
pool={}
pool.__index=pool

function pool:new()
    local _b=setmetatable({},pool)
    _b.type="pool"
    _b.y=130
    _b.h=8
    _b.w=24
    _b.speed=1.5
    _b.was_hit=false
    return _b
end

function spawn_pool()
    local _b=pool:new(rnd(avil_yx),128)
    _b.x=rnd({10, 110})
    _b.speed=randf_rang(1,3)
    add(objects.front,_b)
end

function pool:update()
    if self.y >= -12 then
        self.y-=self.speed
    else
        del(objects.front,self)
    end
end

function pool:on_hit()
    del(objects.front,self)
    p1:take_damage()
end

function pool:draw()
    sspr( 64, 24, 24, 8, self.x, self.y, 24, 8)
end
