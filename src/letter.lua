letter={}
letter.__index=letter
letters={}

function letter:update()
    if self.tossed then
        self.score_mul+=0.2
        self.x+=self.speed*self.dir
        self.t=(self.t+1)%5
        turn=self.t==0
        if turn then
            self.img+=1
        end
        if self.img==35 then
            self.img=32
        end

        for mb in all(mailboxes) do
            if is_colliding(self,mb) and not mb.damaged and mb.empty  then
                if mb.customer then
                    if self.x < mb.x then
                        if mb.facing_l then
                            mb:on_good_letter(self.score_mul)
                        else
                            explode(self.x, self.y, 2, 2, 7)
                        end
                    else
                        if not mb.facing_l then
                            mb:on_good_letter(self.score_mul)
                        else
                            explode(self.x, self.y, 2, 2, 7)
                        end
                    end
                    
                else
                    sfx(5)
                    --deliveries[2] += 1
                end
                deliveries_left -= 1
                del(letters,self)
            end
        end


        if self.x<=8 or self.x>=120 then
            spawn_dog(self.x,self.y)
            sfx(14)
            explode(self.x,self.y,3,4,4)
            del(letters,self)
        end

    else
        self.y-=2
    end
end

function letter:draw()
    spr(self.img,self.x,self.y)
end

function spawn_letter(_dir)
    local _l=setmetatable({},letter)
    _l.t=0
    _l.w=8
    _l.h=8
    _l.score_mul=1
    _l.tossed=true
    _l.img=32
    _l.dir=_dir
    _l.speed=3
    _l.x=p1.x
    _l.y=p1.y
    add(letters,_l)
end


function update_letters()
    for l in all(letters) do
        l:update()
    end
end

function draw_letters()
    for l in all(letters) do
        l:draw()
    end
end
