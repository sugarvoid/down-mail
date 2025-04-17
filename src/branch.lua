branch={}
branch.__index=branch

function spawn_branch(side)
    local b=setmetatable({},branch)
    if side == "left" then
        b.x=2
        b.spr_1=15
        b.spr_3=30
    else
        b.x=106
        b.spr_1=14
        b.spr_3=15
    end
    
    b.y=130
    b.speed=7
    b.img = 14
    b.hitbox = hitbox.new(b, 20, 4)
    add(objects.front, b)
end

function branch:update()
    self.y -= self.speed

    if is_colliding(p1.hitbox, self.hitbox) then
        offset = 0.1
        del(objects.front, self)
        p1:take_damage()
    end

    if self.y <= -10 then
        del(objects.front,self)
    end

    self.hitbox:update()
end

function branch:draw()
    spr(self.spr_1,self.x,self.y)
    spr(15,self.x+8,self.y)
    spr(self.spr_3,self.x+16,self.y)
    draw_hb(self.hitbox)
end