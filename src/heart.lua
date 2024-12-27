hearts={}

heart={}
heart.__index=heart

function spawn_heart(x,y)
    sfx(15)
    local _h=setmetatable({},heart)
    _h.x=x
    _h.y=y
    _h.img=50
    _h.speed=3
    add(objects.front, _h)
    --return _h
end


function heart:update()
    self.y-=self.speed
    if self.y<=-16 then
        del(objects.front,self)
    end
end

function heart:draw()
    spr(self.img,self.x,self.y)
end