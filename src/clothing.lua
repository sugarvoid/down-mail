clothing={}
clothing.__index=clothing

function clothing:draw()
    spr(self.img,self.x,self.y)
end

function clothing:update()
    self.y+=self.fall_speed
    if self.y>130 then
        del(objects.front,self)
    end
end

function spawn_clothing(sprite)
    local _c=setmetatable({},clothing)
    _c.img=sprite
    _c.x=p1.x
    _c.y=p1.y
    _c.fall_speed=2
    add(objects.front,_c)
end
