branch={}
branch.__index=branch

function spawn_branch(side)
    local b=setmetatable({},branch)
    b.x=x
    b.y=130
    b.speed=4
    b.hitbox = hitbox.new(b, 6, 5)
    add(objects.front, b)
end

function branch:update()
    self.y += self.speed

    if is_colliding_pro(p1.hitbox, self.hitbox) then
        offset = 0.1
        --shake(0.1)
        del(objects.front, self)
        p1:take_damage()
    end

    if self.y <= -10 then
        del(objects.front,self)
    end

    self.hitbox:update()
end

function branch:draw()
    spr(self.img,self.x,self.y)
    draw_hb(self.hitbox)
end