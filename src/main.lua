is_debug=false

cols = { 12, 14, 10, 11, 9, 6 } --"b","y","p","g"}
customers = {}
non_customers = {}
reminder = false
mb_spawn = 0
avil_yx = { 7, 16, 25, 34, 43, 52, 61, 70, 79, 88, 97, 106, 113 }
next_mb = 0
map_y = 0
damaged_mb = 0
game_over_x = -10

ending = 0
end_spr = { 64, 68, 72, 76, 128, 132, 136, 140 }
objects = { back = {}, front = {} }

day = 1
days = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }
intro_t = 60
day_t = 60
gamestates = {
    title = 0,
    day_intro = 1,
    day_title = 2,
    game = 3,
    bonus = 4,
    gameover = 5
}
g_state = gamestates.title

deliveries_left = 10

function update_objects()
    for o in all(objects.front) do
        o:update()
    end
    for o in all(objects.back) do
        o:update()
    end
end

function draw_objects()
    -- for o in all(objects.back) do
    --     o:draw()
    -- end
    for o in all(objects.front) do
        o:draw()
    end
end

function _init()
    poke(0x5f5c, 255)
    set_customers()
    score = 0
    misses = 0
    init_wind()
    reset_mb_timer()
    p1 = init_player()
end

function _update()
    if btnp(🅾️) then
        if g_state == gamestates.title then
            g_state = gamestates.day_intro
        elseif g_state == gamestates.day_intro then
            intro_t = 0
        elseif g_state == gamestates.day_title then
            day_t = 0
        elseif g_state == gamestates.game then

        elseif g_state == gamestates.gameover then

        end
    end
    if btnp(❎) then
        if g_state == gamestates.title then

        elseif g_state == gamestates.day_intro then

        elseif g_state == gamestates.day_title then

        elseif g_state == gamestates.game then

        elseif g_state == gamestates.gameover then

        end
    end


    if g_state == gamestates.title then
    elseif g_state == gamestates.day_intro then
        update_intro()
    elseif g_state == gamestates.day_title then
        update_day()
    elseif g_state == gamestates.game then
        update_play()
    elseif g_state == gamestates.bonus then
        update_bonus()
    elseif g_state == gamestates.gameover then
        update_gameover()
    end
end

function _draw()
    if g_state == gamestates.title then
        draw_title()
        --draw_day()
        --draw_intro()
    elseif g_state == gamestates.day_intro then
        draw_intro()
    elseif g_state == gamestates.day_title then
        draw_day()
    elseif g_state == gamestates.game then
        draw_play()
    elseif g_state == gamestates.bonus then
        draw_bonus()
    elseif g_state == gamestates.gameover then
        draw_gameover()
    end

    if is_debug then
        print("mem: " .. flr(stat(0)) .. "kb", 0, 0, 8)
        print("cpu: " .. stat(1) .. "%", 0, 8, 8)
    end
    
end

function update_play()
    p1:update()
    update_particles()
    update_objects()
    update_demons()
    u_letters()
    map_y += .2

    if flr(map_y) == 17 then
        map_y = 0
    end
    --moving the map up
    --update_wind()
    if p1.life == 0 then
        sfx(11)
        change_state(gamestates.gameover)
    end



    -- mb_spawn += 1
    -- if mb_spawn >= next_mb then
    --     spawn_mbox()
    --     spawn_rock()
    --     mb_spawn = 0
    --     reset_mb_timer()
    -- end


    spawner:update()
end

function update_intro()
    intro_t -= 1
    if intro_t <= 0 then
        --g_state=gamestates.day_title
        change_state(gamestates.day_title)
    end
end

function update_day()
    day_t -= 1
    if day_t <= 0 then
        g_state = gamestates.game
    end
end

function update_bonus()
    p1:update()
    u_letters()
    update_rings()
    spawner:update()
end

function draw_play()
    cls(0)
    for o in all(objects.back) do
        o:draw()
    end
    --draw_wind()
    rectfill(0, 0, 127, 8, 0)
    rectfill(0, 120, 127, 128, 0)
    p1:draw()

    draw_particles()


    for o in all(objects.front) do
        o:draw()
    end

    for mb in all(mailboxes) do
        mb:draw()
    end
    draw_letters()
    for r in all(rocks) do
        r:draw()
    end

    map(0, map_y)
    draw_gui()
    draw_demons()
end

function draw_title()
    cls(7)
    print("down mail", hcenter("down mail"), 50, 0)
    print("press 🅾️ to play", hcenter("press 🅾️ to play"), 75, 0)
end

function draw_intro()
    cls()
    print("customers", hcenter("customers"), 45, 7)
    print("non-customers", hcenter("non-customers"), 80, 7)
    --TODO: figure out how to center sprites
    for k, v in pairs(customers) do
        pal(6, v)
        sspr(32, 8, 8, 8, 25 + (16 * k), 52, 16, 16)
        --spr(20, 30+(8*k), 52)
        pal()
    end

    for k, v in pairs(non_customers) do
        pal(6, v)
        sspr(32, 8, 8, 8, 25 + (16 * k), 88, 16, 16)
        --spr(20, 30+(8*k), 88)
        pal()
    end

    draw_skip()
end

function draw_bonus()
    cls(0)
    map(0, map_y)
    p1:draw()
    draw_rings()


    draw_letters()


    draw_gui()
end

function draw_day()
    cls(0)
    print(days[day], hcenter(days[day]), vcenter(days[day]), 7)
    draw_skip()
end

function draw_skip()
    print("🅾️ to skip", 80, 2)
end

function is_colliding(a, b)
    if b.x >= a.x + 8
        or b.x + 8 <= a.x
        or b.y >= a.y + 8
        or b.y + 8 <= a.y then
        return false
    else
        return true
    end
end

function is_colliding_pro(a, b)
    if a.x < b.x + b.w and
        a.x + a.w > b.x and
        a.y < b.y + b.h and
        a.y + a.h > b.y then
        return true
    else
        return false
    end
end

function draw_gui()
    rectfill(0, 121, 128, 128, 0)
    print("score:" .. p1.score, 3, 123, 7)
    --print("CUSTOMERS", 30, 123, 7)
    print("mail", 85, 123, 7)
    for i = 1, p1.max_letter, 1 do
        pset(100 + (2 * i), 124, 5)
        pset(100 + (2 * i), 125, 5)
        pset(100 + (2 * i), 126, 5)
    end
    for i = 1, p1.letters, 1 do
        pset(100 + (2 * i), 124, 7)
        pset(100 + (2 * i), 125, 7)
        pset(100 + (2 * i), 126, 7)
    end
    if reminder then
        for k, v in pairs(customers) do
            pal(6, v)
            --sspr(32, 8, 8, 8, 25+(4*k), 88, 4, 4)
            spr(21, 30 + (8 * k), 122)
            pal()
        end
    end

    --rectfill(48, 124, 50, 126, customers[1])
   -- rectfill(52, 124, 54, 126, customers[2])
    --rectfill(56, 124, 58, 126, customers[3])
end

function advance_day()
    -- TODO: Set customer tables
    set_customers()
    -- TODO: Reset player's health, position and letter stock
    deliveries_left = 10 --TODO: Maybe increase as the week goes on
    day += 1
    g_state = gamestates.day_intro
end

function change_state(new_state)
    g_state = new_state
end

function set_customers()
    shuffle(cols)

    customers = { cols[1], cols[2], cols[3] }
    non_customers = { cols[4], cols[5], cols[6] }
end

function angle_lerp(angle1, angle2, t)
    angle1 = angle1 % 1
    angle2 = angle2 % 1

    if abs(angle1 - angle2) > 0.5 then
        if angle1 > angle2 then
            angle2 += 1
        else
            angle1 += 1
        end
    end

    return ((1 - t) * angle1 + t * angle2) % 1
end

function print_debug(str)
    printh("debug: " .. str, 'debug.txt')
end

function hcenter(s)
    -- screen center minus the
    -- string length times the
    -- pixels in a char's width,
    -- cut in half
    return 64 - #s * 2
end

function vcenter(s)
    -- screen center minus the
    -- string height in pixels,
    -- cut in half
    return 61
end

function shuffle(t)
    -- do a fisher-yates shuffle
    for i = #t, 1, -1 do
        local j = flr(rnd(i)) + 1
        t[i], t[j] = t[j], t[i]
    end
end

function randf_rang(l, h)
    local h = h - l
    return l + rnd(h)
end

function randi_rang(l, h)
    return flr(rnd(h)) + l
end

function randsec_rang(l, h)
    return (flr(rnd(h)) + l) * 30
end

function draw_hitbox(o)
    rect(o.x, o.y, (o.x + o.w), (o.y + o.h), 8)
end
