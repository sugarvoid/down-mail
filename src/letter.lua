letters={}
--letters_free={}

letter={}
letter.__index=letter

function letter:new()
    local _l=setmetatable({},letter)
    _l.x=0
    _l.y=0
    _l.col=nil
    _l.t=0
    _l.tossed=false
    _l.t_col=0
    _l.b_col=0
    _l.img=32
    _l.dir=0
    _l.speed=3
    return _l
end

function letter:update()
    if self.tossed then
        self.x+=self.speed*self.dir
        self.t=(self.t+1)%5
        turn=self.t==0
        if turn then
            self.img+=1
        end
        if self.img==35 then
            self.img=32
        end
    else
        self.y-=2
    end
end

function letter:draw()
    pal(5,self.t_col)
    pal(6,self.b_col)
    spr(self.img,self.x,self.y)
    pal()
end

-- letter=obj:new({
--     x,y=0,
--     col=nil,
--     t=0,
--     tossed=false,
--     t_col=0,
--     b_col=0,
--     img=32,
--     dir=0,
--     speed=3,

--     update=function(self)
--         if self.tossed then
--             self.x+=self.speed*self.dir
--             self.t=(self.t+1)%5
--             turn=self.t==0
--             if turn then
--                 self.img+=1
--             end
--             if self.img==35 then
--                 self.img=32
--             end
--         else
--             self.y-=2
--         end
--     end,
--     draw=function(self)
--         render_letter(self)
--     end
-- })

-- function render_letter(l)
--     pal(5,l.t_col)
--     pal(6,l.b_col)
--     spr(l.img,l.x,l.y)
--     pal()
-- end

function spawn_letter(_dir)
    new_letter=letter:new()

    new_letter.dir=_dir
    new_letter.tossed=true
    new_letter.x=p1.x
    new_letter.y=p1.y
    if font_col[1]==12 then
        new_letter.col="b"
    else
        new_letter.col="y"
    end

    set_let_val(new_letter)
    add(letters,new_letter)
end

function set_let_val(l)
    if l.col=="b" then
        l.t_col=1
        l.b_col=12
    end
    if l.col=="y" then
        l.t_col=9
        l.b_col=10
    end
end

function u_letters()
    for l in all(letters) do
        l:update()
        --l:draw()
    end
end