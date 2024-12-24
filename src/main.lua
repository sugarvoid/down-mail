cols={"b","y"}
g_state=0
mb_spawn=0
avil_yx={7,16,25,34,43,52,61,70,79,88,97,106,113}
next_mb=0
map_y=0
clamp=mid
damaged_mb=0
game_over_x=-10
ending=0
end_spr={64,68,72,76,128,132,136,140}

-- obj2={
--     new=function(self,tbl)
--         tbl=tbl or {}
--         setmetatable(
--             tbl,{
--                 __index=self
--             })
--             return tbl
--         end
--     }

objects={
back={},front={}}

function update_objects()
    for o in all(objects.front) do
        o:update()
    end
    for o in all(objects.back) do
        o:update()
    end
end

function draw_objects()
    for o in all(objects.back) do
        o:draw()
    end
    for o in all(objects.front) do
        o:draw()
    end
end

function _init()
    poke(0x5f5c,255)
    earnings=0
    score=0
    combo=1
    misses=0
    init_wind()
    reset_mb_timer()
end

function _update()
    if g_state==0 then
        if btnp(🅾️) then g_state=1 end
    elseif g_state==1 then
        update_play()
    elseif g_state==2 then
        update_gameover()
    end
end

function _draw()
    if g_state==0 then
        draw_title()
    elseif g_state==1 then
        draw_play()
    elseif g_state==2 then
        draw_gameover()
    end
end

function update_play()
    p1:update()
    update_objects()
    u_letters()
    map_y+=.2

    if (flr(map_y)==17) then map_y=0 end
    --moving the map up
    --update_wind()
    if p1.life==0 then
        sfx(11)
        g_state=2
    end

    mb_spawn+=1
    if mb_spawn>=next_mb then
        spawn_mbox("b",true)
        spawn_rock()

        --make_letter()
        mb_spawn=0
        reset_mb_timer()
    end

    for r in all(rocks) do
        r:update()
        if is_colliding(p1,r) then
            del(rocks,r)
            p1:take_damage()
        end
    end
end

function draw_play()
    cls(0)
    for o in all(objects.back) do
        o:draw()
    end
    rectfill(0,0,127,8,0)
    rectfill(0,120,127,128,0)
    p1:draw()

    for mb in all(mailboxes) do
        mb:update()
        if is_colliding(p1,mb) and not mb.damaged then
            sfx(3)
            mb.damaged=true
            damaged_mb+=1
            if damaged_mb==3 then
                end_text=endings[4]
                g_state=2
            end
            update_cash(-10)
        end

        for l in all(letters) do
            if l.x<=8 or l.x>=126 then
                misses+=1
                update_cash(-5)
                del(letters,l)
            end
            if is_colliding(l,mb) and not mb.damaged and mb.empty then
                if l.col==mb.col then
                    del(letters,l)
                    mb.empty=false
                    mb.speed=4
                    update_cash(2)
                    sfx(4)
                else
                    del(letters,l)
                    sfx(5)
                end
            end
        end
    end

    for o in all(objects.front) do
        o:draw()
    end

    for mb in all(mailboxes) do
        mb:draw()
    end
    for l in all(letters) do
        l:draw()
    end
    for r in all(rocks) do
        r:draw()
    end
    map(0,map_y)
    draw_gui()
end

function draw_title()
    cls(0)
    print("down mail",48,50,3)
    print("press 🅾️ to start",30,57,3)
end

function is_colliding(a,b)
    if b.x>=a.x+8
        or b.x+8<=a.x
        or b.y>=a.y+8
        or b.y+8<=a.y then
        return false
    else
        return true
    end
end

function draw_gui()
    rectfill(0,121,128,128,5)
    print("$"..earnings,2,122,font_col[1])
    print("miss:"..misses,50,122,font_col[1])
    print("combo:x"..combo,91,122,font_col[1])
end

function update_cash(amount)
    earnings=mid(0,earnings+amount)
end
