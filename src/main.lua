cols={12,14,10,11,9,6} --"b","y","p","g"}
customers={}
non_customers={}
g_state=0
mb_spawn=0
avil_yx={7,16,25,34,43,52,61,70,79,88,97,106,113}
next_mb=0
map_y=0
damaged_mb=0
game_over_x=-10
max_letter=12
ending=0
end_spr={64,68,72,76,128,132,136,140}
objects={back={},front={}}

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
    score=0
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
    print("mem: "..flr(stat(0)).."kb", 0, 0, 8)
    print("cpu: "..stat(1).. "%", 0, 8, 8)
end

function update_play()
    p1:update()
    update_particles()
    update_objects()
    u_letters()
    map_y+=.2

    if flr(map_y)==17 then
        map_y=0
    end
    --moving the map up
    --update_wind()
    if p1.life==0 then
        sfx(11)
        g_state=2
    end

    for mb in all(mailboxes) do
        mb:update()
    end

    mb_spawn+=1
    if mb_spawn>=next_mb then
        spawn_mbox()
        spawn_rock()
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
    

    

    draw_particles()

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
    rectfill(0,121,128,128,0)
    print("score: "..p1.score,2,123,7)
    for i=1,max_letter,1 do
        pset(70+(2*i), 124, 5)
        pset(70+(2*i), 125, 5)
      end
      for i=1,p1.letters,1 do
        pset(70+(2*i), 124, 7)
        pset(70+(2*i), 125, 7)
      end
end

function angle_lerp(angle1, angle2, t)
    angle1=angle1%1
    angle2=angle2%1

    if abs(angle1-angle2)>0.5 then
      if angle1>angle2 then
       angle2+=1
      else
       angle1+=1
      end
    end

    return ((1-t)*angle1+t*angle2)%1
end

function print_debug(str)
    printh("debug: " .. str, 'debug.txt')
end
