
--WindLine = Object:extend()

WindLine = {}
WindLine.__index = WindLine


all_windlines = {}
local spriteBatch

local image = love.graphics.newImage("wind.png")

function WindLine:new(x, y)
	local _wind = setmetatable({}, WindLine)
	_wind.x = x 
	_wind.y = y 
	--self.sy = x
	
	_wind.length = 3
	_wind.ey = _wind.y + _wind.length
	

	return _wind

end

function init_wind()
	
	--quad = love.graphics.newQuad(0, 0, 1, 3, image)
	--spriteBatch = love.graphics.newSpriteBatch(image)

	for i=1, 10 do 
		local ran_x = math.random(1, 127)
		local ran_y = math.random(1, 127)
		local _w = WindLine:new(ran_x, ran_y)
		table.insert(all_windlines, _w)
	end
end


function WindLine:draw()
	--love.graphics.line(self.x, self.y, self.x, self.ey)
	--spriteBatch:clear()
	--for _, entity in ipairs(all_windlines) do
		--spriteBatch:add(quad, math.floor(entity.x), math.floor(entity.y))
	--end
	love.graphics.draw(image, self.x, self.y)
end

function WindLine:update(dt)
	self.y = self.y + 1
 	self.ey = self.y + self.length --* dt
	if self.y == 128+3 then
		self:reset()
	end
end

function WindLine:reset()
	self.y = 0
	self.ey = self.y + 3
	self.x = math.random(1, 127)
end




-- wind_line={
-- 	x,sy,ey=0,
-- 	col=5,
-- 	t=0,
-- 	speed=5,
-- 	new=function(self,tbl)
-- 		tbl=tbl or {}
-- 		setmetatable(tbl,{
-- 			__index=self
-- 		})
-- 	tbl.x = 9 + rnd(125)
  
-- 	tbl.sy=rnd(128)
-- 	tbl.ey=tbl.sy-2
-- 	return tbl
-- 	end,

-- 	update=function(self)
-- 		self.t = (self.t + 1) % 3
--   		move=(self.t==0)
--   	if move then
--   		self.sy-=self.speed
--   		self.ey-=self.speed
--   	end
-- 	if self.ey <= 0 then 
-- 		self.x = 9 + rnd(125)
-- 		self.sy=flr(rnd(128))+8
-- 		self.ey=self.sy-2
-- 	end
--   	end,
-- 	draw=function(self)
-- 		line(self.x,self.sy,self.x,self.ey,self.col)
-- 	end
-- }