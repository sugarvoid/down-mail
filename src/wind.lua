
wind_line={}
wind_line.__index=wind_line

function wind_line:new()
    local _w=setmetatable({},wind_line)
    _w.speed=randi_rang(3,7)
    _w:reset()
    return _w
end

function wind_line:update()
    self.t=(self.t+1)%3
    move=self.t==0
    if move then
        self.sy-=self.speed
        self.ey-=self.speed
    end
    if self.ey<=0 then
        self:reset()
    end
end

function wind_line:reset()
    self.x=randi_rang(10,120)
    self.sy=randi_rang(50,124)--flr(rnd(128))+8
    self.ey=self.sy-2
    self.t=0
end

function wind_line:draw()
    line(self.x,self.sy,self.x,self.ey,5)
end

function init_wind()
    for i=0,30 do
        add(objects.back,wind_line:new())
    end
end

