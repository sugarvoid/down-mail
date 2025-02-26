--skulls={}

skull={}
skull.__index=skull

function spawn_skull(x,y, p,face_r)
    local _d=setmetatable({},skull)
    _d.x=x
    _d.y=y
    _d.target={x=p.x, y=p.y}
    _d.facing_r=face_r
    _d.img=39
    _d.speed=5
    _d.dx = p.x - _d.x
    _d.dy = p.y - _d.y
    local len = sqrt(_d.dx^2 + _d.dy^2)
    _d.dx /= len
    _d.dy /= len
    add(objects.front, _d)
end

function skull:set_target(obj)
    self.target=obj
end

function skull:update()
    self.x += self.dx * self.speed
    self.y += self.dy * self.speed

    if is_colliding(p1, self) then
        offset =0.1
        del(objects.front, self)
        p1:take_damage()
    end

    if self.x<=8 or self.x>=120 then
        explode(self.x,self.y,3,4,5)
        del(objects.front,self)
    end
end

function skull:draw()
    spr(self.img,self.x,self.y,1,1,self.facing_r)
end


