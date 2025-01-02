branches={}



branch={}
branch.__index=branch

function branch:new(x,y)
    local _b=setmetatable({},branch)
    _b.type="branch"
    _b.x=x
    _b.y=y
    _b.facing_l=true
    _b.img=36
    _b.speed=1.5
    _b.prox=0.2
    return _b
end

function spawn_branch(dog)
    local _b=branch:new(rnd(avil_yx),128)
    _b.y=rnd({10, 110})
    _b.speed=randf_rang(1,3)
    add(branches.front,_b)
end

function branch:update()
    if not self.y <= -12 then
        self.y-=self.speed
    else
        del(objects.front,self)
    end
end

function branch:draw()
    sspr( 64, 24, 24, 8, self.x, self.y, 24, 8, self.facing_l)
    if not self.collected then
        spr(self.img,self.x,self.y)
    end
end
