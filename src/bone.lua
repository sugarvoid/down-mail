bones={}

bone={}
bone.__index=bone

function bone:new(x,y)
    local _b=setmetatable({},bone)
    _b.type="bone"
    _b.x=x
    _b.y=y
    _b.facing_l=nil
    _b.img=36
    _b.speed=1.5
    _b.prox=0.2
    return _b
end

function spawn_bone(dog)
    local _b = bone:new(rnd(avil_yx), 128)
    dog.speed = 3
    dog.target = _b
    dog.prox=0.8
    
    add(objects.front, _b)
end

function bone:update()
    if not self.collected then
        self.y-=self.speed
    else
        del(objects.front, self)
    end
end

function bone:draw()
    if not self.collected then
        spr(self.img,self.x,self.y)
    end
end