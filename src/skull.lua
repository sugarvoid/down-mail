--skulls={}

skull={}
skull.__index=skull

function spawn_skull(x,y, p,face_r)
    local _d=setmetatable({},skull)
    
    _d.x=x
    _d.y=y
    _d.target={x=p.x, y=p.y}
    _d.facing_r=face_r
    _d.img=142
    _d.angle=0
    _d.speed=3
    _d.prox=0.2
    print_debug("skull added")
    add(objects.front, _d)
    --return _d
end

function skull:set_target(obj)
    self.target=obj
end

function skull:update()
    local _newangle = atan2(self.target.x-self.x, self.target.y-self.y)
    if _newangle <= 0.2 then
        del(objects.front, self)
        print_debug("player hit by skull")
    end
    
    self.angle = angle_lerp(self.angle, _newangle, self.prox)
    self.x += self.speed * cos(self.angle)
    self.y += self.speed * sin(self.angle)

    if is_colliding(p1, self) then
        del(objects.front, self)
        p1:take_damage()
    end
    
end

function skull:draw()
    spr(self.img,self.x,self.y,1,1,self.facing_r)
end


