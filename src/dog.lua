dogs={}

dog={}
dog.__index=dog

function spawn_dog(x,y)
    local _d=setmetatable({},dog)
    
    _d.x=x
    _d.y=y
    _d.timer=150
    _d.target=p1
    _d.facing_l=nil
    _d.img=19
    _d.angle=0
    _d.speed=1.5
    _d.prox=0.2
    add(objects.front, _d)
    --return _d
end

function dog:set_target(obj)
    self.target=obj
end

function dog:update()
    self.timer-=1
    if self.timer == 0 then
        spawn_bone(self)
    end
    local _newangle = atan2(self.target.x-self.x, self.target.y-self.y)
    if _newangle <= 0.3 then
        local _t = self.target.type
        if _t == "bone" then
            del(objects.front, self)
            del(objects.front, self.target)
            spawn_heart(self.x,self.y)
        elseif _t == "player" then
            --TODO: add logic
            p1.move_speed = 0.5
        end
    end
    
    self.angle = angle_lerp(self.angle, _newangle, self.prox)
    self.x += self.speed * cos(self.angle)
    self.y += self.speed * sin(self.angle)
    
end

function dog:draw()
    spr(self.img,self.x,self.y,1,1,self.facing_l)
end


