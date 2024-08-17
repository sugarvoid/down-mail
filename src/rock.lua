
rocks={}

danger_y=10

rock=obj:new({
	x=0,
	y=-40,
	col=nil,
	facing_l=nil,
	img=rnd({26,27,43}),
	speed=rnd({2,3,4}),
	danger_time=20,

	update=function(self)
		self.y+=self.speed
		self.danger_time-=2
		if self.y >= 130 then
			del(rocks,self)
		end
		if self.x <= 5 then
			
		end
  	end,
	draw=function(self)
		spr(self.img,self.x,self.y)
		if self.danger_time >= 0 then
			spr(25, self.x, danger_y)
		end
	end,
    in_range=function(self, x_val)
        return x_val >= self.x-10 and x_val <= self.x+10
    end
})

function spawn_rock()

    --get random x
    -- make sure there isn't already a mailbox with that x 



    --spawn rock higher than 0, 
    -- show indicator 
    -- hide indicator

	new_rock = rock:new()
	new_rock.x=rnd(avil_yx)  --flr(rnd(108))+10
	
	add(rocks,new_rock)
	reset_rock_timer()
end

function reset_rock_timer()
	next_rock=70 + rnd(10)
end





function in_range(x_val)
    if x_val >= 1 and x_val <= 20 then
        print 'it is!'
    end
end