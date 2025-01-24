
package={}
package.__index=package

function package:new()
    local _r=setmetatable({},package)
    _r.x=0
    _r.y=-40
    _r.anim = { 55, 56, 57, 58 }
    _r.tick = 0
    _r.frame = 1
    _r.step = 5
    _r.img=41
    _r.speed=1
    return _r
end

function package:update()
    self.tick = (self.tick + 1) % self.step
    if (self.tick == 0) then
        self.frame = self.frame % #self.anim + 1
    end
    self.y+=self.speed
    if self.y>=130 then
        del(objects.front,self)
    end
    if is_colliding(p1,self) then
        del(objects.front,self)
        p1:update_letters(5)
    end
end

function package:draw()
    spr(self.anim[self.frame], self.x,self.y)
end


function spawn_package()
    new_package=package:new()
    new_package.x=rnd(avil_yx)
    add(objects.front,new_package)
    reset_package_timer()
end

function reset_package_timer()
    next_package=70+rnd(10)
end

