
hazards={}

danger_y=10

hazard={}
hazard.__index=hazard

h_types=
{
    {"rock",{26},true},
    {"dancer",{10,11},true},
    {"twister",{-1},false},
{"mower",{-1},false}}

function hazard:new(id)
    local _r=setmetatable({},hazard)
    _h.id=id
    _h.x=0
    _h.dx=1
    _h.y=-40
    _h.img=rnd({26,27,43})
    _h.fall_speed=rnd({2,3,4})
    _h.danger_time=20
    return _r
end

function hazard:update()
    self.y+=self.fall_speed
    self.danger_time-=2
    if h_types[self.id][3] then
        self.x+=self.dx
        if not self.in_range then
            self.dx*=-1
        end

    end
    if self.y>=130 then
        del(hazards,self)
    end
    if self.x<=5 then
    end
end

function hazard:draw()
    spr(self.img,self.x,self.y)
    if self.danger_time>=0 then
        spr(25,self.x,danger_y)
    end
end

function hazard:in_range()
    return self.x>=20 and self.x<=110
end

function spawn_hazard()
    --get random x
    -- make sure there isn't already a mailbox with that x

    --spawn hazard higher than 0,
    -- show indicator
    -- hide indicator

    new_hazard=hazard:new()
    new_hazard.x=rnd(avil_yx)
    --flr(rnd(108))+10

    add(hazards,new_hazard)
    reset_hazard_timer()
end

function reset_hazard_timer()
    next_hazard=70+rnd(10)
end

function in_range(x_val)
    if x_val>=1 and x_val<=20 then
        print 'it is!'
    end
end

function new_spawner()
    local _spawner={
        rock_1=randi_rang(3,10),
        rock_2=randi_rang(3,10),
        mail_box=140,
        demon=140,

        update=function(self)
            self.rock_1=self.rock_1-1
            self.rock_2=self.rock_2-1
            self.mail_box=self.mail_box-1
            self.demon=self.demon-1

            if self.rock_1<=0 then
                spawn_rock()
                self.rock_1=math.floor(randi_rang(3,10))
            end

            if self.rock_2<=0 then
                spawn_rock()
                self.rock_2=math.floor(randi_rang(3,10))
            end

            if self.mail_box<=0 then
                spawn_mailbox()
                self.mail_box=math.floor(randi_rang(2,4))
            end

            if self.demon<=0 then
                self.demon=math.floor(randi_rang(9,20))
                spawn_thing()
            end
        end
    }

    return _spawner
end