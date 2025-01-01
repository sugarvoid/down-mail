packages={}

package={}
package.__index=package

function package:new()
    local _r=setmetatable({},package)
    _r.x=0
    _r.y=-40
    _r.img=41
    _r.speed=rnd({1,2,3})
    return _r
end

function package:update()
    self.y+=self.speed
    if self.y>=130 then
        del(objects.front,self)
    end
    if is_colliding(p1,self) then
        del(objects.front,self)
        p1:update_letters(5)
    end
    if self.x<=5 then
    end
end

function package:draw()
    spr(self.img,self.x,self.y)
end


function spawn_package()
    --get random x
    -- make sure there isn't already a mailbox with that x

    --spawn package higher than 0,
    -- show indicator
    -- hide indicator

    new_package=package:new()
    new_package.x=rnd(avil_yx)
    --flr(rnd(108))+10

    add(objects.front,new_package)
    reset_package_timer()
end

function reset_package_timer()
    next_package=70+rnd(10)
end

