dogs = {}

dog = {}
dog.__index = dog

function spawn_dog()
    local d = setmetatable({}, dog)
    d.x = 113
    d.y = 50
    d.facing_l = d.x < 128 / 2
    d.b_col = rnd(cols)
    d.img = 19
    d.empty = true
    d.damaged = false
    d.dir = 0
    d.dx = 1.3
    add(dogs, d)
end

function dog:update()
    
end

function dog:take_damage()
    
end

function dog:draw()
    pal(6, self.b_col)
    spr(self.img, self.x, self.y, 1, 1, self.facing_l)
    pal()
    spr(3, self.x, self.y + 7)
end


