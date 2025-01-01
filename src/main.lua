
cols={12,14,10,11,9,6} --"b","y","p","g"}
customers={}
non_customers={}
reminder=false
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
day=1
days={"monday","tuesday","wednesday","thursday","friday","saturday","sunday"}
intro_t=60
day_t=60
gamestates={
    title=0,
    day_intro=1,
    day_title=2,
    game=3,
    bonus=4,
    gameover=5
}
g_state=gamestates.title

deliveries_left=10

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
    set_customers()
    score=0
    misses=0
    init_wind()
    reset_mb_timer()
    for i=0,150 do
        print_debug(randi_rang(2,7))
    end

end

function _update()
    if g_state==gamestates.title then
        if btnp(🅾️) then
            --g_state=1
            g_state=gamestates.day_intro
        end
    elseif g_state==gamestates.day_intro then
        update_intro()
    elseif g_state==gamestates.day_title then
        update_day()
    elseif g_state==gamestates.game then
        update_play()
    elseif g_state==gamestates.gameover then
        update_gameover()
    end
end

function _draw()
    if g_state==gamestates.title then
        draw_title()
        --draw_day()
        --draw_intro()
    elseif g_state==gamestates.day_intro then
        draw_intro()
    elseif g_state==gamestates.day_title then
        draw_day()
    elseif g_state==gamestates.game then
        draw_play()
    elseif g_state==gamestates.gameover then
        draw_gameover()
    end
    print("mem: "..flr(stat(0)).."kb",0,0,8)
    print("cpu: "..stat(1).."%",0,8,8)
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
        change_state(gamestates.gameover)
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

function update_intro()
    intro_t-=1
    if intro_t<=0 then
        --g_state=gamestates.day_title
        change_state(gamestates.day_title)
    end
end

function update_day()
    day_t-=1
    if day_t<=0 then
        g_state=gamestates.game
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
    cls(7)
    print("down mail",hcenter("down mail"),50,0)
    print("press 🅾️ to play",hcenter("press 🅾️ to play"),75,0)
end

function draw_intro()
    cls()
    print("customers",hcenter("customers"),45,7)
    print("non-customers",hcenter("non-customers"),80,7)
    --TODO: figure out how to center sprites
    for k,v in pairs(customers) do
        pal(6,v)
        sspr(32,8,8,8,25+(16*k),52,16,16)
        --spr(20, 30+(8*k), 52)
        pal()
    end

    for k,v in pairs(non_customers) do
        pal(6,v)
        sspr(32,8,8,8,25+(16*k),88,16,16)
        --spr(20, 30+(8*k), 88)
        pal()
    end
end

function draw_day()
    cls(0)
    print(days[day],hcenter(days[day]),vcenter(days[day]),7)
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
        pset(70+(2*i),124,5)
        pset(70+(2*i),125,5)
    end
    for i=1,p1.letters,1 do
        pset(70+(2*i),124,7)
        pset(70+(2*i),125,7)
    end
    if reminder then
        for k,v in pairs(customers) do
            pal(6,v)
            --sspr(32, 8, 8, 8, 25+(4*k), 88, 4, 4)
            spr(21,30+(8*k),122)
            pal()
        end
    end
    --   for i=1,#customers,1 do
    --     pset(30+(2*i), 126, customers[i])
    --     pset(30+(2*i), 126, customers[i])
    --     pset(30+(2*i), 126, customers[i])
    --   end
end

function advance_day()
    -- TODO: Set customer tables
    -- TODO: Reset player's health, position and letter stock
    deliveries_left=10 --TODO: Maybe increase as the week goes on
    day+=1
    g_state=gamestates.day_intro
end

function change_state(new_state)
    g_state=new_state
end

function set_customers()

    shuffle(cols)

    customers={cols[1],cols[2],cols[3]}
    non_customers={cols[4],cols[5],cols[6]}
end

function angle_lerp(angle1,angle2,t)
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
    printh("debug: "..str,'debug.txt')
end

function hcenter(s)
    -- screen center minus the
    -- string length times the
    -- pixels in a char's width,
    -- cut in half
    return 64-#s*2
end

function vcenter(s)
    -- screen center minus the
    -- string height in pixels,
    -- cut in half
    return 61
end

function shuffle(t)
    -- do a fisher-yates shuffle
    for i=#t,1,-1 do
        local j=flr(rnd(i))+1
        t[i],t[j]=t[j],t[i]
    end
end

function randf_rang(l,h)
    local h=h-l
    return l+rnd(h)
end

function randi_rang(l,h)
    return flr(rnd(h))+l
end
