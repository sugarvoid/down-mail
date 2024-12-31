mailboxes={}

mailbox={}
mailbox.__index=mailbox

function mailbox:new()
    local _m=setmetatable({},mailbox)
    _m.x=0
    _m.y=0
    _m.col=nil
    _m.customer=true
    _m.facing_l=nil
    _m.b_col=0
    _m.img=21
    _m.empty=true
    _m.damaged=false
    _m.dir=0
    _m.dx=1.3
    _m.speed=rnd({0.5,0.7,0.9})
    return _m
end

function mailbox:update()
    self.y-=self.speed

    if self.empty and not self.damaged then
        self.img=21
    elseif not self.empty and not self.damaged then
        self.img=20
    elseif self.damaged then
        self.img=22
        self.speed=-2
    end

    if self.y<=-16 then
        del(mailboxes,self)
    end

    if is_colliding(p1,self) and not self.damaged then
        sfx(3)
        self.damaged=true
        damaged_mb+=1
        if damaged_mb==3 then
            end_text=endings[4]
            g_state=2
        end
        update_cash(-10)
    end
end

function mailbox:draw()
    pal(6,self.b_col)
    spr(self.img,self.x,self.y,1,1,self.facing_l)
    pal()
    spr(37,self.x,self.y+8)
end

function mailbox:in_range(x_val)
    return x_val>=self.x-10 and x_val<=self.x+10
end

-- m_box=obj:new({
--     -- x,y=0,
--     -- col=nil,
--     -- facing_l=nil,
--     -- b_col=0,
--     -- img=21,
--     -- empty=true,
--     -- damaged=false,
--     -- dir=0,
--     -- dx=1.3,
--     -- speed=rnd({0.5,0.7,0.9}),
--     --speed=0.7,

--     update=function(self)
--         self.y-=self.speed

--         if self.empty and not self.damaged then
--             self.img=21
--         elseif not self.empty and not self.damaged then
--             self.img=20
--         elseif self.damaged then
--             self.img=22
--         end

--         if self.y<=-16 then
--             del(mailboxes,self)
--         end
--     end,
--     draw=function(self)
--         pal(6,self.b_col)
--         spr(self.img,self.x,self.y,1,1,self.facing_l)
--         pal()
--         spr(37,self.x,self.y+8)
--     end,
--     in_range=function(self,x_val)
--         return x_val>=self.x-10 and x_val<=self.x+10
--     end
-- })

function spawn_mbox()
    new_mb=mailbox:new()
    new_mb.x=rnd(avil_yx)
    --flr(rnd(108))+10
    new_mb.y=128
    new_mb.facing_l=new_mb.x>128/2
    new_mb.col=rnd(cols)
    if new_mb.col=="b" then
        new_mb.b_col=12
    elseif new_mb.col=="p" then
        new_mb.b_col=14
    elseif new_mb.col=="y" then
        new_mb.b_col=10
    end
    add(mailboxes,new_mb)
    reset_mb_timer()
end

function reset_mb_timer()
    next_mb=70+rnd(10)
end
