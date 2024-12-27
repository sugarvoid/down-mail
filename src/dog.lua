dogs={}

dog={}
dog.__index=dog

function dog:new(x,y)
    local _d=setmetatable({},dog)
    _d.x=0
    _d.y=0
    _d.target=p1
    _d.facing_l=nil
    _d.img=19
    _d.angle=0
    _d.speed=1.5
    _d.prox=0.2
    return _d
end

function dog:set_target(obj)
    self.target=obj
end

function dog:update()
    local _newangle = atan2(self.target.x-self.x, self.target.y-self.y)
    self.angle = angle_lerp(self.angle, _newangle, self.prox)
    self.x += self.speed * cos(self.angle)
    self.y += self.speed * sin(self.angle)
end

function dog:draw()
    spr(self.img,self.x,self.y,1,1,self.facing_l)
end


