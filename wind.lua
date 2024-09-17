
WindLine = Object:extend()

function WindLine:new(x, y)
	self.x = x or 0
	self.y = y or 0
	self.ey = 0
	self.length = 3

	table.insert(all_windlines, self)

end


function WindLine:draw()
	love.graphics.line(self.x, self.sy, self.x, self.ey)
end

function WindLine:update(dt)
 	self.ey = self.y + self.length
end




wind_line={
	x,sy,ey=0,
	col=5,
	t=0,
	speed=5,
	new=function(self,tbl)
		tbl=tbl or {}
		setmetatable(tbl,{
			__index=self
		})
	tbl.x = 9 + rnd(125)
  
	tbl.sy=rnd(128)
	tbl.ey=tbl.sy-2
	return tbl
	end,

	update=function(self)
		self.t = (self.t + 1) % 3
  		move=(self.t==0)
  	if move then
  		self.sy-=self.speed
  		self.ey-=self.speed
  	end
	if self.ey <= 0 then 
		self.x = 9 + rnd(125)
		self.sy=flr(rnd(128))+8
		self.ey=self.sy-2
	end
  	end,
	draw=function(self)
		line(self.x,self.sy,self.x,self.ey,self.col)
	end
}