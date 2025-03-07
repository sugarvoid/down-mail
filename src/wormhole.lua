


local wh_pixel={}
wh_pixel.__index=wh_pixel

function wh_pixel.new(x,y)
    local _px=setmetatable({},wh_pixel)
    _px.col = rnd{5,6,7}
    _px.angle=0
    _px.originx=x
    _px.originy=y
    _px.radius = randi_rang(3, 16)
    _px.start_radius = _px.radius
    _px.speed=randf_rang(2,20)
    return _px
end

function wh_pixel:update()

    self.angle+=self.speed
    if(self.angle>360) then
        self.angle=0
    end

    self.radius -= .5
    if self.radius == 0 then
        self.radius = randi_rang(10, 16)
    end

    self.x=self.originx+
        self.radius*
        cos(self.angle/360)
    self.y=self.originy+
        self.radius*
        sin(self.angle/360)
end

function wh_pixel:draw()
    pset(self.x,self.y,self.col)
end







worm_hole={}
worm_hole.__index=worm_hole

function worm_hole.new(px, py)
    local _w=setmetatable({},worm_hole)
    _w.x = px
    _w.y = py
    _w.pxs ={}
    _w.in_play = false

    _w:init()

    return _w
end

function worm_hole:update()
    for p in all(self.pxs) do
        p:update()
    end
    
end

function worm_hole:reset()

end

function worm_hole:draw()
    for p in all(self.pxs) do
        p:draw()
    end
end

function worm_hole:init()
    for i=0,20 do
        add(self.pxs, wh_pixel.new(self.x,self.y))
    end
    self.in_play = true
end

