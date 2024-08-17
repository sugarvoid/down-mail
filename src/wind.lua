
---wind={}

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

function init_wind()
	for i=0,15 do
		add(objects.back, wind_line:new())
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
