bone={}
bone.__index=bone

function spawn_bone(x,y,p)
    local b=setmetatable({},bone)
    b.x=x
    b.y=y
    b.target={x=p.x, y=p.y}
    b.img=2
    b.speed=6
    b.dx = p.x - b.x
    b.dy = p.y - b.y
    local len = sqrt(b.dx^2 + b.dy^2)
    b.dx /= len
    b.dy /= len
    b.hitbox = hitbox.new(b, 6, 5)
    add(objects.front, b)
end

function bone:update()
    self.x += self.dx * self.speed
    self.y += self.dy * self.speed

    if is_colliding(p1.hitbox, self.hitbox) then
        offset =0.1
        del(objects.front, self)
        p1:take_damage()
    end

    if self.x<=8 or self.x>=120 then
        explode(self.x,self.y,3,4,5)
        sfx(18)
        del(objects.front,self)
    end
    self.hitbox:update()
end

function bone:draw()
    spr(self.img,self.x,self.y)
    draw_hb(self.hitbox)
end