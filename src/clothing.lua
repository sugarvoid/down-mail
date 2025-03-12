clothing={}
clothing.__index=clothing

function clothing:draw()
    pal(14, self.col)
    spr(self.img,self.x,self.y)
    pal()
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
    _c.col = p1.colors[1]
    add(objects.front,_c)
end
