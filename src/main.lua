is_debug = false

cols = { 12, 14, 9, 6 }
customers = {}
non_customers = {}
reminder = false
mb_spawn = 0
avil_yx = { 7, 16, 25, 34, 43, 52, 61, 70, 79, 88, 97, 106, 113 }
next_mb = 0
map_y = 0
damaged_mb = 0
game_over_x = -10
score = 0
bouns_timer = 0
hint_txt = "hint off"

deliveries = { 0, 0 }
deliveries_good = 0
deliveries_bad = 0
goto_bonus_tmr = 60


offset=0

ending = 0
end_spr = { 64, 68, 72, 76, 140}
objects = { back = {}, front = {} }


day = 1
days = { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }
days_needed = 3
intro_t = 30 * 6
day_t = 30 * 6
post_t = 30 * 8
gamestates = {
    title = 0,
    day_intro = 1,
    day_title = 2,
    game = 3,
    bonus = 4,
    gameover = 5,
    post_day = 6,
}

g_state = nil
deliveries_needed = 6
deliveries_left = deliveries_needed

end_text_l1 = ""
end_text_l2 = ""
ending_idx = 0

endings = {
    { "city mourns",    "loss of mailman" },
    { "local mailman",  "goes missing" },
    { "mailman fired",  "" },
    { "mailman quits,", "buys city" },
    { "mediocre mailman,", "does job" },
}

function update_objects()
    for o in all(objects.front) do
        o:update()
    end
    for o in all(objects.back) do
        o:update()
    end
end

function draw_objects()
    for o in all(objects.front) do
        o:draw()
    end
end

function restart_game()
    day = 1
    deliveries_left = deliveries_needed
    deliveries = { 0, 0 }
    intro_t = 30 * 6
    day_t = 30 * 6
    post_t = 30 * 8
    spawner:reset()
    set_customers()
    score = 0
    init_wind()
    reset_mb_timer()
    p1 = init_player()
    change_state(gamestates.title)
end

function _init()
    poke(0x5f5c, 255)
    menuitem(3, hint_txt, my_menu_item)
    restart_game()
end

function my_menu_item(b)
    if b & 1 > 0 then toggle_hint() end
    if b & 2 > 0 then toggle_hint() end
    return true -- stay open
end

function toggle_hint()
    reminder = not reminder
    if reminder then
        hint_txt = "hint on"
    else
        hint_txt = "hint off"
    end
    menuitem(_, hint_txt)
end

function _update()
    check_input()



    if g_state == gamestates.title then
    elseif g_state == gamestates.day_intro then
        update_intro()
    elseif g_state == gamestates.day_title then
        update_day()
    elseif g_state == gamestates.game then
        update_play()
    elseif g_state == gamestates.bonus then
        update_bonus()
    elseif g_state == gamestates.post_day then
        update_postday()
    elseif g_state == gamestates.gameover then
        update_gameover()
    end
end

function _draw()
    if g_state == gamestates.title then
        draw_title()
    elseif g_state == gamestates.day_intro then
        draw_intro()
    elseif g_state == gamestates.day_title then
        draw_day()
    elseif g_state == gamestates.game then
        screen_shake()
        draw_play()
    elseif g_state == gamestates.bonus then
        draw_bonus()
    elseif g_state == gamestates.gameover then
        draw_gameover()
    elseif g_state == gamestates.post_day then
        draw_postday()
    end

    if is_debug then
        print("mem: " .. flr(stat(0)) .. "kb", 10, 0, 8)
        print("cpu: " .. stat(1)*100 .. "%", 10, 8, 8)
        
    end
end

function check_input()
    if btnp(🅾️) then
        if g_state == gamestates.title then
            g_state = gamestates.day_intro
        elseif g_state == gamestates.day_intro then
            intro_t = 0
        elseif g_state == gamestates.day_title then
            day_t = 0
        elseif g_state == gamestates.post_day then
            post_t = 0
        elseif g_state == gamestates.game then
            p1:throw()
        elseif g_state == gamestates.bonus then
            p1:throw()
        elseif g_state == gamestates.gameover then
            restart_game()
        end
    end

    if btn(➡️) then
        p1:move("r")
    elseif btn(⬅️) then
        p1:move("l")
    end


    if btnp(⬆️) then
        p1:update_chute(true)
        --p1.is_chute_open = true
        --p1.speed = 1
    elseif btnp(⬇️) then
        p1:update_chute(false)
        --p1.is_chute_open = false
        --p1.speed = 2
    end

    if btnp(❎) then
        if g_state == gamestates.title then

        elseif g_state == gamestates.day_intro then

        elseif g_state == gamestates.day_title then

        elseif g_state == gamestates.game then
            --spawn_package()
        elseif g_state == gamestates.gameover then

        end
    end
end

function update_play()
    p1:update()
    update_particles()
    update_objects()
    update_lizards()
    update_letters()
    for t in all(twisters) do
        t:update()
    end

    map_y += .2

    if flr(map_y) == 17 then
        map_y = 0
    end



    spawner:update()

    if deliveries_left <= 0 then
        deliveries_left = 0
        goto_bonus_tmr -= 1
        if goto_bonus_tmr == 0 then
            goto_bonus()
        end
    end

end

function update_intro()
    intro_t -= 1
    if intro_t <= 0 then
        change_state(gamestates.day_title)
    end
end

function update_postday()
    post_t -= 1
    if post_t <= 0 then
        change_state(gamestates.day_intro)
        deliveries = { 0, 0 }
    end
end

function update_day()
    day_t -= 1
    if day_t <= 0 then
        g_state = gamestates.game
        spawner.running = true
    end
end

function update_bonus()
    bouns_timer -= 1
    if bouns_timer <= 0 then
        if day <= (days_needed - 1) then
           advance_day()
        else
            --if day == 3 then
                if deliveries[1] == (deliveries_needed * (days_needed)) then
                    end_text = endings[4]
                    ending_idx = 4
                else
                    end_text = endings[5]
                    ending_idx = 5
                end      
                change_state(gamestates.gameover)
            --end
        end
    end
    p1:update()
    update_letters()
    update_particles()
    --update_rings()
    spawner:update()
end

function draw_play()
    cls(0)
    for o in all(objects.back) do
        o:draw()
    end

    p1:draw()
    draw_particles()

    for o in all(objects.front) do
        o:draw()
    end
    for t in all(twisters) do
        t:draw()
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
    draw_lizards()
    for k, v in ipairs(lanes) do
        if lanes[k][2] == true then
            circfill(lanes[k][1] + 4, 119, 2, 10)
        end
    end
end

function draw_title()
    cls(7)
    spr(200, 48, 34, 4, 2)
    spr(232, 48, 34+10, 4, 2)
    --print("down mail", hcenter("down mail"), 50, 0)
    print("press 🅾️ to play", hcenter("press 🅾️ to play"), 75, 8)
end

function draw_intro()
    cls()
    print("customers", hcenter("customers"), 45, 7)
    print("non-customers", hcenter("non-customers"), 80, 7)

    for k, v in pairs(customers) do
        pal(6, v)
        sspr(56, 8, 8, 8, 25 + (20 * k), 52, 16, 16)
        pal()
    end

    for k, v in pairs(non_customers) do
        pal(6, v)
        sspr(56, 8, 8, 8, 25 + (20 * k), 88, 16, 16)
        pal()
    end

    draw_skip()
end

function draw_bonus()
    cls(0)
    map(16, 0)
    p1:draw()
    draw_particles()
    draw_rings()
    draw_letters()
    draw_gui()
    rectfill(17, 10, 17 + flr(bouns_timer / 15) * 3, 13, 3)
    rect(17, 9, 109, 14, 7)
    print("bonus", 50, 3, 7)
    -- print("bonus: " .. flr(bouns_timer/30), 20, 20, 5)
    
end

function draw_postday()
    cls(0)

    all_particles = {}
    letters = {}

    print("deliveries: " .. (deliveries[1] + deliveries[2]), 20, 40, 7)
    print("customers: " .. deliveries[1], 20, 48, 7)
    print("non-customers: " .. deliveries[2], 20, 48 + 8, 7)

    draw_skip()
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
    print("score:" .. score, 3, 123, 7)
    --print("CUSTOMERS", 30, 123, 7)

    --print(days[day], 85, 123, 7)
    print("mail", 85, 123, 7)
    for i = 1, deliveries_needed, 1 do
        pset(100 + (2 * i), 124, 5)
        pset(100 + (2 * i), 125, 5)
        pset(100 + (2 * i), 126, 5)
    end
    for i = 1, (deliveries[1]+deliveries[2]), 1 do
        pset(100 + (2 * i), 124, 7)
        pset(100 + (2 * i), 125, 7)
        pset(100 + (2 * i), 126, 7)
    end
    if reminder then
        for k, v in pairs(customers) do
            pal(6, v)
            --sspr(32, 8, 8, 8, 25+(4*k), 88, 4, 4)
            spr(21, 38 + (8 * k), 122)
            pal()
        end
    end

    line( 48, 127, 65, 127, 0) 

    --rectfill(48, 124, 50, 126, customers[1])
    -- rectfill(52, 124, 54, 126, customers[2])
    --rectfill(56, 124, 58, 126, customers[3])
end

function advance_day()
    day += 1

    


    -- TODO: Set customer tables
    rings = {}
    intro_t = 30 * 6
    day_t = 30 * 6
    post_t = 30 * 6
    set_customers()
    p1 = init_player()
    -- TODO: Reset player's health, position and letter stock
    deliveries_left = deliveries_needed --TODO: Maybe increase as the week goes on
    
    g_state = gamestates.post_day
    init_wind()
end

function change_state(new_state)
    offset=0
    g_state = new_state
end

function set_customers()
    shuffle(cols)
    customers = { cols[1], cols[2] }
    non_customers = { cols[3], cols[4] }
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

function goto_bonus()
    p1.move_speed = 1.5
    spawner.reset()
    bouns_timer = 30 * 15
    change_state(gamestates.bonus)
    spawner.running = true
end

function draw_gameover()
    cls(7)
    spr(192, 32, 8, 8, 2)
    print("$0.25", 6, 10, 5)
    print("score: " .. score, 10, 32, 5)
    rect(4, 30, 124, 120, 5)
    pal(14, 0)
    spr(end_spr[ending_idx], 80, 34, 4, 4)
    pal()
    print("game over", game_over_x, 1, 0)
    print(end_text[1], 10, 40 + 5, 0)
    print(end_text[2], 10, 48 + 5, 0)
    fillp(▤)
    rectfill(10, 70, 76, 95, 0)
    rectfill(10, 100, 90, 110, 0)
    rectfill(90, 70, 110, 90, 6)
    fillp()
end

function update_gameover()
    game_over_x += 1
    if game_over_x == 130 then
        game_over_x = -30
    end
end

function in_range(x_val)
    if x_val >= 1 and x_val <= 20 then
        print 'it is!'
    end
end


function screen_shake()
    local fade = 0.95
    local offset_x=16-rnd(32)
    local offset_y=16-rnd(32)
  
    offset_x*=offset
    offset_y*=offset
    
    camera(offset_x,offset_y)
  
    offset*=fade
    if offset<0.05 then
      offset=0
    end
  end


  --function calc_dist2(x1,y1,x2,y2)
    --return abs(x1-x2)+abs(y1-y2)
  --end


  function dist(a,b)
    return abs(a.x-b.x)+abs(a.y-b.y)
  end

