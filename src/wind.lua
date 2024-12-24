
wind_line={}
wind_line.__index=wind_line

function wind_line:new()
    local _w=setmetatable({},wind_line)
    _w.x=9+rnd(125)
    _w.sy=rnd(128)
    _w.ey=_w.sy-2
    _w.col=5
    _w.t=0
    _w.speed=5
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
        self.x=9+rnd(125)
        self.sy=flr(rnd(128))+8
        self.ey=self.sy-2
    end
end

function wind_line:draw()
    line(self.x,self.sy,self.x,self.ey,self.col)
end

function init_wind()
    for i=0,15 do
        add(objects.back,wind_line:new())
    end
end

function draw_wind()
    for w in all(wind) do
        w:draw()
    end
end

function update_wind()
    for w in all(wind) do
        w:update()
    end
end
