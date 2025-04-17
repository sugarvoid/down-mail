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
    local c=setmetatable({},clothing)
    c.img=sprite
    c.x=p1.x
    c.y=p1.y
    c.fall_speed=2
    add(objects.front,c)
end
