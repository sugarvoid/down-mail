hitbox = {}
hitbox.__index = hitbox


function hitbox.new(obj,w ,h)
    local _h = setmetatable({}, hitbox)
    _h.obj = obj
    _h.x = obj.x
    _h.y = obj.y
    _h.w = w
    _h.h = h
    return _h
end

function hitbox:update()
    self.x = self.obj.x
    self.y = self.obj.y
end

function draw_hb(b)
    rect(b.x, b.y, b.x + b.w, b.y + b.h, 8)
end

