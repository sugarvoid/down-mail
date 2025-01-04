

branch={}
branch.__index=branch

function branch:new()
    local _b=setmetatable({},branch)
    _b.type="branch"
    _b.y=130
    _b.h=8
    _b.w=24
    _b.speed=1.5
    _b.was_hit=false
    return _b
end

function spawn_branch()
    local _b=branch:new(rnd(avil_yx),128)
    _b.x=rnd({10, 110})
    _b.speed=randf_rang(1,3)
    add(objects.front,_b)
end

function branch:update()
    if self.y >= -12 then
        self.y-=self.speed
    else
        del(objects.front,self)
    end
end

function branch:on_hit()
    del(objects.front,self)
    p1:take_damage()
end

function branch:draw()
    sspr( 64, 24, 24, 8, self.x, self.y, 24, 8)
end
